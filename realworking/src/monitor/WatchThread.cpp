/*
 *
 * FILENAME     : WatchThread.cpp
 * PROGRAM      : monitor
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Tan JunLiang
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#include "MonitorCommon.h"
#include "WatchThread.h"

void * const WatchThread::WATCHER_EXIT_NORMAL = PTHREAD_CANCELED;

WatchThread::WatchThread():m_thread(0), m_threadExitValue(0)
{
	
}

WatchThread::~WatchThread()
{
	
}

bool WatchThread::IsRunning()
{
	if (m_thread == 0)
	{
		return false;
	}
	else
	{
		return pthread_kill(m_thread, 0) == 0 ? true : false;
	}
}

bool WatchThread::Start(ThreadFunc_t threadFunc)
{
	int ret = 0;
	if ((ret = pthread_create(&m_thread, NULL, threadFunc, this)) != 0)
	{
		ERROR_LOG("Failed to create thread(%s) error:%s", m_threadName.c_str(), strerror(ret));
		return false;
	}
	return true;
}

bool WatchThread::Stop()
{
	INFO_LOG("Stop thread(%s) begin...", m_threadName.c_str());
	int ret = 0;
	int *retThread;
	if ((ret = pthread_cancel(m_thread)) != 0)
	{
		ERROR_LOG("Do system API function pthread_cancel() error:%d, %s", ret, strerror(ret));
		return false;
	}
	if ((ret = pthread_join(m_thread, (void **)(&retThread))) != 0)
	{
		ERROR_LOG("Do system API function pthread_join() error:%d, %s", ret, strerror(ret));
		return false;
	}
	if (retThread != WATCHER_EXIT_NORMAL)
	{
		ERROR_LOG("%s exited abnormally!", m_threadName.c_str());
		return false;
	}
	INFO_LOG("Thread(%s) is stopped successfully!", m_threadName.c_str());
	return true;
}
