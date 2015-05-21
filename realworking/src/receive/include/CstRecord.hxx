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
    string m_cstNo;         //工事管理番号
    string m_scheduleName;  //スケジュール名（工事名）
    string m_mCnt;          //装置数
};
class CstChildRecord
{
public:
    enum RecordType m_type;
    CstRecord m_cst;
    string m_cstChildNo;    //子番号
    string m_bldName;       //ビル名
    string m_mType;         //設備種別
    string m_sDatePre;      //開始予定日時
    string m_eDatePre;      //終了予定日時
    string m_sDate;         //開始実績日時
    string m_eDate;         //終了実績日時
    string m_inputRes;      //開始登録
    string m_neId;          //NEID
    string m_subNeId;       //NE付加ID

    CstChildRecord(WRecord *record);
    bool FillRealworkRecord(RealworkRecord & record);

};

#endif
