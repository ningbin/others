/*
 *
 * FILENAME     : DBWrite.hxx
 * PROGRAM      : receive
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Li Yang
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#ifndef _DB_WRITE_HXX_
#define _DB_WRITE_HXX_

#include <map>
#include "DBConnection.hxx"
#include "CstRecord.hxx"
using namespace std;


class DBWrite: public WThread
{
	private:
		DBWrite();
		bool m_skip;
		CstRecord m_cstRecord;
	    RealworkMap m_xmlMap;
	    RealworkMap m_dbMap;
	
	public:
		DBWrite( int buffSize );
		virtual ~DBWrite();
		
	    void Init();
	    bool AddXmlRecord(CstChildRecord &record);
	    bool ExecuteRecords(CstChildRecord &record);
	    void ClearRecords();
	    void ReconnectDB();
	    void ProcessRecord(CstChildRecord &record);
};

#endif
