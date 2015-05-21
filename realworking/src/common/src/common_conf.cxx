/*
 *
 * FILENAME     : common_conf.cxx
 * PROGRAM      : powerdown
 * CREATE DATE  : 2009/01/04
 * AUTHOR       : Xiong Weijun
 * MODIFIED BY  : 
 * 
 * DESCRIPTION  : 
 * 
 * Copyright_2007_Hewlett-Packard
 *
 */
 
#include "common_conf.hxx"
#include "common_log.hxx"

void analyzeIni::operator()( const string &strini) 
{ 
	string::size_type first =strini.find('['); 
	string::size_type last = strini.rfind(']'); 
	if( first != string::npos && last != string::npos && first != last+1) 
	{
		strSect = strini.substr(first+1, last-first-1); 
		return ; 
	} 
	if(strSect.empty())
	{
		return ; 
	}

	if((first=strini.find('=')) == string::npos) 
	{
		return ;
	}

	string strtmp1= strini.substr(0,first); 
	string strtmp2=strini.substr(first+1, string::npos); 
	first= strtmp1.find_first_not_of(" \t"); 
	last = strtmp1.find_last_not_of(" \t"); 
	if(first == string::npos || last == string::npos)
	{
		return ; 
	}
	string strkey = strtmp1.substr(first, last-first+1); 
	first = strtmp2.find_first_not_of(" \t"); 
	if(((last = strtmp2.find("\t#", first )) != string::npos) || 
		((last = strtmp2.find(" #", first )) != string::npos) || 
		((last = strtmp2.find("\t//", first )) != string::npos)|| 
		((last = strtmp2.find(" //", first )) != string::npos))
	{ 
		strtmp2 = strtmp2.substr(0, last-first); 
	} 

	last = strtmp2.find_last_not_of(" \t"); 
	if(first == string::npos || last == string::npos)
	{
		return ;
	}
	string value = strtmp2.substr(first, last-first+1); 
	string mapkey = strSect + MIDDLESTRING; 
	mapkey += strkey; 
	(*pMap)[mapkey]=value; 

	return ; 
}

RTWConf::RTWConf()
{
	COUT("construt RTWConf");
}

RTWConf::~RTWConf()
{
	COUT("RTWConf destruted");
}

string RTWConf::read(const char*psect, const char*pkey) 
{ 
	string mapkey = psect; 
	mapkey += MIDDLESTRING; 
	mapkey += pkey; 

	INI_STR_MAP::iterator it = m_InitMap.find(mapkey);  
	if(it == m_InitMap.end())
	{
		return "";
	}
	else
	{
		return it->second;
	}
} 

bool RTWConf::open(const string pstrPath) 
{ 
	ifstream fin(pstrPath.c_str()); 
	if(!fin.is_open())
	{
		return false; 
	}

	vector<string> strvect; 
	while(!fin.eof()) 
	{ 
		string inbuf; 
		getline(fin, inbuf, '\n'); 
		strvect.push_back(inbuf); 
	} 

	if(strvect.empty()) 
	{
		return false;
	}

	for_each(strvect.begin(), strvect.end(), analyzeIni(m_InitMap));

	return !m_InitMap.empty(); 
}

