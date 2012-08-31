%{
#include "memory.h"
#include "y.tab.h"

%}

letter		   [A-Za-z]
digit		   [0-9]
specialinitial     [!$%&*/:<=>?^_~]
initial            {letter}|{specialinitial}
specialsubsequent  [-+.@] 
peculiaridentifier [-+]
subsequent         ({initial})|{digit}|{specialsubsequent}
identifier	   ({initial})({subsequent})*|{peculiaridentifier}

number		   {digit}+
anybutquote        [^"]
escapedquote       \\\"
escapedbackslash   \\\\
stringelement      {anybutquote}
string             "\""{stringelement}*"\""
charactername      space|newline
character          #\\.|#\\{charactername}

%%

"(" 			{return(OPENPAR);}
")"                     {return(CLOSEPAR);}
"."                     {return(DOT);}
"'"                     {return(QUOTE);}
"`"                     {return(QUASIQUOTE);}
","                     {return(COMMA);}
"#t"                    {return(TRUE);}
"#f"                    {return(FALSE);}
{string}         	{yylval.str = yytext; return(STRING);}
{identifier}		{yylval.str = yytext; return(IDENTIFIER);}
{number}		{yylval.num = atoi(yytext); return(NUMBER);}
{character}		{yylval.str = yytext; return(CHARACTER);}
<<EOF>>                 {return(END_OF_FILE);}
";".*\n                  /* eat up one-line comments */
[ \t\n]+                 /* eat up whitespace */
.			{yylval.str = yytext; return(OTHER);}
%%

