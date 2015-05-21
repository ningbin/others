/*
 *
 * FILENAME     : WorkReflector.cpp
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

#include <algorithm>
#include <iostream>
#include <fstream>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <dirent.h>
#include "WorkReflector.h"
#include "ReflectCommon.h"

const int WorkReflector::PERM_READ = R_OK;
const int WorkReflector::PERM_WRITE = W_OK;
const int WorkReflector::PERM_EXECUTE = X_OK;

WorkReflector::WorkReflector(const string &confFile):m_userStop(0), m_confFile(confFile)
{
	TRACE_ENTER_FUNC;
	TRACE_LEAVE_FUNC;
}

WorkReflector::~WorkReflector()
{
	TRACE_ENTER_FUNC;
	TRACE_LEAVE_FUNC;
}

bool WorkReflector::Initialize()
{
	TRACE_ENTER_FUNC;
	RTWConf* pConf = new RTWConf;
	if(!pConf->open(m_confFile))
	{
		ERROR_LOG("Can't open the config file: %s", m_confFile.c_str());
		delete pConf;
		return false;
	}
	m_csvInputDir = pConf->read("path", "RTWORK_REFL_CSV_INPUT_DIR");
	m_datOutputDir = pConf->read("path", "RTWORK_REFL_DAT_OUTPUT_DIR");
	m_csvBackupDir = pConf->read("path", "RTWORK_REFL_BACKUP_CSV_DIR");
	m_datBackupDir = pConf->read("path", "RTWORK_REFL_BACKUP_DAT_DIR");
	m_ocScriptFile = pConf->read("path", "RTWORK_REFL_OC_SCRIPT_FILE");
	m_ocConfigFile = pConf->read("path", "RTWORK_REFL_OC_CONFIG_FILE");
	delete pConf;
	pConf = NULL;
	if (!CheckDir(m_csvInputDir, PERM_READ|PERM_EXECUTE))
	{
		ERROR_LOG("Can't access direcotry: %s", m_csvInputDir.c_str());
		return false;
	}
	if (!CheckDir(m_datOutputDir, PERM_READ|PERM_WRITE|PERM_EXECUTE))
	{
		ERROR_LOG("Can't access direcotry: %s", m_datOutputDir.c_str());
		return false;
	}
	if (!CheckDir(m_csvBackupDir, PERM_READ|PERM_WRITE|PERM_EXECUTE))
	{
		ERROR_LOG("Can't access direcotry: %s", m_csvBackupDir.c_str());
		return false;
	}
	if (!CheckDir(m_datBackupDir, PERM_READ|PERM_WRITE|PERM_EXECUTE))
	{
		ERROR_LOG("Can't access direcotry: %s", m_datBackupDir.c_str());
		return false;
	}
	if (access(m_ocScriptFile.c_str(), R_OK|X_OK) != 0)
	{
		ERROR_LOG("Permission denied! file: %s", m_ocScriptFile.c_str());
		return false;
	}
	if (access(m_ocConfigFile.c_str(), R_OK) != 0)
	{
		ERROR_LOG("Permission denied! file: %s", m_ocConfigFile.c_str());
		return false;
	}
	m_vCsvInputFiles.clear();
	TRACE_LEAVE_FUNC;
	return true;
}

int WorkReflector::PollCsvFile()
{
	if (!m_vCsvInputFiles.empty())
	{
		m_vCsvInputFiles.clear();
	}
	DIR *dir;
	struct dirent *ent;
	if ((dir = opendir(m_csvInputDir.c_str())) == NULL)
	{
		ERROR_LOG("Do system API function opendir() error:%d, %s.(directory:%s)", errno, strerror(errno), m_csvInputDir.c_str());
		return REFL_RT_ERROR;
	}
	while ((ent = readdir(dir)) != NULL)
	{
		string filename = ent->d_name;
		if (IsFile(m_csvInputDir + filename) 
				&& filename.find(CSV_FILE_NAME_PREFIX) == 0
				&& filename.rfind(CSV_FILE_NAME_EXT) == (filename.size()-strlen(CSV_FILE_NAME_EXT)))
		{
			m_vCsvInputFiles.push_back(filename);
		}
	}
	closedir(dir);
	
	sort(m_vCsvInputFiles.begin(), m_vCsvInputFiles.end());
	return m_vCsvInputFiles.size();
}

int WorkReflector::MergeCsvFile()
{
	TRACE_ENTER_FUNC;
	MakeMergeFileName();

	int i;
	for (i = 0; i < m_vCsvInputFiles.size(); i++)
	{
		string csvFileName = m_csvInputDir + m_vCsvInputFiles.at(i);
		if (!MergeFile(csvFileName, m_mergeOutputFile))
		{
			ERROR_LOG("Failed to merge CSV file.");
			return REFL_RT_ERROR;
		}
	}
	TRACE_LEAVE_FUNC;
	return REFL_RT_SUCCESS;
}

bool WorkReflector::CallOcReflection()
{
	TRACE_ENTER_FUNC;
	char cmdBuf[CMD_BUFFER_SIZE + 1];
	int iExitStatus;
	memset(cmdBuf, 0x00, sizeof(cmdBuf));
	sprintf(cmdBuf, "%s -f %s -c %s", m_ocScriptFile.c_str(), m_mergeOutputFile.c_str(), m_ocConfigFile.c_str());
	if (!((iExitStatus = system(cmdBuf)) == 0
			&& WIFEXITED(iExitStatus)
			&& WEXITSTATUS(iExitStatus) == 0))
	{
		ERROR_LOG("OC reflection error: %s", cmdBuf);
		return false;
	}
	TRACE_LEAVE_FUNC;
	return true;
}

bool WorkReflector::MoveIntoBackup()
{
	TRACE_ENTER_FUNC;
	char cmdBuf[CMD_BUFFER_SIZE + 1];
	int iExitStatus;
	int i = 0;
	for (i = 0; i < m_vCsvInputFiles.size(); i++)
	{
		string csvFileName = m_csvInputDir + m_vCsvInputFiles.at(i);
		memset(cmdBuf, 0x00, sizeof(cmdBuf));
		sprintf(cmdBuf, "mv -f %s %s", csvFileName.c_str(), m_csvBackupDir.c_str());
		if (!((iExitStatus = system(cmdBuf)) == 0
				&& WIFEXITED(iExitStatus)
				&& WEXITSTATUS(iExitStatus) == 0))
		{
			ERROR_LOG("Failed to execute system command. CMD_LINE=[:%s]", cmdBuf);
			return false;
		}
	}

	memset(cmdBuf, 0x00, sizeof(cmdBuf));
	sprintf(cmdBuf, "mv -f %s %s", m_mergeOutputFile.c_str(), m_datBackupDir.c_str());
	if (!((iExitStatus = system(cmdBuf)) == 0
			&& WIFEXITED(iExitStatus)
			&& WEXITSTATUS(iExitStatus) == 0))
	{
		ERROR_LOG("Failed to execute system command. CMD_LINE=[:%s]", cmdBuf);
		return false;
	}
	TRACE_LEAVE_FUNC;
	return true;
}

bool WorkReflector::DeleteMergedFile()
{
	TRACE_ENTER_FUNC;
	if (unlink(m_mergeOutputFile.c_str()) != 0)
	{
		ERROR_LOG("Do system API function unlink() error: %d, %s", errno, strerror(errno));
		return false;
	}
	TRACE_LEAVE_FUNC;
	return true;
}

void WorkReflector::MakeMergeFileName()
{
	m_mergeOutputFile.clear();
	m_mergeBackupFile.clear();
	char occurTime[17+1];
	struct timeval  tv;
	struct tm nowtm;
	memset(occurTime, 0x00, sizeof(occurTime));
	gettimeofday(&tv, NULL);
	localtime_r(&tv.tv_sec, &nowtm);
	sprintf(occurTime, "%04d%02d%02d%02d%02d%02d%03d",
		nowtm.tm_year + 1900,
		nowtm.tm_mon + 1,
		nowtm.tm_mday,
		nowtm.tm_hour,
		nowtm.tm_min,
		nowtm.tm_sec,
		(int)(tv.tv_usec/1000));
	string datFilename = CSV_FILE_NAME_PREFIX;
	datFilename += occurTime;
	datFilename += MERGE_FILE_NAME_EXT;
	m_mergeOutputFile = m_datOutputDir + datFilename;
	m_mergeBackupFile = m_datBackupDir + datFilename;
}

void WorkReflector::CheckUserStopSignal()
{
	sigset_t sigset;
	sigemptyset(&sigset);
	sigaddset(&sigset, SIGTERM);
	sigprocmask(SIG_UNBLOCK, &sigset, NULL);
	sigprocmask(SIG_BLOCK, &sigset, NULL);
}

bool WorkReflector::MergeFile(string srcfile, string destfile)
{
	TRACE_ENTER_FUNC;
	char * buffer;
	long size;
	long leftSize;
	ifstream infile (srcfile.c_str(), ifstream::binary);
	if (infile.fail())
	{
		ERROR_LOG("Failed to open file: %s\n", srcfile.c_str());
		return false;
	}
	ofstream outfile (destfile.c_str(), ofstream::binary | ofstream::app);
	if (outfile.fail())
	{
		ERROR_LOG("Failed to open file: %s\n", destfile.c_str());
		return false;
	}

	// get size of file
	infile.seekg(0, ifstream::end);
	size = infile.tellg();
	leftSize = size;
	infile.seekg(0);
	
	// allocate memory for file content
	buffer = new char [FILE_OP_BUFFER_SIZE+1];
	if (buffer == NULL)
	{
		outfile.close();
		infile.close();
		ERROR_LOG("Failed to allocate memory for file content!");
		return false;
	}
	while (leftSize > 0)
	{
		int opsize;
		if (leftSize > FILE_OP_BUFFER_SIZE)
		{
			opsize = FILE_OP_BUFFER_SIZE;
		}
		else
		{
			opsize = leftSize;
		}
		// read content of infile
		infile.read (buffer, opsize);
		if (infile.bad())
		{
			outfile.close();
			infile.close();
			delete[] buffer;
			ERROR_LOG("Failed to read cvs file: %s", srcfile.c_str());
			return false;
		}
		// write to outfile
		outfile.write (buffer, opsize);
		if (outfile.bad())
		{
			outfile.close();
			infile.close();
			delete[] buffer;
			ERROR_LOG("Failed to write file: %s\n", destfile.c_str());
			return false;
		}
		leftSize -= opsize;	
	}
	// release dynamically-allocated memory
	delete[] buffer;
	outfile.close();
	infile.close();
	TRACE_LEAVE_FUNC;
	return true;
}


bool WorkReflector::IsFile(string filename)
{
	struct stat filestat;
	memset(&filestat, 0x00, sizeof(filestat));
	if (stat(filename.c_str(), &filestat) != 0)
	{
		ERROR_LOG("Do system API function stat() error. file: %s, error:%d, %s", filename.c_str(), errno, strerror(errno));
		return false;
	}
	
	if ((filestat.st_mode&S_IFDIR) != 0)
	{
		return false;
	}
	else
	{
		return true;
	}
}

bool WorkReflector::IsDir(string filename)
{
	struct stat filestat;
	memset(&filestat, 0x00, sizeof(filestat));
	if (stat(filename.c_str(), &filestat) != 0)
	{
		ERROR_LOG("Do system API function stat() error. file: %s, error:%d, %s", filename.c_str(), errno, strerror(errno));
		return false;
	}
	
	if ((filestat.st_mode&S_IFDIR) != 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool WorkReflector::CheckDir(string &dirname, int perm)
{
	if (!IsDir(dirname))
	{
		ERROR_LOG("%s is not a directory!", dirname.c_str());
		return false;
	}
	
	if (access(dirname.c_str(), perm) != 0)
	{
		INFO_LOG("Bad permission for the directory:%s", dirname.c_str());
		return false;
	}
	
	if (dirname.at(dirname.size()-1) != '/')
	{
		dirname += "/";
	}
	return true;
}
