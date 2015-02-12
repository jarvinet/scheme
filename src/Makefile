# $@ target
# $* matching stem
# $^ dependencies


REGSIMSCANNER = rsscan.yy.c

REGSIMPARSER = rsparse.tab.c

SCHEMESCANNER = scscan.yy.c 

SCHEMEPARSER = scparse.tab.c

# register.c should not be in SCHEMESRCS

SCHEMESRCS = \
	object.c boolean.c brokenheart.c character.c \
	continuation.c eof.c null.c number.c pairpointer.c \
	port.c primitive.c register.c sstring.c symbol.c vector.c

SUPPORTSRCS = \
	env.c init.c support.c syntax.c glue.c hash.c list.c util.c

# schemeparser and scanner should not be in REGSIMSRCS

REGSIMSRCS = \
	$(SUPPORTSRCS) \
	$(SCHEMESRCS) \
	argcheck.c eprint.c insts.c main.c regsim.c math.c memory.c \
	$(REGSIMPARSER) $(REGSIMSCANNER) \
	$(SCHEMEPARSER) $(SCHEMESCANNER)

REGSIMOBJS = $(REGSIMSRCS:%c=%o)

CLEANFILES =\
	$(REGSIMSCANNER) $(REGSIMPARSER)\
	$(SCHEMESCANNER) $(SCHEMEPARSER)\
	$(REGSIMOBJS) rsparse.tab.h scparse.tab.h\
	regsim core *~


# INCDIR = -I../core

LIBDIR = -L../lib

# LIBRARY = -lcore

CFLAGS = $(INCDIR) -g -Wall

CC = gcc

LEX = flex

YACC = bison

all : regsim

regsim: $(REGSIMOBJS)
	$(CC) -o $@ $^ $(LIBDIR) $(LIBRARY) 
	cp $@ ../bin

#  -rdynamic -ldl

# .PRECIOUS: $(REGSIMSCANNER) $(REGSIMPARSER) $(SCHEMESCANNER) $(SCHEMEPARSER)

%scan.yy.c: %scan.l
	$(LEX) -L -o$@ -P$* $^

%parse.tab.c %parse.tab.h: %parse.y
	$(YACC) -v -l -d -t -p $* $^

clean:
	rm -f $(CLEANFILES)
	for d in $(SUBDIRS); do (cd $$d; make $@); done

makercslinks:
	ln -s ../RCS/src RCS
	for d in $(SUBDIRS); do (cd $$d; make $@); done

rmrcslinks:
	rm -f RCS
	for d in $(SUBDIRS); do (cd $$d; make $@); done
