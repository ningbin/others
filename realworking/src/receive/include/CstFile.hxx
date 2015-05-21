/*
 *
 * FILENAME     : CstFile.hxx
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

#ifndef _CST_FILE_HXX_
#define _CST_FILE_HXX_

#include <fstream>
#include "DBConnection.hxx"

#define STR_FILENAME_PRE "/realwork_"
#define STR_FILEEXT_TMP ".tmp"
#define STR_FILEEXT_CSV ".csv"

class CstFile
{
    ofstream m_ofs;
    string m_tmpFilePath;
public:
    void WriteRecord(RealworkRecord &record);
    void WriteEnd(bool isOk);
	~CstFile();
};

#endif
