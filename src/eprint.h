#ifndef _EPRINT_H
#define _EPRINT_H

#include <setjmp.h>

extern jmp_buf jumpBuffer;

void eprintf(char* fmt, ...);
void esprint(char* fmt, ...);
void erprint(char* msg, Register reg);

#endif /* _EPRINT_H */
