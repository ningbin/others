/*
 *
 * FILENAME     : WApp.hxx
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

#ifndef _REAL_TIME_WORK_WAPP_HXX_
#define _REAL_TIME_WORK_WAPP_HXX_

#include <rw/cstring.h>

#define SOCKET_RECV_BUFF_SIZE_DEFAULT 32768

class WThread;
class WSocket;
class RTWConf;

class WApp
{
	public:	
		static RWCString m_process_log;
		static RWCString m_command_log;
		static RWCString m_osi_entity;
		static RWCString m_oc_name;
		static RWCString m_hc_ao;
		static RWCString m_work_ao;
		static RWCString m_error_ao;
		static int m_work_buff_size;
		static int m_trace_mask;
		static int m_log_max_size;
		static int m_socket_port;
		static int m_recv_socketbuff_size;
		static int m_hc_timeout;

		static WThread* m_pWorkThread;
		static WThread* m_pHcThread;
		static WThread* m_pHcCheckThread;
		static WThread* m_pDbThread;
		static WSocket* m_pSocket;
		
		static void Init(const char* confFile);

	private:
		static void ReadConf( RTWConf& conf );
		static void InitLog();
		static void InitCommand();
		static RWCString ReadConfItem( RTWConf& conf, const char* section, const char* name,
							  		bool isNumber=false, bool optional=false, bool hasLog=true );
};

class WTest
{
	public:
		static int hc_sleep_time;
		static int work_sleep_time;
		static int hc_sleep_num;
		static int work_sleep_num;
};

#endif 
