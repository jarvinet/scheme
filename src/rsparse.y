%{
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include "common.h"
#include "primitive.h"

#include "insts.h"
#include "regsim.h"

#include "util.h"

#define YYERROR_VERBOSE

    /* rsLineNumber is defined in rsscan.l */
    extern unsigned int rsLineNumber;

    char* rsFileName;

%}


%union {
    char*        str;
    int          num;
    Inst         ins;
    RegisterExp  reg;
    Constant     con;
    OperationExp ope;
    Label        lbl;
    Source       src;
    Target       trg;
    Input        inp;
    List         lst;
}

%token <str> OTHER
%token <str> DOT
%token <str> STRING
%token <str> IDENTIFIER
%token <num> NUMBER
%token <str> OPENPAR
%token <str> CLOSEPAR
%token <str> ASSIGN
%token <str> PERFORM
%token <str> TEST
%token <str> BRANCH
%token <str> GOTO
%token <str> SAVE
%token <str> RESTORE
%token <str> REG
%token <str> CONST
%token <str> LABEL
%token <str> OP
%token <str> COMMENT

%type <str> instseq
%type <ins> instruction
%type <ins> assign
%type <ins> perform
%type <ins> test
%type <ins> branch
%type <ins> goto
%type <ins> save
%type <ins> restore
%type <ins> comment
%type <reg> regexpr
%type <con> constexpr
%type <ope> opexpr
%type <lbl> labelexpr
%type <lst> inputs
%type <inp> input
%type <str> labelname
%type <str> opname
%type <str> regname

%%

regsimfile   : OPENPAR needsregs modifiesregs OPENPAR instseq CLOSEPAR CLOSEPAR {}
             ;

needsregs    : OPENPAR reglist CLOSEPAR {}
             ;

modifiesregs : OPENPAR reglist CLOSEPAR {}
             ;

reglist      : reglist IDENTIFIER
             | /* empty */
             ;

instseq      : instseq instruction {rsAddInst($2);}
             | instruction         {rsAddInst($1);}
             ;

instruction  : assign
             | perform
             | test
             | branch
             | goto
             | save
             | restore
             | comment
             | labelname                                 {$$ = insMakeLabel(rsFileName, rsLineNumber, lblMake($1)); rsAddLabel($1);}
             ;

assign       : OPENPAR ASSIGN regname regexpr CLOSEPAR   {$$ = insMakeAssign(rsFileName, rsLineNumber, rexMake($3), srcMakeReg($4));}
             | OPENPAR ASSIGN regname constexpr CLOSEPAR {$$ = insMakeAssign(rsFileName, rsLineNumber, rexMake($3), srcMakeConst($4));}
             | OPENPAR ASSIGN regname opexpr CLOSEPAR    {$$ = insMakeAssign(rsFileName, rsLineNumber, rexMake($3), srcMakeOp($4));}
             | OPENPAR ASSIGN regname labelexpr CLOSEPAR {$$ = insMakeAssign(rsFileName, rsLineNumber, rexMake($3), srcMakeLabel($4));}
             ;

perform      : OPENPAR PERFORM opexpr CLOSEPAR           {$$ = insMakePerform(rsFileName, rsLineNumber, $3);}
             ;

test         : OPENPAR TEST opexpr CLOSEPAR              {$$ = insMakeTest(rsFileName, rsLineNumber, $3);}
             ;

branch       : OPENPAR BRANCH labelexpr CLOSEPAR         {$$ = insMakeBranch(rsFileName, rsLineNumber, trgMakeLabel($3));}
             ;

goto         : OPENPAR GOTO labelexpr CLOSEPAR           {$$ = insMakeGoto(rsFileName, rsLineNumber, trgMakeLabel($3));}
             | OPENPAR GOTO regexpr CLOSEPAR             {$$ = insMakeGoto(rsFileName, rsLineNumber, trgMakeReg($3));}
             ;

save         : OPENPAR SAVE regname CLOSEPAR             {$$ = insMakeSave(rsFileName, rsLineNumber, rexMake($3));}
             ;

restore      : OPENPAR RESTORE regname CLOSEPAR          {$$ = insMakeRestore(rsFileName, rsLineNumber, rexMake($3));}
             ;

comment      : OPENPAR COMMENT STRING CLOSEPAR           {$$ = insMakeComment(rsFileName, rsLineNumber, $3);}
             ;

regexpr      : OPENPAR REG regname CLOSEPAR              {$$ = rexMake($3);}
             ;

constexpr    : OPENPAR CONST STRING CLOSEPAR             {$$ = conMake($3);}
             ;

opexpr       : OPENPAR OP opname CLOSEPAR inputs         {$$ = opMake($3, $5);}
             ;

labelexpr    : OPENPAR LABEL labelname CLOSEPAR          {$$ = lblMake($3);}
             ;

inputs       : inputs input                              {$$ = lstAddLast($1, $2); }
             | /* empty */                               {$$ = lstMake(); }
             ;

input        : regexpr                                   {$$ = inpMakeRegister($1);}
             | constexpr                                 {$$ = inpMakeConst($1);}
             | labelexpr                                 {$$ = inpMakeLabel($1);}
             ;

labelname    : IDENTIFIER                                {$$ = estrdup($1);}
             ;

opname       : IDENTIFIER                                {$$ = estrdup($1);}
             ;

regname      : IDENTIFIER                                {$$ = estrdup($1);}
             ;


%%

#include <stdlib.h>

int yyerror(char *s)
{
    printf("%d: %s\n", rsLineNumber, s);
    return 0;
}

int rswrap() /* yywrap */
{
    return(1);
}
