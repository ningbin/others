/*
 *
 * FILENAME     : CstConf.hxx
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

#include <string>
using namespace std;

class CstConf
{
public:
	static string RTWORK_ORACLE_USER;
	static string RTWORK_ORACLE_PSW;
	static string RTWORK_ORACLE_SID;
	static string RTWORK_RECV_NETYPE_CONF_FILE;
	static string RTWORK_RECV_RESULT_TMP_DIR;
	static string RTWORK_RECV_RESULT_DIR;
	static int RTWORK_RECV_RETRY_INTERVAL;
	static int RTWORK_DB_RETRY_NUMBER;
};


