#ifndef _UTIL_H
#define _UTIL_H

#include <stdlib.h>

#ifndef FALSE
#define FALSE 0
#define TRUE (!FALSE)
#endif

void eprintf(char* fmt, ...);
char* estrdup(char* s);
void* emalloc(size_t n);

#endif /* _UTIL_H */
