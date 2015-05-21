#!/usr/bin/sh
#set -x
#------------------------#
# ファイルバージョン定義 #
#------------------------#
#$Id: reflect_tar_del.sh,v 1.14 2009/02/16 06:48:19 xiongw Exp $
#---------------------------------------------------------------------------------------#
#											#
#	ファイル名		reflect_tar_del.sh					#
#											#
#	作成者名		熊衛軍							#
#											#
#	作成日付		2009/01/07						#
#											#
#	処理概要		ディレクトに格納されたファイルを圧縮し、保存する。	#
#				かつ、圧縮したファイルを実績反映ファイルを		#
#				ディレクトリから削除する。				#
#											#
#	実行形式		reflect_tar_del.sh <設定ファイル>			#
#											#
#	パラメタ説明	なし								#
#											#
#	戻り値										#
#		正常終了	0							#
#		異常		1							#
#											#
#	変更履歴									#
#		変更日付		変更者名		変更内容		#
#		2009/01/07	:	熊衛軍	:		新規			#
#											#
#---------------------------------------------------------------------------------------#
export SHLIB_PATH=${SHLIB_PATH}:${ORACLE_HOME}/lib:/NWS-ALM-1PRG/app/realworking/bin

CONFFILE="/NWS-ALM-1PRG/app/realworking/conf/rtwork_refl.conf"
LOG_OUT="/NWS-ALM-1PRG/app/realworking/bin/sh_log_out"
SHELLNAME=`basename $0`
RESULT=0

# 設定ファイルから読取 #
BACKUP_CSV_DIR=
BACKUP_DAT_DIR=
BACKUP_ARCHIVE_DIR=
LOG_FILE=
LOG_MASK=
LOG_SIZE=0
KEEP_DAYS=

LOG ()
{
	$LOG_OUT $LOG_SIZE $LOG_MASK $1 $LOG_FILE "$2" $$ $SHELLNAME
}

#------------------#
# 設定ファイル読取 #
#------------------#
LoadConfig(){
	if [ ! -f "$CONFFILE" -o ! -r "$CONFFILE" ]; then
		echo "config file isn't exist. CONFFILE=[$CONFFILE]"
		exit 1
	fi

	LOG_FILE=`cat $CONFFILE |grep "^RTWORK_REFL_TAR_DEL_LOG_NAME=" | sed 's/^RTWORK_REFL_TAR_DEL_LOG_NAME=//'`
	if [ ! -d "`dirname $LOG_FILE`" ]; then
		echo "check config file error. RTWORK_REFL_TAR_DEL_LOG_NAME=[$LOG_FILE]"
		exit 1
	fi
	
	LOG_MASK=`cat $CONFFILE |grep "^RTWORK_REFL_PROCESS_TRACE_MASK=" | sed 's/^RTWORK_REFL_PROCESS_TRACE_MASK=//'`
	if [ -z "$LOG_MASK" ]; then
		echo "check config file error. RTWORK_REFL_PROCESS_TRACE_MASK=[${LOG_MASK}]"
		exit 1
	fi

	if [ -f "$LOG_FILE" ]; then
		>$LOG_FILE 2>/dev/null
	fi
	
	LOG "INFO" "$SHELLNAME beginning..."

	BACKUP_CSV_DIR=`cat $CONFFILE |grep "^RTWORK_REFL_BACKUP_CSV_DIR=" | sed 's/^RTWORK_REFL_BACKUP_CSV_DIR=//'`
	if [ ! -d "$BACKUP_CSV_DIR" ]; then
		LOG "ERROR" "check config file error. RTWORK_REFL_BACKUP_CSV_DIR=[$BACKUP_CSV_DIR]"
		return 1
	fi

	BACKUP_DAT_DIR=`cat $CONFFILE |grep "^RTWORK_REFL_BACKUP_DAT_DIR=" | sed 's/^RTWORK_REFL_BACKUP_DAT_DIR=//'`
	if [ ! -d "$BACKUP_DAT_DIR" ]; then
		LOG "ERROR" "check config file error. RTWORK_REFL_BACKUP_DAT_DIR=[$BACKUP_DAT_DIR]"
		return 1
	fi

	BACKUP_ARCHIVE_DIR=`cat $CONFFILE |grep "^RTWORK_REFL_BACKUP_ARCHIVE_DIR=" | sed 's/^RTWORK_REFL_BACKUP_ARCHIVE_DIR=//'`
	if [ ! -d "$BACKUP_ARCHIVE_DIR" ]; then
		LOG "ERROR" "check config file error. RTWORK_REFL_BACKUP_ARCHIVE_DIR=[$BACKUP_ARCHIVE_DIR]"
		return 1
	fi

	KEEP_DAYS=`cat $CONFFILE |grep "^RTWORK_REFL_KEEP_DAYS=" | sed 's/^RTWORK_REFL_KEEP_DAYS=//'`
	if [ -z "$KEEP_DAYS" ]; then
		LOG "ERROR" "check config file error. RTWORK_REFL_KEEP_DAYS=[$KEEP_DAYS]"
		return 1
	fi

	return 0
}

#----------------------------------------#
# 結合前、結合済み圧縮ファイルの削除処理 #
#----------------------------------------#
CleanUp(){
	archfile="??????????????_???.tar.gz"
	filelist=`find $BACKUP_ARCHIVE_DIR -type f -name "$archfile" -mtime "+$KEEP_DAYS" 2>/dev/null`
	for f in $filelist
	do
		rm -f $f >/dev/null
		RESULT=$?
		if [ $RESULT -ne 0 ]; then
			LOG "ERROR" "Failed to delete file. FILE=[$f]"
			return 1
		fi
	done

	return 0
}

#--------------------#
# ファイルの圧縮処理 #
#--------------------#
TarGzip(){
	tarfile=$1
	filelist=$2

	tar -cvf $tarfile $filelist >/dev/null 2>&1
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		LOG "ERROR" "Failed to execute command. CMD_LINE=[tar -cvf $tarfile $filelist], errno=$RESULT"
		return $RESULT
	fi
	
	gzip $tarfile >/dev/null
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		LOG "ERROR" "Failed to execute command. CMD_LINE=[gzip $tarfile], errno=$RESULT"
		return $RESULT
	fi

	rm -f $filelist >/dev/null
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		LOG "ERROR" "Failed to delete files. FILE=[$filelist]"
		return $RESULT
	fi
	
	return 0
}

main(){
	#------------------#
	# 設定ファイル読取 #
	#------------------#
	LoadConfig
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi

	#----------------------------------------#
	# 結合前、結合済み圧縮ファイルの削除処理 #
	#----------------------------------------#
	CleanUp
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		return $RESULT
	fi

	#--------------------------#
	# 結合前ファイルの圧縮処理 #
	#--------------------------#
	filecnt=`ls ${BACKUP_CSV_DIR}/*.csv 2>/dev/null | wc -l`
	if [ $filecnt -ne 0 ];then
		tarfile="${BACKUP_ARCHIVE_DIR}/`date "+%Y%m%d%H%M%S"`_csv.tar"
		TarGzip $tarfile "${BACKUP_CSV_DIR}/*.csv"
		RESULT=$?
		if [ $RESULT -ne 0 ]; then
			return $RESULT
		fi
	fi

	#----------------------------#
	# 結合済みファイルの圧縮処理 #
	#----------------------------#
	filecnt=`ls ${BACKUP_DAT_DIR}/*.dat 2>/dev/null | wc -l`
	if [ $filecnt -ne 0 ];then
		tarfile="${BACKUP_ARCHIVE_DIR}/`date "+%Y%m%d%H%M%S"`_dat.tar"
		TarGzip $tarfile "${BACKUP_DAT_DIR}/*.dat"
		RESULT=$?
		if [ $RESULT -ne 0 ]; then
			return $RESULT
		fi
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
