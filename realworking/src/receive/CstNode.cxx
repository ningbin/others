/*
 *
 * FILENAME     : CstNode.cxx
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

#include <sstream>
#include <iomanip>
#include <iostream>
#include "CstErrorMessage.hxx"
#include "DBConnection.hxx"
#include "CstNode.hxx"
#include "CstUtil.hxx"
#include "common_log.hxx"

RTWConf CstNode::m_neTypeConf;

bool CstNode::LoadNeTypeConfigFile(string filepath)
{
    return m_neTypeConf.open(filepath);
}
CstNode::CstNode(string neId, string subNeId, CstChildRecord &record)
{
    TRACE_TRACE("enter CstNode::CstNode. neId:"<<neId<<", subNeId:"<<subNeId);

    if (neId.length() != 16 || subNeId.length() != 16)
    {
	THROW_NODE_PARSE_EXCEPTION(MSG_ERR_NEID_LENGTH(record));
    }
    if (neId == "0000000000000000" && subNeId == "0000000000000000")
    {
        THROW_NODE_PARSE_EXCEPTION(MSG_ERR_NEID_ZERO(record));
    }
    m_regionCode = "00"+neId.substr(0, 2);
    TRACE_DEBUG("m_regionCode="<<m_regionCode);

    string neType = neId.substr(10, 2);
    m_neType = GetConfigNeType(neType);
    TRACE_DEBUG("m_neType="<<m_neType);
    if (m_neType == "0000")
    {
        THROW_NODE_PARSE_EXCEPTION(MSG_ERR_UNDEFINED_NETYPE(record, neType));
    }

    string serialNo = "0000" + neId.substr(12, 4);
	m_serial = HexStringToString(serialNo);
    TRACE_DEBUG("m_serial="<<m_serial);

    string subNeIdTmp;
    if (m_neType == "0002" || m_neType == "0003" || m_neType == "000b" || m_neType == "000c")
    {
        subNeIdTmp = subNeId.substr(0, 4);
		m_mms = HexStringToString(subNeIdTmp);
        m_rnc = "";
        m_bts = "";
    }
    else if (m_neType == "0004" || m_neType == "000d" || m_neType == "000e")
    {
        subNeIdTmp = subNeId.substr(0, 6);
		m_mms = HexStringToString(subNeIdTmp.substr(0, 4));
        m_rnc = HexStringToString(subNeIdTmp.substr(4, 2));
        m_bts = "";
    }
    else if (m_neType == "0005" || m_neType == "0006" || m_neType == "000a" || m_neType == "0010")
    {
		subNeIdTmp = subNeId.substr(0, 8);
        m_mms = HexStringToString(subNeIdTmp.substr(0, 4));
        m_rnc = HexStringToString(subNeIdTmp.substr(4, 2));
        m_bts = HexStringToString(subNeIdTmp.substr(6, 2));
    }
    else // (m_neType == "0001")
    {
        subNeIdTmp = "";
        m_mms = "";
        m_rnc = "";
        m_bts = "";
    }
    TRACE_DEBUG("m_mms="<<m_mms);
    TRACE_DEBUG("m_rnc="<<m_rnc);
    TRACE_DEBUG("m_bts="<<m_bts);

    stringstream ss;
    ss<<"01000201"<<m_regionCode<<"0000"<<m_neType<<serialNo<<subNeIdTmp;
	ss >> m_nodeId;
    TRACE_DEBUG("m_nodeId="<<m_nodeId);

    TRACE_TRACE("leave CstNode::CstNode");
}
string CstNode::GetConfigNeType(string baseNeType)
{
    string ret = m_neTypeConf.read("NETYPE", baseNeType.c_str());
    if (ret.empty()) return "0000";
    else return ret;
}

string CstNode::GetCstNodeId()
{
    string nodeId;
    if (m_neType == "0006" || m_neType == "0010")
    {
        nodeId = m_nodeId.substr(0, 16);
        nodeId += "0004";
        nodeId += "000000" + m_nodeId.substr(34, 2);
        nodeId += m_nodeId.substr(28, 6);
    }
    else nodeId = m_nodeId;

    return nodeId;
}
string CstNode::GetCstNeType()
{
    if (m_neType == "0004" || m_neType == "0006" || m_neType == "000d" || m_neType == "0010")
    {
        return "9904";
    }
    else if (m_neType == "000a")
    {
        return "9905";
    }
    else
    {
        return m_neType;
    }
}
string CstNode::GetCstSerial(CstChildRecord &record)
{
    if (m_neType == "000a")
    {
        int errCode;
        string errMsg;
        string sector;
        DBConnection::GetInstance()->GetSectorNo(m_serial, m_mms, m_rnc, m_bts, sector, errCode, errMsg);
        if (errCode != 0)
        {
            THROW_NODE_PARSE_EXCEPTION(MSG_ERR_GET_SECTOR(errCode, errMsg, m_serial, m_mms, m_rnc, m_bts, record));
        }
        else return sector;
    }
    else if (m_neType == "0006" || m_neType == "0010")
    {
        return m_bts;
    }
    else
    {
        return m_serial;
    }
}
string CstNode::GetCstBts()
{
    if (m_neType == "0004" || m_neType == "000d")
    {
        return m_serial;
    }
    else
    {
        return m_bts;
    }
}
string CstNode::GetCstRegionCode()
{
	string region = HexStringToString(m_regionCode);
	while (region.length() < 4)
	{
		region = string("0") + region;
	}
	return region;
}



