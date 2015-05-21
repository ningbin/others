/*
 *
 * FILENAME     : Main.cpp
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

#include <signal.h>
#include <unistd.h>
#include "ReflectCommon.h"
#include "WorkReflector.h"

using namespace std;

char gl_logbuf[LOG_LINEBUF_SIZE+1];
pthread_mutex_t gl_mtxLog = PTHREAD_MUTEX_INITIALIZER;
static WorkReflector* gs_pReflector = NULL;

static void DoSigTerm(int signo)
{
	INFO_LOG("Get user stop signal!");
	gs_pReflector->SetUserStopFlag();
}

static int RegistSignal()
{
	struct sigaction saTerm;
	sigset_t sigmask;
	memset(&saTerm, 0x00, sizeof(saTerm));
	sigemptyset(&sigmask);
	saTerm.sa_handler = DoSigTerm;
	saTerm.sa_mask = sigmask;
	if (sigaction(SIGTERM, &saTerm, NULL) != 0)
	{
		ERROR_LOG("Do system API function sigaction() error:%d,%s", errno, strerror(errno));
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
		exit(REFL_EXIT_PARAMERR);
	}

	/* read configuration file */
	const char* confFileName = argv[1];
	RTWConf* pConf = new RTWConf;
	if(!pConf->open(confFileName))
	{
		printf("Can't open the config file, %s\n", confFileName);
		delete pConf;
		exit(REFL_EXIT_CONFERR);
	}
	string logname = pConf->read("log", "RTWORK_REFL_PROCESS_LOG_NAME");
	string commandLogName = pConf->read("log", "RTWORK_REFL_COMMAND_LOG_NAME");
	string mask = pConf->read("log", "RTWORK_REFL_PROCESS_TRACE_MASK");
	string logsize = pConf->read("log", "RTWORK_REFL_LOG_MAX_SIZE");
	string osi_entity = pConf->read("command", "RTWORK_REFL_NOTIFY_OSI_ENTITY");
	delete pConf;
	pConf = NULL;

	/* initialize log */
	INIT_LOG( atoi(logsize.c_str()), atoi(mask.c_str()) );
	INIT_TRACE( COMMAND, commandLogName.c_str() );
	INIT_TRACE( ERROR, logname.c_str() );
	INIT_TRACE( WARNING, logname.c_str() );
	INIT_TRACE( DEBUG, logname.c_str() );
	INIT_TRACE( INFO, logname.c_str() );
	INIT_TRACE( TRACE, logname.c_str() );
	INIT_TRACE( DATA, logname.c_str() );
	
	if (osi_entity.size() == 0){
		ERROR_LOG("Reflect process's OSI ENTITY is not set!");
		exit(REFL_EXIT_OTERR);
	}
	
	if (RegistSignal() != 0)
	{
		ERROR_LOG("Failed to register signal!");
		exit(REFL_EXIT_SIGREGERR);
	}
	
	/* initialize AO */
	INIT_NOTIFY_OSI_ENTITY(osi_entity.c_str());
	
	INFO_LOG(LOG_APP_START_INFO);
	SEND_NOTIFY_WARNING_AO(LOG_APP_START_INFO);
	
	WorkReflector reflector(confFileName);
	gs_pReflector = &reflector;
	if (!gs_pReflector->Initialize())
	{
		ERROR_LOG(LOG_INIT_ERROR);
		SEND_NOTIFY_AO(LOG_INIT_ERROR);
		exit(REFL_EXIT_INITERR);
	}
	
	struct timespec pollCsvItvl;
	memset(&pollCsvItvl, 0x00, sizeof(pollCsvItvl));
	pollCsvItvl.tv_nsec = POLL_CSV_FILE_INTERVAL;
	bool isBrkWithError = false;
	while (true)
	{
		/* check user stop signal */		
		gs_pReflector->CheckUserStopSignal();
		if (gs_pReflector->IsUserStop())
		{
			break;
		}

		/* poll csv files from csv input directory */
		int iCsvCount = gs_pReflector->PollCsvFile();
		if (iCsvCount < 0)
		{
			ERROR_LOG(LOG_POLL_CSV_ERROR);
			SEND_NOTIFY_AO(LOG_POLL_CSV_ERROR);
			isBrkWithError = true;
			break;
		}
		if (iCsvCount == 0)
		{
			nanosleep(&pollCsvItvl, NULL);
			continue;
		}

		/* merge csv files */
		int iRet = gs_pReflector->MergeCsvFile();
		if (iRet == REFL_RT_ERROR) // error
		{
			ERROR_LOG(LOG_MERGE_CSV_ERROR);
			SEND_NOTIFY_AO(LOG_MERGE_CSV_ERROR);
			isBrkWithError = true;
			if (!gs_pReflector->DeleteMergedFile()) // if merge failed, delete the uncompleted merged dat file
			{
				WARN_LOG(LOG_DEL_MERGE_ERROR);
				isBrkWithError = true;
			}
			break;
		}
		/* OC reflection */
		bool ret = gs_pReflector->CallOcReflection();
		if (!ret)
		{
			ERROR_LOG(LOG_OC_REFL_ERROR);
			SEND_NOTIFY_AO(LOG_OC_REFL_ERROR);
			isBrkWithError = true;
			if (!gs_pReflector->DeleteMergedFile()) // if OC reflection failed, delete the completed merged dat file
			{
				WARN_LOG(LOG_DEL_MERGE_ERROR);
			}
			break;	
		}
		else
		{
			ret = gs_pReflector->MoveIntoBackup();
			if (!ret)
			{
				ERROR_LOG(LOG_BK_FILE_ERROR);
				SEND_NOTIFY_AO(LOG_BK_FILE_ERROR);
				isBrkWithError = true;
				if (!gs_pReflector->DeleteMergedFile())
				{
					WARN_LOG(LOG_DEL_MERGE_ERROR);
				}
				break;
			}
		}
	}
	if (isBrkWithError)
	{
		INFO_LOG(LOG_APP_EXIT_ERROR);
		SEND_NOTIFY_WARNING_AO(LOG_APP_EXIT_INFO);
		exit(REFL_EXIT_OTERR);
	}
	else // exit by user
	{
		INFO_LOG(LOG_APP_EXIT_INFO);
		SEND_NOTIFY_WARNING_AO(LOG_APP_EXIT_INFO);
		exit(REFL_EXIT_NORM);
	}
}
