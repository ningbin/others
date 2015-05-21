/*
 *
 * FILENAME     : WQueue.hxx
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

#ifndef _REAL_TIME_WORK_QUEUE_HXX_
#define _REAL_TIME_WORK_QUEUE_HXX_

#include <rw/tpslist.h>
#include <pthread.h>
#include "WException.hxx"
#include "common_log.hxx"
#include <iostream>

template <class T> class WQueue;

template <class T>
class WQueue
{
	public:
		WQueue();
		WQueue(int max);
		~WQueue();
		bool Put( T* );
		T* Get();
		void Close();
		bool IsClosed(){return m_close;};

	private:
		RWTPtrSlist<T> m_queue;
		int m_max;
		int m_num;
		bool m_close;
		pthread_cond_t m_cond_put;
		pthread_cond_t m_cond_get;
		pthread_mutex_t m_mutex;
};

template <class T>
WQueue<T>::WQueue(): m_num(0), m_max(0), m_close(false)
{
	if( pthread_mutex_init( &m_mutex,NULL) != 0 )
		throw WException("Init thread mutex m_mutex failed",2);
	if( pthread_cond_init( &m_cond_put,NULL) != 0 )
		throw WException("Init thread cond m_cond_put failed",2);	
	if( pthread_cond_init( &m_cond_get,NULL) != 0 )
		throw WException("Init thread cond m_cond_get failed",2);
}


template <class T>
WQueue<T>::WQueue(int max): m_num(0), m_max(max), m_close(false)
{
	if( pthread_mutex_init( &m_mutex,NULL) != 0 )
		throw WException("Init thread mutex m_mutex failed",2);
	if( pthread_cond_init( &m_cond_put,NULL) != 0 )
		throw WException("Init thread cond m_cond_put failed",2);	
	if( pthread_cond_init( &m_cond_get,NULL) != 0 )
		throw WException("Init thread cond m_cond_get failed",2);
}

template <class T>
WQueue<T>::~WQueue()
{
	pthread_mutex_destroy( &m_mutex );
	pthread_cond_destroy( &m_cond_put );
	pthread_cond_destroy( &m_cond_get );
	if(!m_queue.isEmpty())
	{
		TRACE_DEBUG("Destructing all items!");
		m_queue.clearAndDestroy();
	}
	TRACE_DEBUG("WQueue destructed!");
}

template <class T>
bool WQueue<T>::Put( T* item )
{
	if( (!item) || m_close )
	{
		return false;
	}
	pthread_mutex_lock(&m_mutex);
	if( m_max && m_num == m_max )
	{
		TRACE_WARNING("The queue is full!");
		pthread_cond_wait( &m_cond_put, &m_mutex );
	}
	m_queue.insert( item );
	++m_num;
	if( m_num == 1 )
	{
		TRACE_DEBUG("Unlock get!");
		pthread_cond_signal( &m_cond_get );
	}
	pthread_mutex_unlock(&m_mutex);
	return true;
}

template <class T>
T* WQueue<T>::Get()
{
	pthread_mutex_lock(&m_mutex);
	if( m_num == 0 && !m_close)
	{	
		TRACE_DEBUG("Lock get");
		pthread_cond_wait( &m_cond_get, &m_mutex );
	}
	if( m_num == 0 && m_close)
	{	
		pthread_mutex_unlock(&m_mutex);
		TRACE_DEBUG("Return NULL");
		return NULL;
	}
	T* item = m_queue.get();	
	--m_num;
	if( m_max && m_num == m_max-1 )
	{
		TRACE_DEBUG("Unlock put!");
		pthread_cond_signal( &m_cond_put );
	}
	pthread_mutex_unlock(&m_mutex);
	
	return item;
}

template <class T>
void WQueue<T>::Close()
{
	pthread_mutex_lock(&m_mutex);
	m_close=true;	
	if( m_num == 0 )
	{
		TRACE_DEBUG("Closed, unlock get!");
		pthread_cond_signal( &m_cond_get );
	}
	pthread_mutex_unlock(&m_mutex);
}

#endif

