#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <setjmp.h>
#include <string.h>
#include <errno.h>

#include "common.h"
#include "parameters.h"
#include "port.h"

jmp_buf jumpBuffer;


/* eprintf: print error message and exit */
void eprintf(char* fmt, ...)
{
    va_list args;

    fflush(stdout);

    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);

    if (fmt[0] != '\0' && fmt[strlen(fmt)-1] == ':')
	fprintf(stderr, " %s", strerror(errno));
    fprintf(stderr, "\n");
    exit(2); /* conventional value for failed execution */
}

void esprint(char* fmt, ...)
{
    va_list args;
    fflush(stdout);
    va_start(args, fmt);
    vfprintf(stderr, fmt, args);
    va_end(args);
    longjmp(jumpBuffer, 2);
}

void erprint(char* msg, Register reg)
{
    fflush(stdout);
    printf("%s", msg);
    regDisplayToCurrentPort(reg);
    printf("\n");
    longjmp(jumpBuffer, 2);
}
