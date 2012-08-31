#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

#include "util.h"


/* estrdup: duplicate a string, report if error */
char* estrdup(char* s)
{
    char *t = (char*) malloc(strlen(s)+1);
    if (t == NULL) {
	printf("estrdup(\"%.20s\") failed:", s);
	exit(2);
    }
    strcpy(t, s);
    return t;
}

/* emalloc: malloc and report if error */
void* emalloc(size_t n)
{
    void* p = malloc(n);
    if (p == NULL) {
	printf("malloc of %u bytes failed:", n);
	exit(2);
    }
    return p;
}
