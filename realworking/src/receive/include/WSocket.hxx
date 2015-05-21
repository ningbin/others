/*
 *
 * FILENAME     : WSocket.hxx
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

#ifndef _REAL_TIME_WORK_SOCKET_HXX_
#define _REAL_TIME_WORK_SOCKET_HXX_


#include <netdb.h>
#include <sys/socket.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>
#include <pthread.h>
#include <rw/cstring.h>

class WHead;
class WThread;

class WSocket
{
	public:
		WSocket(int port);
		~WSocket();
		void Open();
		void Close();
		void Connect();
		void Disconnect();
		void ReadWork();
		void WriteResponse( WHead& head );
		bool IsConnected(){return m_connected;};
		bool IsStart(){return m_start;};
		bool IsInterrupt(){ return m_interrupt;};
		void IncWorkCount();
		
	private:
		WSocket();
		ssize_t Readn(char *vptr, size_t n );
		ssize_t Writen(const char *vptr, size_t n );
		void CheckSignal();
		void SetRecvBuff();
		void CheckRecvBuff();
		
	private:
		int m_port;
		int m_serv_fd;
		int m_conn_fd;
		bool m_connected;
		bool m_start;
		bool m_interrupt;
		pthread_mutex_t m_mutex;
		size_t m_hc_count;
		size_t m_work_count;
		size_t m_error_count;
};

#define NOT_CONNECT_YET 99

#endif
