/*
 *
 * FILENAME     : WSaxXml.cxx
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


#include <xercesc/util/PlatformUtils.hpp>
#include <xercesc/util/TransService.hpp>
#include <xercesc/framework/MemBufInputSource.hpp>
#include <xercesc/sax2/SAX2XMLReader.hpp>
#include <xercesc/sax2/XMLReaderFactory.hpp>
#include <xercesc/util/OutOfMemoryException.hpp>
#include "WSaxXml.hxx"
#include "WSocket.hxx"
#include "WApp.hxx"
#include "WException.hxx"
#include "WMessage.hxx"
#include "common_log.hxx"
#include <rw/cstring.h>

using namespace xercesc;

WSaxXml::WSaxXml(const char* source, const WHead& head)
: m_inputSource( source ), m_head( head )
{
	TRACE_DEBUG("Construct WSaxXml");
}


WSaxXml::~WSaxXml()
{
	TRACE_DEBUG("WSaxXml destructed");
}


void WSaxXml::Initialize()
{
	try
	{
		XMLPlatformUtils::Initialize();
		TRACE_DEBUG("XMLPlatformUtils Initialized");
	}
	catch(const XMLException& e)
	{
		TRACE_ERROR("XML parsing initialize failure");
		throw WException("XMLPlatformUtils Initialize failure");
	}
}


void WSaxXml::Terminate()
{
	try
	{
		XMLPlatformUtils::Terminate();
		TRACE_DEBUG("XMLPlatformUtils Terminated");
	}
	catch(const XMLException& e)
	{
		TRACE_ERROR("XML parsing terminate failure");
	}
}

void WSaxXml::Run(void*)
{
	TRACE_TRACE("Start to run work xml");
	SAX2XMLReader* parser = XMLReaderFactory::createXMLReader();
	WSax2Handler handler(this);
	parser->setContentHandler(&handler);
    parser->setErrorHandler(&handler);
    m_xmlLen = 	m_inputSource.length();
    FixChar();
    
    MemBufInputSource* memBufIS = new MemBufInputSource
    (
        (const XMLByte*)(const char*)m_inputSource,
       	m_xmlLen,
        "work.xml",
        false
    );
    
    try
    {
   		if( WApp::m_pSocket->IsConnected() )
   		{
   			parser->parse(*memBufIS);
   		}
   		else
   		{
   			TRACE_TRACE("Socket connection is brocken, don't parse xml");
   		}
    }
    catch (const OutOfMemoryException& e)
    {
        TRACE_ERROR("OutOfMemoryException");
    }
    catch (const SAXParseException & e)
    {
    	TRACE_ERROR("SAXParseException : "<<StrX( e.getMessage() )<<Dump() );
    }
    catch (const XMLException& e)
    {
        TRACE_ERROR("XMLException : "<<StrX( e.getMessage() )<<Dump() );
    }
    catch (WException& e)
    {
        TRACE_ERROR( e.GetMessage()<<Dump() );
    }
    catch (...)
    {
        TRACE_ERROR("Unknown exception");
    }
   	SendReponse();
	delete parser;
	parser = NULL;
	delete memBufIS;
	memBufIS = NULL;
	TRACE_TRACE("End to run work xml");
}

RWCString WSaxXml::Dump()
{
	RWCString dump("\nWork head:\n");
	dump += m_head.Dump();
	dump += "\nWork data:\n";
	dump += m_inputSource;
	return dump;
}

void WSaxXml::FixChar()
{
	unsigned char* outChar = NULL;
	bool fixed=false;
	try
	{
		outChar = new unsigned char[m_xmlLen+1];
		outChar[m_xmlLen]='\0';
		strcpy( (char*)outChar, (const char*)m_inputSource);	
		
		size_t j=0;
		for( size_t i=0; i<m_xmlLen; i++ )
		{
			if( ( 0xa1 <= outChar[i] && outChar[i] <= 0xfe) )
			{
				if( 0xa1 == outChar[i] )
				{ 
					outChar[j] = outChar[i] + 0x54;
					outChar[++j] = outChar[++i];
					fixed = true;
				}
				else if( 0xad == outChar[i] )
				{ 
					outChar[j] = outChar[i] + 0x50;
					outChar[++j] = outChar[++i];
					fixed = true;
				}
				else if( 0xf5 <= outChar[i] && outChar[i] <= 0xf8 )
				{
					outChar[j] = 0xaf;
					outChar[++j] = outChar[++i];
					fixed = true;
				}
				else if( 0xfd <= outChar[i] )
				{
					outChar[j] = 0xaf;
					outChar[++j] = outChar[++i];
					fixed = true;
				}
				else
				{
					outChar[j] = outChar[i];
					outChar[++j] = outChar[++i];
				}
			}
			else if( 0x8e == outChar[i] )
			{
				outChar[j] = outChar[i];
				outChar[++j] = outChar[++i];
			}
			else if( 0x8f == outChar[i] )
			{
				outChar[j] = 0xa2;
				outChar[++j] = 0xae;
				i += 2;
				fixed = true;
			}
			else
			{
				outChar[j] = outChar[i];
			}
			j++;
		}
		
		if(fixed)
		{
			outChar[j]='\0';
			TRACE_DEBUG("Fixed XML:\n"<<outChar);
			m_inputSource = (const char*)outChar;
		}
		if(outChar)
		{
			delete outChar;
			outChar = NULL;
		}
	}
	catch(...)
	{
		if(outChar)
		{
			delete outChar;
			outChar = NULL;
		}
	}
}

void WSaxXml::SendReponse()
{
	m_head.SetHandleId( handle_id_work_reply );
	m_head.SetDefault();
	bool needSleep=false;
	if( WTest::work_sleep_time ==0 || WTest::work_sleep_num <1 )
	{
		needSleep=false;
	}
	else if( WTest::work_sleep_num >1 )
	{
		needSleep=false;
		WTest::work_sleep_num--;
	}
	else
	{
		needSleep=true;
		WTest::work_sleep_num--;
	}

	if(needSleep)
	{
		TRACE_TRACE("Sleep "<<WTest::work_sleep_time<<" seconds...");
		sleep( WTest::work_sleep_time );
	}
	WApp::m_pSocket->WriteResponse( m_head );
}


WSax2Handler::WSax2Handler(WSaxXml* pXml)
 : m_open(false),m_pXml(pXml)
{
}

WSax2Handler::~WSax2Handler()
{
	if( !m_tmpRecordList.isEmpty() )
	{
		TRACE_DEBUG("Destroy all records in temp list");
		m_tmpRecordList.clearAndDestroy();
	}
}

void WSax2Handler::startElement(const XMLCh* const uri, const XMLCh* const localname, const XMLCh* const qname, const Attributes& attrs)
{
	m_open=true;
	m_curElement = StrX( localname ).localForm();
	m_curValue = "";
	TRACE_DEBUG("m_curElement=>"<<m_curElement);
}


void WSax2Handler::endElement( const XMLCh* const uri, const XMLCh* const localname, const XMLCh* const qname)
{
	m_open=false;
	m_curElement = StrX( localname ).localForm();
	TRACE_DEBUG("m_curElement=>"<<m_curElement);
	if( m_curElement=="equipInfo" )
	{
		// construct a record
		WRecord* pRecord = new WRecord;
		try
		{
			GET_HEAD_FROM_MAP(pRecord, messageType)
			GET_HEAD_FROM_MAP(pRecord, koujitCount)
			GET_HEAD_FROM_MAP(pRecord, regkubun)
			GET_HEAD_FROM_MAP(pRecord, cmngno)
			GET_HEAD_FROM_MAP(pRecord, constnm)
			GET_HEAD_FROM_MAP(pRecord, equipCount)
			GET_RECORD_FROM_MAP(pRecord, kono)
			GET_RECORD_FROM_MAP(pRecord, buil_nm)
			GET_RECORD_FROM_MAP(pRecord, kaitei_nm)
			GET_RECORD_FROM_MAP(pRecord, sdate)
			GET_RECORD_FROM_MAP(pRecord, edate)
			GET_RECORD_FROM_MAP(pRecord, jsdate)
			GET_RECORD_FROM_MAP(pRecord, jedate)
			GET_RECORD_FROM_MAP(pRecord, ope_kd_flg)
			GET_RECORD_FROM_MAP(pRecord, neid)
			GET_RECORD_FROM_MAP(pRecord, sub_neid)
		}
		catch(...)
		{
			if(pRecord)
			{
				delete pRecord;
				pRecord = NULL;
			}
			throw;
		}
		m_tmpRecordList.insert(pRecord);
	}
	else
	{
		m_curRecord[m_curElement] =  m_curValue;
	}
}


void WSax2Handler::characters(const XMLCh* const chars, const unsigned int length)
{
	if( m_open && m_curElement!="message" && m_curElement!="koujitInfo" && m_curElement!="equipInfo" )
	{
		m_curValue +=  m_coder.ToString(chars) ;
		TRACE_DEBUG("m_curValue="<<m_curValue);
	}
}


void WSax2Handler::startDocument()
{
	TRACE_DEBUG("Start to parse work xml");
}


void WSax2Handler::endDocument()
{
	WApp::m_pSocket->IncWorkCount();
	bool hasRecord=false;
	if( WApp::m_pSocket->IsConnected() )
	{
		while( !m_tmpRecordList.isEmpty() )
		{
			WApp::m_pDbThread->Notify(m_tmpRecordList.get());
			hasRecord=true;
		}
		if( hasRecord )
		{
			// notify a record with end flag
			WApp::m_pDbThread->Notify(new WRecord(true));
		}
	}
	else
	{
		TRACE_TRACE("socket connection is brocken, don't handle records");
	}
	TRACE_DEBUG("End to parse work xml");
}



void WSax2Handler::warning(const SAXParseException& e)
{
}


void WSax2Handler::error(const SAXParseException& e)
{
	RWCString message(StrX(  e.getMessage() ).localForm());
	TRACE_ERROR("XML error, line " << e.getLineNumber()
	 << ", char " << e.getColumnNumber()
	 << "\n  Message: " << message << m_pXml->Dump() );
	SEND_NOTIFY_AO( MESSAGE_XML_FORMAT_ERROR<<"(XML error: "<<message<<")" );
}


void WSax2Handler::fatalError(const SAXParseException& e)
{
	RWCString message(StrX(  e.getMessage() ).localForm());
	TRACE_ERROR("XML error, line " << e.getLineNumber()
	 << ", char " << e.getColumnNumber()
	 << "\n  Message: " << message << m_pXml->Dump() );
	SEND_NOTIFY_AO( MESSAGE_XML_FORMAT_ERROR<<"(XML error: "<<message<<")" );
}


