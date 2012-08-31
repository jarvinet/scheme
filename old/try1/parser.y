%{
#include <stdlib.h>
#include <string.h>
#include "memory.h"
#include "obarray.h"
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

%type <obj> datum
%type <obj> simpledatum
%type <obj> boolean
%type <obj> number
%type <obj> character
%type <obj> string
%type <obj> symbol
%type <obj> compounddatum
%type <obj> list
%type <obj> datumzeroormore
%type <obj> datumoneormore
%type <obj> abbreviation
%type <obj> abbrevprefix

%%

foo             : datum {printObject($1);printf("\n");}
                ;

datum           : simpledatum
                | compounddatum
                ;

simpledatum     : boolean 
                | number
                | character
                | string
                | symbol
                ;

boolean         : TRUE                                      {$$ = makeSymbol(insert($1));}
                | FALSE                                     {$$ = makeSymbol(insert($1));}
                ;

number          : NUMBER                                    {$$ = makeNumber($1);}
                ;

character       : CHARACTER                                 {}
                ;

string          : STRING                                    {}
                ;

symbol          : IDENTIFIER                                {$$ = makeSymbol(insert($1));}
                ;

compounddatum   : list 
                ;

list            : OPENPAR datumzeroormore CLOSEPAR          {$$ = $2;}
                | OPENPAR datumoneormore DOT datum CLOSEPAR {}
                | abbreviation                              {$$ = $1;}
                ;

datumzeroormore : datum datumzeroormore                     {$$ = cons($1, $2);}
                |                                           {$$ = makeNull();}
                ;

datumoneormore  : datum datumzeroormore                     {$$ = cons($1, $2);}
                ;

abbreviation    : abbrevprefix datum                        {$$ = cons($1, $2);}
                ;

abbrevprefix    : QUOTE                                     {$$ = makeSymbol(insert("quote"));}
                | QUASIQUOTE                                {$$ = makeSymbol(insert("quasiquote"));}
                | COMMA                                     {$$ = makeSymbol(insert("comma"));}
                ;

%%

#include <stdlib.h>
#include <string.h>
#include "memory.h"
#include "obarray.h"

yyerror(char *s)
{
    printf("%s\n",s);
}

yywrap()
{
    return(1);
}
#if 0
main()
{
    printf("start\n");
    yyparse();
    printf("stop\n");
}

#endif
