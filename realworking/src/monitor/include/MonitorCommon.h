/*
 *
 * FILENAME     : MonitorCommon.h
 * PROGRAM      : monitor
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Tan JunLiang
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#ifndef MONITORCOMMON_H_
#define MONITORCOMMON_H_
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include <time.h>
#include <pthread.h>
#include <stdarg.h>
#include <string>
#include <vector>
#include "common_log.hxx"
#include "common_conf.hxx"

/* macro define for log */
#define		LOG_LINEBUF_SIZE			1024*10
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

/* check threads' status interval(in second) */
#define		MON_THRD_STATUS_CHK_INTERVAL	1

/* get current log file interval(in second) */
#define		LOG_FILE_CHECK_INTERVAL			1

enum MonitorExit_e
{
	MONITOR_EXIT_NORM = 0,
	MONITOR_EXIT_SIGREGERR,
	MONITOR_EXIT_SIGMSKGERR,
	MONITOR_EXIT_SIGUMSKGERR,
	MONITOR_EXIT_PARAMERR,
	MONITOR_EXIT_CONFERR,
	MONITOR_EXIT_INITERR,
	MONITOR_EXIT_OTERR,	
};

/* watch thread name define */
#define		MON_THRD_NAME_PROC			"process watch thread"
#define		MON_THRD_NAME_RECV_LOG		"receive log watch thread"
#define		MON_THRD_NAME_REFL_LOG		"reflect log watch thread"

#define		CMD_FUSER					"/usr/sbin/fuser "
#define		CMD_FUSER_TAIL				" 2>/dev/null"
#define		CMD_TEMIP_MNG_DO			"manage do"
#define		CMD_TEMIP_MNG_DO_GREP		"| grep \"No such entity\""
#define		COMMAND_BUFF_SIZE			1024
#define		LINE_BUFF_SIZE				LOG_LINEBUF_SIZE

#define		SIG_RECV_STOPPING			SIGUSR1
#define		SIG_REFL_STOPPING			SIGUSR2
#define		SIG_MONITOR_STOP			SIGTERM



#define		CMD_LOG_END_FLAG				"[END]"
#define		CMD_LOG_HC_CNT_FLAG				"<HC_COUNT>"
#define		CMD_LOG_WORK_CNT_FLAG			"<WORK_COUNT>"
#define		CMD_LOG_OTHER_CNT_FLAG			"<ERROR_COUNT>"
#define		CMD_LOG_COMMON_CNT_FLAG			"<COMMAND>"

enum AoCmdType_e
{
	AO_CMD_TYPE_UNKNOWN = 0,
	AO_CMD_TYPE_HC_COUNTER,
	AO_CMD_TYPE_WORK_COUNTER,
	AO_CMD_TYPE_OTHER_COUNTER,
	AO_CMD_TYPE_COMMON
};

typedef struct
{
	AoCmdType_e type;
	std::string cmdContent;
	void clear()
	{
		type = AO_CMD_TYPE_UNKNOWN;
		cmdContent.clear();
	}
	bool isEmpty()
	{
		return type == AO_CMD_TYPE_UNKNOWN;
	}
} AoCommand_t;

typedef struct
{
	AoCommand_t hcCntCmd;
	AoCommand_t workCntCmd;
	AoCommand_t otherCntCmd;
	std::vector<AoCommand_t> commonCmdVector;
	void clear()
	{
		hcCntCmd.clear();
		workCntCmd.clear();
		otherCntCmd.clear();
		commonCmdVector.clear();
	}
	bool isEmpty()
	{
		return (hcCntCmd.isEmpty() && workCntCmd.isEmpty() && otherCntCmd.isEmpty()
					&& commonCmdVector.size() == 0);
	}
} AoCommandContainer_t;

/* AO customize */
#define		AO_TMPFILE_DIR				"/tmp/"
#define		AO_TMPFILE_PREFIX			"aofile_"
#define		AO_TMPFILE_EXT				".fcl"
#define		AO_MSG_RECV_STARTED_FMT		"set oper %s alarm %s additional text=\"[作業リアル1] %s 受信書き込みプロセス：起動\""
#define		AO_MSG_RECV_STOPPING_FMT	"set oper %s alarm %s additional text=\"[作業リアル1] %s 受信書き込みプロセス：停止処理中\""
#define		AO_MSG_RECV_STOPPED_FMT		"set oper %s alarm %s additional text=\"[作業リアル1] %s 受信書き込みプロセス：停止\""
#define		AO_MSG_REFL_STARTED_FMT		"set oper %s alarm %s additional text=\"[作業リアル1] %s 実績反映プロセス：起動\""
#define		AO_MSG_REFL_STOPPING_FMT	"set oper %s alarm %s additional text=\"[作業リアル1] %s 実績反映プロセス：停止処理中\""
#define		AO_MSG_REFL_STOPPED_FMT		"set oper %s alarm %s additional text=\"[作業リアル1] %s 実績反映プロセス：停止\""
#define		TOTAL_AO_BUFFER_SIZE		LOG_LINEBUF_SIZE
#define		SND_RESULT_BUFFER_SIZE		LOG_LINEBUF_SIZE

extern char gl_logbuf[];
extern pthread_mutex_t gl_mtxLog;
#endif /*MONITORCOMMON_H_*/
