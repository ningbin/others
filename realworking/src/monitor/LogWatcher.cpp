/*
 *
 * FILENAME     : LogWatcher.cpp
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
#include <fcntl.h>
#include <errno.h>
#include "LogWatcher.h"
#include "LogAnalyzer.h"
#include "AoSender.h"


void* LogWatcher::Run(void *_pLogWatcher)
{
	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
	LogWatcher* pLogWatcher = static_cast<LogWatcher*>(_pLogWatcher);
	while (true)
	{
		if (!pLogWatcher->WatchLog())
		{
			ERROR_LOG("Failed to watch log in thread(%s)!", pLogWatcher->m_threadName.c_str());
			pLogWatcher->m_threadExitValue = WATCHER_EXIT_ABNORMAL;
			pthread_exit(&(pLogWatcher->m_threadExitValue));
		}
	}
}

LogWatcher::LogWatcher(const string &threadName, const string &firstLogFileName, const string &secondLogFileName, int logCheckInterval):m_fpLogFile(NULL)
				, m_firstLogFileName(firstLogFileName), m_secondLogFileName(secondLogFileName), m_logCheckInterval(logCheckInterval)
{
	m_threadName = threadName;
}

LogWatcher::~LogWatcher()
{
	CloseLogFileTail();
}

bool LogWatcher::WatchLog()
{
	TRACE_ENTER_FUNC;
	/* get the current log file */
	bool tailFromTopFlag = false;
	if (!GetCurrentLogFile(m_currentLogFileName, tailFromTopFlag))
	{
		ERROR_LOG("Failed to get current log file!");
		TRACE_LEAVE_FUNC;
		return false;
	}
	
	/* open tail the current log file */
	if (!OpenLogFileTail(m_currentLogFileName, tailFromTopFlag))
	{
		ERROR_LOG("Failed to open log file for watching.");
		TRACE_LEAVE_FUNC;
		return false;
	}

	/* do the current log file content process */
	while (true)
	{
		pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
		pthread_testcancel();
		pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
		
		int retSel;
		bool logEndFlag = false;
		fd_set readFdSet;
		struct timeval timeout;
		time_t oldTime;
		time_t nowTime;
		
		FD_ZERO(&readFdSet);
		FD_SET(fileno(m_fpLogFile), &readFdSet);
		memset(&timeout, 0x00, sizeof(timeout));
		time(&oldTime);
		if ((retSel = select(fileno(m_fpLogFile)+1, &readFdSet, NULL, NULL, &timeout)) == 0)
		{
			//Do nothing, just go to the end of the while to do user interval sleep
		}
		else if (retSel == -1)
		{
			ERROR_LOG("Do system API function select() error:%d", errno);
			CloseLogFileTail();
			TRACE_LEAVE_FUNC;
			return false;
		}
		else
		{
			if (FD_ISSET(fileno(m_fpLogFile), &readFdSet))
			{
				char buf[LINE_BUFF_SIZE + 1];
				memset(buf, 0, sizeof(buf));
				AoCommandContainer_t aoCmdContainer;
				aoCmdContainer.clear();
				AoCommand_t hcCntAoCmd;
				hcCntAoCmd.clear();
				AoCommand_t workCntAoCmd;
				workCntAoCmd.clear();
				AoCommand_t otherCntAoCmd;
				otherCntAoCmd.clear();

				while (fgets(buf, sizeof(buf), m_fpLogFile) != NULL)
				{
					int len = strlen(buf);
					while (len > 0 && (buf[len-1 ] == '\r' || buf[len-1 ] == '\n'))
					{
						buf[len-1] = '\0';
						len = strlen(buf);
					}
					string lineString(buf);
					if (LogAnalyzer::IsValidCmdLineBuf(lineString))
					{
						AoCommand_t aoCmd;
						aoCmd.clear();
						LogAnalyzer::GetAoCmdFromLine(lineString, aoCmd);
						switch (aoCmd.type)
						{
						case AO_CMD_TYPE_HC_COUNTER:
							hcCntAoCmd = aoCmd;
							break;
						case AO_CMD_TYPE_WORK_COUNTER:
							workCntAoCmd = aoCmd;
							break;
						case AO_CMD_TYPE_OTHER_COUNTER:
							otherCntAoCmd = aoCmd;
							break;
						default: // common error AO cmd
							aoCmdContainer.commonCmdVector.push_back(aoCmd);
						}
					}
					else if(LogAnalyzer::IsLogEnd(lineString))
					{
						logEndFlag = true;
						break;
					}
					else
					{
						WARN_LOG("warning: Bad command log:%s", buf);
					}
					memset(buf, 0, sizeof(buf));
				}
				aoCmdContainer.hcCntCmd = hcCntAoCmd;
				aoCmdContainer.workCntCmd = workCntAoCmd;
				aoCmdContainer.otherCntCmd = otherCntAoCmd;
				if (!aoCmdContainer.isEmpty())
				{
					AoSender aoSender(aoCmdContainer);;
					aoSender.SendAo();
				}
				if (logEndFlag) // reach the END of the log
				{
					break;
				}
				else
				{
					if (!feof(m_fpLogFile))
					{
						ERROR_LOG("Do system API function fget() error:%d", errno);
						CloseLogFileTail();
						TRACE_LEAVE_FUNC;
						return true; // not a severe error
					}
				}
			}
		}
		time(&nowTime);
		if (nowTime - oldTime < m_logCheckInterval)
		{
			sleep(m_logCheckInterval - (nowTime - oldTime));
		}
		
	}
	CloseLogFileTail();
	TRACE_LEAVE_FUNC;
	return true; // only hit here when reach the END flag of log file
}

bool LogWatcher::GetCurrentLogFile(string &currentLogFileName, bool &tailFromTopFlag)
{
	while (true)
	{
		pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
		pthread_testcancel();
		pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
		// should choose the one which exist and not empty and not END, if both not empty but without END, choose a newer one
		if (LogAnalyzer::IsFileExist(m_firstLogFileName)
						&& !LogAnalyzer::IsEmptyFile(m_firstLogFileName)
						&& LogAnalyzer::IsEndLogFile(m_firstLogFileName) == 0
						&& LogAnalyzer::IsFileExist(m_secondLogFileName)
						&& !LogAnalyzer::IsEmptyFile(m_secondLogFileName)
						&& LogAnalyzer::IsEndLogFile(m_secondLogFileName) == 0)
		{
			if (!LogAnalyzer::GetNewerFile(m_firstLogFileName, m_secondLogFileName, currentLogFileName))
			{
				WARN_LOG("Get command log file error!");
				continue;
			}
			break;
		}
		else if (LogAnalyzer::IsFileExist(m_firstLogFileName)
				&& !LogAnalyzer::IsEmptyFile(m_firstLogFileName)
				&& LogAnalyzer::IsEndLogFile(m_firstLogFileName) == 0)
		{
			currentLogFileName = m_firstLogFileName;
			break;
		}
		else if (LogAnalyzer::IsFileExist(m_secondLogFileName)
				&& !LogAnalyzer::IsEmptyFile(m_secondLogFileName)
				&& LogAnalyzer::IsEndLogFile(m_secondLogFileName) == 0)
		{
			currentLogFileName = m_secondLogFileName;
			break;
		}
		else
		{
			tailFromTopFlag = true;
			sleep(LOG_FILE_CHECK_INTERVAL);
		}
	}
	return true;
}

bool LogWatcher::OpenLogFileTail(const string &filename, bool &tailFromTopFlag)
{
	m_fpLogFile = fopen(filename.c_str(), "r");
	if (m_fpLogFile == NULL)
	{
		ERROR_LOG("Do system API function fopen() error:%d", errno);
		return false;
	}
	if (fcntl(fileno(m_fpLogFile), F_SETFL, O_NONBLOCK) == -1)
	{
		ERROR_LOG("Do system API function fcntl() error:%d", errno);
		return false;
	}
	
	if (!tailFromTopFlag)
	{
		if (fseek(m_fpLogFile, 0L, SEEK_END) != 0)
		{
			ERROR_LOG("Do system API function fseek() error:%d", errno);
			return false;
		}
	}
	return true;
}

void LogWatcher::CloseLogFileTail()
{
	if (m_fpLogFile != NULL)
	{
		fclose(m_fpLogFile);
		m_fpLogFile = NULL;
	}
}
