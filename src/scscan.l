%{

#include "bool.h"
#include "common.h"
#include "hash.h"
#include "object.h"
#include "memory.h"
#include "util.h"
#include "scparse.tab.h"

#define MAX_STR_CONST 255

unsigned int scLineNumber = 1;

void scanFoundString(char* str) {
    printf("scscan.l: found string (%s)\n", str);
}

%}

letter		   [A-Za-z]
digit		   [0-9]
specialinitial     [!$%&*/:<=>?^_~]
initial            {letter}|{specialinitial}
specialsubsequent  [-+.@] 
peculiaridentifier "-"|"+"|"..."
subsequent         ({initial})|{digit}|{specialsubsequent}
identifier	   ({initial})({subsequent})*|{peculiaridentifier}
sign               [+-]
number		   ({sign})?({digit})+

%x string

%%

               char string_buf[MAX_STR_CONST];
               char *string_buf_ptr;

\"             string_buf_ptr = string_buf; BEGIN(string);

<string>\"        { /* saw closing quote - all done */
    BEGIN(INITIAL);
    *string_buf_ptr = '\0';
    /* string_buf is a local variable, it should be copied here */
    sclval.str = estrdup(string_buf);
    return(STRING);
}

<string>\n        { /* error - unterminated string constant */ }

<string>\\\"  *string_buf_ptr++ = '\"';

<string>\\\\  *string_buf_ptr++ = '\\';

<string>[^\\\"]+  {
    char *yptr = yytext;
    while ( *yptr )
	*string_buf_ptr++ = *yptr++;
}

"#("                    {return(BEGINVECTOR);}
"(" 			{return(OPENPAR);}
")"                     {return(CLOSEPAR);}
"."                     {return(DOT);}
"'"                     {return(QUOTE);}
"`"                     {return(QUASIQUOTE);}
","                     {return(UNQUOTE);}
",@"                    {return(UNQUOTESPLICING);}
"#t"                    {return(TOKEN_TRUE);}
"#f"                    {return(TOKEN_FALSE);}
{identifier}		{sclval.str = yytext; return(IDENTIFIER);}
{number}		{sclval.num = atoi(yytext); return(NUMBER);}
#\\space                {sclval.chr = ' '; return(CHARACTER);}
#\\SPACE                {sclval.chr = ' '; return(CHARACTER);}
#\\newline              {sclval.chr = '\n'; return(CHARACTER);}
#\\NEWLINE              {sclval.chr = '\n'; return(CHARACTER);}
#\\.                    {sclval.chr = yytext[2]; return(CHARACTER);}
<<EOF>>                 {return(END_OF_FILE);}
";".*\n                 {scLineNumber++;}
\n                      {scLineNumber++;}
[ \t]+                  /* eat up whitespace */
.			{sclval.str = yytext; return(OTHER);}

%%

void scSetCurrentYYBuffer(void* buffer)
{
    sc_switch_to_buffer((YY_BUFFER_STATE)buffer);
}

void* scGetCurrentYYBuffer(void)
{
    return (void*)YY_CURRENT_BUFFER;
}

void* scCreateYYBuffer(FILE* file)
{
    return (void*)sc_create_buffer(file, YY_BUF_SIZE);
}

void scDeleteYYBuffer(void* buffer)
{
    sc_flush_buffer((YY_BUFFER_STATE)buffer);
    sc_delete_buffer((YY_BUFFER_STATE)buffer);
}

void* scScanString(char* str)
{
    return (void*)sc_scan_string(str); /* sets the buffer to scan */
}
