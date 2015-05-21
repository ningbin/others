/*
 *
 * FILENAME     : WMessage.hxx
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

#ifndef _REAL_TIME_WORK_WMESSAGE_HXX_
#define _REAL_TIME_WORK_WMESSAGE_HXX_


#define MESSAGE_APP_START "[作業リアル2] 受信書き込みプロセスを開始しました。"
#define MESSAGE_APP_END "[作業リアル2] 受信書き込みプロセスを停止しました。"
#define MESSAGE_APP_ERROR_THREAD "[作業リアル2] 受信書き込みプロセスを停止しました。"
#define MESSAGE_APP_ERROR_SOCKET "[作業リアル2] 受信書き込みプロセスを停止しました。"

#define MESSAGE_HC_TIMEOUT "[作業リアル1] ヘルスチェック受信がタイムアウトしました。"

#define MESSAGE_REPLY_ID_ERROR "[作業リアル1] 不正な応答ＩＤを受信しました。"
#define MESSAGE_WORK_REPLY_ID_ERROR "[作業リアル1] 作業電文から不正な応答ＩＤを受信しました。"
#define MESSAGE_HC_REPLY_ID_ERROR "[作業リアル1] ヘルスチェック電文から不正な応答ＩＤを受信しました。"
#define MESSAGE_OTHER_REPLY_ID_ERROR "[作業リアル1] その他の電文電文から不正な応答ＩＤを受信しました。"
#define MESSAGE_HANDLE_ID_ERROR "[作業リアル1] 異常な処理IDの電文を受信しました。"

#define MESSAGE_CONNECTION_SETUP "[作業リアル1] NEPTUNとの接続が確立されました。"
#define MESSAGE_CONNECTION_BROKEN "[作業リアル1] NEPTUNとの接続が切断されました。"
#define MESSAGE_WRITE_RESPONSE_ERROR "[作業リアル1] 応答電文の送信に失敗しました。"

#define MESSAGE_XML_TAG_ERROR "[作業リアル1] 不正なタグを受信しました。"
#define MESSAGE_XML_FORMAT_ERROR "[作業リアル1] 不正なタグを受信しました。"

#define MESSAGE_HC_COUNT "[作業リアル1] ヘルスチェック受信数 = "
#define MESSAGE_WORK_COUNT "[作業リアル1] 作業電文受信数 = "
#define MESSAGE_ERROR_COUNT "[作業リアル1] その他の電文受信数 = "

#endif 
