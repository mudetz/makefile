# C Makefile Template
# Copyright (C) 2018  Manuel Weitzman
# You may use/distribute this template under the terms of the MIT LICENSE

# HowTo:
#	Create a src/ dir for all .c files
#	Create a head/ dir for all .h files
#	In .c files import .h files as if they were in the same dir
#	You have available:
#		make			Compile binaries
#		make install		Install final exec to /usr/bin
#		make uninstall		Remove final exec from /usr/bin
#		make clean		Remove intermediate .o files
#		make distclean		Remove final executable
#		make cleanall		clean+distclean

# Final executable name
EXEC = exec

# Directories for sourcefiles, headers and object files
SRCDIR = src
HEADDIR = head
OBJDIR = obj

# Files will be detected automatically (they shall not be in subdirectories
# though)
SOURCES = $(wildcard $(SRCDIR)/*.c)
OBJECTS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SOURCES))

# Compiler options
CC ?= /usr/bin/gcc
CPPFLAGS = $(addprefix -I, $(HEADDIR)) -MMD -MP
CFLAGS = -O2 -Wall -Wextra -std=gnu99 -Wimplicit -Wshadow -Wswitch-default \
	 -Wswitch-enum -Wundef -Wuninitialized -Wpointer-arith \
	 -Wstrict-prototypes -Wmissing-prototypes -Wcast-align \
	 -Wformat=2 -Wimplicit-function-declaration -Wredundant-decls \
	 -Wformat-security -Wno-unused-result -mtune=native
LDFLAGS =
LDLIBS =

# Utilities used for output and others
ECHO = echo
RM = rm -rf
MKDIR = mkdir
INSTALL = install
FIND = find
CP = cp

# Makefile rules
.PHONY: all
all: $(OBJDIR) $(EXEC)

$(EXEC): $(OBJECTS)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -c $< -o $@

$(OBJDIR):
	@$(MKDIR) -p $@

.PHONY: install
install:
	$(INSTALL) $(EXEC) /usr/bin/$(EXEC)

.PHONY: uninstall
uninstall:
	$(RM) /usr/bin/$(EXEC)

.PHONY: cleanall
cleanall: clean distclean

.PHONY: clean
clean:
	$(FIND) . -iname '*.d'            -type f -delete
	$(FIND) . -iname '*.o'            -type f -delete
	$(FIND) . -iname '*.ko'           -type f -delete
	$(FIND) . -iname '*.obj'          -type f -delete
	$(FIND) . -iname '*.elf'          -type f -delete
	$(FIND) . -iname '*.ilk'          -type f -delete
	$(FIND) . -iname '*.map'          -type f -delete
	$(FIND) . -iname '*.exp'          -type f -delete
	$(FIND) . -iname '*.gch'          -type f -delete
	$(FIND) . -iname '*.pch'          -type f -delete
	$(FIND) . -iname '*.lib'          -type f -delete
	$(FIND) . -iname '*.a'            -type f -delete
	$(FIND) . -iname '*.la'           -type f -delete
	$(FIND) . -iname '*.lo'           -type f -delete
	$(FIND) . -iname '*.dll'          -type f -delete
	$(FIND) . -iname '*.so'           -type f -delete
	$(FIND) . -iname '*.so.*'         -type f -delete
	$(FIND) . -iname '*.dylib'        -type f -delete
	$(FIND) . -iname '*.exe'          -type f -delete
	$(FIND) . -iname '*.out'          -type f -delete
	$(FIND) . -iname '*.app'          -type f -delete
	$(FIND) . -iname '*.i*86'         -type f -delete
	$(FIND) . -iname '*.x86_64'       -type f -delete
	$(FIND) . -iname '*.hex'          -type f -delete
	$(FIND) . -iname '*.su'           -type f -delete
	$(FIND) . -iname '*.idb'          -type f -delete
	$(FIND) . -iname '*.pdb'          -type f -delete
	$(FIND) . -iname '*.mod*'         -type f -delete
	$(FIND) . -iname '*.cmd'          -type f -delete
	$(FIND) . -iname 'modules.order'  -type f -delete
	$(FIND) . -iname 'Module.symvers' -type f -delete
	$(FIND) . -iname 'Mkfile.old'     -type f -delete
	$(FIND) . -iname 'dkms.conf'      -type f -delete
	$(FIND) . -iname '*.dSYM'        -type d -empty -delete
	$(FIND) . -iname '.tmp_versions' -type d -empty -delete
	$(FIND) . -iname 'obj'           -type d -empty -delete

.PHONY: distclean
distclean:
	$(RM) $(EXEC)

-include $(wildcard $(OBJDIR)/*.d)
