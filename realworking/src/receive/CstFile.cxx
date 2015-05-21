/*
 *
 * FILENAME     : CstFile.cxx
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

#include <fstream>
#include <iostream>
#include <iomanip>
#include <time.h>
#include <sys/timeb.h>
#include "CstErrorMessage.hxx"
#include "CstFile.hxx"
#include "CstUtil.hxx"
#include "common_log.hxx"
#include "CstConf.hxx"

using namespace std;


void CstFile::WriteRecord(RealworkRecord &record)
{
    TRACE_TRACE("enter CstFile::WriteRecord. record:"<<PRINT_REALWORK(record));
    bool needAlarm = true;
    while (!m_ofs.is_open())
    {
        m_tmpFilePath = CstConf::RTWORK_RECV_RESULT_TMP_DIR + STR_FILENAME_PRE + GetNowTimeString() + STR_FILEEXT_TMP;
        TRACE_DEBUG("file does not opened. open file:" << m_tmpFilePath);
        m_ofs.open(m_tmpFilePath.c_str());
        if (!m_ofs.is_open())
        {
            TRACE_WARNING(MSG_ERR_OPEN_FILE(m_tmpFilePath));
            if (needAlarm)
            {
                //SEND_NOTIFY_AO(CMD_FILE_OPEN_ERROR(m_tmpFilePath));
                needAlarm = false;
            }
            sleep(CstConf::RTWORK_RECV_RETRY_INTERVAL);
        }
    }
    if (!needAlarm)
    {
        //SEND_NOTIFY_AO(CMD_FILE_OPEN_SUCCESS(m_tmpFilePath));
    }
    m_ofs << record.m_cstNo << ","
        << record.m_cstChildNo << ","
        << record.m_nodeId << ","
        << ChangeTimeFormat(record.m_sDate) << ","
        << ChangeTimeFormat(record.m_eDate) << ","
        << record.m_serialno << ","
        << record.m_mms << ","
        << record.m_rnc << ","
        << record.m_bts << endl;
    TRACE_TRACE("leave CstFile::WriteRecord");

}
void CstFile::WriteEnd(bool isOk)
{
    TRACE_TRACE("enter CstFile::WriteEnd.isOk:" << isOk);
    if (m_ofs.is_open())
    {
        m_ofs.close();
        bool needAlarm = true;
        if (isOk)
        {
            string resultFilePath = CstConf::RTWORK_RECV_RESULT_DIR + STR_FILENAME_PRE + GetNowTimeString() + STR_FILEEXT_CSV;
            TRACE_DEBUG("rename file "<< m_tmpFilePath <<" to " << resultFilePath);
            while (access(m_tmpFilePath.c_str(), 0) == 0 && rename(m_tmpFilePath.c_str(), resultFilePath.c_str()) < 0)
            {
                TRACE_WARNING(MSG_ERR_RENAME_FILE(m_tmpFilePath, resultFilePath));
                if (needAlarm)
                {
                    //SEND_NOTIFY_AO(CMD_FILE_RENAME_ERROR(m_tmpFilePath, resultFilePath));
                    needAlarm = false;
                }
                sleep(CstConf::RTWORK_RECV_RETRY_INTERVAL);
                resultFilePath = CstConf::RTWORK_RECV_RESULT_DIR + STR_FILENAME_PRE + GetNowTimeString() + STR_FILEEXT_CSV;
                TRACE_DEBUG("rename file "<< m_tmpFilePath <<" to " << resultFilePath);
            }
            if (!needAlarm)
            {
                //SEND_NOTIFY_AO(CMD_FILE_RENAME_SUCCESS(m_tmpFilePath, resultFilePath));
            }
        }
        else
        {
            while (access(m_tmpFilePath.c_str(), 0) == 0 && remove(m_tmpFilePath.c_str()) < 0)
            {
                TRACE_WARNING(MSG_ERR_REMOVE_FILE(m_tmpFilePath));
                if (needAlarm)
                {
                    //SEND_NOTIFY_AO(CMD_FILE_REMOVE_ERROR(m_tmpFilePath));
                    needAlarm = false;
                }
                sleep(CstConf::RTWORK_RECV_RETRY_INTERVAL);
            }
            if (!needAlarm)
            {
                //SEND_NOTIFY_AO(CMD_FILE_REMOVE_SUCCESS(m_tmpFilePath));
            }
        }
    }
    TRACE_TRACE("leave CstFile::WriteEnd");
}
CstFile::~CstFile()
{
    if (m_ofs.is_open())
    {
        m_ofs.close();
    }
}

