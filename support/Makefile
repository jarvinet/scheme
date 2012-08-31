SCHEMESRCS = \
	env.c init.c support.c syntax.c

SCHEMEOBJS = $(SCHEMESRCS:%c=%o)

LIBRARY = libscheme.so

INCDIR = -I../core -I../src

INSTALLDIR = ../lib

CFLAGS += $(INCDIR) -g -Wall

CC = gcc

all: $(LIBRARY) install

$(LIBRARY): $(SCHEMEOBJS)
	$(CC) -shared -Wl,-soname,$@.1 -o $@.1.0 $^

install: $(LIBRARY)
	(cp $(LIBRARY).1.0 $(INSTALLDIR); \
	cd $(INSTALLDIR); \
	ln -s -f $(LIBRARY).1.0 $(LIBRARY).1; \
	ln -s -f $(LIBRARY).1 $(LIBRARY))

clean:
	rm -rf $(SCHEMEOBJS) $(LIBRARY)
	rm -rf *~ core

makercslinks:
	ln -s ../RCS/support RCS

rmrcslinks:
	rm -f RCS

