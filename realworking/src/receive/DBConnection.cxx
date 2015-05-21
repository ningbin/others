/*
 *
 * FILENAME     : DBConnection.cxx
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

#include <map>
#include <iostream>
#include <sstream>
#include "DBConnection.hxx"
#include "otlv4.h"
#include "CstErrorMessage.hxx"
#include "common_log.hxx"

//static DBConnection gDBCon;

DBConnection DBConnection::m_con;

DBConnection *DBConnection::GetInstance()
{
    return &m_con;
}

void DBConnection::InitConnection(string user, string pwd, string sid)
{
    TRACE_TRACE("enter DBConnection::InitConnection");
    otl_connect::otl_initialize(1);
    m_connectString = user + "/" + pwd + "@" + sid;
    TRACE_TRACE("leave DBConnection::InitConnection");
}
void DBConnection::Open()
{
    TRACE_TRACE("enter DBConnection::Open");
    try
    {
        m_dbConn.rlogon(m_connectString.c_str());
    }
    catch (otl_exception &ex)
    {
        throw DBConnectException(ex);
    }
    TRACE_TRACE("leave DBConnection::Open");
}
void DBConnection::Rollback()
{
    TRACE_TRACE("enter DBConnection::Rollback");
    try
    {
        m_dbConn.rollback();
    }
    catch (otl_exception &)
    {
    }
    TRACE_TRACE("leave DBConnection::Rollback");
}
void DBConnection::Commit()
{
    TRACE_TRACE("enter DBConnection::Commit");
    try
    {
        m_dbConn.commit();
    }
    catch (otl_exception &ex)
    {
        if(IsOpened()) throw ex;
        else throw DBConnectException(ex);
    }
    TRACE_TRACE("leave DBConnection::Commit");
}
void DBConnection::Close()
{
    TRACE_TRACE("enter DBConnection::Close");
    try
    {
        m_dbConn.logoff();
    }
    catch (otl_exception &)
    {
    }
    TRACE_TRACE("leave DBConnection::Close");
}
bool DBConnection::IsOpened()
{
    TRACE_TRACE("enter DBConnection::IsOpened");
	try
	{
		otl_nocommit_stream os(1, "SELECT SYSDATE FROM DUAL", m_dbConn);
        if (!os.eof()) os.close();
        TRACE_TRACE("leave DBConnection::IsOpened. return:1");
		return true;
	}
	catch (otl_exception &ex)
	{
        TRACE_TRACE("leave DBConnection::IsOpened. return:0");
		return false;
	}
}
void DBConnection::GetSectorNo(string serial, string mms, string rnc, string bts, string &sector, int &errCode, string &errMsg)
{
    TRACE_TRACE("enter DBConnection::GetSectorNo. serial:"<<serial<<", mms:"<<mms<<", rnc:"<<rnc<<", bts:"<<bts);
    try
    {
	    otl_nocommit_stream os(1, "begin "
					    "GET_SECTORNO("
					    ":c_SERI<char[11],in>,"
					    ":c_MMS<char[6],in>,"
					    ":c_RNC<char[4],in>,"
					    ":c_BTS<char[4],in>,"
					    ":c_SEC<char[3],out>,"
					    ":i_ERRCODE<int,out>,"
					    ":c_ERRMSG<char[257],out>);"
                        "end;", 
                        m_dbConn);
        os << serial << mms << rnc << bts;
	    os >> sector >> errCode >> errMsg;
    }
    catch (otl_exception &ex)
    {
        if(IsOpened()) throw ex;
        else throw DBConnectException(ex);
    }
    TRACE_TRACE("leave DBConnection::GetSectorNo");
}
void DBConnection::SelectRealwork(RealworkMap &rmap, string cstNo)
{
    TRACE_TRACE("enter DBConnection::SelectRealwork. cstNo:"<<cstNo);
	if (!rmap.empty()) rmap.clear();
    try
    {
	string sqltext = string("SELECT CSTNO, CSTCHILDNO, NODEID, TRIM(NETYPE), "
                                "TRIM(SERIALNO), TRIM(MMS), TRIM(RNC), TRIM(BTS), "
                                "TRIM(REGIONCODE), SCHEDULENAME, "
                                "TO_CHAR(SDATEPRE, 'yyyymmddhh24miss'), "
                                "TO_CHAR(EDATEPRE, 'yyyymmddhh24miss'), "
                                "TO_CHAR(SDATE, 'yyyymmddhh24miss'), "
                                "TO_CHAR(EDATE, 'yyyymmddhh24miss'), "
                                "MCNT, BLDNAME, MTYPE, INPUTRES FROM REALWORK "
                                "WHERE CSTNO = '") + cstNo + "' AND WORKFLAG = 0";
        otl_nocommit_stream os(1, sqltext.c_str(), m_dbConn);
        while (!os.eof())
        {
            RealworkRecord record;
            os >> record.m_cstNo >> record.m_cstChildNo >> record.m_nodeId
                >> record.m_neType >> record.m_serialno >> record.m_mms
                >> record.m_rnc >> record.m_bts >> record.m_regionCode
                >> record.m_scheduleName >> record.m_sDatePre >> record.m_eDatePre
                >> record.m_sDate >> record.m_eDate >> record.m_mCnt
                >> record.m_bldName >> record.m_mType >> record.m_inputRes;
	        TRACE_DEBUG("select record:"<<PRINT_REALWORK(record));
	        rmap.insert(RealworkMap::value_type(record.m_cstChildNo, record));
        }
    }
    catch (otl_exception &ex)
    {
        if(IsOpened()) throw ex;
        else throw DBConnectException(ex);
    }
    TRACE_TRACE("leave DBConnection::SelectRealwork");
}
void DBConnection::InsertRealwork(RealworkRecord &record)
{
    TRACE_TRACE("enter DBConnection::InsertRealwork. record:"<<PRINT_REALWORK(record));
    try
    {
        otl_nocommit_stream os(1, "INSERT INTO REALWORK(CSTNO, CSTCHILDNO, "
                                "NODEID, NETYPE, SERIALNO, "
                                "MMS, RNC, BTS, REGIONCODE, "
                                "SCHEDULENAME, SDATEPRE, EDATEPRE, "
                                "SDATE, EDATE, MCNT, BLDNAME, MTYPE, "
                                "INPUTRES, WORKFLAG, UPDDATE) VALUES( "
                                ":cstno<char[15]>, :cstchildno<char[5]>, "
                                ":nodeid<char[39]>, :netype<char[5]>, "
                                ":serial<char[11]>, :mms<char[6]>, :rnc<char[4]>, "
                                ":bts<char[4]>, :regioncode<char[5]>, :schedule<char[401]>, "
                                "TO_DATE(:sdatepre<char[15]>, 'yyyymmddhh24miss'), TO_DATE(:edatepre<char[15]>, 'yyyymmddhh24miss'), "
                                "TO_DATE(:sdate<char[15]>, 'yyyymmddhh24miss'), TO_DATE(:edate<char[15]>, 'yyyymmddhh24miss'), "
                                ":mcnt<int>, :bldname<char[201]>, :mtype<char[21]>, "
                                ":inputres<char[5]>, 0, SYSDATE)",
                                m_dbConn);
        os << record.m_cstNo << record.m_cstChildNo << record.m_nodeId << record.m_neType
            << record.m_serialno << record.m_mms << record.m_rnc << record.m_bts
            << record.m_regionCode << record.m_scheduleName << record.m_sDatePre 
            << record.m_eDatePre << record.m_sDate << record.m_eDate << record.m_mCnt
            << record.m_bldName << record.m_mType << record.m_inputRes;

    }
    catch (otl_exception &ex)
    {
        if(IsOpened()) throw ex;
        else throw DBConnectException(ex);
    }
    TRACE_TRACE("leave DBConnection::InsertRealwork");
}
void DBConnection::UpdateRealwork(RealworkRecord &record, RealworkRecord &newrecord)
{
    TRACE_TRACE("enter DBConnection::UpdateRealwork. record:"<<PRINT_REALWORK(record)<<", newrecord:"<<PRINT_REALWORK(newrecord));
    try
    {
        otl_nocommit_stream os(1, "UPDATE REALWORK SET "
                                "NODEID = :nodeid<char[39]>, "
                                "NETYPE = :netype<char[5]>, "
                                "SERIALNO = :serial<char[11]>, "
                                "MMS = :mms<char[6]>, "
                                "RNC = :rnc<char[4]>, "
                                "BTS = :bts<char[4]>, "
                                "REGIONCODE = :regioncode<char[5]>, "
                                "SCHEDULENAME = :schedule<char[401]>, "
                                "SDATEPRE = TO_DATE(:sdatepre<char[15]>, 'yyyymmddhh24miss'), "
                                "EDATEPRE = TO_DATE(:edatepre<char[15]>, 'yyyymmddhh24miss'), "
                                "SDATE = TO_DATE(:sdate<char[15]>, 'yyyymmddhh24miss'), "
                                "EDATE = TO_DATE(:edate<char[15]>, 'yyyymmddhh24miss'), "
                                "MCNT = :mcnt<int>, "
                                "BLDNAME = :bldname<char[201]>, "
                                "MTYPE = :mtype<char[21]>, "
                                "INPUTRES = :inputres<char[5]>, "
                                "UPDDATE = SYSDATE "
                                "WHERE CSTNO = :cstno<char[15]> "
            					"AND WORKFLAG = 0 "
                                "AND CSTCHILDNO = :cstchildno<char[5]>", 
                                m_dbConn);
        os << newrecord.m_nodeId << newrecord.m_neType << newrecord.m_serialno 
            << newrecord.m_mms << newrecord.m_rnc << newrecord.m_bts
            << newrecord.m_regionCode << newrecord.m_scheduleName << newrecord.m_sDatePre 
            << newrecord.m_eDatePre << newrecord.m_sDate << newrecord.m_eDate << newrecord.m_mCnt
            << newrecord.m_bldName << newrecord.m_mType << newrecord.m_inputRes << record.m_cstNo << record.m_cstChildNo;

    }
    catch (otl_exception &ex)
    {
        if(IsOpened()) throw ex;
        else throw DBConnectException(ex);
    }
    TRACE_TRACE("leave DBConnection::UpdateRealwork");
}
void DBConnection::DeleteRealwork(RealworkRecord &record)
{
    TRACE_TRACE("enter DBConnection::DeleteRealwork. record:"<<PRINT_REALWORK(record));
    try
    {
        otl_nocommit_stream os(1, "DELETE FROM REALWORK "
                                "WHERE CSTNO = :cstno<char[15]> "
            					"AND WORKFLAG = 0 "
                                "AND CSTCHILDNO = :cstchildno<char[5]>", 
                                m_dbConn);
        os << record.m_cstNo << record.m_cstChildNo;
    }
    catch (otl_exception &ex)
    {
        if(IsOpened()) throw ex;
        else throw DBConnectException(ex);
    }
    TRACE_TRACE("leave DBConnection::DeleteRealwork");
}



