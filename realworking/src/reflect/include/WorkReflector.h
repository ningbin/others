/*
 *
 * FILENAME     : WorkReflector.h
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

#ifndef WORKREFLECTOR_H_
#define WORKREFLECTOR_H_
#include <string>
#include <vector>

using namespace std;

class WorkReflector
{
public:
	WorkReflector(const string &confFile);
	~WorkReflector();
	bool Initialize();
	int PollCsvFile();
	int MergeCsvFile();
	bool CallOcReflection();
	bool IsUserStop()
	{
		return m_userStop == 0 ? false:true;
	}
	void SetUserStopFlag()
	{
		m_userStop = 1;
	}
	bool DeleteMergedFile();
	bool MoveIntoBackup();
	void CheckUserStopSignal();

private:
	void MakeMergeFileName();
	bool MergeFile(string srcfile, string destfile);
	bool IsFile(string filename);
	bool IsDir(string filename);
	bool CheckDir(string &dirname, int perm);

private:
	int m_userStop;
	string m_confFile;
	string m_csvInputDir;
	string m_datOutputDir;
	string m_csvBackupDir;
	string m_datBackupDir;
	string m_ocScriptFile; // full name
	string m_ocConfigFile; // full name
	vector<string> m_vCsvInputFiles; // not full name
	string m_mergeOutputFile; // full name
	string m_mergeBackupFile; // full name
	static const int PERM_READ;
	static const int PERM_WRITE;
	static const int PERM_EXECUTE;
};

#endif /*WORKREFLECTOR_H_*/
