##==========================================================================##
##                                                                          ##
## PROGRAM		: makefile													##
## CREATE DATE	: 2008/12/19												##
## MODIFY DATE	: 															##
## AUTHOR		: Tan Junliang												##
## RULES		: make -> to make the executable file						##
##				  make clean -> to clean the object files and executable	##
##   						   files  										##
##                                                                          ##
##==========================================================================##

PROJECT_OBJECTS = Main.o WorkReflector.o

PROJECT_NAME = realwork_reflect

COMMON_INCLUDE = ../common/include
COMMON_LIB = ../common/lib

#PROJECT_TYPE = LIBRARY

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
PROJECT_NAME_EXE = $(PROJECT_NAME)
PROJECT_NAME_LIBRARY = $(PROJECT_NAME).$(SHLIB)
PROJECT_NAME_ = $(PROJECT_NAME_$(PROJECT_TYPE_TYPE))

###############################################################################
# Include and Library                                                         #
###############################################################################

INCDIR = -I./include -I. -I$(COMMON_INCLUDE)
LIBS = -lrwtool_v2 -L/usr/opt/temip_3pps/xerces/2.5.0/lib/ \
       -L$(COMMON_LIB) -lrtw_common

###############################################################################
# for debug mode                                                              #
###############################################################################
   
DEBUG = OFF 
DEBUG_OFF = 
DEBUG_ON =
DEBUG_FLAG =

###############################################################################
# Compile and Link                                                            #
###############################################################################

CXX = /opt/aCC/bin/aCC
CXXFLAGS = -mt -c +DD64 -g +O0 +W2815 -D_HPUX_SOURCE $(DEBUG_FLAG) \
           -D__HPACC_USING_MULTIPLIES_IN_FUNCTIONAL -AA $(CXXFLAGS_PROJECT_TYPE)

LD = /opt/aCC/bin/aCC
LDFLAGS = -D_HPUX_SOURCE -mt -z +DD64 $(LDFLAGS_PROJECT_TYPE)

###############################################################################
# Rules                                                                       #
###############################################################################

.SUFFIXES: .cpp .o .h
.cpp.o:
	$(CXX) $(CXXFLAGS) $(INCDIR) $(LIBS) -o $*.o $*.cpp

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
