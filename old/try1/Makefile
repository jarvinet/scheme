SRCS=memory.c scheme.c obarray.c y.tab.c lex.yy.c

OBJS=$(SRCS:%c=%o)

LIBRARIES=

CFLAGS = $(INCDIR) -g

CC = gcc
LEX=flex -l
YACC=bison -y

scheme: $(OBJS)

lex.yy.c: scanner.l
	$(LEX) scanner.l

y.tab.c: parser.y
	$(YACC) -d -t -v -l parser.y

clean:
	rm -f *.o scheme core *~

