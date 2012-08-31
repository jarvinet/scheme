#include <stdio.h>

#include "memory.h"

static unsigned int memorySize;

static void
test(void)
{
    Object n1 = makeNumber(1);
    Object n2 = makeNumber(2);
    Object n3 = makeNumber(3);
    Object n4 = makeNumber(4);

    Object p1 = cons(n1, n2);
    Object p2 = cons(n3, n4);

    unsigned int i;

    expr = cons(p1, p2);
    dumpMemory(16);
    dumpRegisters();

    printf("expr: "); printObject(expr); printf("\n");
    for (i = 0; i < 5*memorySize; i++) {
	cons(n1, p1);
    }
    printf("expr: "); printObject(expr); printf("\n");
}


int
main(void)
{
    Object obj;

    memorySize = 32;
    initMemory(memorySize);
#if 0
    test();
#endif
    obj = yyparse();
#if 0
    printObject(obj);
    printf("\n");
#endif
    return 0;
}


