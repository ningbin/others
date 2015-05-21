/*
 *
 * FILENAME     : WHead.cxx
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

#include "WException.hxx"
#include "common_log.hxx"
#include "WHead.hxx"
#include "WSocket.hxx"
#include "WApp.hxx"
#include "WMessage.hxx"
#include <iomanip>

WHead::WHead( void* pHead )
{
	TRACE_DEBUG("Construct Whead");
	memcpy( m_data, pHead, HEAD_SIZE );	
	memcpy( &m_total_size, (char*)pHead, sizeof(m_total_size) );
	memcpy( &m_business_id, (char*)pHead+OP_BUSINESS_ID, sizeof(m_business_id) );
	memcpy( &m_method_id, (char*)pHead+OP_METHOD_ID, sizeof(m_method_id) );
	memcpy( &m_handle_id, (char*)pHead+OP_HANDLE_ID, sizeof(m_handle_id) );
	memcpy( &m_reply_id, (char*)pHead+OP_REPLY_ID, sizeof(m_reply_id) );
	memcpy( &m_reply_kind_id, (char*)pHead+OP_REPLY_KIND_ID, sizeof(m_reply_kind_id) );
	memcpy( &m_destination_id, (char*)pHead+OP_DESTINATION_ID, sizeof(m_destination_id) );
	memcpy( &m_source_id, (char*)pHead+OP_SOURCE_ID, sizeof(m_source_id) );
	memcpy( &m_sequence_id, (char*)pHead+OP_SEQUENCE_ID, sizeof(m_sequence_id) );	
	memcpy( &m_reserve_1, (char*)pHead+OP_RESERVE_1, sizeof(m_reserve_1) );
	memcpy( &m_data_size, (char*)pHead+OP_DATA_SIZE, sizeof(m_data_size) );
	memcpy( &m_repeat_count, (char*)pHead+OP_REPEAT_COUNT, sizeof(m_repeat_count) );
	memcpy( &m_reserve_2, (char*)pHead+OP_RESERVE_2, sizeof(m_reserve_2) );
	TRACE_DEBUG("WHead "<<m_reply_id<<" constructed");
}


WHead::~WHead()
{
	TRACE_DEBUG("Destructing Whead "<<m_reply_id<<" ...");
}


RWCString WHead::Dump()
{
	RWCString time_in_head = GetTime();
	ostringstream dump;	
	dump<<hex<<setfill('0');
	dump<<"\n"
	<<"\ttotal_size: 0x"<<setw(4)<<m_total_size<<"\n"
	<<"\tbusiness_id: 0x"<<setw(2)<<(unsigned short)m_business_id<<"\n"
	<<"\tmethod_id: 0x"<<setw(2)<<(unsigned short)m_method_id<<"\n"
	<<"\thandle_id: 0x"<<setw(4)<<m_handle_id<<"\n"
	<<"\treply_id: 0x"<<setw(8)<<m_reply_id<<"\n"
	<<"\treply_kind_id: 0x"<<setw(4)<<m_reply_kind_id<<"\n"
	<<"\tdestination_id: 0x"<<setw(8)<<m_destination_id<<"\n"
	<<"\tsource_id: 0x"<<setw(8)<<m_source_id<<"\n"
	<<"\tsequence_id: 0x"<<setw(2)<<(unsigned short)m_sequence_id<<"\n"
	<<"\treserve_1: 0x"<<setw(2)<<(unsigned short)m_reserve_1<<"\n"
	<<"\ttime: "<<time_in_head<<"\n"
	<<"\tdata_size: 0x"<<setw(4)<<m_data_size<<"\n"
	<<"\trepeat_count: 0x"<<setw(2)<<(unsigned short)m_repeat_count<<"\n"
	<<"\treserve_2: 0x"<<setw(2)<<(unsigned short)m_reserve_2;
	return (dump.str()).c_str();
}


void WHead::Run(void*)
{
	bool needSleep=false;
	if( m_handle_id == handle_id_hc_request )
	{
		SetHandleId( handle_id_hc_reply );
		needSleep=true;
	}
	else if( m_handle_id == handle_id_work_request )
	{
		SetHandleId( handle_id_work_reply );
	}
	else
	{
		TRACE_ERROR("ProcessID Error :"<<Dump());
	}

	if(WApp::m_pSocket)
	{
		SetDefault();
		if( !needSleep || WTest::hc_sleep_time ==0 || WTest::hc_sleep_num <1 )
		{
			needSleep=false;
		}
		else if( WTest::hc_sleep_num >1 )
		{
			needSleep=false;
			WTest::hc_sleep_num--;
		}
		else
		{
			needSleep=true;
			WTest::hc_sleep_num--;
		}

		if( needSleep )
		{
			TRACE_TRACE("Sleep "<<WTest::hc_sleep_time<<" seconds...");
			sleep( WTest::hc_sleep_time );
		}
		WApp::m_pSocket->WriteResponse( *this );
	}
}


void WHead::SetDefault()
{
	m_destination_id = equipment_id_neptun;
	m_source_id = equipment_id_temip;
	memcpy( m_data+OP_DESTINATION_ID, &m_destination_id, sizeof(m_destination_id) );
	memcpy( m_data+OP_SOURCE_ID, &m_source_id, sizeof(m_source_id) );
	m_reply_kind_id = 0;
	memcpy( m_data+OP_REPLY_KIND_ID, &m_reply_kind_id, sizeof(m_reply_kind_id) );
	SetTime();
	SetSize();
}


void WHead::SetHandleId( unsigned short handle_id)
{
	m_handle_id = handle_id;
	memcpy( m_data+OP_HANDLE_ID, &m_handle_id, sizeof(m_handle_id) );
}

void WHead::SetSize()
{
	m_total_size = HEAD_SIZE - sizeof(m_total_size);
	memcpy( m_data, &m_total_size, sizeof(m_total_size) );
	m_data_size = 0;
	memcpy( m_data+OP_DATA_SIZE, &m_data_size, sizeof(m_data_size) );
	m_repeat_count = 0;
	memcpy( m_data+OP_REPEAT_COUNT, &m_repeat_count, sizeof(m_repeat_count) );
	m_sequence_id = 0;
	memcpy( m_data+OP_SEQUENCE_ID, &m_sequence_id, sizeof(m_sequence_id) );
}


RWCString WHead::GetTime()
{
	unsigned char time_c[TIME_LENGTH];
	memcpy( time_c, m_data+OP_TIME, TIME_LENGTH );
	ostringstream time_os;
	time_os<<hex<<setfill('0');

	for(int i=0; i<TIME_LENGTH; i++)
	{
		time_os<<"0x"<<setw(2)<<(unsigned short)(time_c[i])<<", ";
	}
	RWCString time_s = (time_os.str()).c_str();
	time_s( time_s.length()-2,2 )="";
	return time_s;	
}


void WHead::SetTime()
{
	struct tm* local;
	time_t t;
	t=time(NULL);
	local = localtime(&t);	
	unsigned char us_time[TIME_LENGTH] = {(local->tm_year)-100, (local->tm_mon)+1, local->tm_mday,
								local->tm_hour, local->tm_min, local->tm_sec };
	unsigned char nc_time[TIME_LENGTH];
	for(int i=0; i<TIME_LENGTH; i++ )
	{
		nc_time[i] = BIN_BCD( us_time[i] );
	}
	memcpy( m_data+OP_TIME, nc_time, TIME_LENGTH);
}


void WHead::CheckReplyId()
{
	if( m_reply_id == reply_id_error )
	{
		if( m_handle_id == handle_id_hc_request )
		{
			TRACE_ERROR("HC reply id error :"<<Dump());
			SEND_NOTIFY_AO( MESSAGE_HC_REPLY_ID_ERROR<<"(HC reply id error)" );
		}
		else if( m_handle_id == handle_id_work_request )
		{
			TRACE_ERROR("Workdata reply id error :"<<Dump());
			SEND_NOTIFY_AO( MESSAGE_WORK_REPLY_ID_ERROR<<"(Workdata reply id error)"  );
		}
		else
		{
			TRACE_ERROR("Other reply id error :"<<Dump());
			//SEND_NOTIFY_AO( MESSAGE_OTHER_REPLY_ID_ERROR );
		}	
	}
}
