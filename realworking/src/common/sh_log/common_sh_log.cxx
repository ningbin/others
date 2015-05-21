/*
 *
 * FILENAME		: common_sh_log.cxx
 * PROGRAM		: sh_log_out
 * CREATE DATE	: 2009/01/04
 * AUTHOR		: Xiong Weijun
 * MODIFIED BY	: 
 * 
 * DESCRIPTION	: 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */
#include "common_log.hxx"
#include <string>
using namespace std;

const int PARAMS_CNT = 8;
const string PARA_CNT_ERROR = "Parameter count is error.CMD_LINE=";

#define TRACE_ERROR_SH( message ,pid, shell) \
	if(TRACE_OBJECT_ERROR.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<pid<<"]["<<pid<<"]" \
						<<"<ERROR>"<<shell<<":"<<message<<TRACE_OBJECT_ERROR; \
	}

#define TRACE_WARNING_SH( message ,pid, shell) \
	if(TRACE_OBJECT_WARNING.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<pid<<"]["<<pid<<"]" \
						<<"<WARNING>"<<shell<<":"<<message<<TRACE_OBJECT_WARNING; \
	}

#define TRACE_DEBUG_SH( message ,pid, shell) \
	if(TRACE_OBJECT_DEBUG.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<pid<<"]["<<pid<<"]" \
						<<"<DEBUG>"<<shell<<":"<<message<<TRACE_OBJECT_DEBUG; \
	}

#define TRACE_TRACE_SH( message ,pid, shell) \
	if(TRACE_OBJECT_TRACE.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<pid<<"]["<<pid<<"]" \
						<<"<TRACE>"<<shell<<":"<<message<<TRACE_OBJECT_TRACE; \
	}


#define TRACE_INFO_SH( message ,pid, shell) \
	if(TRACE_OBJECT_INFO.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<pid<<"]["<<pid<<"]" \
							<<"<INFO>" <<shell<<":"<<message <<TRACE_OBJECT_INFO; \
	}


/*
 * FUNCTION	NAME:	Main()
 * AUTHOR		:	Xiong Weijun
 * PARAMETER	:	log_max_size
 *				:	current_mask
 *				:	trace_level
 *				:	file_name
 *				:	message
 *				:	pid
 *				:	shell
 * MODIFIED BY	:
 * RETURN CODE	:	0	:	SUCCESS
 *					1	:	FAIL
 * DESCRIPTION	:	main function
 */
int main(int argv, char *argc[])
{
	if (argv != PARAMS_CNT)
	{
		cout<<PARA_CNT_ERROR<<endl;
		return 1;
	}
	
	long log_max_size = atoi(argc[1]);
	int current_mask = atoi(argc[2]);
	string trace_level = argc[3];
	string file_name = argc[4];
	string message = argc[5];
	string pid = argc[6];
	string shell = argc[7];
	
	INIT_LOG( log_max_size, current_mask );
	INIT_TRACE( INFO, file_name.c_str() );
	INIT_TRACE( ERROR, file_name.c_str() );
	INIT_TRACE( DEBUG, file_name.c_str() );
	INIT_TRACE( TRACE, file_name.c_str() );
	INIT_TRACE( WARNING, file_name.c_str() );
	
	
	if (trace_level == "INFO")
	{
		TRACE_INFO_SH(message, pid, shell);
	}
	else if (trace_level == "ERROR")
	{
		TRACE_ERROR_SH(message, pid, shell);
	}
	else if (trace_level == "DEBUG")
	{
		TRACE_DEBUG_SH(message, pid, shell);
	}
	else if (trace_level == "TRACE")
	{
		TRACE_TRACE_SH(message, pid, shell);
	}
	else if(trace_level == "WARNING")
	{
		TRACE_WARNING_SH(message, pid, shell);
	}


	return 0;
}
