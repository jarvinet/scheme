COREFILES = \
	coreprim.c\
	hash.c\
	memory.c\
	read.c\
	y.tab.c\
	lex.yy.c\
	util.c

REGSIMFILES = \
	regsim.c

SCHEMEFILES = \
	env.c\
	primitives.c\
	scheme.c\
	support.c\
	syntax.c

FIBFILES = \
	fib.c


SCHEMESRCS = $(COREFILES) $(REGSIMFILES) $(SCHEMEFILES)

SCHEMEOBJS = $(SCHEMESRCS:%c=%o)

FIBSRCS = $(COREFILES) $(REGSIMFILES) $(FIBFILES)

FIBOBJS = $(FIBSRCS:%c=%o)

LIBRARIES=

CFLAGS = $(INCDIR) -g

FLEXFILES = lex.yy.c

BISONFILES = y.tab.c y.tab.h y.output 

CC = gcc

LEX=flex -l

YACC=bison -y

scheme: $(SCHEMEOBJS)

fib: $(FIBOBJS)

lex.yy.c: scanner.l
	$(LEX) scanner.l

y.tab.c: parser.y
	$(YACC) -d -t -v -l parser.y

clean:
	rm -f $(FLEXFILES) $(BISONFILES) *.o scheme core *~

