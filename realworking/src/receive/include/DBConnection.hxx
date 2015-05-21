/*
 *
 * FILENAME     : DBConnection.hxx
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

#ifndef _DB_CONNECTION_HXX_
#define _DB_CONNECTION_HXX_

#include <string>
#include <map>

using namespace std;

#define OTL_ORA9I 			// Compile OTL 4.0/OCI9i
#define OTL_ORA_TIMESTAMP 	// enable Oracle 9i TIMESTAMPs [with local time zone]
#define OTL_STL
#define OTL_UNCAUGHT_EXCEPTION_ON
#define OTL_DEFAULT_STRING_NULL_TO_VAL ""

#include "otlv4.h"


struct RealworkRecord
{
    string m_cstNo;
    string m_cstChildNo;
    string m_nodeId;
    string m_neType;
    string m_serialno;
    string m_mms;
    string m_rnc;
    string m_bts;
    string m_regionCode;
    string m_scheduleName;
    string m_sDatePre;
    string m_eDatePre;
    string m_sDate;
    string m_eDate;
    int m_mCnt;
    string m_bldName;
    string m_mType;
    string m_inputRes;
};
class RealworkRecordSort
{
public:
       bool operator() (string const &a, string const &b) const
       {
       	   return atoi(a.c_str()) < atoi(b.c_str());
       }
};

typedef map<string, RealworkRecord, RealworkRecordSort> RealworkMap;
class DBConnectException: public exception
{
public:
    int code;
    string msg;
    string stm_text;
    string var_info;
    DBConnectException(otl_exception &ex)
    {
        code = ex.code;
        msg = (char *)ex.msg;
        stm_text = ex.stm_text;
        var_info = ex.var_info;
    }
    virtual ~DBConnectException() throw() {}
};
class DBConnection
{
    string m_connectString;
    otl_connect m_dbConn;
    bool IsOpened();

public:
    static DBConnection *GetInstance();
    
    void InitConnection(string user, string pwd, string sid);
    void Open();
	void Close();
    void Rollback();
    void Commit(); 

    void SelectRealwork(RealworkMap &rmap, string cstNo);
    void InsertRealwork(RealworkRecord &record);
    void UpdateRealwork(RealworkRecord &record, RealworkRecord &newrecord);
    void DeleteRealwork(RealworkRecord &record);
    
    void GetSectorNo(string serial, string mms, string rnc, string bts, string &sector, int &errCode, string &errMsg);
    
private:
	static DBConnection m_con;
};

#endif
