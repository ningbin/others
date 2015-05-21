#!/usr/bin/perl
##---------------------------------------------------------------------------
#
# FILENAME		: undoterminate_ao.pl
# PROGRAM		: perl program
# CREATE DATE	: 2009/02/10
# MODIFY DATE	: 
# AUTHOR		: Ning Bin
# USAGE			: undoterminate_ao.pl
# DESCRIPTION	: 
# RETURN CODE	: NONE
# 
# Copyright_2009_Hewlett-Packard
##---------------------------------------------------------------------------

# realtime_work monitor conf file
$RT_WORK_MONITOR_CONF_FILE="/NWS-ALM-1PRG/app/realworking/conf/rtwork_monitor.conf";

# realtime_work receive conf file
$RT_WORK_RECV_CONF_FILE="/NWS-ALM-1PRG/app/realworking/conf/rtwork_recv.conf"; 

# tmp fcl file
$FCL_FILE="/tmp/undoterminate_ao.$$.fcl";

# manage command path
$MANAGE_CMD="/usr/opt/temip/bin/manage";

# open monitor conf file
if( !open( MONITOR_CONF_FILE, "<", "$RT_WORK_MONITOR_CONF_FILE" ))
{
	die "Can not read monitor conf file $RT_WORK_MONITOR_CONF_FILE : ($!)";
}
# open receive conf file
if( !open( RECV_CONF_FILE, "<", "$RT_WORK_RECV_CONF_FILE" ))
{
	die "Can not read receive conf file $RT_WORK_RECV_CONF_FILE : ($!)";
}
# open tmp fcl file
if( !open( FCL_FILE, ">", "$FCL_FILE" ))
{
	die "Can not write tmp fcl file $FCL_FILE : ($!)";
}

# read monitor conf file
print "\nread monitor conf file:\n";
while(<MONITOR_CONF_FILE>)
{
	next if( /^\s*\#/ );
	next if( /^\s*$/ );
	if(/RTWORK_RECV_OC_NAME\s*=\s*(.+)/)
	{
		$recv_oc_name=$1;
		print;
	}
	elsif(/RTWORK_RECV_AO_ID\s*=\s*(.+)/)
	{
		$recv_ao_id=$1;
		print;
	}
	elsif(/RTWORK_REFL_OC_NAME\s*=\s*(.+)/)
	{
		$refl_oc_name=$1;
		print;
	}
	elsif(/RTWORK_REFL_AO_ID\s*=\s*(.+)/)
	{
		$refl_ao_id=$1;
		print;
	}
}
close MONITOR_CONF_FILE;

# real receive conf file
print "\nread receive conf file:\n";
while(<RECV_CONF_FILE>)
{
	next if( /^\s*\#/ );
	next if( /^\s*$/ );
	if(/RTWORK_RECV_NOTIFY_HC_COUNT_AO_ID\s*=\s*(.+)/)
	{
		$hc_ao_id=$1;
		print;
	}
	elsif(/RTWORK_RECV_NOTIFY_WORK_COUNT_AO_ID\s*=\s*(.+)/)
	{
		$work_ao_id=$1;
		print;
	}
	elsif(/RTWORK_RECV_NOTIFY_ERROR_COUNT_AO_ID\s*=\s*(.+)/)
	{
		$error_ao_id=$1;
		print;
	}
}
close RECV_CONF_FILE;

# check all items
print "\nchecking conf items exist...\n";
$error=0;
&CheckConfItem( $recv_oc_name, "RTWORK_RECV_OC_NAME", $RT_WORK_MONITOR_CONF_FILE );
&CheckConfItem( $refl_oc_name, "RTWORK_REFL_OC_NAME", $RT_WORK_MONITOR_CONF_FILE );
&CheckConfItem( $recv_ao_id, "RTWORK_RECV_AO_ID", $RT_WORK_MONITOR_CONF_FILE );
&CheckConfItem( $refl_ao_id, "RTWORK_REFL_AO_ID", $RT_WORK_MONITOR_CONF_FILE );
&CheckConfItem( $hc_ao_id, "RTWORK_RECV_NOTIFY_HC_COUNT_AO_ID", $RT_WORK_RECV_CONF_FILE );
&CheckConfItem( $work_ao_id, "RTWORK_RECV_NOTIFY_WORK_COUNT_AO_ID", $RT_WORK_RECV_CONF_FILE );
&CheckConfItem( $error_ao_id, "RTWORK_RECV_NOTIFY_ERROR_COUNT_AO_ID", $RT_WORK_RECV_CONF_FILE );
if( $error ==1 ) 
{
	unlink $FCL_FILE;
	print "UndoTerminate Failed!\n";
	exit -1;
}


print "\nmaking undoterminate ao fcl command...\n";
print FCL_FILE "undoterminate oper $recv_oc_name alarm $recv_ao_id\n";
print FCL_FILE "undoterminate oper $refl_oc_name alarm $refl_ao_id\n";
print FCL_FILE "undoterminate oper $recv_oc_name alarm $hc_ao_id\n";
print FCL_FILE "undoterminate oper $recv_oc_name alarm $work_ao_id\n";
print FCL_FILE "undoterminate oper $recv_oc_name alarm $error_ao_id\n";
close FCL_FILE;

print "\nexecuting undoterminate ao fcl command...\n";
system "$MANAGE_CMD do $FCL_FILE";
unlink $FCL_FILE;


sub CheckConfItem
{
	$value=$_[0];
	$name=$_[1];
	$conf=$_[2];
	if( $value eq "" )
	{
		print "Missing \"$name\" in $conf\n";
		$error=1;
	}
}

