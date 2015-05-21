/*
 *
 * FILENAME     : LogAnalyzer.h
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

#ifndef LOGANALYZER_H_
#define LOGANALYZER_H_
#include "MonitorCommon.h"

using namespace std;

class LogAnalyzer
{
public:
	/**
	 * Check the line buf string is a valid command string or not
	 * @param lineBuf
	 * line buffer string
	 * @return true if is valid, false if invalid
	 */
	static bool IsValidCmdLineBuf(const string &lineBuf);
	/**
	 * Check the line buffer string is a log end flag string or not
	 * @param lineBuf
	 * line buffer string
	 * @return true if is log end, false if not
	 */
	static bool IsLogEnd(const string &lineBuf);
	
	static void GetAoCmdFromLine(const string &lineBuf, AoCommand_t &aoCommand);
	static bool IsFileExist(const string &filename);
	static int IsEndLogFile(const string &filename); // -1 error, 0 not end, 1 end
	static bool IsEmptyFile(const string &filename);
	static bool GetNewerFile(const string &filename1, const string &filename2, string &newerfile);

private:
	static bool ReadLastLineOfFile(const string &filename, string &lastline);
};
#endif /*LOGANALYZER_H_*/
