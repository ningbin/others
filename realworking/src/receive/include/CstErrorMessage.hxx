/*
 *
 * FILENAME     : CstErrorMessage.hxx
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

#ifndef _CST_ERROR_MESSAGE_HXX_
#define _CST_ERROR_MESSAGE_HXX_


#define PRINT_CST(cst) \
    "工事管理番号="<<cst.m_cstNo<<", "\
    "工事名="<<cst.m_scheduleName<<", "\
    "装置数="<<cst.m_mCnt

#define PRINT_CST_CHILD(child) \
    PRINT_CST(child.m_cst)<<", "\
    "子番号="<<child.m_cstChildNo<<", "\
    "ビル名="<<child.m_bldName<<", "\
    "設備種別="<<child.m_mType<<", "\
    "開始予\定日時="<<child.m_sDatePre<<", "\
    "終了予\定日時="<<child.m_eDatePre<<", "\
    "開始実績日時="<<child.m_sDate<<", "\
    "終了実績日時="<<child.m_eDate<<", "\
    "開始登録="<<child.m_inputRes<<", "\
    "NEID="<<child.m_neId<<", "\
    "NE付加ID="<<child.m_subNeId

#define PRINT_REALWORK(rec) \
    "CSTNO="<<rec.m_cstNo<<", "\
    "CSTCHILDNO="<<rec.m_cstChildNo<<", "\
    "NODEID="<<rec.m_nodeId<<", "\
    "NETYPE="<<rec.m_neType<<", "\
    "SERIALNO="<<rec.m_serialno<<", "\
    "MMS="<<rec.m_mms<<", "\
    "RNC="<<rec.m_rnc<<", "\
    "BTS="<<rec.m_bts<<", "\
    "REGIONCODE="<<rec.m_regionCode<<", "\
    "SCHEDULENAME="<<rec.m_scheduleName<<", "\
    "SDATEPRE="<<rec.m_sDatePre<<", "\
    "EDATEPRE="<<rec.m_eDatePre<<", "\
    "SDATE="<<rec.m_sDate<<", "\
    "EDATE="<<rec.m_eDate<<", "\
    "MCNT="<<rec.m_mCnt<<", "\
    "BLDNAME="<<rec.m_bldName<<", "\
    "MTYPE="<<rec.m_mType<<", "\
    "INPUTRES="<<rec.m_inputRes<<"。"

#define MSG_ERR_GET_SECTOR(sqlcode,sqlerrm,serial,mms,rnc,bts,child) \
    "データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号:"<<child.m_cstChildNo<< \
    " セクタ番号取得処理に失敗しました。"\
    "SQLCODE=" << sqlcode << ", "\
    "SQLERRM=" << sqlerrm << \
    "SERIALNO=" << serial << ", "\
    "MMS=" << mms<< ", "\
    "RNC=" << rnc << ", "\
    "BTS=" << bts
#define MSG_ERR_NEID_ZERO(child) \
	"データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号:"<<child.m_cstChildNo<< " NEID,NE付加IDがall '0'で定義されています。"
#define MSG_ERR_SDATE_NULL(child) \
    "データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号:"<<child.m_cstChildNo<< "の工事期間（開始実績）=nullかつ工事期間（終了実績）=データ有り。"
#define MSG_ERR_PREDATE_PASS(child) \
    "データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号:"<<child.m_cstChildNo<< " 工事予\定期間が２４時間以上かつ開始登録=「自動」。"
#define MSG_ERR_UNDEFINED_NETYPE(child, netype) \
    "データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号:"<<child.m_cstChildNo<< " ＮＥ種別コード="<<netype<<" が定義されていません。"
#define MSG_ERR_NEID_LENGTH(child) \
    "データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号:"<<child.m_cstChildNo<< " NEIDまたはNE付加IDサイズ不正。"<<PRINT_CST_CHILD(child)
#define MSG_ERR_MAKING_REALWORK_RECORD(child) \
    "データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号:"<<child.m_cstChildNo<< " データ不正。"<<PRINT_CST_CHILD(child)
#define MSG_ERR_CHILDNO_NULL(child) \
    "データを破棄しました。工事管理番号:"<<child.m_cst.m_cstNo<<" 子番号がnullです。"<<PRINT_CST_CHILD(child)
#define MSG_ERR_CSTNO_NULL(child) \
    "データを破棄しました。工事管理番号がnullです。"<<PRINT_CST_CHILD(child)


#define PRINT_OTL_MESSAGE(ex) \
    "code: " << ex.code << ", "\
    "msg: " << ex.msg << ", "\
    "stm_text: " << ex.stm_text << ", "\
    "var_info: " << ex.var_info

#define MSG_ERR_EXECUTE_SQL_NOREC(ex, cstno) \
    "SQL execute fail."<< PRINT_OTL_MESSAGE(ex) << "工事管理番号:"<<cstno<<"を破棄しました。"
#define MSG_ERR_EXECUTE_SQL(ex,rec) \
    PRINT_OTL_MESSAGE(ex) << PRINT_REALWORK(rec) << "工事管理番号:"<<rec.m_cstNo<<"を破棄しました。"
#define MSG_ERR_DB_CONNECT(ex) \
    "DB connect error. " <<PRINT_OTL_MESSAGE(ex)
#define MSG_ERR_DB_CONNECT_RETRY \
	"DB retry times has reached. Process needs to exit."

#define MSG_ERR_UNKNOWN \
    "Unknown exception raise."

#define MSG_ERR_NETYPE_CONFIG(file) \
    "read netype config file error."
#define MSG_ERR_OPEN_FILE(file) \
    "open file " << file <<" error. "<<strerror(errno)
#define MSG_ERR_RENAME_FILE(oldfile, newfile) \
    "rename file "<<oldfile<<" to "<<newfile<<" error. "<<strerror(errno)
#define MSG_ERR_REMOVE_FILE(file) \
    "remove file " << file <<" error. "<<strerror(errno)

#define CMD_DB_CONNECT_ERROR(ex) \
    "[作業リアル1] ＤＢとの接続が切れました。または、接続に失敗しました。"
#define CMD_DB_CONNECT_SUCCESS \
    "[作業リアル1] ＤＢとの接続に成功しました。"
#define CMD_SQL_EXECUTE_ERROR(code, msg, cstno) \
    "[作業リアル1] Oracleエラーコード:"<<code<<", Oracleエラーメッセージ:"<<msg<< ", 工事管理番号:"<<cstno<<"を破棄しました。"
#define CMD_FILE_OPEN_ERROR(file) \
    "[作業リアル1] 実績反映ファイルのファイルオープンに失敗しました。"
#define CMD_FILE_OPEN_SUCCESS(file) \
    "[作業リアル1] 実績反映ファイルのファイルオープンに成功しました。"
#define CMD_FILE_RENAME_ERROR(oldfile, newfile) \
    "[作業リアル1] 実績反映ファイルのリネームに失敗しました。"
#define CMD_FILE_RENAME_SUCCESS(oldfile, newfile) \
    "[作業リアル1] 実績反映ファイルのリネームに成功しました。"
#define CMD_FILE_REMOVE_ERROR(file) \
    "[作業リアル1] 書き込み途中の実績反映ファイルの削除に失敗しました。"
#define CMD_FILE_REMOVE_SUCCESS(file) \
    "[作業リアル1] 書き込み途中の実績反映ファイルの削除に成功しました。"


#endif
