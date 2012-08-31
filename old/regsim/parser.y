%{
#include <stdlib.h>
#include <string.h>
#include "regsim.h"
#include "insts.h"
#include "util.h"
%}


%union {
    char*     str;
    int       num;
    Inst      ins;
    Register  reg;
    Constant  con;
    Operation ope;
    Label     lbl;
    Source    src;
    Target    trg;
    Input     inp;
    List*     lst;
}

%token <str> OTHER
%token <str> IDENTIFIER
%token <num> NUMBER
%token <str> STRING
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

%type <str> instseq
%type <ins> instruction
%type <ins> assign
%type <ins> perform
%type <ins> test
%type <ins> branch
%type <ins> goto
%type <ins> save
%type <ins> restore
%type <reg> regexpr
%type <con> constexpr
%type <ope> opexpr
%type <lbl> labelexpr
%type <lst> inputs
%type <inp> input
%type <str> labelname
%type <str> opname
%type <str> regname
%type <con> constvalue

%%

instseq      : instseq instruction {rsAddInst(theRegSim, $2);}
             | instruction         {rsAddInst(theRegSim, $1);}
             ;

instruction  : assign
             | perform
             | test
             | branch
             | goto
             | save
             | restore
             | labelname           {$$ = insMakeLabel(lblMake($1)); rsAddLabel(theRegSim, $1);}
             ;

assign       : OPENPAR ASSIGN regname regexpr CLOSEPAR   {$$ = insMakeAssign(regMake($3), srcMakeReg($4));}
             | OPENPAR ASSIGN regname constexpr CLOSEPAR {$$ = insMakeAssign(regMake($3), srcMakeConst($4));}
             | OPENPAR ASSIGN regname opexpr CLOSEPAR    {$$ = insMakeAssign(regMake($3), srcMakeOp($4));}
             | OPENPAR ASSIGN regname labelexpr CLOSEPAR {$$ = insMakeAssign(regMake($3), srcMakeLabel($4));}
             ;

perform      : OPENPAR PERFORM opexpr CLOSEPAR           {$$ = insMakePerform($3);}
             ;

test         : OPENPAR TEST opexpr CLOSEPAR              {$$ = insMakeTest($3);}
             ;

branch       : OPENPAR BRANCH labelexpr CLOSEPAR         {$$ = insMakeBranch(trgMakeLabel($3));}
             ;

goto         : OPENPAR GOTO labelexpr CLOSEPAR           {$$ = insMakeGoto(trgMakeLabel($3));}
             | OPENPAR GOTO regexpr CLOSEPAR             {$$ = insMakeGoto(trgMakeReg($3));}
             ;

save         : OPENPAR SAVE regname CLOSEPAR             {$$ = insMakeSave(regMake($3));}
             ;

restore      : OPENPAR RESTORE regname CLOSEPAR          {$$ = insMakeRestore(regMake($3));}
             ;

regexpr      : OPENPAR REG regname CLOSEPAR              {$$ = regMake($3);}
             ;

constexpr    : OPENPAR CONST constvalue CLOSEPAR         {$$ = $3;}
             ;

opexpr       : OPENPAR OP opname CLOSEPAR inputs         {$$ = opMake($3, $5);}
             ;

labelexpr    : OPENPAR LABEL labelname CLOSEPAR          {$$ = lblMake($3);}
             ;

inputs       : inputs input                              {$$ = lstAppend($1, lstMake($2));}
             |                                           {$$ = lstAppend(NULL, NULL);}
             ;

input        : regexpr                                   {$$ = inpMakeRegister($1);}
             | constexpr                                 {$$ = inpMakeConst($1);}
             ;

labelname    : IDENTIFIER                                {$$ = estrdup($1);}
             ;

opname       : IDENTIFIER                                {$$ = estrdup($1);}
             ;

regname      : IDENTIFIER                                {$$ = estrdup($1);}
             ;

constvalue   : NUMBER                                    {$$ = conMakeNumber($1);}
             | STRING                                    {$$ = conMakeString(estrdup($1));}
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
