COREFILES = glue.c hash.c list.c util.c

COREOBJS = $(COREFILES:%c=%o)

CC = gcc

CFLAGS = -g -Wall

LIBRARY = libcore.a

INSTALLDIR = ../lib

all: libcore.a install

$(LIBRARY): $(COREOBJS)
	ar rs $@ $^

install:
	cp $(LIBRARY) $(INSTALLDIR)

clean:
	rm -rf $(COREOBJS) $(LIBRARY)
	rm -rf *~ core

makercslinks:
	ln -s ../RCS/core RCS

rmrcslinks:
	rm -f RCS
