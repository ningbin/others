#!/usr/bin/perl
##---------------------------------------------------------------------------
#
# FILENAME		: update_control_time
# PROGRAM		: perl program
# CREATE DATE	: 2008/09/26
# MODIFY DATE	: 2009/01/21
# AUTHOR		: Ning Bin
# USAGE			: update_control_time -f WORK_OUTPUT_FILE -c OC_CONFIG_FILE
# DESCRIPTION	: 
# RETURN CODE	: NONE
# 
# Copyright_2008_Hewlett-Packard
##---------------------------------------------------------------------------
use POSIX qw(strftime);
use Getopt::Std;

# log file
$LOG_FILE="/var/NWS-ALM-1PRG/log/marking_release/update_control_time.log";
# global entity name
$GLOBAL_ENTITY="NW_OPS *";
# summrize fcl file
$SUMMARIZE_FCL="/tmp/update_control_time_summarize.$$.fcl";
# set controlTime fcl file
$SET_CONTROL_TIME_FCL="/tmp/update_control_time_set.$$.fcl";
# manage command path name
$MANAGE_CMD="/usr/opt/temip/bin/manage";
# usage
$USAGE="USAGE: $0 -f [WORK_OUTPUT_FILE] -c [OC_CONFIG_FILE] \nEXAMPLE: $0 -f work.csv -c oc.conf\n\n";


# open log file
if( !open( LOG_FILE, ">>", "$LOG_FILE" ))
{
	print "Warning: can not write log $LOG_FILE : ($!)\nprocess continue...\n";
}
$info=&WriteLog("INFO");		# for writing info log
$error=&WriteLog("ERROR"); 		# for writing error log

# get the parameters
getopt("cf:");

# get oc config file
if ($opt_f)
{
    #if work output file is specified
    $WORK_OUTPUT_FILE=$opt_f;
}
else
{
	#if work output file is not specified
	$error->("No parameter [WORK_OUTPUT_FILE], quit");
	print "\nERROR: No parameter [WORK_OUTPUT_FILE]. \n";
	die $USAGE;
}

# get oc name
if ($opt_c)
{
    #if oc config file is specified
    $OC_CONF_FILE=$opt_c;
}
else
{
	#if oc config file is not specified
	$error->("No parameter [OC_CONFIG_FILE], quit");
	print "\nERROR: No parameter [OC_CONFIG_FILE]. \n";
	die $USAGE;
}

# start here
&Main;

# the Main function
sub Main
{
	$info->("$0 -f $WORK_OUTPUT_FILE -c $OC_CONF_FILE begin");
	$info->("checking files...");
	&CheckFile;
	$info->("reading OC configuration file...");
	&ReadOCConfFile;
	$info->("reading work output file...");
	&ReadWorkOutputFile;
	$info->("writing summarize fcl...");
	&WriteSummarizeFcl;	
	$info->("summarizing OC...");
	&HandleSummarizeResult;
	$info->("updating AOs' controlTime...");
	&UpdateControlTime;
	$info->("$0 finish");
	close LOG_FILE;
}

# log function
sub WriteLog
{
	my $logType = shift;
	$LogFunc = sub {
		my $event_time=strftime('%Y-%m-%d %H:%M:%S', localtime(time));		
		my $logContent = shift;
		print LOG_FILE "$event_time [$$] $logType: $logContent\n";		
	}
}

# check files' privilege
sub CheckFile
{
	if( !open( WORK_OUTPUT_FILE, "<", "$WORK_OUTPUT_FILE" ))
	{
		$error->("Can not read $WORK_OUTPUT_FILE : ($!), quit");
		die "Can not read $WORK_OUTPUT_FILE : ($!)";
	}
	if( !open( OC_CONF_FILE, "<", "$OC_CONF_FILE" ))
	{
		$error->("Can not read $OC_CONF_FILE : ($!), quit");
		die "Can not read $OC_CONF_FILE : ($!)";
	}
	if( !open( SUMMARIZE_FCL, ">", "$SUMMARIZE_FCL" ))
	{
		$error->("Can not write $SUMMARIZE_FCL : ($!), quit");
		die "Can not write $SUMMARIZE_FCL : ($!)";
	}
	if( !open( SET_CONTROL_TIME_FCL, ">", "$SET_CONTROL_TIME_FCL" ))
	{
		$error->("Can not write $SET_CONTROL_TIME_FCL : ($!), quit");
		die "Can not write $SET_CONTROL_TIME_FCL : ($!)";
	}
}

# read the OC conf file
sub ReadOCConfFile
{
	while(<OC_CONF_FILE>)
	{
		chomp;
		next if( /^\s?\#/ );	#comment line
		next if( /^\s?$/ );		#null line
		if(/(.+)=(.+)/)
		{
			my $oc_name = $1;
			my @value_list=split( /,/, $2);		#devide line by ','
			foreach $item (@value_list)
			{
				$item =~ s/ //g; 				#delete the space
				if( exists($oc_conf_hash->{$item}) )		#this item is already defined
				{
					$old_oc_list = $oc_conf_hash->{$item};
					push( @$old_oc_list, $oc_name );
				}
				else
				{
					my $new_oc_list=();						#create a new list 
					push( @$new_oc_list, $oc_name );
					$oc_conf_hash->{$item}=$new_oc_list;
				}
			}
		}
	}
	close OC_CONF_FILE;
}


# read work output file
sub ReadWorkOutputFile
{
	while(<WORK_OUTPUT_FILE>)
	{
		chomp;
		next if( /^\s?\#/ );	#comment line
		next if( /^\s?$/ );		#null line
		#s/@//g;				#delete shift-jis double space 
		
		@LINE=split /,/;		#devide line by ','
		foreach $item (@LINE)
		{
			$item =~ s/^\s+//;	#delete the space in the begining
			$item =~ s/\s+$//;	#delete the space in the behind
		}
		my $work_record = {
			cstNo => "$LINE[0]-$LINE[1]",
			nodeId => $LINE[2],
			controlTime => $LINE[4],
			serialNo => $LINE[5],
			neType => substr($LINE[2],16,4),
		};
		my $MO = &GetMO(@LINE);
		if(exists($work_record_hash->{$MO}))			#this MO group is already exist
		{
			$mo_record_set=$work_record_hash->{$MO};	#add the record to the group
			push(@$mo_record_set, $work_record);
		}
		else
		{
			my $new_mo_record_set=();					#create a new group.
			$work_record->{areaCode} = "98".$LINE[9];;
			$work_record->{mmsCode} = "99".$mmsNo;
			push(@$new_mo_record_set, $work_record);
			$work_record_hash->{$MO}=$new_mo_record_set;
		}
	}
	close WORK_OUTPUT_FILE;
}

# construct MO by neType and nodeId
sub GetMO
{
	my $tp = substr($_[2],16,4); #neType
	if($tp eq "0001")	#MMS
	{
		$mmsNo = $_[5];
		$result_mo = "MMS $_[5]";
	}
	elsif($tp eq "0002")	#MPE
	{
		$mmsNo = $_[6];
		$result_mo = "MMS $_[6] MPE $_[5]";
	}
	elsif($tp eq "0003")	#RNC
	{
		$mmsNo = $_[6];
		$result_mo = "MMS $_[6] RNC $_[5]";
	}
	elsif($tp eq "000b")	#xGSN
	{
		$mmsNo = $_[6];
		$result_mo = "MMS $_[6] xGSN $_[5]";
	}
	elsif($tp eq "000c")	#IP-RNC
	{
		$mmsNo = $_[6];
		$result_mo = "MMS $_[6] RNC $_[5]";
	}
	elsif($tp eq "000e")	#BS_DTM
	{
		$mmsNo = $_[6];
		$result_mo = "MMS $_[6] RNC $_[7] BS_DTM $_[5]";
	}
	elsif($tp eq "")
	{
		$mmsNo = "error";
		$result_mo = "error";
	}
	else	#others 
	{
		$mmsNo = $_[6];
		$result_mo = "MMS $_[6] RNC $_[7] BTS $_[8]";
	}
}

# write the summarize fcl file
sub WriteSummarizeFcl
{
	for $mo (keys %$work_record_hash)
	{
		my $set = $work_record_hash->{$mo};
		$oc_list = &GetOCName($$set[0]->{areaCode},$$set[0]->{mmsCode});		
		foreach $o (@$oc_list)
		{
			$_="summarize oper $o alarm \* managed object={ $GLOBAL_ENTITY $mo }";
			#111=>Identifier, 10021=>neType, 10018=>nodeId, 10035=>openCloseFlag, 10000=>aoType
			#10009=>workFlag, 10011=>pfFlag, 10034=>controlTime, 10003=>patternId, 9=>Managed Object
			$_.=", what={ 111,10021,10018,10035,10000,10009,10011,10034,10003,9,4 }";
			$_.=", state={ Outstanding,Acknowledged }\n";
			print SUMMARIZE_FCL; 
			print;
		}
	}
	close SUMMARIZE_FCL;
}

# get oc name according to mms and area.
sub GetOCName
{
	my $area=$_[0];
	my $mms=$_[1];
	my @oc_list=();
	if( exists($oc_conf_hash->{$area}) )		#if area in oc_conf_hash
	{
		$list = $oc_conf_hash->{$area};
		push( @oc_list, @$list );
	}
	if( exists($oc_conf_hash->{$mms}) )			#if mms in oc_conf_hash
	{
		$list = $oc_conf_hash->{$mms};
		push( @oc_list, @$list );
	}
	my %seen = ();
	@oc_list = grep { ! $seen{$_} ++ } @oc_list; 	#delete the extra value from list
	return \@oc_list;
}

# do summarize and get the result.
sub HandleSummarizeResult
{
	open SUMMARIZE_AO, "$MANAGE_CMD do $SUMMARIZE_FCL |";	#do the summarize fcl
	while (<SUMMARIZE_AO>)
	{
		chomp;
		if(/\:\.(\S+) alarm_object \d+/)
		{
			$oc_name = $1;
		}
		elsif(/Identifier = \d+/ ... /Perceived Severity = .+/)
		{
			if(/Identifier = (\d+)/)	#the begining of an AO
			{
				$ao = {				
					Identifier => "oper $oc_name alarm $1",	
					neType =>"",
					nodeId =>"",
					openCloseFlag =>"",
					aoType =>"",
					workFlag =>"",
					pfFlag =>"",
					controlTime =>"",
					patternId=>"",
					"Managed Object" => "",
				}
			}
			elsif(/Perceived Severity = (.+)/)	#the end of an AO
			{
				my $tmp_mo = $ao->{"Managed Object"};
				if( $tmp_mo=~/.+ (MMS .+) $/ )
				{
					$ao->{"Managed Object"}=$1;
					if( &NeedToBeUpdated(\$ao) )
					{
						#write the set control time fcl
						local $_="set $ao->{Identifier} controlTime=\"$ao->{controlTime}\"\n";
						$at_least_one=1;
						print SET_CONTROL_TIME_FCL;
						print "$_\n";
					}
				}
			}
			elsif(/\s+(.+) = (.+)/)	#an attribute field of AO
			{
				$name = $1;
				$value = $2;
				$value =~ s/^\"//;
				$value =~ s/\"$//;
				$ao->{$name}=$value;
				$ipos = length($name) + 3 + index($_, "$name = ");
			}
			else		#if the value appears more than one line
			{
				$value2 = substr($_,$ipos);		#delete the space in the begining
				$ao->{$name}.=$value2;			#combine it into previous attribute
			}
		}
	}
	close SUMMARIZE_AO;
	close SET_CONTROL_TIME_FCL;
	unlink $SUMMARIZE_FCL;
}

# check if AO's contolTime need to be updated
sub NeedToBeUpdated
{
	my $object = $_[0];	
	#check AO's aoType, if aoType=5, it's a group ao, don't update it
	if( $$object->{aoType} eq "5" )
	{
		return 0;
	}	
	#check AO's workFlag and pfFlag
	if( !($$object->{workFlag} eq "›") && !($$object->{pfFlag} eq "›") )
	{
		return 0;
	}
	#get the group with the same MO
	my $managed_object=$$object->{"Managed Object"};
	my $mo_work_list=$work_record_hash->{$managed_object};
	
	#compare with work output record
	my @control_time_list=();
	my $has_one=0;
	foreach $mo (@$mo_work_list)
	{
        $mo_set=$mo;
        #if MO are the related MO and patternId contains cstNo and record's controlTime is earlier
		if( &IsCorelatedMO($object,$mo_set) 
			&& &ContainCstNo($$object->{patternId},$mo_set->{cstNo})
			&& &IsWorkControlTimeEarlier($$object->{controlTime},$mo_set->{controlTime}) )
		{
			push(@control_time_list, $mo_set->{controlTime});
			$has_one=1;
		}
    }
    if($has_one)
    {
    	#update AO's controlTime in memory
    	$$object->{controlTime} = &GetEarliestControlTime(\@control_time_list); 
    	return 1;
    }
    else
    {
    	return 0;
    }	
}

# check the relationship between AO'MO and work'MO
sub IsCorelatedMO
{
	my $ao_bject=$_[0];
	my $record_object=$_[1];	
	my $ao_type = $$ao_bject->{neType};
	my $record_type = $record_object->{neType};
	my $ao_nodeid = $$ao_bject->{nodeId};
	$ao_nodeid =~ s/\"//g;
	my $record_nodeid = $record_object->{nodeId};
	my $ao_opencloseflag = $$ao_bject->{openCloseFlag};
	my $record_serialno = $record_object->{serialNo};
	
	#print "\nao_type=$ao_type\n";
	#print "record_type=$record_type\n";
	#print "ao_nodeid=$ao_nodeid\n";
	#print "record_nodeid=$record_nodeid\n";
	#print "ao_opencloseflag=$ao_opencloseflag\n";
	#print "record_serialno=$record_serialno\n";	
	
	if($record_type eq "000a")	#Kiti
	{
		if($ao_type eq "000a")	#Kiti
		{
			if($ao_nodeid eq $record_nodeid)
			{
				$is_correlated_mo=1;
			}
			else
			{
				$is_correlated_mo=0;
			}
		}
		elsif($ao_type eq "0005")	#Sector
		{
			if($ao_opencloseflag eq $record_serialno)
			{
				$is_correlated_mo=1;
			}
			else
			{
				$is_correlated_mo=0;
			}
		}
		else #BTS
		{
			$is_correlated_mo=1;
		}
	}
	elsif($record_type eq "0005")	#Sector
	{
		if($ao_type eq "000a" || $ao_type eq "0005")	#Kiti or Sector
		{
			if($ao_opencloseflag eq $record_serialno)
			{
				$is_correlated_mo=1;
			}
			else
			{
				$is_correlated_mo=0;
			}
		}
		else  #BTS
		{
			$is_correlated_mo=1;
		}
	}
	else
	{
		$is_correlated_mo=1; #BTS, MMS, RNC, EPE, xGSN, IP-RNC, BS-TDM etc.
	}
	#print "IsCorelatedMO return $is_correlated_mo\n";
	return $is_correlated_mo;
}


# check if patternId contains CstNo 
sub ContainCstNo
{
	my $pId=$_[0];
	my $cNo=$_[1];
	$pId=~s/\"$//;		#delete the '"' from behind
	$pId=~s/\"\"/\"/g;	#hanlle '"'
	#$pId=~s/\s+/ /g;	#delete extra space
	#print "pId=\"$pId\"\ncNo=\"$cNo\"\n";
	
	if( $cNo=~/^\s?$/ )
	{
		#print "ContainCstNo return 0\n";
		return 0;
	}
	if( $pId =~ /(^|\s)$cNo($|\s)/ )
	{
		#print "ContainCstNo return 1\n";
		return 1;
	}
	else
	{	
		#print "ContainCstNo return 0\n";
		return 0;
	}
}

# check if controlTime in work file is earlier 
sub IsWorkControlTimeEarlier
{
	my $ao_controlTime=$_[0];
	my $record_controlTim=$_[1];	
	$ao_controlTime=~s/\D//g;		#delete the non-number character
	$record_controlTim=~s/\D//g;	#delete the non-number character
	
	if($ao_controlTime=~/^$/)		#if the ao's controlTime is null
	{
		return 1;
	}
	elsif( $ao_controlTime gt $record_controlTim )	#if the work record's controlTime is earlier
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

# get the earliest time
sub GetEarliestControlTime
{
	my $list=$_[0];
	my $earliestTime=shift @$list;
	foreach(@$list)
	{
		$earliestTime = $_ if $_ lt $earliestTime;
	}
	return $earliestTime;
}

# set the controlTime through fcl file.
sub UpdateControlTime
{
	system "$MANAGE_CMD do $SET_CONTROL_TIME_FCL" if $at_least_one;		#do set fcl
	unlink $SET_CONTROL_TIME_FCL;						#delete set fcl file
}


