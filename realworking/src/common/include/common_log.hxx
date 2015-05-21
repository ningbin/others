/*
 *
 * FILENAME     : common_log.hxx
 * PROGRAM      : common
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Ning Bin
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */

#ifndef _REAL_TIME_WORK_LOG_HXX_
#define _REAL_TIME_WORK_LOG_HXX_

#include <pthread.h>
#include <iostream>
#include <fstream>
#include <sstream>
#include <rw/cstring.h>
#include <rw/tpmap.h>

#define LOG_FILE_END "[END]"
#define RESULT_MAXLINE 1024

class RTWLog
{
	friend class RTWLogFactory;
	public:
		~RTWLog();
		void WriteLog( const string& message );
		
	private:
		RTWLog( RWCString fileName, long size );
		RTWLog();
		void OpenFile();
		void CheckSize();
		bool StatFile(RWCString fileName, time_t& mtime, long& size);
		bool CheckEnd(RWCString fileName);
		
	private:
		RWCString m_baseName;
		RWCString m_logName;
		long m_maxSize;
		ofstream m_ofs;
		pthread_mutex_t m_mutex;
};

class RTWTrace
{
	public:
		RTWTrace(RWCString name, int shift);
		~RTWTrace();
		static RWCString TimeNow();			
		RTWLog* GetLog(){return m_pLog;};
		void SetLog(RTWLog* p){m_pLog = p;};
		RWCString GetName(){return m_name;};
		bool Enable(){ return m_enable;};
		bool CheckWithMask(int mask);
		
	private:
		RTWTrace();
		
	private:
		RTWLog* m_pLog;
		RWCString m_name;
		int m_mask;
		bool m_enable;
};

typedef RWTPtrMap<RWCString, RTWLog, std::less<RWCString> > LogMap;

class RTWLogFactory
{
	public:
		RTWLogFactory();
		~RTWLogFactory();
		bool CreateLog( RWCString name );
		RTWLog* GetLog( RWCString name );
		static void SetMaxLogSize( long size ){ m_max_log_size = size; };
		static long GetMaxLogSize(){ return m_max_log_size; };
		static void SetMask( int mask ){ m_mask = mask; };
		static int GetMask(){ return m_mask; };

	private:
		LogMap m_map;
		static long m_max_log_size;
		static int m_mask;
};

class RTWCommand
{
	public:
		static RWCString osi_entity;
		static RWCString oc_name;
		static RWCString hc_count_ao_id;
		static RWCString work_count_ao_id;
		static RWCString error_count_ao_id;
};

extern RTWLogFactory traceFactory;

extern void operator <<(ostream&, RTWTrace&);


#ifdef DEBUG_MODE
	#define COUT( message ) \
		cout<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
			<<"<DEBUG>"<<__FILE__<<":"<<__FUNCTION__<<"() line " <<__LINE__ \
			<<": "<<message<<endl
	#define CERR( message ) \
		cerr<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
			<<"<ERROR>"<<__FILE__<<":"<<__FUNCTION__<<"() line " <<__LINE__ \
			<<": "<<message<<endl
#else
	#define COUT( message ) 
	#define CERR( message )
#endif


extern RTWTrace TRACE_OBJECT_COMMAND;
extern RTWTrace TRACE_OBJECT_ERROR;
extern RTWTrace TRACE_OBJECT_WARNING;
extern RTWTrace TRACE_OBJECT_INFO;
extern RTWTrace TRACE_OBJECT_DEBUG;
extern RTWTrace TRACE_OBJECT_TRACE;
extern RTWTrace TRACE_OBJECT_DATA;


#define INIT_TRACE( level, filename ) \
	if(TRACE_OBJECT_##level.CheckWithMask( RTWLogFactory::GetMask() )) \
	{ \
		TRACE_OBJECT_##level.SetLog( traceFactory.GetLog(filename) ); \
		COUT("trace "<<#level<<" is set with "<<filename); \
	} \
	else \
	{ \
		COUT("trace "<<#level<<" is disabled"); \
	}

#define INIT_LOG( size, mask ) \
	COUT("set log max size = "<<size<<" mask = "<<mask); \
	RTWLogFactory::SetMaxLogSize( size ); \
	RTWLogFactory::SetMask( mask )

#define TRACE_COMMAND( message ) \
	if(TRACE_OBJECT_COMMAND.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<message<<TRACE_OBJECT_COMMAND; \
	}


#define TRACE_ERROR( message ) \
	if(TRACE_OBJECT_ERROR.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
						<<"<ERROR>"<<__FILE__<<":"<<__FUNCTION__ \
						<<"() line " <<__LINE__<<": "<<message<<TRACE_OBJECT_ERROR; \
	}

#define TRACE_WARNING( message ) \
	if(TRACE_OBJECT_WARNING.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
						<<"<WARNING>"<<__FILE__<<":"<<__FUNCTION__ \
						<<"() line " <<__LINE__<<": "<<message<<TRACE_OBJECT_WARNING; \
	}

#define TRACE_DEBUG( message ) \
	if(TRACE_OBJECT_DEBUG.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
						<<"<DEBUG>"<<__FILE__<<":"<<__FUNCTION__ \
						<<"() line " <<__LINE__<<": "<<message<<TRACE_OBJECT_DEBUG; \
	}

#define TRACE_TRACE( message ) \
	if(TRACE_OBJECT_TRACE.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
						<<"<TRACE>"<<__FILE__<<":"<<__FUNCTION__ \
						<<"() line " <<__LINE__<<": "<<message<<TRACE_OBJECT_TRACE; \
	}


#define TRACE_INFO( message ) \
	if(TRACE_OBJECT_INFO.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
							<<"<INFO>" <<message <<TRACE_OBJECT_INFO; \
	}

	
#define TRACE_DATA( message ) \
	if(TRACE_OBJECT_DATA.Enable()) \
	{ \
		ostringstream stream; \
		stream<<RTWTrace::TimeNow()<<"["<<getpid()<<"]["<<pthread_self()<<"]" \
							<<"<DATA>" <<message<<TRACE_OBJECT_DATA; \
	}


#define INIT_NOTIFY_OSI_ENTITY( osiEntity ) \
	RTWCommand::osi_entity = osiEntity

#define INIT_NOTIFY_OC_NAME( ocName ) \
	RTWCommand::oc_name = ocName
		
#define INIT_HC_COUNT_AO_ID( aoId ) \
	RTWCommand::hc_count_ao_id = aoId
		
#define INIT_WORK_COUNT_AO_ID( aoId ) \
	RTWCommand::work_count_ao_id = aoId
		
#define INIT_ERROR_COUNT_AO_ID( aoId ) \
	RTWCommand::error_count_ao_id = aoId


#define SEND_NOTIFY_AO( addText ) \
	TRACE_COMMAND("<COMMAND>submit_event osi_system "<<RTWCommand::osi_entity<<" event type=equipmentalarm, \
probable cause=unknown, perceived-securityalarm severity=critical,add text=\""<< addText <<"\"")

#define SEND_NOTIFY_WARNING_AO( addText ) \
	TRACE_COMMAND("<COMMAND>submit_event osi_system "<<RTWCommand::osi_entity<<" event type=equipmentalarm, \
probable cause=unknown, perceived-securityalarm severity=warning,add text=\""<< addText <<"\"")

#define SET_HC_AO( addText ) \
	TRACE_COMMAND("<HC_COUNT>set oper "<<RTWCommand::oc_name<<" alarm "<<RTWCommand::hc_count_ao_id<<" additional text=\""<< addText <<"\"")

#define SET_WORK_AO( addText ) \
	TRACE_COMMAND("<WORK_COUNT>set oper "<<RTWCommand::oc_name<<" alarm "<<RTWCommand::work_count_ao_id<<" additional text=\""<< addText <<"\"")

#define SET_ERROR_AO( addText ) \
	TRACE_COMMAND("<ERROR_COUNT>set oper "<<RTWCommand::oc_name<<" alarm "<<RTWCommand::error_count_ao_id<<" additional text=\""<< addText <<"\"")


#endif
