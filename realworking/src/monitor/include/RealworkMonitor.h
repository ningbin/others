/*
 *
 * FILENAME     : RealworkMonitor.h
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

#ifndef REALWORKMONITOR_H_
#define REALWORKMONITOR_H_
#include "MonitorCommon.h"
#include "ProcessWatcher.h"
#include "LogWatcher.h"
#include "AoSender.h"

using namespace std;

class RealworkMonitor
{
public:
	RealworkMonitor(const string &confFile);
	~RealworkMonitor();
	bool Initialize();
	bool StartMonitor();
	bool CheckRunningStatus();
	bool StopMonitor();
	
private:
	string m_confFile;
	ProcessWatcher *m_pProcessWatcher;
	LogWatcher *m_pRecvLogWatcher;
	LogWatcher *m_pReflLogWatcher;
	string m_recvProcFileName;
	string m_reflProcFileName;
	int m_procCheckInterval;
	string m_recvFirstLogFileName;
	string m_recvSecondLogFileName;
	string m_reflFirstLogFileName;
	string m_reflSecondLogFileName;
	int m_logCheckInterval;
};

#endif /*REALWORKMONITOR_H_*/
