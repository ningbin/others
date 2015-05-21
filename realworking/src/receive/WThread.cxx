/*
 *
 * FILENAME     : WThread.cxx
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
#include "WThread.hxx"
#include "WApp.hxx"
#include "WSocket.hxx"
#include "WException.hxx"
#include "common_log.hxx"
#include <unistd.h>

extern volatile sig_atomic_t get_term_signal;

using namespace std;

WThread::WThread(int maxEvent):m_cancel(false),m_end(false),m_EventList(maxEvent)
{
	TRACE_DEBUG("Constructing WThread...");
}

WThread::WThread():m_cancel(false),m_end(false),m_EventList(0)
{
	TRACE_DEBUG("Constructing WThread...");
}

WThread::~WThread()
{
	TRACE_DEBUG("WThread "<<m_pThreadId<<" destructed");
}

void* ExecuteThread(void* object)
{
	sigset_t set;
	sigfillset( &set );
	pthread_sigmask( SIG_SETMASK, &set, NULL );
	
	((WThread*)object)->OnExecute();
	return (void*)0;
}

bool WThread::Create()
{
	try
	{
		int err = pthread_create(&m_pThreadId, NULL, ExecuteThread, this);
	    if (err != 0)
	    {
	    	TRACE_ERROR("Can't create thread: "<<strerror(err));
	    	throw WException("can't create thread",1);
	    }
	    else
	    {
	    	TRACE_DEBUG("WThread "<<m_pThreadId<<" has created!");
	    }
	}
	catch(...)
	{
		return false;
	}
	return true;
}

void WThread::Cancel()
{
	BeforeCancel();
	m_EventList.Close();
}

void WThread::Wait()
{
	pthread_join( m_pThreadId, NULL );
}

bool WThread::Notify( WEvent* event )
{
	bool result = true;
	BeforeNotify(event);
	if( !m_EventList.Put( event ) )
	{
		if( event )
		{
			delete event;
			event = NULL;
		}
		result = false;
	}
	return result;
}

void WThread::OnExecute()
{
	TRACE_TRACE("OnExecute start");
	while( !m_cancel )
	{
		WEvent* event;
		try
		{
			event = m_EventList.Get();
			if( event )
			{
				event->Run(this);
				delete event;
				event = NULL;
				AfterRun();
			}
			else
			{
				TRACE_DEBUG("Event queue is closed");
				m_cancel = true;
			}
		}
		catch(...)
		{
			if( event )
			{
				delete event;
				event = NULL;
			}
			TRACE_DEBUG("Catch ...");
		}
	}
	m_end=true;
	BeforeEnd();
	TRACE_TRACE("OnExecute end");
}

void WWorkThread::BeforeEnd()
{
	if(get_term_signal && WApp::m_pSocket->IsStart())
	{
		TRACE_DEBUG("Notify main thread");
		pthread_kill( 1, MY_STOP_SIG );
	}
}

