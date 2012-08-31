%{

#include "bool.h"
#include "common.h"
#include "hash.h"
#include "object.h"
#include "memory.h"
#include "primitive.h"
#include "list.h"
#include "insts.h"
#include "rsparse.tab.h"

#define MAX_STR_CONST 2048

unsigned int rsLineNumber = 1;

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
charactername      space|newline
character          #\\.|#\\{charactername}

%x constant
%x comment

%%

               char string_buf[MAX_STR_CONST];
               char *string_buf_ptr;
               int leftparCount;


"const"[ \t]+ {
		 BEGIN(constant);
		 leftparCount = 0;
		 string_buf_ptr = string_buf;
		 return(CONST);
}

"comment"[ \t]+ {
		 BEGIN(comment);
		 leftparCount = 0;
		 string_buf_ptr = string_buf;
		 return(COMMENT);
}

<constant,comment>"(" {
  leftparCount++;
  *string_buf_ptr++ = '(';
}

<constant,comment>")" {
  leftparCount--;
  *string_buf_ptr++ = ')';
  if (leftparCount == 0) {
    BEGIN(INITIAL);
    *string_buf_ptr = '\0';
    rslval.str = estrdup(string_buf);
    return(STRING);
  }
}

<constant,comment>[^()]+ {
  char *yptr = yytext;
  while (*yptr)
    *string_buf_ptr++ = *yptr++;
  if (leftparCount == 0) {
    BEGIN(INITIAL);
    *string_buf_ptr = '\0';
    rslval.str = estrdup(string_buf);
    return(STRING);
  }
}


"(" 			{return(OPENPAR);}
")"                     {return(CLOSEPAR);}
"."                     {return(DOT);}
"assign"                {return(ASSIGN);}
"perform"               {return(PERFORM);}
"test"                  {return(TEST);}
"branch"                {return(BRANCH);}
"goto"                  {return(GOTO);}
"save"                  {return(SAVE);}
"restore"               {return(RESTORE);}
"reg"                   {return(REG);}
"label"                 {return(LABEL);}
"op"                    {return(OP);}
{identifier}		{rslval.str = yytext; return(IDENTIFIER);}
{number}		{rslval.num = atoi(yytext); return(NUMBER);}
";".*\n                 {rsLineNumber++;}
\n                      {rsLineNumber++;}
[ \t]+                  /* eat up whitespace */
.			{rslval.str = yytext; return(OTHER);}
%%


void* rsGetCurrentYYBuffer(void)
{
    return (void*)YY_CURRENT_BUFFER;
}

void rsDeleteYYBuffer(void* buffer)
{
    rs_flush_buffer((YY_BUFFER_STATE)buffer);
    rs_delete_buffer((YY_BUFFER_STATE)buffer);
}
