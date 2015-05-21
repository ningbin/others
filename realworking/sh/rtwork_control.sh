#!/usr/bin/sh
#set -x
#------------------------#
# �t�@�C���o�[�W������` #
#------------------------#
#$Id: rtwork_control.sh,v 1.17 2009/03/09 03:57:38 xiongw Exp $
#---------------------------------------------------------------------------------------#
#											#
#	�t�@�C����		rtwork_control.sh					#
#											#
#	�쐬�Җ�		�F�q�R							#
#											#
#	�쐬���t		2009/01/06						#
#											#
#	�����T�v		�N��/��~�c�[���́A��M�v���Z�X�A���є��f�v���Z�X�A	#
#				�Ď��v���Z�X�̋N���ƒ�~���s���܂��B			#
#											#
#	���s�`��		rtwork_control.sh <OPTION> <PROCESS>			#
#											#
#	�p�����^����		OPTION	start	�N������				#
#					stop	��~����				#
#				PROCESS	recv	��M�v���Z�X				#
#					refl	���є��f�v���Z�X			#
#					monitor	�Ď��v���Z�X				#
#					all	�S�̂̃v���Z�X				#
#											#
#											#
#	�߂�l										#
#		����I��	0							#
#		�ُ�		1							#
#											#
#	�ύX����									#
#		�ύX���t		�ύX�Җ�		�ύX���e		#
#		2009/01/06	:	�F�q�R	:		�V�K			#
#											#
#---------------------------------------------------------------------------------------#
export SHLIB_PATH=${SHLIB_PATH}:${ORACLE_HOME}/lib:/NWS-ALM-1PRG/app/realworking/bin
export NLS_LANG=Japanese_Japan.JA16SJIS

#----------------#
# �ݒ�t�@�C���� #
#----------------#
RECV_CONFFILE="/NWS-ALM-1PRG/app/realworking/conf/rtwork_recv.conf"
REFL_CONFFILE="/NWS-ALM-1PRG/app/realworking/conf/rtwork_refl.conf"
MONI_CONFFILE="/NWS-ALM-1PRG/app/realworking/conf/rtwork_monitor.conf"

#----------------#
# �ݒ�v���Z�X�� #
#----------------#
RECV_PROC_FILE="/NWS-ALM-1PRG/app/realworking/bin/realwork_receive"
REFL_PROC_FILE="/NWS-ALM-1PRG/app/realworking/bin/realwork_reflect"
MONI_PROC_FILE="/NWS-ALM-1PRG/app/realworking/bin/realwork_monitor"

#----------#
# ���̑��� #
#----------#
SHELLNAME=`basename $0`
CONTROL_CONF=
PROC_FILE=
RESULT=0
OPTION=
PROCESS=

#-------------#
# �N�����ߏ���#
#-------------#
DoStart(){
	#------------------#
	# �N����ԃ`�F�b�N #
	#------------------#
	pid=`ps -ef | grep "$PROC_FILE" | grep "$CONTROL_CONF" | grep -v grep | cut -c9-15 | wc -l`
	if [ $pid -ne 0 ];then
		echo "�v���Z�X(${PROC_FILE})�͎��s���Ȃ̂ŁA�ċN���ł��܂���B"
		return 1
	fi

	nohup $PROC_FILE ${CONTROL_CONF}& >/dev/null
	echo "$PROC_FILE is beginning to startup..."
	return 0
}

#-------------#
# ��~���ߏ���#
#-------------#
DoStop(){
	pid=`ps -ef|grep "$PROC_FILE" | grep "$CONTROL_CONF" | grep -v grep | cut -c9-15`
	if [ -z "$pid" ];then
		echo "�v���Z�X(${PROC_FILE})�͒�~���܂����̂ŁA�Ē�~�ł��܂���B"
		return 1
	fi

	kill -SIGTERM $pid 2>/dev/null
	RESULT=$?
	if [ $RESULT -ne 0 ]; then
		echo "�v���Z�X(${PROC_FILE})�͒�~���s���܂����B"
		return $RESULT
	fi
	
	# send SIGUSR1/SIGUSR2 to monitor process
	if [ X"$PROCESS" = X"MONITOR" ];then
		return 0
	else
		mon_pid=`ps -ef | grep "$MONI_PROC_FILE" | grep "$MONI_CONFFILE" | grep -v grep | cut -c9-15`
		if [ -z "$mon_pid" ];then
			return 0
		fi

		if [ X"$PROCESS" = X"RECV" ];then
			kill -SIGUSR1 $mon_pid 2>/dev/null
		else
			kill -SIGUSR2 $mon_pid 2>/dev/null
		fi
		return $?
	fi
}

#------------------#
# �p�����^�`�F�b�N #
#------------------#
if [ $# -ne 2 ]; then
	echo "Usage : $SHELLNAME <OPTION> <PROCESS>"
	echo "OPTION	start|stop"
	echo "PROCESS	recv|refl|monitor|all"
	exit 1
else
	OPTION=`echo $1 | tr "[:lower:]" "[:upper:]"`
	if [ "$OPTION" != "START" -a "$OPTION" != "STOP" ];then
		echo "Usage : $SHELLNAME <OPTION> <PROCESS>"
		echo "OPTION	start|stop"
		echo "PROCESS	recv|refl|monitor|all"
		exit 1
	fi

	PROCESS=`echo $2 | tr "[:lower:]" "[:upper:]"`
	if [ "$PROCESS" != "RECV" -a "$PROCESS" != "REFL" -a "$PROCESS" != "MONITOR" -a "$PROCESS" != "ALL" ];then
		echo "Usage : $SHELLNAME <OPTION> <PROCESS>"
		echo "OPTION	start|stop"
		echo "PROCESS	recv|refl|monitor|all"
		exit 1
	fi
fi

#------------------------#
# �S�̃v���Z�X�̋N����~ #
#------------------------#
if [ X"$PROCESS" = X"ALL" ];then
	#----------------------#
	# ���߃t�@�C���`�F�b�N #
	#----------------------#
	if [ ! -x "$RECV_PROC_FILE" ]; then
		echo "process file isn't exist. RECV_PROC_FILE=[$PROC_FILE]"
		exit 1
	fi
	if [ ! -x "$REFL_PROC_FILE" ]; then
		echo "process file isn't exist. REFL_PROC_FILE=[$REFL_PROC_FILE]"
		exit 1
	fi
	if [ ! -x "$MONI_PROC_FILE" ]; then
		echo "process file isn't exist. MONI_PROC_FILE=[$MONI_PROC_FILE]"
		exit 1
	fi

	#-------------#
	# ���ߎ��s����#
	#-------------#
	if [ X"$OPTION" = X"START" ];then
		#----------------------#
		# �ݒ�t�@�C���`�F�b�N #
		#----------------------#
		if [ ! -f "$RECV_CONFFILE" -o ! -r "$RECV_CONFFILE" ]; then
			echo "config file isn't exist or cannot access. RECV_CONFFILE=[$RECV_CONFFILE]"
			exit 1
		fi

		if [ ! -f "$REFL_CONFFILE" -o ! -r "$REFL_CONFFILE" ]; then
			echo "config file isn't exist or cannot access. REFL_CONFFILE=[$REFL_CONFFILE]"
			exit 1
		fi

		if [ ! -f "$MONI_CONFFILE" -o ! -r "$MONI_CONFFILE" ]; then
			echo "config file isn't exist or cannot access. MONI_CONFFILE=[$MONI_CONFFILE]"
			exit 1
		fi

		PROC_FILE=$MONI_PROC_FILE
		CONTROL_CONF=$MONI_CONFFILE
		DoStart
		sleep 2

		PROC_FILE=$RECV_PROC_FILE
		CONTROL_CONF=$RECV_CONFFILE
		DoStart

		PROC_FILE=$REFL_PROC_FILE
		CONTROL_CONF=$REFL_CONFFILE
		DoStart
	else
		PROCESS="REFL"
		CONTROL_CONF=$REFL_CONFFILE
		PROC_FILE=$REFL_PROC_FILE
		DoStop
		
		PROCESS="RECV"
		CONTROL_CONF=$RECV_CONFFILE
		PROC_FILE=$RECV_PROC_FILE
		DoStop

		sleep 2
		PROCESS="MONITOR"
		CONTROL_CONF=$MONI_CONFFILE
		PROC_FILE=$MONI_PROC_FILE
		DoStop
	fi

#----------------------#
# �e�v���Z�X�̋N����~ #
#----------------------#
else
	#----------------------#
	# ���߃t�@�C���`�F�b�N #
	#----------------------#
	if [ X"$PROCESS" = X"RECV" ];then
		PROC_FILE=$RECV_PROC_FILE
		if [ ! -x "$PROC_FILE" ]; then
			echo "process file isn't exist. RECV_PROC_FILE=[$PROC_FILE]"
			exit 1
		fi

		if [ X"$OPTION" = X"STOP" ];then
			MONI_PROC_FILE=$MONI_PROC_FILE
			if [ ! -x "$MONI_PROC_FILE" ]; then
				echo "process file isn't exist. MONI_PROC_FILE=[$MONI_PROC_FILE]"
				exit 1
			fi
		fi	
	elif [ X"$PROCESS" = X"REFL" ];then
		PROC_FILE=$REFL_PROC_FILE
		if [ ! -x "$PROC_FILE" ]; then
			echo "process file isn't exist. REFL_PROC_FILE=[$PROC_FILE]"
			exit 1
		fi
		
		if [ X"$OPTION" = X"STOP" ];then
			MONI_PROC_FILE=$MONI_PROC_FILE
			if [ ! -x "$MONI_PROC_FILE" ]; then
				echo "process file isn't exist. MONI_PROC_FILE=[$MONI_PROC_FILE]"
				exit 1
			fi
		fi
	else
		PROC_FILE=$MONI_PROC_FILE
		if [ ! -x "$PROC_FILE" ]; then
			echo "process file isn't exist. MONI_PROC_FILE=[$PROC_FILE]"
			exit 1
		fi
	fi

	#--------------#
	# �ݒ�t�@�C�� #
	#--------------#
	if [ X"$PROCESS" = X"RECV" ];then
		CONTROL_CONF=$RECV_CONFFILE
	elif [ X"$PROCESS" = X"REFL" ];then
		CONTROL_CONF=$REFL_CONFFILE
	else
		CONTROL_CONF=$MONI_CONFFILE
	fi

	#-------------#
	# ���ߎ��s����#
	#-------------#
	if [ X"$OPTION" = X"START" ];then
		#----------------------#
		# �ݒ�t�@�C���`�F�b�N #
		#----------------------#
		if [ ! -f "$CONTROL_CONF" -o ! -r "$CONTROL_CONF" ]; then
			echo "config file isn't exist or cannot access. CONTROL_CONF=[$CONTROL_CONF]"
			exit 1
		fi

		DoStart
	else
		DoStop
	fi

fi

