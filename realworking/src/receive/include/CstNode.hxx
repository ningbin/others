/*
 *
 * FILENAME     : CstNode.hxx
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

#ifndef _CST_NODE_HXX_
#define _CST_NODE_HXX_

#include <string>
#include <map>
#include "CstRecord.hxx"
#include "common_conf.hxx"
using namespace std;


class CstNode
{
    string m_nodeId;
    string m_neType;
    string m_regionCode;
    string m_mms;
    string m_rnc;
    string m_bts;
    string m_serial;
    static RTWConf m_neTypeConf;
    string GetConfigNeType(string baseNeType);

public:
    static bool LoadNeTypeConfigFile(string filepath);
    CstNode(string neId, string subNeId, CstChildRecord &record);
    string GetNodeId() { return m_nodeId; }
    string GetNeType() { return m_neType; }
    string GetRegionCode() { return m_regionCode; }
    string GetMms() { return m_mms; }
    string GetRnc() { return m_rnc; }
    string GetBts() { return m_bts; }
    string GetSerial() { return m_serial; }
    string GetCstNodeId();
    string GetCstNeType();
    string GetCstSerial(CstChildRecord &record);
    string GetCstBts();
    string GetCstRegionCode();
};
class NodeParseException: public exception
{
public:
    string message;
    NodeParseException(string msg) {message = msg;}
    virtual ~NodeParseException() throw() {}
};

#define THROW_NODE_PARSE_EXCEPTION(s) \
    stringstream ss;\
    ss << s;\
    NodeParseException ex(ss.str());\
    throw ex;

#endif
