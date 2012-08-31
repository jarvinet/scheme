#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>
#include <errno.h>

#include "memory.h"
#include "util.h"


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

void checkArgsEQ(char* name, char* types, Register operands)
{
    unsigned int nargs = length(operands);
    unsigned int ntypes = strlen(types);
    unsigned int i;

    if (ntypes != nargs)
	eprintf("%s: want exactly %d arguments\n", name, ntypes);

    for (i = 0; i < ntypes; i++) {
	car(regArgs[i], operands);
	switch (types[i]) {
	case 'p':
	    if (!isPair(regArgs[i]))
		eprintf("%s: arg %d must be a pair\n", name, i);
	    break;
	case 'y':
	    if (!isSymbol(regArgs[i]))
		eprintf("%s: arg %d must be a symbol\n", name, i);
	    break;
	case 's':
	    if (!isString(regArgs[i]))
		eprintf("%s: arg %d must be a string\n", name, i);
	    break;
	case 'n':
	    if (!isNumber(regArgs[i]))
		eprintf("%s: arg %d must be a number\n", name, i);
	    break;
	case 'b':
	    if (!isBoolean(regArgs[i]))
		eprintf("%s: arg %d must be a boolean\n", name, i);
	    break;
	case 'r':
	    if (!isPrimitive(regArgs[i]))
		eprintf("%s: arg %d must be a primitive\n", name, i);
	    break;
	case '*':
	    /* accept all types */
	    break;
	default:
	    eprintf("checkArgsEQ: unknown arg type: %c\n", types[i]);
	    break;
	}
	cdr(operands, operands);
    }
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
unsigned int isTaggedList(Register exp, char* tag)
{
    Register symbol = reg0;
    Register tag = reg1;
    unsigned int result;

    makeSymbol(symbol, tag);
    if (isPair(exp)) {
	car(tag, exp);
	result = isEq(tag, symbol);
    } else {
	result = FALSE;
    }

    return result;
}
