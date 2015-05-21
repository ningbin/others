/*
*
* FILENAME     : common_log.cxx
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

#include <assert.h>
#include <sys/types.h>
#include <sys/stat.h>
#include "common_log.hxx"

RTWLog::RTWLog( RWCString fileName, long size )
: m_baseName(fileName), m_maxSize( size )
{
	COUT("construct RTWLog "<<m_baseName);	
	pthread_mutex_init( &m_mutex,NULL);
	OpenFile();
}


RTWLog::~RTWLog()
{
	pthread_mutex_destroy( &m_mutex );	
	m_ofs.flush();
	m_ofs.close();	
	COUT("RTWLog "<<m_baseName<<" destructed ");	
}


void RTWLog::WriteLog( const string& message )
{
	pthread_mutex_lock(&m_mutex);
	CheckSize();
	m_ofs<<message<<endl;	
	pthread_mutex_unlock(&m_mutex);
}


void RTWLog::OpenFile()
{
	m_baseName.strip(RWCString::both);
	if(m_baseName=="")
	{
		cerr<<"file name is null: "<<m_baseName<<endl;
		exit(-1);
	}
	
	if( !(m_maxSize>0) )
	{
		m_logName = m_baseName;
		m_ofs.open( m_logName, ios_base::app);
		if ( (m_ofs.rdstate() & ifstream::failbit ) != 0 )
    	{
    		cerr<<"can not open file: "<<m_logName<<endl;
    		exit(-1);
    	}
		return;
	}
	
	RWCString file1 = m_baseName+".1";
	RWCString file2 = m_baseName+".2";
	
	time_t time1, time2;
	long size1, size2, file_size;
	bool exist1=false, exist2=false;
	bool end1=false, end2=false;
	bool open_end_file=false;
	
	if( (exist1 = StatFile(file1, time1, size1)) )
	{
		end1 = CheckEnd(file1);
	}	
	if( (exist2 = StatFile(file2, time2, size2)) )
	{
		end2 = CheckEnd(file2);
	}

	if( exist1 && exist2 ) //2 files exist
	{
		COUT("file 1 and file 2 are both exist");
		if( end1 && !end2 ) //file1 has end flag
		{
			COUT("file 1 has end flag, file 2 no");
			m_logName = file2;
			file_size = size2;		
		}
		else if( !end1 && end2 ) //file2 has end flag
		{
			COUT("file 2 has end flag, file 1 no");
			m_logName = file1;
			file_size = size1;
		}
		else if( end1 && end2 ) //both files have end flag
		{	
			open_end_file=true;
			if( time1 < time2 ) //file2 is newer
			{
				COUT("file 2 is newer than file 1");
				m_logName = file1;
				file_size = size1;
			}
			else //file1 is new
			{
				COUT("file 1 is newer than file 2");
				m_logName = file2;
				file_size = size2;
			}
		}
		else // both files have no end flag
		{
			if( time1 < time2 ) //file2 is newer
			{
				COUT("file 2 is newer than file 1");
				m_logName = file2;
				file_size = size2;
			}
			else //file1 is new
			{
				COUT("file 1 is newer than file 2");
				m_logName = file1;
				file_size = size1;
			}
		}
	}
	else if( exist1 && !exist2 ) //file1 exist and file2 not exist
	{
		COUT("file 1 exist, no file 2");
		if( !end1 )
		{
			COUT("file 1 has no end flag");
			m_logName = file1;
			file_size = size1;
		}
		else
		{
			COUT("file 1 has  end flag");
			m_logName = file2;
			file_size = size2;
		}
	}
	else if( !exist1 && exist2 ) //file1 not exist and file2 exist
	{
		COUT("file 2 exist, no file 1");
		if( !end2 )
		{
			COUT("file 2 has no end flag");
			m_logName = file2;
			file_size = size2;
		}
		else
		{
			COUT("file 2 has  end flag");
			m_logName = file1;
			file_size = size1;
		}
	}
	else  // both not exist
	{
		COUT("no log file exist");
		m_logName = file1;
		file_size = 0;
	}

	if(open_end_file)
	{
		m_ofs.open( m_logName, ios_base::trunc);
		if ( (m_ofs.rdstate() & ifstream::failbit ) != 0 )
		{
			cerr << "can not open file: "<<m_logName<<endl;
			exit(-1);
		}
		m_ofs.seekp( 0 );
		COUT("open file "<<m_logName<<", current size=0");
	}
	else
	{
		m_ofs.open( m_logName, ios_base::app);
		if ( (m_ofs.rdstate() & ifstream::failbit ) != 0 )
		{
			cerr << "can not open file: "<<m_logName<<endl;
			exit(-1);
		}
		m_ofs.seekp( file_size );
		COUT("open file "<<m_logName<<", current size="<<file_size);
	}
}

bool RTWLog::StatFile(RWCString fileName, time_t& mtime, long& size)
{
	struct stat buf;
	if( stat(fileName, &buf)<0 )
	{
		return false;
	}
	mtime = buf.st_mtime;
	size = buf.st_size;
	return true;
}


bool RTWLog::CheckEnd(RWCString fileName)
{
	COUT("tail last line of "<<fileName);
	FILE *fp = popen("tail -n 1 "+fileName, "r" );
	if(!fp)
	{
		CERR("can not tail the file "<<fileName);
		return false;	
	}
	char buff[RESULT_MAXLINE]={0};
	RWCString result;
	while( fgets( buff, RESULT_MAXLINE, fp ) )
	{
		result+=buff;
		memset(buff,0,RESULT_MAXLINE);
	}
	pclose(fp);
	result(result.length()-1,1)="";
	COUT("tail result: "<<result);
	if(result == LOG_FILE_END)
	{
		return true;
	}
	else
	{
		return false;
	}
}


void RTWLog::CheckSize()
{
	if( m_maxSize > 0 && m_maxSize < m_ofs.tellp() )
	{
		COUT("max_size="<<m_maxSize<<",current size="<<m_ofs.tellp());
		if( m_logName  == m_baseName+".1" )
		{
			m_logName = m_baseName+".2";
		}
		else
		{
			m_logName = m_baseName+".1";
		}
		m_ofs<<LOG_FILE_END<<endl;
		m_ofs.flush();
		m_ofs.close();
		COUT("log turn to : "<<m_logName);
		m_ofs.open( m_logName, ios_base::trunc);
	}
}


RTWTrace::RTWTrace( RWCString name, int shift )
: m_name(name),m_mask( 1<<(shift-1) ),m_pLog(NULL)
{
	assert(shift>=0);
	COUT("RTWTrace "<<m_name<<" with mask = "<<m_mask<<" constructed");
	if( m_mask == 0)
	{
		m_enable = true;
	}
	else
	{
		m_enable = false;
	}
}


RTWTrace::~RTWTrace()
{
	COUT("RTWTrace "<<m_name<<" destructed");
}


bool RTWTrace::CheckWithMask(int mask)
{
	if( (mask&m_mask) == m_mask )
	{
		m_enable = true;
	}
	else
	{
		m_enable = false;
	}
	return m_enable;
}

RWCString RTWTrace::TimeNow()
{
	char usec[10]={0};
	struct timeval tv;
	gettimeofday(&tv, NULL);
    sprintf(usec, ".%06llu", tv.tv_usec);
  
    char sec[80]={0};
	strftime(sec,100,"%Y-%m-%d %H:%M:%S",localtime(&tv.tv_sec) );

	RWCString time_now = sec;
	time_now += usec;
	return time_now;
}


void operator <<(ostream& os, RTWTrace& trace)
{
	RTWLog* pLog = trace.GetLog();
	if( pLog )
	{
		pLog->WriteLog( ((ostringstream&)os).str() );
	}
	else
	{
		COUT("no "<<trace.GetName()<<" log file" );
	}
}


RTWLogFactory::RTWLogFactory()
{
	COUT("consctruct RTWLogFactory");
}


RTWLogFactory::~RTWLogFactory()
{
	m_map.clearAndDestroy();
	COUT("RTWLogFactory desctructed");
}

long RTWLogFactory::m_max_log_size=0;
int RTWLogFactory::m_mask=0;

bool RTWLogFactory::CreateLog( RWCString name )
{
	return m_map.insert( new RWCString(name), new RTWLog(name, m_max_log_size) );
}	


RTWLog* RTWLogFactory::GetLog( RWCString name )
{
	if(!m_map.contains(&name) )
	{
		CreateLog( name );
	}
	return m_map[&name];
}

RTWLogFactory traceFactory;

// trace objects
// trace mask  = 1<<(shift-1)
RTWTrace TRACE_OBJECT_COMMAND("COMMAND",0);		//0x00000000 => command mask = 0
RTWTrace TRACE_OBJECT_ERROR("ERROR",0);			//0x00000000 => error mask = 0
RTWTrace TRACE_OBJECT_WARNING("WARNING",1);		//0x00000001 => warning mask = 1
RTWTrace TRACE_OBJECT_INFO("INFO",2);			//0x00000010 => info mask = 2
RTWTrace TRACE_OBJECT_DEBUG("DEBUG",3);			//0x00000100 => debug mask = 4
RTWTrace TRACE_OBJECT_TRACE("TRACE",4);			//0x00001000 => trace mask = 8
RTWTrace TRACE_OBJECT_DATA("DATA",5);			//0x00010000 => data mask = 16


RWCString RTWCommand::osi_entity;
RWCString RTWCommand::oc_name;
RWCString RTWCommand::hc_count_ao_id;
RWCString RTWCommand::work_count_ao_id;
RWCString RTWCommand::error_count_ao_id;
