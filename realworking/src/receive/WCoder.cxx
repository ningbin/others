/*
 *
 * FILENAME     : WCoder.cxx
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


#include "WCoder.hxx"
#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/util/TransService.hpp>
#include <assert.h>
#include <iconv.h>
#include "common_log.hxx"

#define JIS_SP_STR "Å¨"


WCoder::WCoder() : m_pFormatter(NULL)
{	
 	TRACE_DEBUG("Construct WCoder");
 	m_pFormatter = new XMLFormatter("SHIFT_JIS",this,XMLFormatter::NoEscapes,XMLFormatter::UnRep_CharRef);
}


WCoder::~WCoder()
{
	if(m_pFormatter)
	{
		delete m_pFormatter;
		m_pFormatter = NULL;
	}	
	TRACE_DEBUG("WCoder destructed");
}


void WCoder::writeChars(const XMLByte* const toWrite, const unsigned int count, XMLFormatter* const formatter)
{
	RWCString chars = (const char*)toWrite;
	if( chars=="&#xFFFD;" )
	{
		chars = JIS_SP_STR;
	}
	m_value += chars;
}


RWCString WCoder::ToString( const XMLCh* const xmlStr)
{
	m_value="";
	*m_pFormatter<<xmlStr;
	return m_value;
}


RWCString WCoder::CheckChars( RWCString& value )
{
	bool fixed=false;
	size_t len=value.length();
	unsigned char* outChar = new unsigned char[len+1];
	outChar[len]='\0';
	strcpy( (char*)outChar, (const char*)value);
	
	for( size_t i=0; i<len; i++ )
	{
		if( ( 0x81 <= outChar[i] && outChar[i] <= 0x9f)||( 0xe0 <= outChar[i] && outChar[i] <= 0xef) )
		{
			i++;
		}
		else if(0xf0 == outChar[i])
		{
			outChar[i] -= 0x6f;
			i++;
			fixed=true;			
		}
		else if( 0xf2 == outChar[i] || 0xf3 == outChar[i])
		{
			outChar[i] -= 5;
			i++;
			fixed=true;
		}
		else if( 0xf4 == outChar[i])
		{
			outChar[i] -= 0x6d;
			i++;
			fixed=true;
		}
		else if( 0xf5 <= outChar[i])
		{
			i++;
		}
	}
	
	if(fixed)
	{
		TRACE_DEBUG("Before fixed:"<<value);
		value = (const char*)outChar;
		TRACE_DEBUG("After fixed:"<<value);
	}

	delete outChar;
	outChar = NULL;
	return value;
}

