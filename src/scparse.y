%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"

#include "eof.h"
#include "symbol.h"
#include "number.h"
#include "character.h"
#include "sstring.h"
#include "vector.h"
#include "null.h"
#include "hash.h"
#include "util.h"
#include "port.h"

#define YYDEBUG 1
#define YYERROR_VERBOSE 1

    /* scLineNumber is defined in scscan.l */
    extern unsigned int scLineNumber;
%}

%union {
    int   num;
    char* str;
    char  chr;
}
     
%token <str> OTHER
%token <str> IDENTIFIER
%token <num> NUMBER
%token <chr> CHARACTER
%token <str> STRING
%token <str> BEGINVECTOR
%token <str> OPENPAR
%token <str> CLOSEPAR 
%token <str> DOT
%token <str> QUOTE
%token <str> QUASIQUOTE
%token <str> UNQUOTE
%token <str> UNQUOTESPLICING
%token <str> TOKEN_TRUE
%token <str> TOKEN_FALSE
%token <str> NEWLINE
%token <str> END_OF_FILE

%%

input           : datum          {YYACCEPT;}
                ;

datum           : simpledatum
                | compounddatum
                ;

simpledatum     : boolean
                | number
                | character
                | string
                | symbol
                | END_OF_FILE    {regMakeEOF(regSimple);}
                ;

boolean         : TOKEN_TRUE           {regMakeSymbol(regSimple, "true");}
                | TOKEN_FALSE          {regMakeSymbol(regSimple, "false");}
                ;

number          : NUMBER         {regMakeNumber(regSimple, $1);}
                ;

character       : CHARACTER      {regMakeCharacter(regSimple, $1);}
                ;

string          : STRING         {/* The string $1 has been allocated in the scanner */
                                  regMakeString(regSimple, $1);}
                ;

symbol          : IDENTIFIER     {regMakeSymbol(regSimple, $1);}
                ;

compounddatum   : list           {regCopy(regSimple, regCompound);}
                | vector         {regList2Vector(regSimple, regCompound);}
                ;

list            : OPENPAR datumzero CLOSEPAR          {restore(regCompound); /* restore datumzero */}
                | OPENPAR datumone DOT datum CLOSEPAR {restore(regCompound); /* restore datumone */
                                                       listSetCdr(regCompound, regCompound, regSimple); /* append datum */}
                | abbreviation                        {}
                ;

vector          : BEGINVECTOR datumzero CLOSEPAR      {restore(regCompound);}
                ;

datumzero       : datumzero datum    {restore(regCompound);                      /* restore datumzero */
                                      snoc(regCompound, regCompound, regSimple); /* append datum */
				      save(regCompound);                         /* save datumzero */ }
                |                    {regMakeNull(regCompound);
		                      save(regCompound);                         /* save datumzero */ }
                ;

datumone        : datumzero datum    {restore(regCompound);                      /* restore datumzero */
                                      snoc(regCompound, regCompound, regSimple); /* append datum */
				      save(regCompound);                         /* save datumone */ }
                ;

abbreviation    : abbrevprefix datum {regMakeNull(regCompound);
				      cons(regSimple, regSimple, regCompound);
				      restore(regCompound); /* restore abbrevprefix */
                                      cons(regCompound, regCompound, regSimple);}
                ;

abbrevprefix    : QUOTE           {regMakeSymbol(regCompound, "quote");
                                   save(regCompound); /* save abbrevprefix */ }
                | QUASIQUOTE      {regMakeSymbol(regCompound, "quasiquote");
                                   save(regCompound); /* save abbrevprefix */ }
                | UNQUOTE         {regMakeSymbol(regCompound, "unquote");
                                   save(regCompound); /* save abbrevprefix */ }
                | UNQUOTESPLICING {regMakeSymbol(regCompound, "unquote-splicing");
                                   save(regCompound); /* save abbrevprefix */ }
                ;

%%

#include <stdlib.h>

void parseFoundString(char* str)
{
    printf("scparse.y: found string (%s)\n", str);
}

int yyerror(char *s)
{
    printf("%u: %s\n", scLineNumber, s);
    return 0;
}

int scwrap() /* yywrap */
{
    return(1);
}
