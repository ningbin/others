/*
 *
 * FILENAME     : WTimeOut.cxx
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


#include "common_log.hxx"
#include "WTimeOut.hxx"
#include "WMessage.hxx"
#include "WApp.hxx"
#include "WSocket.hxx"

WTimeOut::WTimeOut( int flag ) : m_flag(flag)
{
	TRACE_DEBUG("Construct WTimeOut, flag="<<flag);
}

WTimeOut::WTimeOut() : m_flag(HC_CHECK_FLAG)
{
	TRACE_DEBUG("Construct check WTimeOut");
}

WTimeOut::~WTimeOut()
{
	TRACE_DEBUG("WTimeOut destructed");
}

void WTimeOut::Run(void* pHcCheckThread)
{
	if( m_flag == HC_CHECK_FLAG )
	{
		TRACE_DEBUG("Timeout checking...");
	}
	else if( m_flag == HC_STOP_FLAG )
	{
		TRACE_DEBUG("Stop timeout checking");
	}
}

time_t WTimeOut::last_hc_time = 0;


WHCCheckThread::WHCCheckThread( int timeout )
 : m_lock(false),m_stop(false),m_timeout(timeout)
{
	pthread_mutex_init( &m_mutex,NULL);
	pthread_cond_init( &m_cond,NULL);
	TRACE_DEBUG("Consturct WHCCheckThread, timeout="<<m_timeout);
}

WHCCheckThread::WHCCheckThread()
 : m_lock(false),m_stop(false),m_timeout(0)
{
	pthread_mutex_init( &m_mutex,NULL);
	pthread_cond_init( &m_cond,NULL);
	TRACE_DEBUG("Consturct WHCCheckThread, timeout="<<m_timeout);
}

WHCCheckThread::~WHCCheckThread()
{
	pthread_mutex_destroy( &m_mutex );
	pthread_cond_destroy( &m_cond );	
}


void WHCCheckThread::BeforeCancel()
{
	pthread_mutex_lock( &m_mutex );
	if(m_lock)
	{
		pthread_cond_signal(&m_cond);
	}
	pthread_mutex_unlock( &m_mutex );
}

void WHCCheckThread::BeforeNotify(WEvent* event)
{
	if(!event) return;
	if( ((WTimeOut*)event)->GetFlag()==HC_CHECK_FLAG)
	{
		WTimeOut::last_hc_time = time(NULL);
		TRACE_DEBUG("last_hc_time:"<<WTimeOut::last_hc_time); 
		m_stop=false;
	}
	else
	{
		m_stop=true;
		TRACE_DEBUG("Notify stop timeout");
	}
	
	pthread_mutex_lock( &m_mutex );
	if(m_lock)
	{
		pthread_cond_signal(&m_cond);
	}
	pthread_mutex_unlock( &m_mutex );
}

void WHCCheckThread::AfterRun()
{
	pthread_mutex_lock( &m_mutex );
	if( !m_stop && m_timeout )
	{
		struct timespec timeout_time;
		timeout_time.tv_sec = WTimeOut::last_hc_time + m_timeout;
		timeout_time.tv_nsec = 0;
		m_lock = true;
		int ret = pthread_cond_timedwait( &m_cond, &m_mutex, &timeout_time );
		m_lock = false;
		if( !(WApp::m_pSocket->IsConnected()) )
		{
			TRACE_DEBUG("Socket is broken now");
		}
		else if( ret == ETIMEDOUT )
		{
			TRACE_WARNING("Receive HC timeout");
			SEND_NOTIFY_AO( MESSAGE_HC_TIMEOUT );
		}
		else
		{
			TRACE_DEBUG("HC not timeout");
		}
	}
	pthread_mutex_unlock( &m_mutex );
}


