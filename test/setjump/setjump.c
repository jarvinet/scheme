#include <setjmp.h>


jmp_buf jumpBuffer;

int foo(void)
{
    longjmp(jumpBuffer, 1);
}


int main(void)
{
    int val;
    if ((val = setjmp(jumpBuffer)) == 0) {
	printf("direct call, val = %d\n", val);
	foo();
    } else {
	printf("calling longjmp, val = %d\n", val);
    }
    return 0;
}
