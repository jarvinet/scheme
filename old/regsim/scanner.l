%{
#include "insts.h"
#include "y.tab.h"
%}

delimiter	   [ \t\n]
comment 	   ;.*\n
whitespace	   {delimiter}*|{comment}

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
"assign"                {return(ASSIGN);}
"perform"               {return(PERFORM);}
"test"                  {return(TEST);}
"branch"                {return(BRANCH);}
"goto"                  {return(GOTO);}
"save"                  {return(SAVE);}
"restore"               {return(RESTORE);}
"reg"                   {return(REG);}
"const"                 {return(CONST);}
"label"                 {return(LABEL);}
"op"                    {return(OP);}
{identifier}		{yylval.str = yytext; return(IDENTIFIER);}
{number}		{yylval.num = atoi(yytext); return(NUMBER);}
{whitespace}		{/* skip all whitespace */}
.			{yylval.str = yytext; return(OTHER);}
%%
