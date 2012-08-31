#include <stdlib.h>
#include <stdio.h>

#include "common.h"
#include "parameters.h"

#include "string.h"
#include "null.h"
#include "primitive.h"

#include "insts.h"
#include "regsim.h"

#include "syntax.h"
#include "support.h"
#include "env.h"
#include "util.h"


static Register exp;
static Register env;
static Register val;
static Register cont;
static Register proc;
static Register argl;
static Register unev;
static Register level;


static void initRepl(void)
{
    exp   = regAllocate("exp");
    env   = regAllocate("env");
    val   = regAllocate("val");
    cont  = regAllocate("continue");
    proc  = regAllocate("proc");
    argl  = regAllocate("argl");
    unev  = regAllocate("unev");
    level = regAllocate("level"); /* used in quasiquote handling */
}

/* These are the primitives the "repl.reg" register machine
 * simulator program uses
 */
static void addPrimitives(void)
{
    /* syntax.c */
    rsAddPrimitive("self-evaluating?",         isSelfEvaluating_if);
    rsAddPrimitive("quoted?",                  isQuote_if);
    rsAddPrimitive("text-of-quotation",        textOfQuotation_if);
    rsAddPrimitive("quasiquote?",              isQuasiquote_if);
    rsAddPrimitive("unquote?",                 isUnquote_if);
    rsAddPrimitive("unquote-splicing?",        isUnquoteSplicing_if);
    rsAddPrimitive("variable?",                isVariable_if);
    rsAddPrimitive("assignment?",              isAssignment_if);
    rsAddPrimitive("assignment-variable",      assignmentVariable_if);
    rsAddPrimitive("assignment-value",         assignmentValue_if);
    rsAddPrimitive("definition?",              isDefinition_if);
    rsAddPrimitive("definition-variable",      definitionVariable_if);
    rsAddPrimitive("definition-value",         definitionValue_if);
    rsAddPrimitive("lambda?",                  isLambda_if);
    rsAddPrimitive("lambda-parameters",        lambdaParameters_if);
    rsAddPrimitive("lambda-body",              lambdaBody_if);
    rsAddPrimitive("if?",                      isIf_if);
    rsAddPrimitive("if-predicate",             ifPredicate_if);
    rsAddPrimitive("if-consequent",            ifConsequent_if);
    rsAddPrimitive("if-alternative",           ifAlternative_if);
    rsAddPrimitive("begin?",                   isBegin_if);
    rsAddPrimitive("begin-actions",            beginActions_if);
    rsAddPrimitive("last-exp?",                isLastExp_if);
    rsAddPrimitive("first-exp",                firstExp_if);
    rsAddPrimitive("rest-exps",                restExps_if);
    rsAddPrimitive("application?",             isApplication_if);
    rsAddPrimitive("operator",                 operator_if);
    rsAddPrimitive("operands",                 operands_if);
    rsAddPrimitive("no-operands?",             isNoOperands_if);
    rsAddPrimitive("first-operand",            firstOperand_if);
    rsAddPrimitive("rest-operands",            restOperands_if);
    rsAddPrimitive("empty-arglist",            emptyArglist_if);
    rsAddPrimitive("last-operand?",            isLastOperand_if);
    rsAddPrimitive("no-more-exps?",            isNoMoreExps_if);
    rsAddPrimitive("let?",                     isLet_if);
    rsAddPrimitive("let->combination",         let2combination_if);
    rsAddPrimitive("let*?",                    isLetx_if);
    rsAddPrimitive("let*->nested-lets",        letx2nestedLets_if);
    rsAddPrimitive("letrec?",                  isLetrec_if);
    rsAddPrimitive("letrec->let",              letrec2let_if);
    rsAddPrimitive("cond?",                    isCond_if);
    rsAddPrimitive("cond->if",                 cond2if_if);
    rsAddPrimitive("and?",                     isAnd_if);
    rsAddPrimitive("and-expressions",          andExpressions_if);
    rsAddPrimitive("or?",                      isOr_if);
    rsAddPrimitive("or-expressions",           orExpressions_if);
    rsAddPrimitive("no-expressions?",          isNoExpressions_if);
    rsAddPrimitive("last-expression?",         isLastExpression_if);
    rsAddPrimitive("first-expression",         firstExpression_if);
    rsAddPrimitive("rest-expressions",         restExpressions_if);
    rsAddPrimitive("make-procedure",           makeProcedure_if);
    rsAddPrimitive("compound-procedure?",      isCompoundProcedure_if);
    rsAddPrimitive("procedure-parameters",     procedureParameters_if);
    rsAddPrimitive("procedure-body",           procedureBody_if);
    rsAddPrimitive("procedure-environment",    procedureEnvironment_if);
    rsAddPrimitive("make-compiled-procedure",  makeCompiledProcedure_if);
    rsAddPrimitive("compiled-procedure-entry", compiledProcedureEntry_if);
    rsAddPrimitive("compiled-procedure-env",   compiledProcedureEnv_if);
    rsAddPrimitive("compiled-procedure?",      isCompiledProcedure_if);

    rsAddPrimitive("delay?",                   isDelay_if);
    rsAddPrimitive("delay-expression",         delayExpression_if);

    /* env.c */
    rsAddPrimitive("extend-environment",       extendEnvironment_if);
    rsAddPrimitive("lookup-variable-value",    lookupVariableValue_if);
    rsAddPrimitive("set-variable-value!",      setVariableValue_if);
    rsAddPrimitive("define-variable!",         defineVariable_if);
    rsAddPrimitive("get-global-environment",   interactionEnvironment_if);

    /* support */
    rsAddPrimitive("user-print",               userPrint_if);
}

void regsimInit(void)
{
    initEnvironment();
    initRepl(); 
    addPrimitives();
    setupEnvironment();
    interactionEnvironment(env);
}

void regsimExit(void)
{
}
