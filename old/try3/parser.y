%{
#include <stdlib.h>
#include <string.h>
#include "hash.h"
#include "memory.h"
#include "util.h"
#include "read.h"

#define YYDEBUG 1

Register regSimple;
Register regCompound;

%}


%union {
    char*  str;
    int    num;
}
     
%token <str> OTHER
%token <str> IDENTIFIER
%token <num> NUMBER
%token <str> CHARACTER
%token <str> STRING
%token <str> OPENPAR
%token <str> CLOSEPAR 
%token <str> DOT
%token <str> QUOTE
%token <str> QUASIQUOTE
%token <str> COMMA
%token <str> TRUE
%token <str> FALSE
%token <str> NEWLINE
%token <str> END_OF_FILE

%%

input           : datum   {YYACCEPT;}
                ;

datum           : simpledatum
                | compounddatum
                ;

simpledatum     : boolean
                | number
                | character
                | string
                | symbol
                | END_OF_FILE    {makeEOF(regSimple);}
                ;

boolean         : TRUE           {makeSymbol(regSimple, "true");}
                | FALSE          {makeSymbol(regSimple, "false");}
                ;

number          : NUMBER         {makeNumber(regSimple, $1);}
                ;

character       : CHARACTER      {}
                ;

string          : STRING         {makeString(regSimple, estrdup($1));}
                ;

symbol          : IDENTIFIER     {makeSymbol(regSimple, estrdup($1));}
                ;

compounddatum   : list           {copyReg(regSimple, regCompound);}
                ;

list            : OPENPAR datumzero CLOSEPAR          {restore(regCompound);}
                | OPENPAR datumone DOT datum CLOSEPAR {restore(regCompound); listSetCdr(regCompound, regCompound, regSimple);}
                | abbreviation                        {restore(regCompound);}
                ;

datumzero       : datumzero datum    {restore(regCompound); snoc(regCompound, regCompound, regSimple); save(regCompound);}
                |                    {makeNull(regCompound); save(regCompound);}
                ;

datumone        : datumzero datum    {restore(regCompound); snoc(regCompound, regCompound, regSimple); save(regCompound);}
                ;

abbreviation    : abbrevprefix datum {restore(regCompound); cons(regCompound, regCompound, regSimple); save(regCompound);}
                ;

abbrevprefix    : QUOTE          {makeSymbol(regCompound, "quote"); save(regCompound);}
                | QUASIQUOTE     {makeSymbol(regCompound, "quasiquote"); save(regCompound);}
                | COMMA          {makeSymbol(regCompound, "comma"); save(regCompound);}
                ;

%%

#include <stdlib.h>

yyerror(char *s)
{
    printf("%s\n",s);
}

yywrap()
{
    return(1);
}

void initParser(void)
{
    regSimple = allocateRegister("parserSimple");
    regCompound = allocateRegister("parserCompound");
}
