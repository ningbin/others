/*
 *
 * FILENAME     : WHead.hxx
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

#ifndef _REAL_TIME_WORK_HEAD_HXX_
#define _REAL_TIME_WORK_HEAD_HXX_

#include "WThread.hxx"

#define HEAD_SIZE 32
#define NO_TOTALSIZE_HEAD_SIZE 30
#define TIME_LENGTH 6

#define OP_BUSINESS_ID 2
#define OP_METHOD_ID 3
#define OP_HANDLE_ID 4
#define OP_REPLY_ID 6
#define OP_REPLY_KIND_ID 10
#define OP_DESTINATION_ID 12
#define OP_SOURCE_ID 16
#define OP_SEQUENCE_ID 20
#define OP_RESERVE_1 21
#define OP_TIME 22
#define OP_DATA_SIZE 28
#define OP_REPEAT_COUNT 30
#define OP_RESERVE_2 31


class WHead : public WEvent
{
	public:
		WHead( void* );
		~WHead();
		void Run(void*);
		RWCString Dump();		
		char* GetHeadData(){ return m_data;};
		
		unsigned short GetTotalSize(){ return m_total_size;};
		unsigned short GetHandleId(){ return m_handle_id;};
		unsigned int GetReplyId(){ return m_reply_id;};
		unsigned short GetReplyKindId(){ return m_reply_kind_id;};
		unsigned short GetDataSize(){ return m_data_size;};
		unsigned char GetRepeatCount(){ return m_repeat_count;};
		RWCString GetTime();
		void SetTime();
		
		void SetDefault();
		void SetHandleId( unsigned short handle_id);
		void SetSize();
		
		void CheckReplyId();

	private:
		WHead();
		
	private:
		unsigned short m_total_size;
		unsigned short m_handle_id;
		unsigned int m_reply_id;
		unsigned short m_reply_kind_id;
		unsigned int m_destination_id;
		unsigned int m_source_id;
		unsigned char m_sequence_id;
		unsigned short m_data_size;
		unsigned char m_repeat_count;
		// un-used part
		unsigned char m_business_id;
		unsigned char m_method_id;
		unsigned char m_reserve_1;
		unsigned char m_reserve_2;
		// primitive data part
		char m_data[HEAD_SIZE];
};

#define BIN_BCD( val ) ((val/10)*16 + val%10)

const unsigned short handle_id_hc_request = 0x2001;
const unsigned short handle_id_hc_reply = 0x2002;
const unsigned short handle_id_work_request = 0x2101;
const unsigned short handle_id_work_reply = 0x2102;

const unsigned short reply_id_error = 0x00000000;

const unsigned short reply_kind_id_ok = 0x0000;
const unsigned short reply_kind_id_continue = 0x4000;
const unsigned short reply_kind_id_end = 0x0000;

const unsigned int equipment_id_neptun = 0x00007901; 
const unsigned int equipment_id_temip = 0x00009001; 


#endif
