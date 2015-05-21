/*
 *
 * FILENAME     : CstUtil.hxx
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

#ifndef _CST_UTIL_HXX_
#define _CST_UTIL_HXX_

using namespace std;

string GetNowTimeString();
string HexStringToString(string hexstr);
time_t GetStringTime(string timestr);
string ChangeTimeFormat(string timestr);

#endif
