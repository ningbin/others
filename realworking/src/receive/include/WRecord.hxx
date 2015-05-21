/*
 *
 * FILENAME     : WRecord.hxx
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

#ifndef _REAL_TIME_WORK_RECORD_HXX_
#define _REAL_TIME_WORK_RECORD_HXX_

#include "WThread.hxx"

class WRecord : public WEvent
{
	public:
		WRecord();
		WRecord(bool flag);
		~WRecord();
		void Run(void*);
		RWCString Dump();
		bool IsEnd(){ return m_end; };
		
	public:
		RWCString messageType;
		RWCString koujitCount;
		RWCString regkubun;
		RWCString cmngno;
		RWCString constnm;
		RWCString equipCount;
		RWCString kono;
		RWCString buil_nm;
		RWCString kaitei_nm;
		RWCString sdate;
		RWCString edate;
		RWCString jsdate;
		RWCString jedate;
		RWCString ope_kd_flg;
		RWCString neid;
		RWCString sub_neid;
		bool m_end;
};


#endif
