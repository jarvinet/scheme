#include <stdio.h>

#include "memory.h"
#include "read.h"


extern Register regSimple; /* parser register */

void read(Register to)
{
    yyparse();

    yyrestart(stdin);

    copyReg(to, regSimple);
}



extern FILE* yyin;

void readFile(Register reg, char* fileName)
{

    if ((yyin = fopen(fileName, "r" )) == NULL) {
	yyrestart(stdin);
	makeNull(reg);
    }

    read(reg);
    
    yyrestart(stdin);
}

void loadFile(Register reg, char* fileName)
{
    if ((yyin = fopen(fileName, "r" )) == NULL) {
	yyrestart(stdin);
	makeNull(reg);
    }

    while (1) {
	read(reg);
	if (isEOF(reg))
	    break;
#if 0
	eval();
#endif
    }
    
    yyrestart(stdin);

    makeSymbol(reg, "ok");
}
