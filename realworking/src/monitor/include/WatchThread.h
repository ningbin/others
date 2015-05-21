/*
 *
 * FILENAME     : WatchThread.h
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

#ifndef WATCHTHREAD_H_
#define WATCHTHREAD_H_
#include "MonitorCommon.h"

typedef void *(*ThreadFunc_t)(void*);

class WatchThread
{
public:
	WatchThread();
	~WatchThread();
	bool Start(ThreadFunc_t threadFunc);
	bool Stop();
	bool IsRunning();
	
protected:
	static const int WATCHER_EXIT_ABNORMAL = 1;
	static void * const WATCHER_EXIT_NORMAL;
	string m_threadName;
	pthread_t m_thread;
	int m_threadExitValue;
};
#endif /*WATCHTHREAD_H_*/
