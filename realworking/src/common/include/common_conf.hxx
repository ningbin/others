/*
 *
 * FILENAME     : common_conf.hxx
 * PROGRAM      : powerdown
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Xiong Weijun
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#ifndef _REAL_TIME_WORK_CONF_HXX_
#define _REAL_TIME_WORK_CONF_HXX_

#include <map> 
#include <string> 
#include <vector> 
#include <algorithm> 
#include <functional> 
#include <fstream>
 
using namespace std; 

typedef map<string, string, less<string> > INI_STR_MAP; 
const char*const MIDDLESTRING = "_______***_______"; 

struct analyzeIni
{ 
	string		strSect; 
	INI_STR_MAP	*pMap; 

	analyzeIni(INI_STR_MAP & strmap):pMap(&strmap){};
	void operator()( const string &strini);
}; 

class RTWConf
{
public:
	RTWConf();
	~RTWConf();

	bool open(const string pstrPath);
	string read(const char*psect, const char*pkey); 

private:
	INI_STR_MAP   m_InitMap; 
};

#endif /*_REAL_TIME_WORK_CONF_HXX_*/

