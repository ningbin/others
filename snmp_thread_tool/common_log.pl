##---------------------------------------------------------------------------
#
# FILENAME		: common_log.pl
# PROGRAM		: perl program
# CREATE DATE	: 2009/10/13
# MODIFY DATE	: 
# AUTHOR		: Ning Bin
# USAGE			:
# DESCRIPTION	: log funtions for common use
# RETURN CODE	: 
# 
# Copyright_2009_Hewlett-Packard
##---------------------------------------------------------------------------

use Time::HiRes qw(gettimeofday);

# log function
# parameters: $1:level, $2:mask, $3:if print all $4:echo mode
sub TraceObject
{
	my $logLevel 	= shift;
	my $logMask  	= shift;
	my $printAll    = shift;
	my $echoMode	= shift;
	
	if( ( $LOG_MASK & $logMask ) == 0 )
	{
		return sub {};
	}
	
	if( $printAll == 0 )
	{
		if( $echoMode == 0)
		{
			return sub
			{ 
				print LOG_FILE "$_[0]\n";
			}
		}
		else
		{
			return sub
			{ 
				print LOG_FILE "$_[0]\n";
				print "$_[0]\n";
			}
		}
	}
	else 
	{
		if( $echoMode == 0)
		{
			return sub
			{
				my ($sec, $usec) = gettimeofday();
				my $event_time=strftime('%Y-%m-%d %H:%M:%S', localtime($sec));
				
				printf LOG_FILE "${event_time}.%06s[$$]\<$logLevel\>$_[0]\n", $usec;
			}
		}
		else
		{
			return sub
			{
				my ($sec, $usec) = gettimeofday();
				my $event_time=strftime('%Y-%m-%d %H:%M:%S', localtime($sec));
				
				printf LOG_FILE "${event_time}.%06s[$$]\<$logLevel\>$_[0]\n", $usec;
				printf "${event_time}.%06s[$$]\<$logLevel\>$_[0]\n", $usec;
			}
		}
	}
}

sub OpenLog
{
	my $LOG_FILE = shift;
	my $max_size = shift;
	if( $max_size>0 )
	{
		my ( undef, undef, $mode1, $nlink1, 
	  	$uid1, $gid1, $rdev1, $size1, 
	  	$atime1, $mtime1, $ctime1, 
	  	undef, undef )       = stat(${LOG_FILE}.".1");
	  	my ( undef, undef, $mode2, $nlink2, 
	  	$uid2, $gid2, $rdev2, $size2, 
	  	$atime2, $mtime2, $ctime2, 
	  	undef, undef )       = stat(${LOG_FILE}.".2"); 
	  	
	  	if( $size1 && $size2 )
	  	{
	  		if( $size1<$max_size && $size2>=$max_size)
	  		{
	  			$LOG_FILE .= ".1";
	  		}
	  		elsif( $size1>=$max_size && $size2<$max_size)
	  		{
	  			$LOG_FILE .= ".2";
	  		}
	  		elsif( $size1>=$max_size && $size2>=$max_size)
	  		{
	  			if( $mtime1 > $mtime2 )
	  			{
	  				$LOG_FILE .= ".2";
	  			}
	  			else
	  			{
	  				$LOG_FILE .= ".1";
	  			}
	  			system ">$LOG_FILE";
	  		}
	  		else
	  		{
	  			if( $mtime1 < $mtime2 )
	  			{
	  				$LOG_FILE .= ".2";
	  			}
	  			else
	  			{
	  				$LOG_FILE .= ".1";
	  			}
	  		}
	  	}
	  	elsif( !$size1 && $size2 )
	  	{
	  		if( $size2<$max_size )
	  		{
	  			$LOG_FILE .= ".2";
	  		}
	  		else
	  		{
	  			$LOG_FILE .= ".1";
	  		}
	  	}
	  	elsif( $size1 && !$size2 )
	  	{
	  		if( $size1<$max_size )
	  		{
	  			$LOG_FILE .= ".1";
	  		}
	  		else
	  		{
	  			$LOG_FILE .= ".2";
	  		}
	  	}
	  	else
	  	{
	  		$LOG_FILE .= ".1";
	  	}
	}
  	
	if( !open( LOG_FILE, ">>$LOG_FILE" ))
	{
		print "Warning: can not write log $LOG_FILE : ($!)\nprocess continue...\n";
	}
	
  	return $LOG_FILE;
}

1;
