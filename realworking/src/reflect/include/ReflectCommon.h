/*
 *
 * FILENAME     : ReflectCommon.h
 * PROGRAM      : reflect
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Tan JunLiang
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#ifndef REFLECTCOMMON_H_
#define REFLECTCOMMON_H_
#include <string.h>
#include "common_log.hxx"
#include "common_conf.hxx"

/* macro define for log */
#define		LOG_LINEBUF_SIZE			1024*4
#define		PutLog(format, ...)			\
						pthread_mutex_lock(&gl_mtxLog);\
						snprintf(gl_logbuf, LOG_LINEBUF_SIZE,\
									format, ##__VA_ARGS__);
#define		ERROR_LOG(format, ...)		PutLog(format, ##__VA_ARGS__);\
										TRACE_ERROR(gl_logbuf);\
										pthread_mutex_unlock(&gl_mtxLog);
#define		WARN_LOG(format, ...)		PutLog(format, ##__VA_ARGS__);\
										TRACE_WARNING(gl_logbuf);\
										pthread_mutex_unlock(&gl_mtxLog);
#define		INFO_LOG(format, ...)		PutLog(format, ##__VA_ARGS__);\
										TRACE_INFO(gl_logbuf);\
										pthread_mutex_unlock(&gl_mtxLog);
#define		TRACE_LOG(format, ...)		PutLog(format, ##__VA_ARGS__);\
										TRACE_TRACE(gl_logbuf);\
										pthread_mutex_unlock(&gl_mtxLog);
#define		DATA_LOG(format, ...)		PutLog(format, ##__VA_ARGS__);\
										TRACE_DATA(gl_logbuf);\
										pthread_mutex_unlock(&gl_mtxLog);
#define		DEBUG_LOG(format, ...)		PutLog(format, ##__VA_ARGS__);\
										TRACE_DEBUG(gl_logbuf);\
										pthread_mutex_unlock(&gl_mtxLog);

#define		TRACE_ENTER_FUNC			TRACE_LOG("ENTER FUNCTION")
#define		TRACE_LEAVE_FUNC			TRACE_LOG("LEAVE FUNCTION")

/* sleep interval for polling csv file (in nanosecond) */
#define		POLL_CSV_FILE_INTERVAL	500000000

enum ReflExit_e{
	REFL_EXIT_NORM = 0,
	REFL_EXIT_PARAMERR,
	REFL_EXIT_CONFERR,
	REFL_EXIT_SIGREGERR,
	REFL_EXIT_INITERR,
	REFL_EXIT_OTERR
};

/* csv file name prefix */
#define		CSV_FILE_NAME_PREFIX	"realwork_"
#define		CSV_FILE_NAME_EXT		".csv"
#define		MERGE_FILE_NAME_EXT		".dat"

/* buffer size for operate file */
#define		FILE_OP_BUFFER_SIZE		1024*1024
/* buffer size for command line string */
#define		CMD_BUFFER_SIZE			1024

/* log message define */
#define		LOG_APP_START_INFO		"[作業リアル2] 実績反映プロセスを開始しました。"
#define		LOG_INIT_ERROR			"[作業リアル1] 実績反映プロセスの起動に失敗しました。"
#define		LOG_POLL_CSV_ERROR		"[作業リアル1] 実績反映ファイルの取得に失敗しました。"
#define		LOG_MERGE_CSV_ERROR		"[作業リアル1] 実績反映ファイルの結合処理に失敗しました。"
#define		LOG_DEL_MERGE_ERROR		"Delete the merged file error!"
#define		LOG_OC_REFL_ERROR		"[作業リアル1] OCへの反映処理に失敗しました。"
#define		LOG_BK_FILE_ERROR		"[作業リアル1] 処理済みファイルのバックアップディレクトリへの移動に失敗しました。"
#define		LOG_APP_EXIT_ERROR		"Refect process exited with error!"
#define		LOG_APP_EXIT_INFO		"[作業リアル2] 実績反映プロセスを停止しました。"

/* function's return value define */
#define		REFL_RT_ERROR			-1
#define		REFL_RT_SUCCESS			0

/* global variables define */
extern char gl_logbuf[];
extern pthread_mutex_t gl_mtxLog;
#endif /*REFLECTCOMMON_H_*/
