/*
 *
 * FILENAME     : WException.hxx
 * PROGRAM      : receive
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Ning Bin
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#ifndef _REAL_TIME_WORK_EXCEPTION_HXX_
#define _REAL_TIME_WORK_EXCEPTION_HXX_

#include <rw/cstring.h>

class WException
{
	public:
		WException(RWCString mes):m_id(0){m_message = mes;};
		WException(int id){m_id = id;};
		WException(RWCString mes, int id){m_message = mes;m_id = id;};
		WException():m_id(0){};
		
		RWCString GetMessage(){return m_message;};
		int GetID(){return m_id;};
		
	private:
		RWCString m_message;
		int m_id;
};


#endif
