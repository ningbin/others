/*
 *
 * FILENAME     : CstErrorMessage.hxx
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

#ifndef _CST_ERROR_MESSAGE_HXX_
#define _CST_ERROR_MESSAGE_HXX_


#define PRINT_CST(cst) \
    "�H���Ǘ��ԍ�="<<cst.m_cstNo<<", "\
    "�H����="<<cst.m_scheduleName<<", "\
    "���u��="<<cst.m_mCnt

#define PRINT_CST_CHILD(child) \
    PRINT_CST(child.m_cst)<<", "\
    "�q�ԍ�="<<child.m_cstChildNo<<", "\
    "�r����="<<child.m_bldName<<", "\
    "�ݔ����="<<child.m_mType<<", "\
    "�J�n�\\�����="<<child.m_sDatePre<<", "\
    "�I���\\�����="<<child.m_eDatePre<<", "\
    "�J�n���ѓ���="<<child.m_sDate<<", "\
    "�I�����ѓ���="<<child.m_eDate<<", "\
    "�J�n�o�^="<<child.m_inputRes<<", "\
    "NEID="<<child.m_neId<<", "\
    "NE�t��ID="<<child.m_subNeId

#define PRINT_REALWORK(rec) \
    "CSTNO="<<rec.m_cstNo<<", "\
    "CSTCHILDNO="<<rec.m_cstChildNo<<", "\
    "NODEID="<<rec.m_nodeId<<", "\
    "NETYPE="<<rec.m_neType<<", "\
    "SERIALNO="<<rec.m_serialno<<", "\
    "MMS="<<rec.m_mms<<", "\
    "RNC="<<rec.m_rnc<<", "\
    "BTS="<<rec.m_bts<<", "\
    "REGIONCODE="<<rec.m_regionCode<<", "\
    "SCHEDULENAME="<<rec.m_scheduleName<<", "\
    "SDATEPRE="<<rec.m_sDatePre<<", "\
    "EDATEPRE="<<rec.m_eDatePre<<", "\
    "SDATE="<<rec.m_sDate<<", "\
    "EDATE="<<rec.m_eDate<<", "\
    "MCNT="<<rec.m_mCnt<<", "\
    "BLDNAME="<<rec.m_bldName<<", "\
    "MTYPE="<<rec.m_mType<<", "\
    "INPUTRES="<<rec.m_inputRes<<"�B"

#define MSG_ERR_GET_SECTOR(sqlcode,sqlerrm,serial,mms,rnc,bts,child) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ�:"<<child.m_cstChildNo<< \
    " �Z�N�^�ԍ��擾�����Ɏ��s���܂����B"\
    "SQLCODE=" << sqlcode << ", "\
    "SQLERRM=" << sqlerrm << \
    "SERIALNO=" << serial << ", "\
    "MMS=" << mms<< ", "\
    "RNC=" << rnc << ", "\
    "BTS=" << bts
#define MSG_ERR_NEID_ZERO(child) \
	"�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ�:"<<child.m_cstChildNo<< " NEID,NE�t��ID��all '0'�Œ�`����Ă��܂��B"
#define MSG_ERR_SDATE_NULL(child) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ�:"<<child.m_cstChildNo<< "�̍H�����ԁi�J�n���сj=null���H�����ԁi�I�����сj=�f�[�^�L��B"
#define MSG_ERR_PREDATE_PASS(child) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ�:"<<child.m_cstChildNo<< " �H���\\����Ԃ��Q�S���Ԉȏォ�J�n�o�^=�u�����v�B"
#define MSG_ERR_UNDEFINED_NETYPE(child, netype) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ�:"<<child.m_cstChildNo<< " �m�d��ʃR�[�h="<<netype<<" ����`����Ă��܂���B"
#define MSG_ERR_NEID_LENGTH(child) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ�:"<<child.m_cstChildNo<< " NEID�܂���NE�t��ID�T�C�Y�s���B"<<PRINT_CST_CHILD(child)
#define MSG_ERR_MAKING_REALWORK_RECORD(child) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ�:"<<child.m_cstChildNo<< " �f�[�^�s���B"<<PRINT_CST_CHILD(child)
#define MSG_ERR_CHILDNO_NULL(child) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ�:"<<child.m_cst.m_cstNo<<" �q�ԍ���null�ł��B"<<PRINT_CST_CHILD(child)
#define MSG_ERR_CSTNO_NULL(child) \
    "�f�[�^��j�����܂����B�H���Ǘ��ԍ���null�ł��B"<<PRINT_CST_CHILD(child)


#define PRINT_OTL_MESSAGE(ex) \
    "code: " << ex.code << ", "\
    "msg: " << ex.msg << ", "\
    "stm_text: " << ex.stm_text << ", "\
    "var_info: " << ex.var_info

#define MSG_ERR_EXECUTE_SQL_NOREC(ex, cstno) \
    "SQL execute fail."<< PRINT_OTL_MESSAGE(ex) << "�H���Ǘ��ԍ�:"<<cstno<<"��j�����܂����B"
#define MSG_ERR_EXECUTE_SQL(ex,rec) \
    PRINT_OTL_MESSAGE(ex) << PRINT_REALWORK(rec) << "�H���Ǘ��ԍ�:"<<rec.m_cstNo<<"��j�����܂����B"
#define MSG_ERR_DB_CONNECT(ex) \
    "DB connect error. " <<PRINT_OTL_MESSAGE(ex)
#define MSG_ERR_DB_CONNECT_RETRY \
	"DB retry times has reached. Process needs to exit."

#define MSG_ERR_UNKNOWN \
    "Unknown exception raise."

#define MSG_ERR_NETYPE_CONFIG(file) \
    "read netype config file error."
#define MSG_ERR_OPEN_FILE(file) \
    "open file " << file <<" error. "<<strerror(errno)
#define MSG_ERR_RENAME_FILE(oldfile, newfile) \
    "rename file "<<oldfile<<" to "<<newfile<<" error. "<<strerror(errno)
#define MSG_ERR_REMOVE_FILE(file) \
    "remove file " << file <<" error. "<<strerror(errno)

#define CMD_DB_CONNECT_ERROR(ex) \
    "[��ƃ��A��1] �c�a�Ƃ̐ڑ����؂�܂����B�܂��́A�ڑ��Ɏ��s���܂����B"
#define CMD_DB_CONNECT_SUCCESS \
    "[��ƃ��A��1] �c�a�Ƃ̐ڑ��ɐ������܂����B"
#define CMD_SQL_EXECUTE_ERROR(code, msg, cstno) \
    "[��ƃ��A��1] Oracle�G���[�R�[�h:"<<code<<", Oracle�G���[���b�Z�[�W:"<<msg<< ", �H���Ǘ��ԍ�:"<<cstno<<"��j�����܂����B"
#define CMD_FILE_OPEN_ERROR(file) \
    "[��ƃ��A��1] ���є��f�t�@�C���̃t�@�C���I�[�v���Ɏ��s���܂����B"
#define CMD_FILE_OPEN_SUCCESS(file) \
    "[��ƃ��A��1] ���є��f�t�@�C���̃t�@�C���I�[�v���ɐ������܂����B"
#define CMD_FILE_RENAME_ERROR(oldfile, newfile) \
    "[��ƃ��A��1] ���є��f�t�@�C���̃��l�[���Ɏ��s���܂����B"
#define CMD_FILE_RENAME_SUCCESS(oldfile, newfile) \
    "[��ƃ��A��1] ���є��f�t�@�C���̃��l�[���ɐ������܂����B"
#define CMD_FILE_REMOVE_ERROR(file) \
    "[��ƃ��A��1] �������ݓr���̎��є��f�t�@�C���̍폜�Ɏ��s���܂����B"
#define CMD_FILE_REMOVE_SUCCESS(file) \
    "[��ƃ��A��1] �������ݓr���̎��є��f�t�@�C���̍폜�ɐ������܂����B"


#endif
