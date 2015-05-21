/*
 *
 * FILENAME     : CstRecord.cxx
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

#include "CstErrorMessage.hxx"
#include "DBConnection.hxx"
#include "CstNode.hxx"
#include "CstRecord.hxx"
#include <iostream>
#include "CstUtil.hxx"
#include <time.h>
#include "common_log.hxx"
#include "WRecord.hxx"
#include "WCoder.hxx"

using namespace std;

CstChildRecord::CstChildRecord(WRecord *record)
{
    m_type = record->m_end?Completed:Content;
    if (!record->m_end)
	{
    	m_cst.m_cstNo = record->cmngno;
    	m_cst.m_scheduleName = WCoder::CheckChars(record->constnm);  //�X�P�W���[�����i�H�����j
    	m_cst.m_mCnt = record->equipCount;          //���u��
	    m_cstChildNo = record->kono;    //�q�ԍ�
	    m_bldName = WCoder::CheckChars(record->buil_nm);       //�r����
	    m_mType = WCoder::CheckChars(record->kaitei_nm);         //�ݔ����
	    m_sDatePre = record->sdate;      //�J�n�\�����
	    m_eDatePre = record->edate;      //�I���\�����
	    m_sDate = record->jsdate;         //�J�n���ѓ���
	    m_eDate = record->jedate;         //�I�����ѓ���
	    m_inputRes = WCoder::CheckChars(record->ope_kd_flg);      //�J�n�o�^
	    m_neId = record->neid;          //NEID
	    m_subNeId =  record->sub_neid;       //NE�t��ID
    }
}

bool CstChildRecord::FillRealworkRecord(RealworkRecord &record)
{
    try
    {
        if (m_cst.m_cstNo.empty())
        {
        	TRACE_WARNING(MSG_ERR_CSTNO_NULL((*this)));
            return false;
        }
        if (m_cstChildNo.empty())
        {
            TRACE_WARNING(MSG_ERR_CHILDNO_NULL((*this)));
            return false;
        }
        if (m_sDate.empty() && !m_eDate.empty())
        {
            TRACE_WARNING(MSG_ERR_SDATE_NULL((*this)));
            return false;
        }
        if (m_inputRes == "����" && !m_sDatePre.empty() && !m_eDatePre.empty())
        {
            if (difftime(GetStringTime(m_eDatePre), GetStringTime(m_sDatePre)) >= 24*60*60)
            {
                TRACE_WARNING(MSG_ERR_PREDATE_PASS((*this)));
                return false;
            }
        }

        record.m_cstNo = m_cst.m_cstNo;
        record.m_cstChildNo = m_cstChildNo;

        CstNode node(m_neId, m_subNeId, (*this));
        record.m_neType = node.GetCstNeType();
        record.m_nodeId = node.GetCstNodeId();
        record.m_serialno = node.GetCstSerial(*this);
        record.m_mms = node.GetMms();
        record.m_rnc = node.GetRnc();
        record.m_bts = node.GetCstBts();
        record.m_regionCode = node.GetCstRegionCode();

        record.m_scheduleName = m_cst.m_scheduleName;
        record.m_sDatePre = m_sDatePre;
        record.m_eDatePre = m_eDatePre;
        record.m_sDate = m_sDate;
        record.m_eDate = m_eDate;
        record.m_mCnt = atoi(m_cst.m_mCnt.c_str());
        record.m_bldName = m_bldName;
        record.m_mType = m_mType;
        record.m_inputRes = m_inputRes;
        return true;
    }
    catch (NodeParseException &ex)
    {
        TRACE_WARNING(ex.message);
        return false;
    }
    catch (otl_exception &ex)
    {
        TRACE_WARNING(PRINT_OTL_MESSAGE(ex));
        return false;
    }
    catch (DBConnectException &ex)
    {
        throw ex;
    }
    catch (...)
    {
        TRACE_WARNING(MSG_ERR_MAKING_REALWORK_RECORD((*this)));
        return false;
    }
}


