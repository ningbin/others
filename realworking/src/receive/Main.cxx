/*
 *
 * FILENAME     : Main.cxx
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


#include <iostream>
#include "WApp.hxx"
#include "WSaxXml.hxx"
#include "WSocket.hxx"
#include "WThread.hxx"
#include "WTimeOut.hxx"
#include "WException.hxx"
#include "WMessage.hxx"
#include "common_log.hxx"
#include "common_conf.hxx"
#include "DBWrite.hxx"


using namespace std;

volatile sig_atomic_t get_term_signal = 0;
volatile sig_atomic_t get_stop_signal = 0;

static void signal_handler( int signum )
{
	if(signum == MY_TERM_SIG && get_term_signal==0)
	{
		get_term_signal = 1;
		struct sigaction act;
		act.sa_handler = signal_handler;
		sigaction( MY_STOP_SIG, &act, NULL );
	}
	else if(signum == MY_STOP_SIG && get_stop_signal==0)
	{
		get_stop_signal = 1;
	}
}


int main(int argC, char* argV[])
{
	// parameter check
	if( argC<2 )
	{
		cerr<<"No parameter"<<endl;
		exit(-1);
	}
	const char* confFileName = argV[1];
	COUT("Parameter confFileName = "<<confFileName);
	
	//read conf file and init log
	WApp::Init(confFileName);
	
	// register stop signal handling fuction
	struct sigaction act;
	act.sa_handler = signal_handler;
	sigaction( MY_TERM_SIG, &act, NULL );
	
	SEND_NOTIFY_WARNING_AO( MESSAGE_APP_START );	
	// create threads
	try
	{
		WApp::m_pWorkThread = new WWorkThread;
		WApp::m_pHcThread = new WThread;
		WApp::m_pHcCheckThread = new WHCCheckThread(WApp::m_hc_timeout);
		WApp::m_pDbThread = new DBWrite( WApp::m_work_buff_size );
		
		((DBWrite*)WApp::m_pDbThread)->Init();
		
		WApp::m_pWorkThread->Create();
		WApp::m_pHcCheckThread->Create();
		WApp::m_pHcThread->Create();
		WApp::m_pDbThread->Create();
	}
	catch(...)
	{
		TRACE_ERROR("Failed to create threads");
		delete WApp::m_pWorkThread;
		delete WApp::m_pHcCheckThread;
		delete WApp::m_pHcThread;
		delete WApp::m_pDbThread;
		SEND_NOTIFY_WARNING_AO( MESSAGE_APP_ERROR_THREAD );
		exit(-1);
	}
	TRACE_DEBUG("Success to creating threads");

	// create socket connection
	WSocket server( WApp::m_socket_port );
	WApp::m_pSocket = &server;
	TRACE_DEBUG("Success to create WSocket");	
	try
	{
		server.Open();
		server.Connect();
	}
	catch(...)
	{
		WApp::m_pHcCheckThread->Cancel();
		WApp::m_pHcCheckThread->Wait();
		WApp::m_pHcThread->Cancel();
		WApp::m_pHcThread->Wait();
		WApp::m_pDbThread->Cancel();
		WApp::m_pDbThread->Wait();
		
		delete WApp::m_pWorkThread;
		delete WApp::m_pHcCheckThread;
		delete WApp::m_pHcThread;
		delete WApp::m_pDbThread;
		
		if( server.IsInterrupt() )
		{
			SEND_NOTIFY_WARNING_AO( MESSAGE_APP_END );
		}
		else
		{
			SEND_NOTIFY_WARNING_AO( MESSAGE_APP_ERROR_SOCKET );
		}
		exit(-1);
	}

	WSaxXml::Initialize();
	// while not get the stop signal
	try
	{
		server.ReadWork();
	}
	catch(...)
	{
		TRACE_TRACE("Exit read work");
	}
	WSaxXml::Terminate();
	
	// stop hc thread
	TRACE_TRACE("Cancel HC thread");
	WApp::m_pHcCheckThread->Cancel();
	WApp::m_pHcCheckThread->Wait();
	WApp::m_pHcThread->Cancel();
	WApp::m_pHcThread->Wait();

	// close listening socket
	server.Close();

	// stop db thread
	TRACE_TRACE("Cancel DB thread");
	WApp::m_pDbThread->Cancel();
	WApp::m_pDbThread->Wait();
	
	delete WApp::m_pWorkThread;
	delete WApp::m_pHcCheckThread;
	delete WApp::m_pHcThread;
	delete WApp::m_pDbThread;
	
	SEND_NOTIFY_WARNING_AO( MESSAGE_APP_END );	
	exit(0);
}

