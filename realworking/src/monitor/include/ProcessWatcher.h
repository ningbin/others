/*
 *
 * FILENAME     : ProcessWatcher.h
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

#ifndef PROCESSWATCHER_H_
#define PROCESSWATCHER_H_
#include "WatchThread.h"

using namespace std;

class ProcessWatcher : public WatchThread
{
public:
	static void *Run(void *_pProcessWatcher);
	ProcessWatcher(const string &threadName, const string &recvFileName, const string &reflFileName, int checkInterval);
	~ProcessWatcher();
	
private:
	int GetProcessStatus(int stopSigNo, string procFileName, bool &isProcStopping, pid_t &procPid);
	int IsProcessStarted(const string &procFileName);
	
private:
	static const int PROCESS_STATUS_ERROR = -1;
	static const int PROCESS_STATUS_DUMMY = 0;
	static const int PROCESS_STATUS_STARTED = 1;
	static const int PROCESS_STATUS_STOPPING = 2;
	static const int PROCESS_STATUS_STOPPED = 3;
	static const int PROCESS_RECV = 1;
	static const int PROCESS_REFL = 2;
	string m_recvProcFileName;
	string m_reflProcFileName;
	int m_checkInterval;
};
#endif /*PROCESSWATCHER_H_*/
