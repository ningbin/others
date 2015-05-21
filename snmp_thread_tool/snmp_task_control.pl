#!/usr/bin/perl
##---------------------------------------------------------------------------
#
# FILENAME		: snmp_task_control.pl
# PROGRAM		: perl program
# CREATE DATE	: 2009/10/23
# MODIFY DATE	: 
# AUTHOR		: Ning Bin
# USAGE			: snmp_task_control.pl 
# DESCRIPTION	: snmp task control
# RETURN CODE	: 
# 
# Copyright_2009_Hewlett-Packard
##---------------------------------------------------------------------------
use threads;
use Thread::Queue;
use POSIX qw(strftime);
use File::Basename;
use Getopt::Std;
$CUR_DIR=dirname($0);
require "${CUR_DIR}/common_log.pl";

# multi snmp perl 
$MULTI_SNMP_PERL="${CUR_DIR}/multi_snmp_mib_collect.pl";

#get program parameters
getopt("htm:");
getopt("e");

# max simultaneously processing hosts
$MAX_COCURRENT_HOST=($opt_h?$opt_h:100);
# snmp task threads
$THREADS=($opt_t?$opt_t:10);

# log setting
$LOG_FILE="${CUR_DIR}/log_snmp_task_control.log";
$MAX_LOG_SIZE=1000000;
$LOG_MASK=($opt_m?$opt_m:3);

# if=1, print log on screen and log file
# if=0, print log only on log file
$ECHO_MODE=($opt_e?1:0);

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
	$info->("$0 begin");
	$info->("open files");
	&OpenFile;
	$info->("read node list conf file");
	&ReadNodeListConf;
	$info->("run snmp task threads");
	&RunThreads;
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
	# open output snmp mib file
	if( !open( OUTPUT_FILE, ">", "$OUTPUT_FILE" ))
	{
		$error->("Can not write $OUTPUT_FILE : ($!)");
		$info->("$0 end" );
		die "Can not write $OUTPUT_FILE : ($!)\n";
	}
	close OUTPUT_FILE;
}

sub ReadNodeListConf
{
	$task_queue = new Thread::Queue;
	my $i = 1;
	while(<NODE_CONF>)
	{
		chomp;
		$trace->($_);
			
		next if( /^\s?\#/ );			#comment line
		next if( /^\s?$/ );				#null line
		
		my $j = $i % $THREADS;
		$j = $THREADS if $j==0;
		$trace->("echo $_ >> ${NODE_CONF}_part${j}");
		system "echo $_ >> ${NODE_CONF}_part${j}";
		$i++;		
	}
	$i--;
	$THREADS = $i if $i < $THREADS;
	for( my $k=1; $k<=$THREADS; $k++ )
	{
		$task_queue->enqueue( $k );
	}
	$task_queue->enqueue( (undef) x $THREADS );
	close NODE_CONF;
}

sub RunThreads
{
	$result_queue = new Thread::Queue;

	my @thread_pool = map{ threads->create( \&SnmpThread ) } 1 .. $THREADS;
	
	for(1..$THREADS)
	{
		while( my $i = $result_queue->dequeue )
		{
			$trace->("cat ${CUR_DIR}/${OUTPUT_FILE_BASE}_part${i} >> ${OUTPUT_FILE}");
			system("cat ${CUR_DIR}/${OUTPUT_FILE_BASE}_part${i} >> ${OUTPUT_FILE}");
			unlink "${CUR_DIR}/${OUTPUT_FILE_BASE}_part${i}";
		}
	}
	
	$_->join for @thread_pool;
	
	$info->("end of all task!");	
}

sub SnmpThread
{
	my $tid = threads->tid;
	$trace->("begining of thread : $tid");
	while( my $i = $task_queue->dequeue )
	{
        $trace->("$MULTI_SNMP_PERL -h $MAX_COCURRENT_HOST -n ${NODE_CONF}_part${i} -o ${CUR_DIR}/${OUTPUT_FILE_BASE}_part${i} -l log_snmp_task_part${i}.log");
        system("$MULTI_SNMP_PERL -h $MAX_COCURRENT_HOST -n ${NODE_CONF}_part${i} -o ${CUR_DIR}/${OUTPUT_FILE_BASE}_part${i} -l log_snmp_task_part${i}.log");        
        unlink "${NODE_CONF}_part${i}";
        $result_queue->enqueue( $i );
        $result_queue->enqueue( undef );
    }
    $trace->("end of thread : $tid");
}


