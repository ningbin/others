/*
 *
 * FILENAME     : WRecord.cxx
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
#include "WRecord.hxx"
#include "DBWrite.hxx"

WRecord::WRecord():m_end(false)
{
	TRACE_DEBUG("construct WRecord");
}

WRecord::WRecord(bool flag): m_end( flag )
{
	TRACE_DEBUG("Construct WRecord, end = "<<m_end);
}

WRecord::~WRecord()
{
	TRACE_DEBUG("WRecord destructed");
}

void WRecord::Run( void* param)
{
	TRACE_TRACE("WRecord::Run begin");
	DBWrite *p_thread = (DBWrite *)param;
    CstChildRecord record(this);
	if(m_end)
	{
        while (!p_thread->ExecuteRecords(record)) p_thread->ReconnectDB();
        p_thread->ClearRecords();
	}
	else
	{
        while (!p_thread->AddXmlRecord(record)) p_thread->ReconnectDB();
	}
	TRACE_TRACE("WRecord::Run end");
}

RWCString WRecord::Dump()
{
	RWCString dump;
	dump += "\n\tmessageType : " + messageType;
	dump += "\n\tkoujitCount : " + koujitCount;
	dump += "\n\tregkubun : " + regkubun;
	dump += "\n\tcmngno : " + cmngno;
	dump += "\n\tconstnm : " + constnm;
	dump += "\n\tequipCount : " + equipCount;
	dump += "\n\tkono : " + kono;
	dump += "\n\tbuil_nm : " + buil_nm;
	dump += "\n\tkaitei_nm : " + kaitei_nm;
	dump += "\n\tsdate : " + sdate;
	dump += "\n\tedate : " + edate;
	dump += "\n\tjsdate : " + jsdate;
	dump += "\n\tjedate : " + jedate;
	dump += "\n\tope_kd_flg : " + ope_kd_flg;
	dump += "\n\tneid : " + neid;
	dump += "\n\tsub_neid : " + sub_neid;
	return dump;
}

