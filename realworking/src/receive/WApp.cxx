/*
 *
 * FILENAME     : WApp.cxx
 * PROGRAM      : receive
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Ning Bin
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */


#include "WApp.hxx"
#include "WThread.hxx"
#include "WSocket.hxx"
#include "common_conf.hxx"
#include "common_log.hxx"
#include "CstConf.hxx"
#include <rw/regexp.h>

RWCString WApp::m_process_log;
RWCString WApp::m_command_log;
RWCString WApp::m_osi_entity;
RWCString WApp::m_oc_name;
RWCString WApp::m_hc_ao;
RWCString WApp::m_work_ao;
RWCString WApp::m_error_ao;
int WApp::m_trace_mask = 0;
int WApp::m_log_max_size = 0;
int WApp::m_socket_port = 0;
int WApp::m_recv_socketbuff_size = SOCKET_RECV_BUFF_SIZE_DEFAULT;
int WApp::m_hc_timeout = 0;
int WApp::m_work_buff_size = 0;
	
WThread* WApp::m_pWorkThread = NULL;
WThread* WApp::m_pHcThread = NULL;
WThread* WApp::m_pHcCheckThread = NULL;
WThread* WApp::m_pDbThread = NULL;
WSocket* WApp::m_pSocket = NULL;

void WApp::Init(const char* confFile)
{
	RTWConf conf;
	if(!conf.open(confFile))
	{
		cerr<<"Can't open the config file "<<confFile<<endl;
		exit(-1);
	}
	ReadConf(conf);
}

void WApp::ReadConf( RTWConf& conf )
{
	// read log items
	m_process_log = ReadConfItem(conf,"log","RTWORK_RECV_PROCESS_LOG_NAME",false,false,false );
	m_command_log = ReadConfItem(conf,"log","RTWORK_RECV_COMMAND_LOG_NAME",false,false,false );
	m_trace_mask = atoi( ReadConfItem(conf,"log","RTWORK_RECV_PROCESS_TRACE_MASK",true,true,false ) );
	m_log_max_size = atoi( ReadConfItem(conf,"log","RTWORK_RECV_LOG_MAX_SIZE",true,false,false ) );
	//init log
	InitLog();
	TRACE_INFO("RTWORK_RECV_PROCESS_LOG_NAME : "<<m_process_log );
	TRACE_INFO("RTWORK_RECV_COMMAND_LOG_NAME : "<<m_command_log );
	TRACE_INFO("RTWORK_RECV_PROCESS_TRACE_MASK : "<<m_trace_mask );
	TRACE_INFO("RTWORK_RECV_LOG_MAX_SIZE : "<<m_log_max_size );
	
	// read command items
	m_osi_entity = ReadConfItem(conf,"command","RTWORK_RECV_NOTIFY_OSI_ENTITY");
	m_oc_name = ReadConfItem(conf,"command","RTWORK_RECV_NOTIFY_OC_NAME");
	m_hc_ao = ReadConfItem(conf,"command","RTWORK_RECV_NOTIFY_HC_COUNT_AO_ID",true);
	m_work_ao = ReadConfItem(conf,"command","RTWORK_RECV_NOTIFY_WORK_COUNT_AO_ID",true);
	m_error_ao = ReadConfItem(conf,"command","RTWORK_RECV_NOTIFY_ERROR_COUNT_AO_ID",true);
	//init command 
	InitCommand();
	
	// read other items
	m_socket_port  = atoi( ReadConfItem(conf,"socket","RTWORK_RECV_LISTEN_PORT",true ) );	
	m_recv_socketbuff_size  = atoi( ReadConfItem(conf,"socket","RTWORK_SOCKET_RECV_BUFF_SIZE",true, true) );
	if(m_recv_socketbuff_size==0)
	{
		m_recv_socketbuff_size = SOCKET_RECV_BUFF_SIZE_DEFAULT;
	}
	m_hc_timeout = atoi( ReadConfItem(conf,"socket","RTWORK_RECV_HC_TIMEOUT",true,true ) );
	m_work_buff_size = atoi( ReadConfItem(conf,"buff","RTWORK_WRITE_DB_BUFF_SIZE",true,true ) );	
	
	// for cst conf reading
	CstConf::RTWORK_ORACLE_USER = ReadConfItem(conf,"db","RTWORK_ORACLE_USER" );
	CstConf::RTWORK_ORACLE_PSW = ReadConfItem(conf,"db","RTWORK_ORACLE_PSW" );
	CstConf::RTWORK_ORACLE_SID = ReadConfItem(conf,"db","RTWORK_ORACLE_SID" );
	CstConf::RTWORK_RECV_NETYPE_CONF_FILE = ReadConfItem(conf,"path","RTWORK_RECV_NETYPE_CONF_FILE" );
	CstConf::RTWORK_RECV_RESULT_TMP_DIR = ReadConfItem(conf,"path","RTWORK_RECV_RESULT_TMP_DIR" );
	CstConf::RTWORK_RECV_RESULT_DIR = ReadConfItem(conf,"path","RTWORK_RECV_RESULT_DIR" );
	CstConf::RTWORK_RECV_RETRY_INTERVAL = atoi(ReadConfItem(conf,"retry","RTWORK_RECV_RETRY_INTERVAL",true ));
	CstConf::RTWORK_DB_RETRY_NUMBER = atoi(ReadConfItem(conf,"retry","RTWORK_DB_RETRY_NUMBER",true ));
}

RWCString WApp::ReadConfItem( RTWConf& conf, const char* section, const char* name,
							  bool isNumber, bool optional, bool hasLog )
{
	RWCString value = (conf.read(section,name)).c_str();
	if(hasLog)
	{
		TRACE_INFO(name<<" : "<<value );
	}
	if( value =="" )
	{
		if(hasLog)
		{
			TRACE_ERROR("Missing config item "<<name<<" in section "<<section);
		}
		if(!optional)
		{
			cerr<<"Missing config item "<<name<<" in section "<<section<<endl;
			exit(-1);
		}
	}
	else if(isNumber)
	{
		RWCRegexp re("^[0-9]+$");
		if( value(re)=="" )
		{
			if(hasLog)
			{
				TRACE_ERROR("Config item "<<name<<" is error: "<<value);
			}
			cerr<<"Config item "<<name<<" is error: "<<value<<endl;
			exit(-1);
		}
	}
	return value;
}

void WApp::InitLog()
{
	INIT_LOG( m_log_max_size, m_trace_mask );
	INIT_TRACE( COMMAND, m_command_log );
	INIT_TRACE( ERROR, m_process_log );
	INIT_TRACE( WARNING, m_process_log );
	INIT_TRACE( DEBUG, m_process_log );
	INIT_TRACE( INFO, m_process_log );
	INIT_TRACE( TRACE, m_process_log );
	INIT_TRACE( DATA, m_process_log );	
}

void WApp::InitCommand()
{
	INIT_NOTIFY_OSI_ENTITY(m_osi_entity);	
	INIT_NOTIFY_OC_NAME(m_oc_name);	
	INIT_HC_COUNT_AO_ID(m_hc_ao);
	INIT_WORK_COUNT_AO_ID(m_work_ao);
	INIT_ERROR_COUNT_AO_ID(m_error_ao);
}

int WTest::hc_sleep_time=atoi(getenv("RTWORK_HC_SLEEP_TIME"));
int WTest::work_sleep_time=atoi(getenv("RTWORK_WORK_SLEEP_TIME"));
int WTest::hc_sleep_num=atoi(getenv("RTWORK_HC_SLEEP_NUM"));
int WTest::work_sleep_num=atoi(getenv("RTWORK_WORK_SLEEP_NUM"));

