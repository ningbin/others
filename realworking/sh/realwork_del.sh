#!/usr/bin/sh
#set -x
#------------------------#
# �t�@�C���o�[�W������` #
#------------------------#
#$Id: realwork_del.sh,v 1.22 2009/03/10 10:40:39 xiongw Exp $
#---------------------------------------------------------------------------------------#
#											#
#	�t�@�C����		realwork_del.sh						#
#											#
#	�쐬�Җ�		�F�q�R							#
#											#
#	�쐬���t		2009/01/07						#
#											#
#	�����T�v		��Ə��ƒ�d����Real_work�e�[�u������폜		#
#				�������s���B						#
#											#
#	���s�`��		realwork_del.sh						#
#											#
#	�p�����^����	�Ȃ�								#
#											#
#	�߂�l										#
#		����I��	0							#
#		�ُ�		1							#
#											#
#	�ύX����									#
#		�ύX���t		�ύX�Җ�		�ύX���e		#
#		2009/01/07	:	�F�q�R	:		�V�K			#
#											#
#---------------------------------------------------------------------------------------#
export SHLIB_PATH=${SHLIB_PATH}:${ORACLE_HOME}/lib:/NWS-ALM-1PRG/app/realworking/bin

CONFFILE="/NWS-ALM-1PRG/app/realworking/conf/rtwork_recv.conf"
LOG_OUT="/NWS-ALM-1PRG/app/realworking/bin/sh_log_out"
SHELLNAME=`basename $0`
RESULT=0

# �ݒ�t�@�C������ǎ� #
ORACLE_USER=
ORACLE_PSW=
ORACLE_SID=
LOG_DIR=
LOG_FILE=
LOG_NAME="receive_tbl_del_`date "+%Y%m%d%H%M%S"`.log"
LOG_MASK=
LOG_SIZE=0
KEEP_DAYS=


LOG ()
{
	$LOG_OUT $LOG_SIZE $LOG_MASK $1 $LOG_FILE "$2" $$ $SHELLNAME
}

#------------------#
# �ݒ�t�@�C���ǎ� #
#------------------#
LoadConfig(){
	if [ ! -f "$CONFFILE" -o ! -r "$CONFFILE" ]; then
		echo "config file isn't exist. CONFFILE=[$CONFFILE]"
		exit 1
	fi

	LOG_DIR=`cat $CONFFILE |grep "^RTWORK_RECV_TBL_DEL_LOG_DIR=" | sed 's/^RTWORK_RECV_TBL_DEL_LOG_DIR=//'`
	if [ ! -d "$LOG_DIR" ]; then
		echo "check config file error. RTWORK_RECV_TBL_DEL_LOG_DIR=[$LOG_DIR]"
		exit 1
	fi
	
	LOG_MASK=`cat $CONFFILE |grep "^RTWORK_RECV_PROCESS_TRACE_MASK=" | sed 's/^RTWORK_RECV_PROCESS_TRACE_MASK=//'`
	if [ -z "$LOG_MASK" ]; then
		echo "check config file error. RTWORK_RECV_PROCESS_TRACE_MASK=[${LOG_MASK}]"
		exit 1
	fi

	LOG_FILE="${LOG_DIR}/${LOG_NAME}"
	LOG "INFO" "$SHELLNAME beginning..."

	ORACLE_USER=`cat $CONFFILE |grep "^RTWORK_ORACLE_USER=" | sed 's/^RTWORK_ORACLE_USER=//'`
	if [ -z "$ORACLE_USER" ]; then
		LOG "ERROR" "check config file error. RTWORK_ORACLE_USER=[$ORACLE_USER]"
		return 1
	fi

	ORACLE_PSW=`cat $CONFFILE |grep "^RTWORK_ORACLE_PSW=" | sed 's/^RTWORK_ORACLE_PSW=//'`
	if [ -z "$ORACLE_PSW" ]; then
		LOG "ERROR" "check config file error. RTWORK_ORACLE_PSW=[$ORACLE_PSW]"
		return 1
	fi

	ORACLE_SID=`cat $CONFFILE |grep "^RTWORK_ORACLE_SID=" | sed 's/^RTWORK_ORACLE_SID=//'`
	if [ -z "$ORACLE_SID" ]; then
		LOG "ERROR" "check config file error. RTWORK_ORACLE_SID=[$ORACLE_SID]"
		return 1
	fi

	KEEP_DAYS=`cat $CONFFILE |grep "^RTWORK_RECV_KEEP_DAYS=" | sed 's/^RTWORK_RECV_KEEP_DAYS=//'`
	if [ "$KEEP_DAYS" -le "0" ]; then
		LOG "ERROR" "check config file error. RTWORK_RECV_KEEP_DAYS=[$KEEP_DAYS]"
		return 1
	fi

	return 0
}

#--------------------------#
# ��Ə���DB����폜���� #
#--------------------------#
CleanWorkInfo()
{
	valdate_str="to_date(to_char((CURRENT_DATE - ${KEEP_DAYS}),'YYYY-MM-DD'),'YYYY-MM-DD')"
	SQL_DELETE_CMD="DELETE FROM REALWORK X WHERE EXISTS 
	(
		SELECT ROWID FROM REALWORK B WHERE (B.EDATE IS NOT NULL) AND (B.EDATE < $valdate_str) AND (B.WORKFLAG <> 0) AND X.ROWID = B.ROWID 
		UNION 
		SELECT ROWID FROM REALWORK A WHERE NOT EXISTS 
		(
			SELECT CSTNO FROM REALWORK S 
			WHERE ((S.EDATE IS NULL) OR (S.EDATE >= $valdate_str)) 
			AND S.WORKFLAG = 0 AND A.CSTNO = S.CSTNO 
		) AND A.WORKFLAG = 0 AND X.ROWID = A.ROWID 
	);"

	LOG "DEBUG" "SQL=${SQL_DELETE_CMD}"

RESULT_STR=`
${ORACLE_HOME}/bin/sqlplus -S /NOLOG <<EOF
connect ${ORACLE_USER}/${ORACLE_PSW}@${ORACLE_SID}
WHENEVER SQLERROR EXIT SQL.SQLCODE
${SQL_DELETE_CMD}
EXIT SQL.SQLCODE;
EOF`

LOG "DEBUG" "${RESULT_STR}"

	ERROR_STR=`echo "${RESULT_STR}" | grep -i "ORA-"`
	if [ X"${ERROR_STR}" != X"" ];then
		LOG "ERROR" "${RESULT_STR}"
		return 1
	fi

	return 0
}

main(){
	#------------------#
	# �ݒ�t�@�C���ǎ� #
	#------------------#
	LoadConfig
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi

	#--------------------------#
	# ��Ə���DB����폜���� #
	#--------------------------#
	CleanWorkInfo
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi

	return 0
}

main
RESULT=$?
if [ $RESULT -ne 0 ]; then
	LOG "ERROR" "$SHELLNAME end abnormally."
else
	LOG "INFO" "$SHELLNAME end normally."
fi
exit $RESULT


