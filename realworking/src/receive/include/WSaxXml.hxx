/*
 *
 * FILENAME     : WSaxXml.hxx
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

#ifndef _REAL_TIME_WORK_XML_HXX_
#define _REAL_TIME_WORK_XML_HXX_

#include "WThread.hxx"
#include "WRecord.hxx"
#include "WCoder.hxx"
#include "WHead.hxx"
#include "WMessage.hxx"
#include <rw/tvmap.h>
#include <xercesc/sax2/DefaultHandler.hpp>

XERCES_CPP_NAMESPACE_USE

class WSaxXml : public WEvent
{
	public:
		WSaxXml(const char* source, const WHead& head);
		~WSaxXml();
		static void Initialize(); 
		static void Terminate();
		void Run(void*);
		RWCString Dump();
		void FixChar();
		
	private:
		WSaxXml();
		inline void SendReponse();	
			
	private:
		RWCString m_inputSource;
		size_t m_xmlLen;
		WHead m_head;
};

typedef RWTValMap< RWCString, RWCString, std::less<RWCString> > RecordMap;

class WSax2Handler : public DefaultHandler
{
	public:
		WSax2Handler(WSaxXml*);
		~WSax2Handler();
		void startElement(const XMLCh* const uri, const XMLCh* const localname, const XMLCh* const qname, const Attributes& attrs);
		void endElement( const XMLCh* const uri, const XMLCh* const localname, const XMLCh* const qname);
		void characters(const XMLCh* const chars, const unsigned int length);
		void startDocument();
		void endDocument();
		
		void warning(const SAXParseException& e);
		void error(const SAXParseException& e);
		void fatalError(const SAXParseException& e);
		
	private:
		WSax2Handler();
		RWTPtrSlist<WRecord> m_tmpRecordList;
		RecordMap m_curRecord;
		RWCString m_curElement;
		RWCString m_curValue;
		bool m_open;
		WCoder m_coder;
		WSaxXml* m_pXml;
};



#define GET_RECORD_FROM_MAP( pRecord, element ) \
	if( m_curRecord.contains(#element) ) \
	{ \
		pRecord->##element = m_curRecord[#element]; \
		m_curRecord.remove(#element); \
	} \
	else \
	{ \
		delete pRecord; \
		pRecord = NULL; \
		RWCString message("Missing tag <"); \
		message += #element; \
		message += ">"; \
		SEND_NOTIFY_AO( MESSAGE_XML_TAG_ERROR<<"("<<message<<")" );	\
		throw WException( message ); \
	}
	
#define GET_HEAD_FROM_MAP( pRecord, element ) \
	if( m_curRecord.contains(#element) ) \
	{ \
		pRecord->##element = m_curRecord[#element]; \
	} \
	else \
	{ \
		delete pRecord; \
		pRecord = NULL; \
		RWCString message("Missing tag <"); \
		message += #element; \
		message += ">"; \
		SEND_NOTIFY_AO( MESSAGE_XML_TAG_ERROR<<"("<<message<<")" );	\
		throw WException( message ); \
	}

#endif
