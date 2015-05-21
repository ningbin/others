/*
 *
 * FILENAME     : WTimeOut.hxx
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

#ifndef _REAL_TIME_WORK_TIME_OUT_HXX_
#define _REAL_TIME_WORK_TIME_OUT_HXX_

#include "WThread.hxx"
#include "time.h"

class WTimeOut : public WEvent
{
	public:
		WTimeOut( int flag );
		WTimeOut();
		~WTimeOut();
		void Run(void*);
		int GetFlag(){return m_flag;};		
		static time_t last_hc_time;

	private:		
		int m_flag;
};

#define HC_CHECK_FLAG 0
#define HC_STOP_FLAG 1


class WHCCheckThread : public WThread
{
	public:
		WHCCheckThread( int timeout );
		WHCCheckThread();
		~WHCCheckThread();
		
		bool m_stop;
		
	private:
		void BeforeCancel();		
		void BeforeNotify(WEvent* event);
		void AfterRun();
		
	private:
		int m_timeout;
		bool m_lock;
		pthread_cond_t m_cond;
		pthread_mutex_t m_mutex;
};


#endif

