/*
 *
 * FILENAME     : LogAnalyzer.cpp
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

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include "LogAnalyzer.h"

bool LogAnalyzer::IsValidCmdLineBuf(const string &lineBuf)
{
	if (lineBuf.find(CMD_LOG_HC_CNT_FLAG) == string::npos
			&& lineBuf.find(CMD_LOG_WORK_CNT_FLAG) == string::npos
			&& lineBuf.find(CMD_LOG_OTHER_CNT_FLAG) == string::npos
			&& lineBuf.find(CMD_LOG_COMMON_CNT_FLAG) == string::npos)
	{
		return false;
	}
	else
	{
		return true;		
	}
}

bool LogAnalyzer::IsLogEnd(const string &lineBuf)
{
	if (lineBuf.find(CMD_LOG_END_FLAG) != string::npos)
	{
		return true;
	}
	else
	{
		return false;
	}
}

void LogAnalyzer::GetAoCmdFromLine(const string &lineBuf, AoCommand_t &aoCommand)
{
	aoCommand.clear();
	if (lineBuf.find(CMD_LOG_HC_CNT_FLAG) != string::npos)
	{
		aoCommand.type = AO_CMD_TYPE_HC_COUNTER;
		aoCommand.cmdContent = lineBuf.substr(lineBuf.find(CMD_LOG_HC_CNT_FLAG) + strlen(CMD_LOG_HC_CNT_FLAG));
	}
	else if (lineBuf.find(CMD_LOG_WORK_CNT_FLAG) != string::npos)
	{
		aoCommand.type = AO_CMD_TYPE_WORK_COUNTER;
		aoCommand.cmdContent = lineBuf.substr(lineBuf.find(CMD_LOG_WORK_CNT_FLAG) + strlen(CMD_LOG_WORK_CNT_FLAG));
	}
	else if (lineBuf.find(CMD_LOG_OTHER_CNT_FLAG) != string::npos)
	{
		aoCommand.type = AO_CMD_TYPE_OTHER_COUNTER;
		aoCommand.cmdContent = lineBuf.substr(lineBuf.find(CMD_LOG_OTHER_CNT_FLAG) + strlen(CMD_LOG_OTHER_CNT_FLAG));
	}
	else if (lineBuf.find(CMD_LOG_COMMON_CNT_FLAG) != string::npos)
	{
		aoCommand.type = AO_CMD_TYPE_COMMON;
		aoCommand.cmdContent = lineBuf.substr(lineBuf.find(CMD_LOG_COMMON_CNT_FLAG) + strlen(CMD_LOG_COMMON_CNT_FLAG));
	}
}

bool LogAnalyzer::IsFileExist(const string &filename)
{
	if (access(filename.c_str(), R_OK) == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

int LogAnalyzer::IsEndLogFile(const string &filename)
{
	string lastline;
	if (!ReadLastLineOfFile(filename, lastline))
	{
		return -1;
	}
	return IsLogEnd(lastline) ? 1 : 0;
}

bool LogAnalyzer::IsEmptyFile(const string &filename)
{
	struct stat filestat;
	memset(&filestat, 0x00, sizeof(filestat));
	if (stat(filename.c_str(), &filestat) == 0 
			&& filestat.st_size == 0)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool LogAnalyzer::ReadLastLineOfFile(const string &filename, string &lastline)
{
	FILE *fp;
	char lineBuf[LINE_BUFF_SIZE + 1];
	memset(lineBuf, 0x00, sizeof(lineBuf));
	lastline = lineBuf;

	if (!IsFileExist(filename))
	{
		ERROR_LOG("File %s does not exist!", filename.c_str());
		return false;
	}

	if ((fp = fopen(filename.c_str(), "r")) == NULL)
	{
		ERROR_LOG("Failed to open file:%s", filename.c_str());
		return false;
	}
	fseek(fp, -1L, SEEK_END);  
	int rtCharFlag = 1;
	for(;;)
	{
		
		char c = fgetc(fp);
		/* skip the lines only with return character */
		while (rtCharFlag == 1 && (c == '\n' || c == '\r'))
		{
			fseek(fp, -1L, SEEK_CUR);
			if (ftell(fp) == 0)
			{
				break;
			}
			fseek(fp, -1L, SEEK_CUR);
			if (ftell(fp) == 0)
			{
				break;
			}
			c = fgetc(fp);
			if (feof(fp))
			{
				fseek(fp, -2L, SEEK_CUR);
				rtCharFlag = 0;
				break;
			}
		}
		rtCharFlag = 0;
		if (c == '\n' || c == '\r')
		{
			break;
		}
		else
		{
			fseek(fp, -1L, SEEK_CUR);
			if (ftell(fp) == 0)
			{
				break;
			}
			fseek(fp, -1L, SEEK_CUR);
			if (ftell(fp) == 0)
			{
				break;
			}
		}
	}
	fgets(lineBuf, sizeof(lineBuf), fp);
	while( strlen(lineBuf) > 0 && (lineBuf[strlen(lineBuf) -1] == '\r' || lineBuf[strlen(lineBuf) -1] == '\n'))
	{
		lineBuf[strlen(lineBuf) -1] = '\0';
	}
	lastline = lineBuf;
	fclose(fp);
	return true;
}

bool LogAnalyzer::GetNewerFile(const string &filename1, const string &filename2, string &newerfile)
{
	struct stat filestat1;
	struct stat filestat2;
	memset(&filestat1, 0x00, sizeof(filestat1));
	memset(&filestat2, 0x00, sizeof(filestat2));
	if (stat(filename1.c_str(), &filestat1) != 0)
	{
		ERROR_LOG("Do system API function stat() error, file: %s, error:%d, %s", filename1.c_str(), errno, strerror(errno));
		return false;
	}
	if (stat(filename2.c_str(), &filestat2) != 0)
	{
		ERROR_LOG("Do system API function stat() error, file: %s, error:%d, %s", filename2.c_str(), errno, strerror(errno));
		return false;
	}
	if (filestat1.st_mtime > filestat2.st_mtime)
	{
		newerfile = filename1;
	}
	else
	{
		newerfile = filename2;
	}
	return true;
}
