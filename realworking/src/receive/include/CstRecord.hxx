/*
 *
 * FILENAME     : CstRecord.hxx
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

#ifndef _CST_RECORD_HXX_
#define _CST_RECORD_HXX_

#include <exception>

#include "DBConnection.hxx"
#include "WRecord.hxx"

using namespace std;

enum RecordType
{
    Content,
    Completed,
    Incompleted
};
struct CstRecord
{
    string m_cstNo;         //�H���Ǘ��ԍ�
    string m_scheduleName;  //�X�P�W���[�����i�H�����j
    string m_mCnt;          //���u��
};
class CstChildRecord
{
public:
    enum RecordType m_type;
    CstRecord m_cst;
    string m_cstChildNo;    //�q�ԍ�
    string m_bldName;       //�r����
    string m_mType;         //�ݔ����
    string m_sDatePre;      //�J�n�\�����
    string m_eDatePre;      //�I���\�����
    string m_sDate;         //�J�n���ѓ���
    string m_eDate;         //�I�����ѓ���
    string m_inputRes;      //�J�n�o�^
    string m_neId;          //NEID
    string m_subNeId;       //NE�t��ID

    CstChildRecord(WRecord *record);
    bool FillRealworkRecord(RealworkRecord & record);

};

#endif
