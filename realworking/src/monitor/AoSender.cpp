/*
 *
 * FILENAME     : AoSender.cpp
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

#include <unistd.h>
#include <sys/time.h>
#include <errno.h>
#include "AoSender.h"

string AoSender::sm_recvOcName;
string AoSender::sm_recvAoId;
string AoSender::sm_reflOcName;
string AoSender::sm_reflAoId;
pthread_mutex_t AoSender::sm_mtxMakeTmpFile = PTHREAD_MUTEX_INITIALIZER;

void AoSender::Initialize(const string &recvOcName, const string &recvAoId, const string &reflOcName, const string &reflAoId)
{
	TRACE_ENTER_FUNC;
	sm_recvOcName = recvOcName;
	sm_recvAoId = recvAoId;
	sm_reflOcName = reflOcName;
	sm_reflAoId = reflAoId;
	TRACE_LEAVE_FUNC;
}

void AoSender::Destroy()
{
	TRACE_ENTER_FUNC;
	pthread_mutex_destroy(&sm_mtxMakeTmpFile);
	TRACE_LEAVE_FUNC;
}

string AoSender::MakeAoEventTime()
{
	TRACE_ENTER_FUNC;
	struct timeval tv;
	struct tm tmLocal;
	char fmtTime[19+1];
	memset(fmtTime, 0x00, sizeof(fmtTime));
	gettimeofday(&tv, NULL);
	localtime_r(&tv.tv_sec, &tmLocal);
	strftime(fmtTime, sizeof(fmtTime), "%Y-%m-%d %H:%M:%S", &tmLocal);
	string fmtTimeStr(fmtTime);
	TRACE_LEAVE_FUNC;
	return fmtTimeStr;
}

string AoSender::GetRecvStartedMsg()
{
	return GetProcStatusMsg(AO_MSG_RECV_STARTED_FMT, sm_recvOcName, sm_recvAoId, MakeAoEventTime());
}

string AoSender::GetRecvStoppingMsg()
{
	return GetProcStatusMsg(AO_MSG_RECV_STOPPING_FMT, sm_recvOcName, sm_recvAoId, MakeAoEventTime());
}

string AoSender::GetRecvStoppedMsg()
{
	return GetProcStatusMsg(AO_MSG_RECV_STOPPED_FMT, sm_recvOcName, sm_recvAoId, MakeAoEventTime());
}

string AoSender::GetReflStartedMsg()
{
	return GetProcStatusMsg(AO_MSG_REFL_STARTED_FMT, sm_reflOcName, sm_reflAoId, MakeAoEventTime());
}

string AoSender::GetReflStoppingMsg()
{
	return GetProcStatusMsg(AO_MSG_REFL_STOPPING_FMT, sm_reflOcName, sm_reflAoId, MakeAoEventTime());
}

string AoSender::GetReflStoppedMsg()
{
	return GetProcStatusMsg(AO_MSG_REFL_STOPPED_FMT, sm_reflOcName, sm_reflAoId, MakeAoEventTime());
}

string AoSender::GetProcStatusMsg(const string &msgFmt, const string &ocName, const string &aoId, const string &aoEventTime)
{
	char cmdBuf[COMMAND_BUFF_SIZE + 1];
	memset(cmdBuf, 0x00, sizeof(cmdBuf));
	sprintf(cmdBuf, msgFmt.c_str(), ocName.c_str(), aoId.c_str(), aoEventTime.c_str());
	string retStr(cmdBuf);
	return retStr;
}

AoSender::AoSender(const AoCommandContainer_t &aoCmdContainer)
		:m_aoCmdContainer(aoCmdContainer)
{
	TRACE_ENTER_FUNC;
	TRACE_LEAVE_FUNC;
}

AoSender::~AoSender()
{
	TRACE_ENTER_FUNC;
	DeleteTmpAoFile();
	TRACE_LEAVE_FUNC;
}

bool AoSender::SendAo()
{
	TRACE_ENTER_FUNC;
	INFO_LOG("Send AO");
	bool isSendAoSuccess = true;
	if (!MakeTmpAoFile())
	{
		isSendAoSuccess = false;
		ERROR_LOG("Failed to create file.");
	}
	else if (!SendAoFile())
	{
		isSendAoSuccess = false;
		ERROR_LOG("Failed to send alarms by file.");
	}
	SaveAoIntoLog();
	TRACE_LEAVE_FUNC;
	return isSendAoSuccess;
}

bool AoSender::MakeTmpAoFile()
{
	TRACE_ENTER_FUNC;
	MakeTmpFileName();
	FILE *fp = fopen(m_aoCmdTmpFileName.c_str(), "w");
	if (fp == NULL)
	{
		ERROR_LOG("Open file error, file:%s, error:%d, %s", m_aoCmdTmpFileName.c_str(), errno, strerror(errno));
		return false;
	}
	if (!m_aoCmdContainer.hcCntCmd.isEmpty())
	{
		fprintf(fp, "%s\n", m_aoCmdContainer.hcCntCmd.cmdContent.c_str());
	}
	if (!m_aoCmdContainer.workCntCmd.isEmpty())
	{
		fprintf(fp, "%s\n", m_aoCmdContainer.workCntCmd.cmdContent.c_str());
	}
	if (!m_aoCmdContainer.otherCntCmd.isEmpty())
	{
		fprintf(fp, "%s\n", m_aoCmdContainer.otherCntCmd.cmdContent.c_str());
	}
	int i = 0;
	for(i = 0; i < m_aoCmdContainer.commonCmdVector.size(); i++)
	{
		fprintf(fp, "%s\n", m_aoCmdContainer.commonCmdVector.at(i).cmdContent.c_str());
	}
	DEBUG_LOG("debug, file name:%s", m_aoCmdTmpFileName.c_str());
	fclose(fp);
	TRACE_LEAVE_FUNC;
	return true;
}

void AoSender::DeleteTmpAoFile()
{
	if (m_aoCmdTmpFileName.size() > 0)
	{
		unlink(m_aoCmdTmpFileName.c_str());
		m_aoCmdTmpFileName.clear();
	}
	
}

bool AoSender::SendAoFile()
{
	TRACE_ENTER_FUNC;
	char cmdBuf[COMMAND_BUFF_SIZE + 1];
    char buf[LINE_BUFF_SIZE + 1];
	memset(cmdBuf, 0x00, sizeof(cmdBuf));
	memset(buf, 0x00, sizeof(buf));
	sprintf(cmdBuf, "%s %s %s", CMD_TEMIP_MNG_DO, m_aoCmdTmpFileName.c_str(), CMD_TEMIP_MNG_DO_GREP);
	FILE *fp = NULL;
	if ((fp = popen(cmdBuf, "r")) == NULL)
	{
		ERROR_LOG("Do system API function popen() error:%d, %s", errno, strerror(errno));
		return false;
	}
    while ((fgets(buf, sizeof(buf), fp)) != NULL)
	{
    	ERROR_LOG("AO or OC not exist:%s", buf);
	}
    pclose(fp);
    TRACE_LEAVE_FUNC;
	return true;
}

void AoSender::SaveAoIntoLog()
{
	TRACE_ENTER_FUNC;
	char *aoFileBuf = new char[TOTAL_AO_BUFFER_SIZE + 1];
	memset(aoFileBuf, 0x00, TOTAL_AO_BUFFER_SIZE + 1);
	if (!m_aoCmdContainer.hcCntCmd.isEmpty())
	{
		if ((strlen(aoFileBuf) + m_aoCmdContainer.hcCntCmd.cmdContent.size() + 1) < TOTAL_AO_BUFFER_SIZE)
		{
			strncat(aoFileBuf, m_aoCmdContainer.hcCntCmd.cmdContent.c_str()
					, m_aoCmdContainer.hcCntCmd.cmdContent.size());
			strncat(aoFileBuf, "\n", 1);
		}
	}
	if (!m_aoCmdContainer.workCntCmd.isEmpty())
	{
		if ((strlen(aoFileBuf) + m_aoCmdContainer.workCntCmd.cmdContent.size() + 1) < TOTAL_AO_BUFFER_SIZE)
		{
			strncat(aoFileBuf, m_aoCmdContainer.workCntCmd.cmdContent.c_str()
					, m_aoCmdContainer.workCntCmd.cmdContent.size());
			strncat(aoFileBuf, "\n", 1);		
		}
	}
	if (!m_aoCmdContainer.otherCntCmd.isEmpty())
	{
		if ((strlen(aoFileBuf) + m_aoCmdContainer.otherCntCmd.cmdContent.size() + 1) < TOTAL_AO_BUFFER_SIZE)
		{
			strncat(aoFileBuf, m_aoCmdContainer.otherCntCmd.cmdContent.c_str()
					, m_aoCmdContainer.otherCntCmd.cmdContent.size());
			strncat(aoFileBuf, "\n", 1);
		}
	}
	int i = 0;
	for(i = 0; i < m_aoCmdContainer.commonCmdVector.size(); i++)
	{
		if ((strlen(aoFileBuf) + m_aoCmdContainer.commonCmdVector.at(i).cmdContent.size() + 1) < TOTAL_AO_BUFFER_SIZE)
		{
			strncat(aoFileBuf, m_aoCmdContainer.commonCmdVector.at(i).cmdContent.c_str()
					, m_aoCmdContainer.commonCmdVector.at(i).cmdContent.size());
			strncat(aoFileBuf, "\n", 1);
		}
	}
	DEBUG_LOG("AO file content: %s", aoFileBuf);
	TRACE_LEAVE_FUNC;
	delete[] aoFileBuf;
}

void AoSender::MakeTmpFileName()
{
	pthread_mutex_lock(&sm_mtxMakeTmpFile);
	char occurTime[20+1];
	struct timeval  tv;
	struct tm nowtm;
	struct tm* pnowtm = &nowtm;
	gettimeofday(&tv, NULL);
	localtime_r(&tv.tv_sec, pnowtm);
	sprintf(occurTime, "%04d%02d%02d%02d%02d%02d%06ld",
		pnowtm->tm_year + 1900,
		pnowtm->tm_mon + 1,
		pnowtm->tm_mday,
		pnowtm->tm_hour,
		pnowtm->tm_min,
		pnowtm->tm_sec,
		tv.tv_usec);
	m_aoCmdTmpFileName = AO_TMPFILE_DIR;
	m_aoCmdTmpFileName += AO_TMPFILE_PREFIX;
	m_aoCmdTmpFileName += occurTime;
	m_aoCmdTmpFileName += AO_TMPFILE_EXT;
	pthread_mutex_unlock(&sm_mtxMakeTmpFile);
}
