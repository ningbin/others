/*
 *
 * FILENAME     : DBWrite.cxx
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

#include <iomanip>
#include <iostream>
#include "CstErrorMessage.hxx"
#include "DBConnection.hxx"
#include "CstRecord.hxx"
#include "CstNode.hxx"
#include "DBWrite.hxx"
#include "CstFile.hxx"
#include "common_log.hxx"
#include "CstConf.hxx"
#include "WException.hxx"
#include "WApp.hxx"
#include "rw/rstream.h"
#include "rw/re.h"

string replace_all(string str, string old_value, string new_value)   
{
    RWCString s(str.c_str());
    s.replace(RWCRExpr(old_value.c_str()), new_value.c_str(), RWCString::all);
    return (const char*)s;
}

DBWrite::DBWrite(int buffSize)
: WThread( buffSize )
{
	m_skip = false;
}

DBWrite::~DBWrite()
{
}

//init db connection & load configuration file
void DBWrite::Init()
{
    TRACE_TRACE("enter DBWrite::Init");
    if (!CstNode::LoadNeTypeConfigFile(CstConf::RTWORK_RECV_NETYPE_CONF_FILE))
    {
        TRACE_ERROR(MSG_ERR_NETYPE_CONFIG(CstConf::RTWORK_RECV_NETYPE_CONF_FILE));
        TRACE_TRACE("leave DBWrite::Init.return:0");
        throw WException();
    }
    DBConnection::GetInstance()->InitConnection(CstConf::RTWORK_ORACLE_USER, CstConf::RTWORK_ORACLE_PSW, CstConf::RTWORK_ORACLE_SID);
    try
    {
        DBConnection::GetInstance()->Open();
    }
    catch (DBConnectException& ex)
    {
        TRACE_ERROR(MSG_ERR_DB_CONNECT(ex));
        TRACE_TRACE("leave DBWrite::Init.return:0");
        throw WException();
    }
    TRACE_TRACE("leave DBWrite::Init.return:1");
}
//process cstchild record
void DBWrite::ProcessRecord(CstChildRecord &record)
{
    TRACE_TRACE("enter DBWrite::ProcessRecord");
    try
    {
        switch (record.m_type)
        {
        case Content:
            while (!AddXmlRecord(record)) ReconnectDB();
            break;
        case Completed:
            while (!ExecuteRecords(record)) ReconnectDB();
        default:
            ClearRecords();
            break;
        }
    }
    catch (...)
    {
        TRACE_WARNING(MSG_ERR_UNKNOWN);
    }
    TRACE_TRACE("leave DBWrite::ProcessRecord");
}
void DBWrite::ClearRecords()
{
    m_xmlMap.clear();
    m_dbMap.clear();
}
void DBWrite::ReconnectDB()
{
	int times = CstConf::RTWORK_DB_RETRY_NUMBER;
    while (true)
    {
        try
        {
            DBConnection::GetInstance()->Open();
            SEND_NOTIFY_AO(CMD_DB_CONNECT_SUCCESS);
            break;
        }
        catch (DBConnectException &ex)
        {
            TRACE_WARNING(MSG_ERR_DB_CONNECT(ex));
            times--;
            if (times <= 0)
            {
            	TRACE_ERROR(MSG_ERR_DB_CONNECT_RETRY);
            	pthread_kill( 1, MY_TERM_SIG );
            	m_skip = true;
            	break;
            }
            sleep(CstConf::RTWORK_RECV_RETRY_INTERVAL);
        }
    }
}
//return db connection is ok
bool DBWrite::AddXmlRecord(CstChildRecord &record)
{
    TRACE_TRACE("enter DBWrite::AddXmlRecord. record:"<<PRINT_CST_CHILD(record));
    if (m_skip)
    {
    	TRACE_DEBUG("skip add record.");
    	return true;
    }
    try
    {
    	m_cstRecord = record.m_cst;
        RealworkRecord newRecord;
        if (record.FillRealworkRecord(newRecord))
        {
	    m_xmlMap.insert(RealworkMap::value_type(newRecord.m_cstChildNo, newRecord));
            TRACE_DEBUG("add this record to map.");
        }
        TRACE_TRACE("leave DBWrite::AddXmlRecord.return:1");
        return true;
    }
    catch (DBConnectException &ex)
    {
        TRACE_WARNING(MSG_ERR_DB_CONNECT(ex));
        SEND_NOTIFY_AO(CMD_DB_CONNECT_ERROR(ex));
        TRACE_TRACE("leave DBWrite::AddXmlRecord.return:0");
        return false;
    }
    catch (...)
    {
        TRACE_WARNING(MSG_ERR_UNKNOWN);
        TRACE_TRACE("leave DBWrite::AddXmlRecord.return:1");
        return true;
    }
}

bool DBWrite::ExecuteRecords(CstChildRecord &record)
{
    TRACE_TRACE("enter DBWrite::ExecuteRecords");
    if (m_skip)
    {
    	TRACE_DEBUG("skip execute records.");
    	return true;
    }
    record.m_cst = m_cstRecord;

    if (record.m_cst.m_cstNo.empty())
    {
        TRACE_TRACE("leave DBWrite::ExecuteRecords.return:1");
        return true;
    }
    CstFile cstFile;
    bool hasxmlrecord = false;
    RealworkMap::iterator xmlIter;
    try
    {
        //select db record
        hasxmlrecord = false;
	    DBConnection::GetInstance()->SelectRealwork(m_dbMap, record.m_cst.m_cstNo);
        TRACE_DEBUG("updating...");
        //find db record in buffer
        for (RealworkMap::iterator dbIter = m_dbMap.begin(); dbIter != m_dbMap.end(); dbIter++)
        {
            xmlIter = m_xmlMap.find(dbIter->first);
            //in buffer
            if (xmlIter != m_xmlMap.end())
            {
		hasxmlrecord = true;
                //is cancel record
                if (xmlIter->second.m_sDate.empty() && xmlIter->second.m_eDate.empty())
                {
                    DBConnection::GetInstance()->DeleteRealwork(dbIter->second);
                    if (xmlIter->second.m_nodeId == dbIter->second.m_nodeId 
			&& (!dbIter->second.m_sDate.empty() && dbIter->second.m_eDate.empty()))
                    {
                        RealworkRecord realrec = dbIter->second;
                        realrec.m_eDate = realrec.m_sDate;
                        cstFile.WriteRecord(realrec);
                    }
                }
                //is normal record
                else
                {
                    DBConnection::GetInstance()->UpdateRealwork(dbIter->second, xmlIter->second);
                    if (xmlIter->second.m_nodeId == dbIter->second.m_nodeId
                        && (!xmlIter->second.m_eDate.empty() && xmlIter->second.m_eDate != dbIter->second.m_eDate))
                    {
                        RealworkRecord realrec = dbIter->second;
                        realrec.m_sDate = xmlIter->second.m_sDate;
                        realrec.m_eDate = xmlIter->second.m_eDate;
                        cstFile.WriteRecord(realrec);
                    }
                }
            }
            //not in buffer
            else
            {
                hasxmlrecord = false;
                DBConnection::GetInstance()->DeleteRealwork(dbIter->second);
            }
        }
        //find buffer record in db
        TRACE_DEBUG("inserting...");
        hasxmlrecord = true;
        for (xmlIter = m_xmlMap.begin(); xmlIter != m_xmlMap.end(); xmlIter++)
        {
            if (!xmlIter->second.m_sDate.empty() && m_dbMap.find(xmlIter->first) == m_dbMap.end())
            {
                DBConnection::GetInstance()->InsertRealwork(xmlIter->second);
            }
        }
        TRACE_DEBUG("commiting...");
        hasxmlrecord = false;
        DBConnection::GetInstance()->Commit();
        cstFile.WriteEnd(true);
        TRACE_TRACE("leave DBWrite::ExecuteRecords.return:1");
        return true;
    }
    catch (otl_exception &ex) //otl_exception
    {
	string msg = replace_all(string((char *)ex.msg), "\n", "");
        msg = replace_all(msg, "\"", "\"\"");
        if (hasxmlrecord)
	{
            TRACE_WARNING(MSG_ERR_EXECUTE_SQL(ex, xmlIter->second));
            SEND_NOTIFY_AO(CMD_SQL_EXECUTE_ERROR(ex.code, msg, record.m_cst.m_cstNo));
	}
	else
	{
            TRACE_WARNING(MSG_ERR_EXECUTE_SQL_NOREC(ex, record.m_cst.m_cstNo));
            SEND_NOTIFY_AO(CMD_SQL_EXECUTE_ERROR(ex.code, msg, record.m_cst.m_cstNo));
	}
        DBConnection::GetInstance()->Rollback();
        cstFile.WriteEnd(false);
        TRACE_TRACE("leave DBWrite::ExecuteRecords.return:1");
        return true;
    }
    catch (DBConnectException &ex)
    {
        TRACE_WARNING(MSG_ERR_DB_CONNECT(ex));
        SEND_NOTIFY_AO(CMD_DB_CONNECT_ERROR(ex));
        cstFile.WriteEnd(false);
        TRACE_TRACE("leave DBWrite::ExecuteRecords.return:0");
        return false;
    }
    catch (...)
    {
        TRACE_WARNING(MSG_ERR_UNKNOWN);
	DBConnection::GetInstance()->Rollback();
        cstFile.WriteEnd(false);
        TRACE_TRACE("leave DBWrite::ExecuteRecords.return:1");
        return true;
    }
}



