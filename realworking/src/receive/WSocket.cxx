/*
 *
 * FILENAME     : WSocket.cxx
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


#include "WSocket.hxx"
#include "WException.hxx"
#include "common_log.hxx"
#include "WApp.hxx"
#include "WHead.hxx"
#include "WThread.hxx"
#include "WTimeOut.hxx"
#include "WSaxXml.hxx"
#include "WMessage.hxx"

extern volatile sig_atomic_t get_term_signal;
extern volatile sig_atomic_t get_stop_signal;

WSocket::WSocket(int port) 
: m_port(port), m_connected(false), m_start(false),m_interrupt(false),
  m_hc_count(0), m_work_count(0), m_error_count(0)
{
	TRACE_DEBUG( "Constructing WSocket");
	pthread_mutex_init( &m_mutex,NULL);
}

WSocket::~WSocket()
{
	TRACE_DEBUG( "Destructing WSocket");
	pthread_mutex_destroy( &m_mutex );
}

void WSocket::Open()
{
	SET_HC_AO( MESSAGE_HC_COUNT<<m_hc_count);
	SET_WORK_AO( MESSAGE_WORK_COUNT<<m_work_count);
	SET_ERROR_AO( MESSAGE_ERROR_COUNT<<m_error_count);
	
	struct sockaddr_in serv_addr;
	serv_addr.sin_family=AF_INET;
	serv_addr.sin_port=htons( m_port );
	serv_addr.sin_addr.s_addr=htonl(INADDR_ANY);
	
	TRACE_TRACE("Create server socket, port = "<<m_port);
	if((m_serv_fd = socket(AF_INET,SOCK_STREAM,0))<0)
	{
		TRACE_ERROR( "Fail to create server socket!");
		throw WException("Fail to create server socket!",1);
	}
	else
	{
		TRACE_TRACE("Server socket "<<m_serv_fd<<" was created");
	}
	
	TRACE_TRACE("Bind server socket");
	if( bind(m_serv_fd,(struct sockaddr *)&serv_addr,sizeof(struct sockaddr)) <0)
	{
		TRACE_ERROR( "Fail to bind server socket!");
		Close();
		throw WException("Fail to bind server socket!",1);
	}
	else
	{
		TRACE_TRACE("Server socket "<<m_serv_fd<<" has bind");
	}
	
	// set socket receive buff size
	SetRecvBuff();
	
	TRACE_TRACE("Create listening");
	if( listen(m_serv_fd,1) <0 )
	{
		TRACE_ERROR( "Fail to listen socket!");
		Close();
		throw WException("Fail to listen socket!",1);
	}
	else
	{
		TRACE_TRACE("Server socket "<<m_serv_fd<<" listening ...");
	}
}

void WSocket::Close()
{
	close( m_serv_fd );
	TRACE_TRACE("Listen socket "<<m_serv_fd<<" was closed");
}

void WSocket::Connect()
{
	// conncet to socket client
	struct sockaddr_in conn_addr;
	int len = sizeof(conn_addr);
	if( get_term_signal==1 )
	{
		Close();
		TRACE_TRACE("Cancel Work thread");
		(WApp::m_pWorkThread)->Cancel();
		(WApp::m_pWorkThread)->Wait();
		m_interrupt = true;
		throw WException("got SIGTERM signal, interrupted");
	}
	TRACE_TRACE("Waiting for connection ...");
	if( (m_conn_fd=accept( m_serv_fd, (struct sockaddr *)&conn_addr, &len ))<0 )
	{
		if(errno == EINTR)
		{	
			TRACE_DEBUG("Check signal");
			if( get_term_signal==1 )
			{
				Close();
				TRACE_TRACE("Cancel Work thread");
				(WApp::m_pWorkThread)->Cancel();
				(WApp::m_pWorkThread)->Wait();
				m_interrupt = true;
				throw WException("Got SIGTERM signal, interrupted");
			}
		}
		else
		{
			TRACE_ERROR("Fail to connect socket client : "<<strerror(errno));
			Close();
			throw WException("Fail to connect socket client!",2);
		}
	}
	else
	{
		m_start = true;
		m_connected = true;
		
		TRACE_TRACE("Client socket "<<m_conn_fd<<" has connected");
		SEND_NOTIFY_AO( MESSAGE_CONNECTION_SETUP );
		(WApp::m_pHcCheckThread)->Notify(new WTimeOut());
		m_hc_count = 0;
		m_work_count = 0;
		m_error_count = 0;
		SET_HC_AO( MESSAGE_HC_COUNT<<m_hc_count);
		SET_WORK_AO( MESSAGE_WORK_COUNT<<m_work_count);
		SET_ERROR_AO( MESSAGE_ERROR_COUNT<<m_error_count);
		
		// check socket receive buff size
		CheckRecvBuff();
	}
}

void WSocket::SetRecvBuff()
{
	int nRecvBuf = WApp::m_recv_socketbuff_size;
	if( setsockopt(m_serv_fd,SOL_SOCKET,SO_RCVBUF,&nRecvBuf,sizeof(int))==0 )
	{
		TRACE_INFO("Setsockopt, SO_RCVBUF = "<<nRecvBuf);
	}		
	else
	{
		TRACE_ERROR("Do system API function setsockopt() error");
	}
	int sockBuf=0;
	int optlen=sizeof(int);
	if( getsockopt(m_serv_fd,SOL_SOCKET,SO_RCVBUF,&sockBuf,&optlen) == 0 )
	{
		TRACE_INFO("Getsockopt, SO_RCVBUF = "<<sockBuf);
	}
	else
	{
		TRACE_ERROR("Do system API function getsockopt() error");
	}
	if( nRecvBuf != sockBuf )
	{
		TRACE_ERROR("SO_RCVBUF was not set successfully");
	}	
}

void WSocket::CheckRecvBuff()
{
	int sockBuf=0;
	int optlen=sizeof(int);
	if( getsockopt(m_conn_fd,SOL_SOCKET,SO_RCVBUF,&sockBuf,&optlen) == 0 )
	{
		TRACE_INFO("Getsockopt, SO_RCVBUF = "<<sockBuf);
	}
	else
	{
		TRACE_ERROR("Do system API function getsockopt() error");
	}
	if( sockBuf != WApp::m_recv_socketbuff_size )
	{
		TRACE_ERROR("SO_RCVBUF was not set successfully");
	}
}

void WSocket::Disconnect()
{
	pthread_mutex_lock(&m_mutex);
	if(m_connected)
	{
		m_connected = false;
		(WApp::m_pHcCheckThread)->Notify(new WTimeOut(HC_STOP_FLAG));
		close( m_conn_fd );
		TRACE_TRACE("Client socket "<<m_conn_fd<<" was closed");
		SEND_NOTIFY_AO( MESSAGE_CONNECTION_BROKEN );
	}
	pthread_mutex_unlock(&m_mutex);
}


ssize_t WSocket::Readn(char *vptr, size_t n )
{
	size_t	nleft;
	ssize_t	nread;
	char	*ptr;

	ptr = vptr;
	nleft = n;
	
	fd_set rset;
	FD_ZERO( &rset );
	FD_SET( m_conn_fd,&rset );
	CheckSignal();
	while( select(FD_SETSIZE, &rset, NULL, NULL, NULL )< 0 )
	{
		if(errno == EINTR)
		{	
			CheckSignal();
		}
		else
		{
			TRACE_ERROR("Do system API funciton select() error.");
			return -1;
		}
	}
	if( FD_ISSET(m_conn_fd,&rset)== 0)
	{
		TRACE_ERROR("Can not read from socket.");
		return -1;
	}

	while (nleft > 0)
	{
		if ( (nread = read(m_conn_fd, ptr, nleft)) < 0) 
		{
			if (errno == EINTR)
			{
				CheckSignal();
				nread = 0;		/* and call read() again */
			}
			else
			{
				TRACE_ERROR("Do system API funciton read() error.");
				return -1;
			}
		}
		else if (nread == 0)
		{ break; }			/* EOF */

		nleft -= nread;
		ptr   += nread;
	}
	return(n - nleft);		/* return >= 0 */
}

ssize_t WSocket::Writen(const char *vptr, size_t n )
{
	size_t		nleft;
	ssize_t		nwritten;
	const char	*ptr;

	ptr = vptr;
	nleft = n;
	
	fd_set wset;
	FD_ZERO( &wset );
	FD_SET( m_conn_fd,&wset );
	while( select(FD_SETSIZE, NULL, &wset, NULL, NULL )< 0 )
	{
		if(errno == EINTR)
		{	
			CheckSignal();
		}
		else
		{
			TRACE_ERROR("Do system API funciton select() error.");
			return -1;
		}
	}
	if( FD_ISSET(m_conn_fd,&wset)== 0)
	{
		TRACE_ERROR("Can not write to socket.");
		return -1;
	}

	while (nleft > 0) 
	{
		if ( (nwritten = write(m_conn_fd, ptr, nleft)) <= 0)
		{
			if (nwritten < 0 && errno == EINTR)
			{
				CheckSignal();
				TRACE_TRACE("Intterupt, continue write");
				nwritten = 0;		/* and call write() again */
			}
			else
			{
				TRACE_ERROR("Do system API funciton write() error.");
				return -1;			/* error */
			}
		}

		nleft -= nwritten;
		ptr   += nwritten;
	}
	return(n);
}


void WSocket::IncWorkCount()
{
	m_work_count++;
	SET_WORK_AO( MESSAGE_WORK_COUNT<<m_work_count);
}


void WSocket::ReadWork()
{
	CheckSignal();
	char head[HEAD_SIZE]={0};
	WHead* pHead = NULL;
	string xmlBuff;
	char* buff = NULL;
	
	for(;;)
	{
		memset(head, 0, HEAD_SIZE);
		if( Readn( head, HEAD_SIZE ) <= 0 )
		{
			Disconnect();
			TRACE_ERROR("Socket connection was broken");
			xmlBuff="";
			Connect();
			continue;
		}
		pHead = new WHead(head);
		TRACE_DATA("Receive head: "<<pHead->Dump());
		pHead->CheckReplyId();
		
		int dataSize = pHead->GetTotalSize() - NO_TOTALSIZE_HEAD_SIZE;
		if( dataSize == 0 ) // when there is no data
		{
			if( pHead->GetHandleId() == handle_id_hc_request ) //hc request
			{
				m_hc_count++;
				SET_HC_AO( MESSAGE_HC_COUNT<<m_hc_count);
				(WApp::m_pHcThread)->Notify(pHead);
				(WApp::m_pHcCheckThread)->Notify(new WTimeOut());
			}
			else if( pHead->GetHandleId() == handle_id_work_request ) //work request without data
			{
				if( pHead->GetReplyKindId() == reply_kind_id_end )
				{
					TRACE_INFO("XML data:\n"<<xmlBuff);
					(WApp::m_pWorkThread)->Notify( new WSaxXml( xmlBuff.c_str(), *pHead) );
					xmlBuff="";
				}
				else
				{
					TRACE_WARNING("Receive work request without data");
				}
				delete pHead;
				pHead = NULL;
			}
			else //ohter request 
			{
				m_error_count++;
				SET_ERROR_AO( MESSAGE_ERROR_COUNT<<m_error_count);
				SEND_NOTIFY_AO( MESSAGE_HANDLE_ID_ERROR<<"(ProcessID Error)" );
				(WApp::m_pHcThread)->Notify(pHead);
				TRACE_WARNING("Receive other request without data");
			}
			continue;
		}
		else // when there is data
		{	
			buff = new char[dataSize+1];
			memset(buff, 0, dataSize+1);
			if( Readn( buff, dataSize ) <= 0 )
			{
				Disconnect();
				TRACE_ERROR("Socket connection was broken");
				xmlBuff="";
				delete[] buff;
				buff = NULL;
				delete pHead;
				pHead = NULL;
				Connect();
				continue;
			}
			buff[dataSize]='\0';
			TRACE_DATA("Receive data:\n"<<buff);

			if( pHead->GetHandleId() == handle_id_work_request ) // work request
			{
				if( pHead->GetReplyKindId() == reply_kind_id_end )
				{
					xmlBuff += buff;
					TRACE_INFO("XML data:\n"<<xmlBuff);
					(WApp::m_pWorkThread)->Notify( new WSaxXml( xmlBuff.c_str(), *pHead) );
					xmlBuff="";
				}
				else if( pHead->GetReplyKindId() == reply_kind_id_continue )
				{
					xmlBuff += buff;
				}
				else
				{
					TRACE_ERROR("Reply kind id is incorrect :"<<pHead->Dump());
				}
				delete pHead;
				pHead = NULL;
			}
			else if( pHead->GetHandleId() == handle_id_hc_request ) //hc request with data
			{
				(WApp::m_pHcThread)->Notify(pHead);					
				(WApp::m_pHcCheckThread)->Notify(new WTimeOut());
				m_hc_count++;
				SET_HC_AO( MESSAGE_HC_COUNT<<m_hc_count);
				TRACE_WARNING("Receive HC request with data");
			}
			else //ohter request with data
			{
				(WApp::m_pHcThread)->Notify(pHead);
				m_error_count++;
				SET_ERROR_AO( MESSAGE_ERROR_COUNT<<m_error_count);
				SEND_NOTIFY_AO( MESSAGE_HANDLE_ID_ERROR<<"(ProcessID Error)" );
				TRACE_WARNING("Receive other request with data");
			}
			delete[] buff;
			buff = NULL;
		}
	}
}

void WSocket::WriteResponse( WHead& head )
{
	pthread_mutex_lock(&m_mutex);
	try
	{
		if( m_connected )
		{
			TRACE_DATA("Send response: "<<head.Dump());
			if( Writen( head.GetHeadData(), HEAD_SIZE ) <0 )
			{
				TRACE_ERROR("Send response failed.");
				SEND_NOTIFY_AO( MESSAGE_WRITE_RESPONSE_ERROR<<"(Send response failed)" );	
			}
		}
		else
		{
			TRACE_TRACE("Disconneted, don't send response");
		}
	}
	catch(WException& e)
	{
		TRACE_DEBUG("Exception when writing response");
	}
	pthread_mutex_unlock(&m_mutex);
}

void WSocket::CheckSignal()
{
	TRACE_DEBUG("Check signal");
	if( get_term_signal == 1)
	{
		TRACE_TRACE("Receive SIGTERM signal");
		get_term_signal = 2;
		TRACE_TRACE("cancel work thread");
		(WApp::m_pWorkThread)->Cancel();
		return;
	}
	if( get_stop_signal == 1 )
	{
		if( (WApp::m_pWorkThread)->IsEnd() )
		{
			TRACE_TRACE("Get notify, work thread is end");	
			get_stop_signal = 2;
			Disconnect();					
			throw WException("Work thread is end",1);
		}
		else
		{
			TRACE_DEBUG("Receive stop signal from others");
		}
		return;
	}
	if( WApp::m_pWorkThread->IsEnd() )
	{
		TRACE_TRACE("No notify, work thread is end");	
		get_stop_signal = 2;
		Disconnect();					
		throw WException("Work thread is end",1);
	}
}




