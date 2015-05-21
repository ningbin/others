/*
 *
 * FILENAME     : WThread.hxx
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

#ifndef _REAL_TIME_WORK_THREAD_HXX_
#define _REAL_TIME_WORK_THREAD_HXX_


#include <pthread.h>
#include "WQueue.hxx"

#define MY_TERM_SIG SIGTERM
#define MY_STOP_SIG SIGRTMIN

extern void* ExecuteThread(void*);

class WEvent
{
	public:
		virtual ~WEvent(){};
		virtual void Run(void*)=0;
};

template class WQueue<WEvent>;

class WThread
{
	friend void* ExecuteThread(void*);
	public:
		WThread(int maxEvent);
		WThread();
		virtual ~WThread();
		bool Create();
		virtual void Cancel();
		void Wait();
		virtual bool Notify( WEvent* event );
		bool IsEnd(){return m_end;};
		pthread_t GetThreadID(){ return m_pThreadId;};
		
	protected:
		virtual void OnExecute();
		virtual void BeforeEnd(){};
		virtual void BeforeCancel(){};
		virtual void BeforeNotify( WEvent* event ){};
		virtual void AfterRun(){};

	protected:
		bool m_cancel;
		bool m_end;
		WQueue<WEvent> m_EventList;
		pthread_t m_pThreadId;
};

class WWorkThread : public WThread
{
	protected:
		virtual void BeforeEnd();
};

#endif

