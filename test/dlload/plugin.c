#include <stdio.h>

#if 0
void _init(void)
{
    printf("plugin.c:_init called\n");
}

void _fini(void)
{
    printf("plugin.c:_fini called\n");
}
#endif

int initFunc(int n)
{
    printf("plugin.c:initFunc called\n");
}

int foobar(int n)
{
    int i;
    printf("plugin.c:foobar called with arg %d\n", n);
    i = bar(n);
    printf("plugin.c:foobar call to bar returned %d\n", i);
    return n;
}
