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

/*
 * p pair
 * y symbol
 * s string
 * n number
 * b boolean
 * r primitive
 * * any
 */
void checkArgsEQ(char* name, char* types, Register operands);

unsigned int isTaggedList(Register exp, char* tag);

#endif /* _UTIL_H */
