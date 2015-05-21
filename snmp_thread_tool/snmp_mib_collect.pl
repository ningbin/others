#!/usr/bin/perl
##---------------------------------------------------------------------------
#
# FILENAME		: snmp_mib_collect.pl
# PROGRAM		: perl program
# CREATE DATE	: 2009/10/13
# MODIFY DATE	: 
# AUTHOR		: Ning Bin
# USAGE			: snmp_mib_collect.pl 
# DESCRIPTION	: collect mib informations from remote nodes.
# RETURN CODE	: 
# 
# Copyright_2009_Hewlett-Packard
##---------------------------------------------------------------------------
use POSIX qw(strftime);
use File::Basename;
use Net::SNMP;
use DBI;
use Getopt::Std;
$CUR_DIR=dirname($0);
require "${CUR_DIR}/common_log.pl";

#get program parameters
getopt("m:");
getopt("e");

# log setting
$LOG_FILE="${CUR_DIR}/log_snmp_mib_collect.log";
$MAX_LOG_SIZE = 1000000;
$LOG_MASK=($opt_m?$opt_m:3);

# if=1, print log on screen and log file
# if=0, print log only on log file
$ECHO_MODE=($opt_e?1:0);

# snmp setting
$SNMP_VERSION="2c";
$SNMP_TIMEOUT=3;
$SNMP_RETRIES=0;
$SNMP_MAXMSGSIZE=1472;

# oid setting
$OID_ifOperStatus="1.3.6.1.2.1.2.2.1.8";
$ifOperStatus_up="1";

# DB setting
$ORACLE_SID="ethercdb";
$ORACLE_USR="ethcct";
$ORACLE_PSW="ethcct";
$TABLE_NAME="MIB_NODE_TBL";

# conf file
$NODE_CONF="${CUR_DIR}/get_node_list.conf";
$OID_CONF="${CUR_DIR}/get_oid_list.conf";

# output file
$OUTPUT_FILE_BASE="mib_info_file";
$time_now=strftime('%Y%m%d%H%M', localtime(time));
$OUTPUT_FILE="${CUR_DIR}/${OUTPUT_FILE_BASE}_".$time_now;

# open log file 
# parameters: $1:log file name, $2:max size of log
$LOG_FILE = &OpenLog( $LOG_FILE, $MAX_LOG_SIZE );

# declare trace object
# parameters: $1:level, $2:mask, 
#  $3:if print formatted data $4: echo mode
$error=&TraceObject("ERROR", 1, 1, $ECHO_MODE);				
$info=&TraceObject("INFO", 2, 1, $ECHO_MODE);				
$trace=&TraceObject("TRACE", 4, 1, $ECHO_MODE);				
$log_data=&TraceObject("DATA", 8, 0, $ECHO_MODE);		

# start here
&Main;

# the Main function
sub Main
{
	$info->("*****************************");
	$info->("$0 start");
	$info->("open files");
	&OpenFile;
	$info->("read node list conf file");
	&ReadNodeListConf;
	$info->("read oid list conf file");
	&ReadOidListConf;
	$info->("open DB sesssion");	
	&OpenDBSession;
	$info->("select host info from DB");
	&SelectHostInfo;
	$info->("close DB sesssion");
	&CloseDBSession;
	$info->("collecting mib info...");
	&CollectMib;
	$info->("$0 end");		
	close LOG_FILE;
}

sub OpenFile
{
	# open node conf file
	if( !open( NODE_CONF, "<", "$NODE_CONF" ))
	{
		$error->("Can not read $NODE_CONF : ($!)");
		$info->("$0 end" );
		die "Can not read $NODE_CONF : ($!)\n";
	}
	# open oid conf file
	if( !open( OID_CONF, "<", "$OID_CONF" ))
	{
		$error->("Can not read $OID_CONF : ($!)");
		$info->("$0 end" );
		die "Can not read $OID_CONF : ($!)\n";
	}
	# open output snmp mib file
	if( !open( OUTPUT_FILE, ">", "$OUTPUT_FILE" ))
	{
		$error->("Can not write $OUTPUT_FILE : ($!)");
		$info->("$0 end" );
		die "Can not write $OUTPUT_FILE : ($!)\n";
	}
}

sub ReadNodeListConf
{
	while(<NODE_CONF>)
	{
		chomp;
		$trace->($_);
			
		next if( /^\s?\#/ );			#comment line
		next if( /^\s?$/ );				#null line
		s/ //g;							#remove space
		my @conf_list=split /,/ ;		#devide line by ','
		
		my $node_conf_hash=();
		$node_conf_hash->{ip} = $conf_list[0];
		$node_conf_hash->{community} = $conf_list[1];
		$node_conf_hash->{port} = $conf_list[2];
		
		push( @node_conf_list, $node_conf_hash );
	}	
	close NODE_CONF;
}

sub ReadOidListConf
{
	while(<OID_CONF>)
	{
		chomp;
		$trace->($_);
		
		next if( /^\s?\#/ );			#comment line
		next if( /^\s?$/ );				#null line
		
		push( @oid_conf_list, $_ );
	}
	close OID_CONF;
}

sub SelectHostInfo
{
	foreach my $node (@node_conf_list)
	{
		&SelectFromDB( $node );			#select info from DB
	}
}

sub CollectMib
{
	foreach my $node (@node_conf_list)
	{
		my $session = &OpenSnmpSession( $node );
		if(!defined $session)
		{
			$error->("open snmp session for $node->{ip} failed!");
			next;
		}
		
		# get ifIndex list whose ifOperStatus= Up(1)
		my $statusUpIfIndexList = &GetStatusUpIfIndex(
					 $session, $node, $OID_ifOperStatus
					 );
		# check oid from conf
		foreach my $oid (@oid_conf_list)
		{
			my $tmp_oid = $oid;
			if ( $tmp_oid =~ /\[\$ifindex\]/ )
			{
				foreach my $ifIndex (@$statusUpIfIndexList)
				{
					# replace "[ifindex]" with ifIndex
					my $oid_index = $tmp_oid;
					$oid_index =~ s/\[\$ifindex\]/$ifIndex/g;
					# snmpget
					SnmpGet( $session, $node, $oid_index );
				}
			}
			else
			{
				# snmpget
				SnmpGet( $session, $node, $tmp_oid );
			}
		}
		# close snmp session of this node
		&CloseSnmpSession( $session, $node );
	}
	$trace->("end of all snmp sessions!");
	
	close OUTPUT_FILE;
}

sub GetStatusUpIfIndex
{
	my $session = shift;
	my $node = shift;
	my $oid = shift;
	my $message = "snmpwalk -v$SNMP_VERSION -c $node->{community} $node->{ip} $oid";
	$trace->($message);
   
	my $result = $session->get_table(-baseoid => $oid,);	
	if (!defined $result)
	{
	  $message .= " => ".$session->error();
	  $error->( $message );
	  return;
	}
	
	# check if ifOperStatus = Up(1)
	my $statusUpIfIndexList = [];
	foreach my $i_oid (sort keys %$result)
	{
		$trace->("$i_oid => $result->{ $i_oid }");
		if( $result->{ $i_oid } eq $ifOperStatus_up )
		{
			if( $i_oid =~ s/\.(\d+)$// )
			{
				my $ifIndex = $1;
				$trace->("ifOperStatus=up(1), ifIndex => $ifIndex");
				push(@$statusUpIfIndexList, $ifIndex);
			}
		}
	}
	
	return $statusUpIfIndexList;
}

sub SnmpGet
{
	my $session = shift;
	my $node = shift;
	my $oid = shift;
	my $message = "snmpget -v$SNMP_VERSION -c $node->{community} $node->{ip} $oid";
	$trace->($message);
 	
	my $result = $session->get_request(-varbindlist => [ $oid ],);	
	if (!defined $result)
	{
		$message .= " => ".$session->error();
	  	$error->( $message );
	  	return;
	}
	
	$trace->("$oid => $result->{$oid}");
	
	my $time_now=strftime('%Y%m%d%H%M%S', localtime(time));	
	my ($slot, $port) = &ParseSlotPort( $oid );
	my $value = $result->{$oid};
	$value =~ s/\n/ /g;
	
	my $output = sprintf( "%-14s%-64s%-15s%-16s%-16s%-64s%-300s\n", 
						$time_now, $node->{hostname}, 
						$node->{ip}, $slot, $port,
						$oid, $value  );

	# print output file
	$log_data->("$output");
	print OUTPUT_FILE "$output";
}

sub ParseSlotPort
{
	my $oid = shift;
	my $slot = "0";	
	my $port = $oid;
	if( $port=~ /\.(\d+)$/ )
	{
		$port = $1;
	}
	
	return ($slot, $port);
}

sub OpenSnmpSession
{
	my $node = shift;

	my ($session, $err_info) = Net::SNMP->session(
	  -version    => "snmpv".$SNMP_VERSION,
      -hostname   => $node->{ip},
      -community  => $node->{community},
      -port		  => $node->{port},
      -timeout	  => $SNMP_TIMEOUT,
      -retries    => $SNMP_RETRIES,
      -maxmsgsize => $SNMP_MAXMSGSIZE,
   	);
   
   if (!defined $session)
   {
      $error->( $err_info );
      return undef;
   }
   
   $info->("open snmp session for $node->{ip}");
   return $session;
}

sub CloseSnmpSession
{
	my $session = shift;
	my $node = shift;
	if( defined $session )
	{
		$session->close();
		$info->("close snmp session for $node->{ip}");
	}
}

sub OpenDBSession
{
	$dbh = DBI->connect( "dbi:Oracle:$ORACLE_SID", $ORACLE_USR, $ORACLE_PSW );
	if( !defined $dbh )
	{
		$error->( $DBI::errstr );
		$info->("$0 end");
		die "Connect Oracle Failed!\n";
	}
	
	my $sel = "select HOST_NAME from $TABLE_NAME where IP_ADD = ?";
	$sel_session = $dbh->prepare($sel);	
	if( !defined $sel_session )
	{
		$error->( $DBI::errstr );
		$info->("$0 end");
		die "Open Oracle Session Failed!\n";
	}
}

sub CloseDBSession
{
	if( defined $sel_session )
	{
		$sel_session->finish;
		$trace->("DB session over");
	}
	if( defined($dbh) )
	{
		$dbh->disconnect;
		$trace->("DB disconnected OK");
	}
}

sub SelectFromDB
{
	my $node = shift;
	$trace->("select HOST_NAME from $TABLE_NAME where IP_ADD = '$node->{ip}'");
	
	$sel_session->bind_param( 1, $node->{ip} );
	$sel_session->execute();
	
	my ( $hostname ) = $sel_session->fetchrow_array();
	if( !defined $hostname )
	{
		$hostname = "";
	}
	
	$node->{hostname}="$hostname";
	$trace->("hostname => $hostname");
}

