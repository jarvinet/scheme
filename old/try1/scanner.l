%{
#include "memory.h"
#include "y.tab.h"
%}

delimiter	[ \t\n]
comment 	;.*\n
whitespace	{delimiter}*|{comment}
letter		[A-Za-z]
digit		[0-9]
identifier	{letter}+({letter}|{digit})*
number		{digit}+
stringelement   [^"]|\\\"|\\\\
string          "\""{stringelement}*"\""
charactername   space|newline
character       #\\.|#\\{charactername}

%%

{string}         	{yylval.str = yytext; return(STRING);}
{identifier}		{yylval.str = yytext; return(IDENTIFIER);}
{number}		{yylval.num = atoi(yytext); return(NUMBER);}
{character}		{yylval.str = yytext; return(CHARACTER);}
"(" 			{return(OPENPAR);}
")"                     {return(CLOSEPAR);}
"."                     {return(DOT);}
"'"                     {return(QUOTE);}
"`"                     {return(QUASIQUOTE);}
","                     {return(COMMA);}
"#t"                    {return(TRUE);}
"#f"                    {return(FALSE);}
{whitespace}		{/* skip all whitespace */}
.			{yylval.str = yytext; return(OTHER);}
%%
