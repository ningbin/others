##==========================================================================##
##                                                                          ##
## PROGRAM     : makefile													##
## CREATE DATE : 2008/12/11													##
## MODIFY DATE : 2008/12/29  												##
## AUTHOR      : Ning Bin													##
## RULES	   : make -> to make the executable file						##
##				 make clean -> to clean the object files and executable		##
##   						   files  										##
##                                                                          ##
##==========================================================================##

PROJECT_OBJECTS = common_log.o common_conf.o

PROJECT_NAME = rtw_common

PROJECT_TYPE = LIBRARY

###############################################################################
# for executable or library compile                                           #
###############################################################################

PROJECT_TYPE_ = EXE
PROJECT_TYPE_EXE = EXE
PROJECT_TYPE_LIBRARY = LIBRARY
PROJECT_TYPE_TYPE = $(PROJECT_TYPE_$(PROJECT_TYPE))

CXXFLAGS_EXE =
CXXFLAGS_LIBRARY = +z
CXXFLAGS_PROJECT_TYPE = $(CXXFLAGS_$(PROJECT_TYPE_TYPE))

LDFLAGS_EXE =
LDFLAGS_LIBRARY = -b
LDFLAGS_PROJECT_TYPE = $(LDFLAGS_$(PROJECT_TYPE_TYPE))

SHLIB = so
PRE_SHLIB = lib
PROJECT_NAME_EXE = $(PROJECT_NAME)
PROJECT_NAME_LIBRARY = $(PRE_SHLIB)$(PROJECT_NAME).$(SHLIB)
PROJECT_NAME_ = $(PROJECT_NAME_$(PROJECT_TYPE_TYPE))

###############################################################################
# Include and Library                                                         #
###############################################################################

INCDIR = -I../include -I/usr/opt/temip_3pps/xerces/2.5.0/include \
         -I$(ORACLE_HOME)/rdbms/demo -I$(ORACLE_HOME)/rdbms/public \
         -I$(ORACLE_HOME)/plsql/public -I$(ORACLE_HOME)/network/public
LIBS = -lrwtool_v2 -L/usr/opt/temip_3pps/xerces/2.5.0/lib/ -lxerces-c \
       -L$(ORACLE_HOME)/lib -lclntsh

###############################################################################
# for debug mode                                                              #
###############################################################################
   
DEBUG = OFF 
DEBUG_OFF = 
DEBUG_ON = -DDEBUG_MODE
DEBUG_FLAG = $(DEBUG_$(DEBUG))

###############################################################################
# Compile and Link                                                            #
###############################################################################

CXX = /opt/aCC/bin/aCC
CXXFLAGS = -mt -c +DD64 -g +O0 +inst_implicit_include -D_HPUX_SOURCE $(DEBUG_FLAG) \
           -D__HPACC_USING_MULTIPLIES_IN_FUNCTIONAL -AA $(CXXFLAGS_PROJECT_TYPE)

LD = /opt/aCC/bin/aCC
LDFLAGS = -D_HPUX_SOURCE -mt -z +DD64 +inst_implicit_include $(LDFLAGS_PROJECT_TYPE)

###############################################################################
# Rules                                                                       #
###############################################################################

.SUFFIXES: .cxx .o .hxx
.cxx.o:
	$(CXX) $(CXXFLAGS) $(INCDIR) $(LIBS) -o $*.o $*.cxx

###############################################################################
# Main Target                                                                 #
###############################################################################

all: $(PROJECT_NAME_)
	@echo "\nTarget $(PROJECT_NAME_) built!\n"

###############################################################################
# Targets                                                                     #
###############################################################################

$(PROJECT_NAME_): $(PROJECT_OBJECTS)
	$(LD) $(LDFLAGS) $(PROJECT_OBJECTS) $(LIBS) -o $(PROJECT_NAME_)

clean:
	-rm $(PROJECT_OBJECTS) $(PROJECT_NAME_)

copy:
	cp $(PROJECT_NAME_) ../lib

