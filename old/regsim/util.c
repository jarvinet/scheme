#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>

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

/* estrdup: duplicate a string, report if error */
char* estrdup(char* s)
{
    char *t;
    
    t = (char*) malloc(strlen(s)+1);
    if (t == NULL)
	eprintf("estrdup(\"%.20s\") failed:", s);
    strcpy(t, s);

    return t;
}

/* emalloc: malloc and report if error */
void* emalloc(size_t n)
{
    void* p;

    p = malloc(n);
    if (p == NULL)
	eprintf("malloc of %u bytes failed:", n);

    return p;
}
