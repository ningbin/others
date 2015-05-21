/*
 *
 * FILENAME     : Main.cpp
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

#include <stdlib.h>
#include <unistd.h>
#include "MonitorCommon.h"
#include "RealworkMonitor.h"

using namespace std;

char gl_logbuf[LOG_LINEBUF_SIZE+1];
pthread_mutex_t gl_mtxLog = PTHREAD_MUTEX_INITIALIZER;

RealworkMonitor *gl_pRealworkMonitor = NULL;

static void sigTerm(int signo)
{
	INFO_LOG("Received user stop signal!");
	if (gl_pRealworkMonitor != NULL)
	{
		if (!gl_pRealworkMonitor->StopMonitor())
		{
			ERROR_LOG("Monitor is stopped with error!");
			delete gl_pRealworkMonitor;
			exit(MONITOR_EXIT_OTERR);
		}
		else
		{
			INFO_LOG("Monitor is stopped successfully!");
			delete gl_pRealworkMonitor;
			exit(MONITOR_EXIT_NORM);
		}
	}
}

static int registSigterm()
{
	struct sigaction saTerm;
	sigset_t sigset;
	memset(&saTerm, 0x00, sizeof(saTerm));
	sigemptyset(&sigset);
	sigaddset(&sigset, SIG_RECV_STOPPING);
	sigaddset(&sigset, SIG_REFL_STOPPING);
	saTerm.sa_handler = sigTerm;
	saTerm.sa_mask = sigset;
	if (sigaction(SIG_MONITOR_STOP, &saTerm, NULL) != 0)
	{
		return -1;
	}
	return 0;
}

static int maskSignal()
{
	sigset_t sigset;
	sigemptyset(&sigset);
	sigaddset(&sigset, SIG_MONITOR_STOP);
	sigaddset(&sigset, SIG_RECV_STOPPING);
	sigaddset(&sigset, SIG_REFL_STOPPING);
	if (sigprocmask(SIG_BLOCK, &sigset, NULL) != 0)
	{
		return -1;
	}
	return 0;
}

static int unmaskSignal()
{
	sigset_t sigset;
	sigemptyset(&sigset);
	sigaddset(&sigset, SIG_MONITOR_STOP);
	if (sigprocmask(SIG_UNBLOCK, &sigset, NULL) != 0)
	{
		return -1;
	}
	return 0;	
}

int main(int argc, char *argv[])
{
	
	/* parameter check */
	if (argc != 2)
	{
		printf("Parameter error!\n");
		exit(MONITOR_EXIT_PARAMERR);
	}

	/* signal handle */
	if (registSigterm() != 0)
	{
		exit(MONITOR_EXIT_SIGREGERR);
	}
	if (maskSignal() != 0)
	{
		exit(MONITOR_EXIT_SIGMSKGERR);
	}

	/* read configuration file */
	const char* confFileName = argv[1];
	RTWConf* pConf = new RTWConf;
	if(!pConf->open(confFileName))
	{
		printf("can not open the config file. %s\n", confFileName);
		exit(MONITOR_EXIT_CONFERR);
	}
	string logname = pConf->read("log", "RTWORK_MONI_PROCESS_LOG_NAME");
	string mask = pConf->read("log", "RTWORK_MONI_PROCESS_TRACE_MASK");
	string size = pConf->read("log", "RTWORK_MONI_LOG_MAX_SIZE");
	delete pConf;
	pConf = NULL;

	/* initialize log */
	INIT_LOG( atoi(size.c_str()), atoi(mask.c_str()) );
	INIT_TRACE( ERROR, logname.c_str() );
	INIT_TRACE( WARNING, logname.c_str() );
	INIT_TRACE( DEBUG, logname.c_str() );
	INIT_TRACE( INFO, logname.c_str() );
	INIT_TRACE( TRACE, logname.c_str() );
	INIT_TRACE( DATA, logname.c_str() );

	TRACE_ENTER_FUNC;
	gl_pRealworkMonitor = new RealworkMonitor(confFileName);
	
	/* monitor initialization */
	if (!gl_pRealworkMonitor->Initialize())
	{
		ERROR_LOG("Process initialize error!");
		TRACE_LEAVE_FUNC;
		exit(MONITOR_EXIT_INITERR);
	}
	INFO_LOG("Monitor initialize success!");

	/* start the monitor */
	if (!gl_pRealworkMonitor->StartMonitor())
	{
		ERROR_LOG("Process start error!");
		gl_pRealworkMonitor->StopMonitor();
		TRACE_LEAVE_FUNC;
		exit(MONITOR_EXIT_OTERR);
	}
	INFO_LOG("Monitor process is started!");
	
	/* wait for the monitor to stop */
	while (gl_pRealworkMonitor->CheckRunningStatus())
	{
		if (unmaskSignal() != 0)
		{
			DEBUG_LOG("unmask signal error!");
			break;
		}
		sleep(MON_THRD_STATUS_CHK_INTERVAL);
		if (maskSignal() != 0)
		{
			DEBUG_LOG("mask signal error!");
			break;
		}
	}
	
	/* only hit here when error occurs */
	if (!gl_pRealworkMonitor->StopMonitor())
	{
		ERROR_LOG("Process stop error!");
	}
	INFO_LOG("Monitor exited abnormally!");
	if (gl_pRealworkMonitor != NULL)
	{
		delete gl_pRealworkMonitor;
		gl_pRealworkMonitor = NULL;
	}
	TRACE_LEAVE_FUNC;
	exit(MONITOR_EXIT_OTERR);
}
