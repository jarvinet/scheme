%{
#include <stdlib.h>
#include <string.h>
#include "hash.h"
#include "object.h"
#include "memory.h"
#include "obarray.h"
#include "util.h"
#include "read.h"
%}


%union {
    Object obj;
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

%type <obj> datum
%type <obj> simpledatum
%type <obj> boolean
%type <obj> number
%type <obj> character
%type <obj> string
%type <obj> symbol
%type <obj> compounddatum
%type <obj> list
%type <obj> datumzero
%type <obj> datumone
%type <obj> abbreviation
%type <obj> abbrevprefix

%%

input           : datum   {parserOutput = $1; YYACCEPT;}
                ;

datum           : simpledatum
                | compounddatum
                ;

simpledatum     : boolean
                | number
                | character
                | string
                | symbol
                | END_OF_FILE    {$$ = makeEOF();}
                ;

boolean         : TRUE           {$$ = makeSymbol("true");}
                | FALSE          {$$ = makeSymbol("false");}
                ;

number          : NUMBER         {$$ = makeNumber($1);}
                ;

character       : CHARACTER      {}
                ;

string          : STRING         {$$ = makeString(estrdup($1));}
                ;

symbol          : IDENTIFIER     {$$ = makeSymbol(estrdup($1));}
                ;

compounddatum   : list 
                ;

list            : OPENPAR datumzero CLOSEPAR          {$$ = $2;}
                | OPENPAR datumone DOT datum CLOSEPAR {$$ = appendBang($2, $4);}
                | abbreviation                        {$$ = $1;}
                ;

datumzero       : datum datumzero    {$$ = cons($1, $2);}
                |                    {$$ = makeNull();}
                ;

datumone        : datum datumzero    {$$ = cons($1, $2);}
                ;

abbreviation    : abbrevprefix datum {$$ = cons($1, cons($2, makeNull()));}
                ;

abbrevprefix    : QUOTE          {$$ = makeSymbol("quote");}
                | QUASIQUOTE     {$$ = makeSymbol("quasiquote");}
                | COMMA          {$$ = makeSymbol("comma");}
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

