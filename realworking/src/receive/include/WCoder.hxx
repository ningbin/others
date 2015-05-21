/*
 *
 * FILENAME     : WCoder.hxx
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

#ifndef _REAL_TIME_WORK_CODE_HXX_
#define _REAL_TIME_WORK_CODE_HXX_

#include <xercesc/framework/XMLFormatter.hpp>
#include <xercesc/util/XMLString.hpp>
#include <iostream>
#include <rw/cstring.h>


using namespace std;
XERCES_CPP_NAMESPACE_USE

class WCoder : public XMLFormatTarget
{
	public:
		WCoder();
		~WCoder();
		RWCString ToString(const XMLCh* const xmlStr);
		static RWCString CheckChars(RWCString& value);
		
	private:
		XMLFormatter*	m_pFormatter;
		RWCString  m_value;

		void writeChars(const XMLByte* const toWrite,
						const unsigned int count,
						XMLFormatter* const formatter);		
};

class StrX
{
public :
    StrX(const XMLCh* const toTranscode)
    {
       m_localForm = XMLString::transcode(toTranscode);
    }

    ~StrX()
    {
        XMLString::release(&m_localForm);
    }

    const char* localForm() const
    {
        return m_localForm;
    }

private :
   char*   m_localForm;
};

inline XERCES_STD_QUALIFIER ostream& operator<<(XERCES_STD_QUALIFIER ostream& target, const StrX& toDump)
{
    target << toDump.localForm();
    return target;
}


#endif 
