/*
 *
 * FILENAME     : RealworkMonitor.cpp
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

#include "RealworkMonitor.h"

RealworkMonitor::RealworkMonitor(const string &confFile):m_confFile(confFile), m_pProcessWatcher(NULL)
				, m_pRecvLogWatcher(NULL), m_pReflLogWatcher(NULL), m_procCheckInterval(0), m_logCheckInterval(0)
{
}

RealworkMonitor::~RealworkMonitor()
{
	if (m_pProcessWatcher != NULL)
	{
		delete m_pProcessWatcher;
		m_pProcessWatcher = NULL;
	}
	if (m_pRecvLogWatcher != NULL)
	{
		delete m_pRecvLogWatcher;
		m_pRecvLogWatcher = NULL;
	}
	if (m_pReflLogWatcher != NULL)
	{
		delete m_pReflLogWatcher;
		m_pReflLogWatcher = NULL;
	}
	AoSender::Destroy();
}
	
bool RealworkMonitor::Initialize()
{
	TRACE_ENTER_FUNC;
	/* read the configuration */
	RTWConf* pConf = new RTWConf;
	if(!pConf->open(m_confFile))
	{
		ERROR_LOG("Can not open the config file, %s", m_confFile.c_str());
		TRACE_LEAVE_FUNC;
		return false;
	}
	m_procCheckInterval = atoi(pConf->read("common", "RTWORK_MONI_PROC_CHK_INTERVAL").c_str());
	m_logCheckInterval = atoi(pConf->read("common", "RTWORK_MONI_LOG_CHK_INTERVAL").c_str());
	m_recvProcFileName = pConf->read("path", "RTWORK_RECV_PROC_FILE");
	m_reflProcFileName = pConf->read("path", "RTWORK_REFL_PROC_FILE");
	m_recvFirstLogFileName = pConf->read("path", "RTWORK_RECV_CMD_LOG_FILE") + ".1";
	m_recvSecondLogFileName = pConf->read("path", "RTWORK_RECV_CMD_LOG_FILE") + ".2";
	m_reflFirstLogFileName = pConf->read("path", "RTWORK_REFL_CMD_LOG_FILE") + ".1";
	m_reflSecondLogFileName = pConf->read("path", "RTWORK_REFL_CMD_LOG_FILE") + ".2";
	string recvOcName = pConf->read("path", "RTWORK_RECV_OC_NAME");
	string recvAoId = pConf->read("path", "RTWORK_RECV_AO_ID");
	string reflOcName = pConf->read("path", "RTWORK_REFL_OC_NAME");
	string reflAoId = pConf->read("path", "RTWORK_REFL_AO_ID");
	delete pConf;
	pConf = NULL;
	
	/* check the receive process file and reflect process file */
	if (access(m_recvProcFileName.c_str(), R_OK|X_OK) != 0)
	{
		DEBUG_LOG("Access error:%d, %s", errno, strerror(errno));
		ERROR_LOG("Receive process file doesn't exist or bad permission:%s", m_recvProcFileName.c_str());
		return false;
	}
	if (access(m_reflProcFileName.c_str(), R_OK|X_OK) != 0)
	{
		DEBUG_LOG("access error:%d, %s", errno, strerror(errno));
		ERROR_LOG("Reflect process file doesn't exist or bad permission:%s", m_reflProcFileName.c_str());
		return false;
	}
	/* check the OC name and AO id */
	if (recvOcName.size() == 0)
	{
		ERROR_LOG("Receive process's OC name is not set!");
		return false;
	}
	if (recvAoId.size() == 0)
	{
		ERROR_LOG("Receive process's AO ID is not set!");
		return false;
	}
	if (reflOcName.size() == 0)
	{
		ERROR_LOG("Reflect process's OC name is not set!");
		return false;
	}
	if (reflAoId.size() == 0)
	{
		ERROR_LOG("Reflect process's AO ID is not set!");
		return false;
	}
	/* check the log file */
	FILE *fpTest = fopen(m_recvFirstLogFileName.c_str(), "a+");
	if (fpTest == NULL)
	{
		ERROR_LOG("Bad log configuration, directory doesn't exist or no permission:%s.", m_recvFirstLogFileName.c_str());
		return false;
	}
	fclose(fpTest);
	fpTest = fopen(m_reflFirstLogFileName.c_str(), "a+");
	if (fpTest == NULL)
	{
		ERROR_LOG("Bad log configuration, directory doesn't exist or no permission:%s.", m_reflFirstLogFileName.c_str());
		return false;
	}
	fclose(fpTest);
	
	/* create watch threads for process and log */
	m_pProcessWatcher = new ProcessWatcher(MON_THRD_NAME_PROC, m_recvProcFileName, m_reflProcFileName, m_procCheckInterval);
	m_pRecvLogWatcher = new LogWatcher(MON_THRD_NAME_RECV_LOG, m_recvFirstLogFileName, m_recvSecondLogFileName, m_logCheckInterval);
	m_pReflLogWatcher = new LogWatcher(MON_THRD_NAME_REFL_LOG, m_reflFirstLogFileName, m_reflSecondLogFileName, m_logCheckInterval);
	
	/* AoSender init */
	AoSender::Initialize(recvOcName, recvAoId, reflOcName, reflAoId);
	TRACE_LEAVE_FUNC;
	return true;
}

bool RealworkMonitor::StartMonitor()
{
	TRACE_ENTER_FUNC;
	if (!m_pProcessWatcher->Start(ProcessWatcher::Run))
	{
		ERROR_LOG("Thread (Process watcher) start failed!");
		return false;
	}
	if (!m_pRecvLogWatcher->Start(LogWatcher::Run))
	{
		ERROR_LOG("Thread (Receive process's log watcher) start failed!");
		return false;
	}
	if (!m_pReflLogWatcher->Start(LogWatcher::Run))
	{
		ERROR_LOG("Thread (Reflect process's log watcher) start failed!");
		return false;
	}
	TRACE_LEAVE_FUNC;
	return true;
}

bool RealworkMonitor::CheckRunningStatus()
{
	bool isRunning = false;
	if (m_pProcessWatcher->IsRunning()
				&& m_pRecvLogWatcher->IsRunning() && m_pReflLogWatcher->IsRunning())
	{
		isRunning = true;
	}
	else
	{
		if (!m_pProcessWatcher->IsRunning())
		{
			ERROR_LOG("Thread (Process watcher) was stopped with exception!");
		}
		if (!m_pRecvLogWatcher->IsRunning())
		{
			ERROR_LOG("Thread (Receive log watcher) was stopped with exception!");
		}
		if (!m_pReflLogWatcher->IsRunning())
		{
			ERROR_LOG("Thread (Reflect log watcher) was stopped with exception!");
		}
	}
	return isRunning;
}

bool RealworkMonitor::StopMonitor()
{
	TRACE_ENTER_FUNC;
	bool ret = true;
	if (m_pProcessWatcher->IsRunning())
	{
		if (!m_pProcessWatcher->Stop())
		{
			ERROR_LOG("Thread (Process watcher) stop failed!");
			ret = false;
		}
	}
	if (m_pRecvLogWatcher->IsRunning())
	{
		if (!m_pRecvLogWatcher->Stop())
		{
			ERROR_LOG("Thread (receive log watcher) stop failed!");
			ret = false;
		}
	}
	if (m_pReflLogWatcher->IsRunning())
	{
		if (!m_pReflLogWatcher->Stop())
		{
			ERROR_LOG("Thread (reflect log watcher) stop failed!");
			ret = false;
		}
	}
	TRACE_LEAVE_FUNC;
	return ret;
}
