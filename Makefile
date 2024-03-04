##
## Makefile for Miosix embedded OS
##
MAKEFILE_VERSION := 1.10
## Path to kernel directory (edited by init_project_out_of_git_repo.pl)
KPATH := miosix
## Path to config directory (edited by init_project_out_of_git_repo.pl)
CONFPATH := $(KPATH)
include $(CONFPATH)/config/Makefile.inc

##
## List here subdirectories which contains makefiles
##
SUBDIRS := $(KPATH)

##
## Bison and Lex 
##

LEX_SRC = parser.l
YACC_SRC = parser.y
C_SRC = lex.yy.c $(patsubst %.y, %.tab.c, $(YACC_SRC))
PARS_NAME = parser


##
## List here your source files (both .s, .c and .cpp)
##
SRC :=                                  \
main.cpp

##
## List here additional static libraries with relative path
##
LIBS :=

##
## List here additional include directories (in the form -Iinclude_dir)
##
INCLUDE_DIRS :=

##############################################################################
## You should not need to modify anything below                             ##
##############################################################################

ifeq ("$(VERBOSE)","1")
Q := 
ECHO := @true
else
Q := @
ECHO := @echo
endif

## Replaces both "foo.cpp"-->"foo.o" and "foo.c"-->"foo.o"
OBJ := $(addsuffix .o, $(basename $(SRC)))

## Includes the miosix base directory for C/C++
## Always include CONFPATH first, as it overrides the config file location
CXXFLAGS := $(CXXFLAGS_BASE) -I$(CONFPATH) -I$(CONFPATH)/config/$(BOARD_INC)  \
            -I. -I$(KPATH) -I$(KPATH)/arch/common -I$(KPATH)/$(ARCH_INC)      \
            -I$(KPATH)/$(BOARD_INC) $(INCLUDE_DIRS)
CFLAGS   := $(CFLAGS_BASE)   -I$(CONFPATH) -I$(CONFPATH)/config/$(BOARD_INC)  \
            -I. -I$(KPATH) -I$(KPATH)/arch/common -I$(KPATH)/$(ARCH_INC)      \
            -I$(KPATH)/$(BOARD_INC) $(INCLUDE_DIRS)
AFLAGS   := $(AFLAGS_BASE)
LFLAGS   := $(LFLAGS_BASE)
DFLAGS   := -MMD -MP

## libmiosix.a is among stdlibs because needs to be within start/end group
STDLIBS  := -lmiosix -lstdc++ -lc -lm -lgcc -latomic
LINK_LIBS := $(LIBS) -L$(KPATH) -Wl,--start-group $(STDLIBS) -Wl,--end-group

all: parser_cicle all-recursive main

clean: clean-recursive clean-topdir clean-parser

parser_cicle: lex.yy.c parser.tab.c parser.tab.h 

$(PARS_NAME): $(C_SRC)
	cc -Os -lm -Wall -Wextra -pedantic -o $@ $^

parser.tab.c: parser.y
	bison -d  $<

parser.tab.h: parser.tab.c

lex.yy.c: $(LEX_SRC)
	flex $<

program:
	$(PROGRAM_CMDLINE)

all-recursive:
	$(foreach i,$(SUBDIRS),$(MAKE) -C $(i)                               \
	  KPATH=$(shell perl $(KPATH)/_tools/relpath.pl $(i) $(KPATH))       \
	  CONFPATH=$(shell perl $(KPATH)/_tools/relpath.pl $(i) $(CONFPATH)) \
	  || exit 1;)

clean-recursive:
	$(foreach i,$(SUBDIRS),$(MAKE) -C $(i)                               \
	  KPATH=$(shell perl $(KPATH)/_tools/relpath.pl $(i) $(KPATH))       \
	  CONFPATH=$(shell perl $(KPATH)/_tools/relpath.pl $(i) $(CONFPATH)) \
	  clean || exit 1;)

clean-topdir:
	-rm -f $(OBJ) main.elf main.hex main.bin main.map $(OBJ:.o=.d)

main: main.elf
	$(ECHO) "[CP  ] main.hex"
	$(Q)$(CP) -O ihex   main.elf main.hex
	$(ECHO) "[CP  ] main.bin"
	$(Q)$(CP) -O binary main.elf main.bin
	$(Q)$(SZ) main.elf

main.elf: $(OBJ) all-recursive
	$(ECHO) "[LD  ] main.elf"
	$(Q)$(CXX) $(LFLAGS) -o main.elf $(OBJ) $(KPATH)/$(BOOT_FILE) $(LINK_LIBS)

%.o: %.s
	$(ECHO) "[AS  ] $<"
	$(Q)$(AS)  $(AFLAGS) $< -o $@

%.o : %.c
	$(ECHO) "[CC  ] $<"
	$(Q)$(CC)  $(DFLAGS) $(CFLAGS) $< -o $@

%.o : %.cpp
	$(ECHO) "[CXX ] $<"
	$(Q)$(CXX) $(DFLAGS) $(CXXFLAGS) $< -o $@

clean-parser:
	rm -rf *.c *.o *.tab.c *.tab.h  $(PARS_NAME)

#pull in dependecy info for existing .o files
-include $(OBJ:.o=.d)
