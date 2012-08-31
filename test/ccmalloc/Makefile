# $@ target
# $* matching stem
# $^ dependencies


a.out: ccmalloc.c
	ccmalloc gcc -g $^

clean:
	rm -f a.out ccmalloc.log *~
