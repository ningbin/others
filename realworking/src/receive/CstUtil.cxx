/*
 *
 * FILENAME     : CstUtil.cxx
 * PROGRAM      : receive
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Li Yang
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#include <time.h>
#include <sys/timeb.h>
#include <sstream>
#include <iomanip>
#include "CstUtil.hxx"

string GetNowTimeString()
{
    timeb tp;
    struct tm * tm;
    ftime(&tp);
    tm = localtime(&tp.time);

	stringstream ss;
	ss << setfill('0');
    ss << setw(4) << 1900 + tm->tm_year;
	ss << setw(2) << tm->tm_mon + 1;
	ss << setw(2) << tm->tm_mday;
	ss << setw(2) << tm->tm_hour;
	ss << setw(2) << tm->tm_min;
	ss << setw(2) << tm->tm_sec;
	ss << setw(3) << tp.millitm;

	string s = ss.str();
	return s;
}
string HexStringToString(string hexstr)
{
    stringstream ss;
    string ret;
    int tempInt;
    ss << hexstr;
    ss >> setbase(16) >> tempInt;
    ss.clear();
    ss << setbase(10) << tempInt;
    ss >> ret;
    return ret;
}
time_t GetStringTime(string timestr)
{
    struct tm stm;
    time_t tim;
    stm.tm_year = atoi(timestr.substr(0, 4).c_str()) - 1900;
    stm.tm_mon = atoi(timestr.substr(4, 2).c_str()) - 1;
    stm.tm_mday = atoi(timestr.substr(6, 2).c_str());
    stm.tm_hour = atoi(timestr.substr(8, 2).c_str());
    stm.tm_min = atoi(timestr.substr(10, 2).c_str());
    stm.tm_sec = atoi(timestr.substr(12, 2).c_str());
    tim = mktime(&stm);
    return tim;
}
string ChangeTimeFormat(string timestr)
{
    if (timestr.empty())
        return timestr;
    else
        return timestr.substr(0, 4) + "/" + timestr.substr(4, 2) + "/" + timestr.substr(6, 2) + " " 
        + timestr.substr(8, 2) + ":" + timestr.substr(10, 2) + ":" +  timestr.substr(12, 2);
}

