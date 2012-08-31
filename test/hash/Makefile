# $@ target
# $* matching stem
# $^ dependencies

SRCS = main.c hash.c list.c util.c

OBJS = $(SRCS:%c=%o)

CFLAGS = -g -Wall

hash: $(OBJS)
	gcc -o$@ $^

clean:
	rm -f hash core *.o *~

