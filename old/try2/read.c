#include <stdio.h>

#include "hash.h"
#include "object.h"
#include "memory.h"
#include "read.h"


Object parserOutput;

Object read(void)
{
    yyparse();

    return parserOutput;
}


extern FILE* yyin;

Object readFile(char* fileName)
{
    Object obj;

    if ((yyin = fopen(fileName, "r" )) == NULL) {
	yyrestart(stdin);
	return makeNull();
    }

    obj = read();
    
    yyrestart(stdin);

    return obj;
}

Object loadFile(char* fileName)
{
    if ((yyin = fopen(fileName, "r" )) == NULL) {
	yyrestart(stdin);
	return makeNull();
    }

    while (1) {
	setReg(regExp, read());
	if (isEOF(getReg(regExp)))
	    break;
	eval();
    }
    
    yyrestart(stdin);

    return makeSymbol("ok");
}
