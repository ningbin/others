/*
 *
 * FILENAME     : AoSender.h
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

#ifndef AOSENDER_H_
#define AOSENDER_H_
#include <pthread.h>
#include "MonitorCommon.h"

using namespace std;

class AoSender
{
public:
	AoSender(const AoCommandContainer_t &aoCmdContainer);
	~AoSender();
	bool SendAo();
	static void Initialize(const string &recvOcName, const string &recvAoId, const string &reflOcName, const string &reflOcId);
	static void Destroy();
	static string GetRecvStartedMsg();
	static string GetRecvStoppingMsg();
	static string GetRecvStoppedMsg();
	static string GetReflStartedMsg();
	static string GetReflStoppingMsg();
	static string GetReflStoppedMsg();
	
private:
	static string GetProcStatusMsg(const string &msgFmt, const string &ocName, const string &aoId, const string &aoEventTime);
	bool MakeTmpAoFile();
	void DeleteTmpAoFile();
	bool SendAoFile();
	void SaveAoIntoLog();
	void MakeTmpFileName();
	static string MakeAoEventTime();

private:
	static string sm_recvOcName;
	static string sm_recvAoId;
	static string sm_reflOcName;
	static string sm_reflAoId;
	static pthread_mutex_t sm_mtxMakeTmpFile;
	AoCommandContainer_t m_aoCmdContainer;
	string m_aoCmdTmpFileName;
};
#endif /*AOSENDER_H_*/
