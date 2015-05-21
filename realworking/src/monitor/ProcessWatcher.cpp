/*
 *
 * FILENAME     : ProcessWatcher.cpp
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

#include <errno.h>
#include <unistd.h>
#include "MonitorCommon.h"
#include "ProcessWatcher.h"
#include "AoSender.h"

void* ProcessWatcher::Run(void *_pProcessWatcher)
{
	pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
	ProcessWatcher* pProcWatcher = static_cast<ProcessWatcher*>(_pProcessWatcher);
	int recvRunFlagOld = PROCESS_STATUS_DUMMY;
	int reflRunFlagOld = PROCESS_STATUS_DUMMY;
	static bool isRecvProcStopping = false;
	static pid_t recvProcPid = 0;
	static bool isReflProcStopping = false;
	static pid_t reflProcPid = 0;
	while (true)
	{
		int recvRunFlagNew = pProcWatcher->GetProcessStatus(SIG_RECV_STOPPING, pProcWatcher->m_recvProcFileName, isRecvProcStopping, recvProcPid);
		if (recvRunFlagNew == PROCESS_STATUS_ERROR)
		{
			ERROR_LOG("Get receive process's status error!");
			pProcWatcher->m_threadExitValue = WATCHER_EXIT_ABNORMAL;
			pthread_exit(&(pProcWatcher->m_threadExitValue));
		}
		if (recvRunFlagNew != recvRunFlagOld)
		{
			AoCommandContainer_t aoCmdContainer;
			aoCmdContainer.clear();
			AoCommand_t aoCmd;
			aoCmd.clear();
			aoCmd.type = AO_CMD_TYPE_COMMON;
			if (recvRunFlagNew == PROCESS_STATUS_STARTED)
			{
				aoCmd.cmdContent = AoSender::GetRecvStartedMsg();
			}
			else if (recvRunFlagNew == PROCESS_STATUS_STOPPING)
			{
				aoCmd.cmdContent = AoSender::GetRecvStoppingMsg();
			}
			else
			{
				aoCmd.cmdContent = AoSender::GetRecvStoppedMsg();
			}
			aoCmdContainer.commonCmdVector.push_back(aoCmd);
			AoSender aoSender(aoCmdContainer);
			aoSender.SendAo();
		}
		
		int reflRunFlagNew = pProcWatcher->GetProcessStatus(SIG_REFL_STOPPING, pProcWatcher->m_reflProcFileName, isReflProcStopping, reflProcPid);
		if (reflRunFlagNew == PROCESS_STATUS_ERROR)
		{
			ERROR_LOG("Get reflect process's status error!");
			pProcWatcher->m_threadExitValue = WATCHER_EXIT_ABNORMAL;
			pthread_exit(&(pProcWatcher->m_threadExitValue));
		}
		if (reflRunFlagNew != reflRunFlagOld)
		{
			AoCommandContainer_t aoCmdContainer;
			aoCmdContainer.clear();
			AoCommand_t aoCmd;
			aoCmd.clear();
			aoCmd.type = AO_CMD_TYPE_COMMON;
			if (reflRunFlagNew == PROCESS_STATUS_STARTED)
			{
				aoCmd.cmdContent = AoSender::GetReflStartedMsg();
			}
			else if (reflRunFlagNew == PROCESS_STATUS_STOPPING)
			{
				aoCmd.cmdContent = AoSender::GetReflStoppingMsg();
			}
			else
			{
				aoCmd.cmdContent = AoSender::GetReflStoppedMsg();
			}
			aoCmdContainer.commonCmdVector.push_back(aoCmd);
			AoSender aoSender(aoCmdContainer);
			aoSender.SendAo();
		}
		pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
		pthread_testcancel();
		pthread_setcancelstate(PTHREAD_CANCEL_DISABLE, NULL);
		if (recvRunFlagNew == recvRunFlagOld && reflRunFlagNew == reflRunFlagOld)
		{
			sleep(pProcWatcher->m_checkInterval);
		}
		recvRunFlagOld = recvRunFlagNew;
		reflRunFlagOld = reflRunFlagNew;
	}
}

ProcessWatcher::ProcessWatcher(const string &threadName, const string &recvFileName, const string &reflFileName, int checkInterval)
			:m_recvProcFileName(recvFileName), m_reflProcFileName(reflFileName), m_checkInterval(checkInterval)
{
	m_threadName = threadName;
}

ProcessWatcher::~ProcessWatcher()
{

}

int ProcessWatcher::GetProcessStatus(int stopSigNo, string procFileName, bool &isProcStopping, pid_t &procPid)
{
	int callRet;
	bool isProcStarted;

	/* stopping flag check */
    sigset_t sigset;
	struct timespec waittime;
	memset(&waittime, 0x00, sizeof(waittime));
	sigemptyset(&sigset);
	sigaddset(&sigset, stopSigNo);
	if (sigtimedwait(&sigset,  NULL, &waittime) == stopSigNo)
	{
		isProcStopping = true;
	}
	
	/* started flag check */
	callRet = IsProcessStarted(procFileName);
	if (callRet == -1)
	{
		DEBUG_LOG("Check process whether it is started or not error!");
		return PROCESS_STATUS_ERROR;
	}
	else if (callRet == 0) // process is not started
	{
		isProcStarted = false;
		isProcStopping = false;
	}
	else // callRet is the pid of the started process
	{
		isProcStarted = true;
		if (isProcStopping)
		{
			if (callRet != procPid) // the process is started again with a new pid
			{
				isProcStopping = false;
			}
		}
	}
	procPid = callRet;
	
	/* status return */
	if (!isProcStarted)
	{
		return PROCESS_STATUS_STOPPED;
	}
	else if (isProcStopping)
	{
		return PROCESS_STATUS_STOPPING;
	}
	else
	{
		return PROCESS_STATUS_STARTED;
	}
}

int ProcessWatcher::IsProcessStarted(const string &procFileName)
{
	char cmdBuf[COMMAND_BUFF_SIZE + 1];
    char buf[LINE_BUFF_SIZE + 1];
    int startedFlag = -1;
	FILE *fp;
	memset(cmdBuf, 0x00, sizeof(cmdBuf));
	memset(buf, 0x00, sizeof(buf));
	strncpy(cmdBuf, CMD_FUSER, strlen(CMD_FUSER));
	strncat(cmdBuf, procFileName.c_str(), procFileName.length());
	strncat(cmdBuf, CMD_FUSER_TAIL, strlen(CMD_FUSER_TAIL));
	if ((fp = popen(cmdBuf, "r")) == NULL)
	{
		ERROR_LOG("Do system API function popen() error.");
		return startedFlag;
	}
    if ((fgets(buf, sizeof(buf), fp)) != NULL)
	{
    	// trim '\n' '\r'
    	int len = strlen(buf);
    	while (len > 0 && (buf[len-1] == '\n' || buf[len-1] == '\r'))
    	{
    		buf[len-1] = '\0';
    		len = strlen(buf);
    	}
    	startedFlag = strlen(buf) > 0 ? atoi(buf) : 0;
	}
    else
    {
    	startedFlag = 0;
    }
	pclose(fp);
	return startedFlag;
}
