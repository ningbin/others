/*
 *
 * FILENAME     : LogWatcher.h
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

#ifndef LOGWATCHER_H_
#define LOGWATCHER_H_
#include "WatchThread.h"

using namespace std;

class LogWatcher : public WatchThread
{
public:
	LogWatcher(const string &threadName, const string &firstLogFileName, const string &secondLogFileName, int logCheckInterval);
	~LogWatcher();
	static void *Run(void *_pLogWatcher);
	
private:
	bool WatchLog();
	bool GetCurrentLogFile(string &currentLogFileName, bool &tailFromTopFlag);
	bool OpenLogFileTail(const string &filename, bool &tailFromTopFlag);
	void CloseLogFileTail();
	
protected:
	FILE *m_fpLogFile;
	string m_firstLogFileName;
	string m_secondLogFileName;
	string m_currentLogFileName;
	int m_logCheckInterval;
};
#endif /*LOGWATCHER_H_*/
