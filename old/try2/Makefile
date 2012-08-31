SRCS=\
	env.c\
	eval.c\
	hash.c\
	memory.c\
	object.c\
	obarray.c\
	primitives.c\
	scheme.c\
	syntax.c\
	read.c\
	util.c\
	y.tab.c\
	lex.yy.c

OBJS=$(SRCS:%c=%o)

LIBRARIES=

CFLAGS = $(INCDIR) -g

FLEXFILES = lex.yy.c

BISONFILES = y.tab.c y.tab.h y.output 

CC = gcc

LEX=flex -l

YACC=bison -y

scheme: $(OBJS)

lex.yy.c: scanner.l
	$(LEX) scanner.l

y.tab.c: parser.y
	$(YACC) -d -t -v -l parser.y

clean:
	rm -f $(FLEXFILES) $(BISONFILES) *.o scheme core *~

