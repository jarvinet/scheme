#include <string.h>
#include <stdio.h>
#include <setjmp.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"
#include "eprint.h"
#include "util.h"

#include "symbol.h"
#include "null.h"
#include "boolean.h"
#include "pairpointer.h"
#include "string.h"
#include "number.h"
#include "character.h"


static bool isTaggedList(Register exp, char* tag)
{
    Register regSymbol = regGetTemp();
    Register listTag = regGetTemp();

    bool result = FALSE;

    if (regIsPairPointer(exp)) {
	regCar(listTag, exp);
	regMakeSymbol(regSymbol, tag);
	result = regIsEq(regSymbol, listTag);
    }

    regFreeTemp(regSymbol);
    regFreeTemp(listTag);
    return result;
}

/* syntax procedures */


/* Self-evaluating expressions */

bool regIsSelfEvaluating(Register exp)
{
    return (regIsNull(exp) ||
	    regIsNumber(exp) ||
	    regIsString(exp) ||
	    regIsCharacter(exp));
}

void isSelfEvaluating_if(Register result, Register operands)
{
    checkArgsEQ("self-evaluating?", "*", operands);
    regMakeBoolean(result, regIsSelfEvaluating(regArgs[0]));
}


/* Variables */
bool regIsVariable(Register reg)
{
    return regIsSymbol(reg);
}

void isVariable_if(Register result, Register operands)
{
    checkArgsEQ("variable?", "*", operands);
    regMakeBoolean(result, regIsVariable(regArgs[0]));
}


/* Quotations */

void isQuote_if(Register result, Register operands)
{
    checkArgsEQ("quoted?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "quote"));
}

static void textOfQuotation(Register result, Register exp)
{
                            /* (quote foo) */
    regCdr(result, exp);    /*       (foo) */
    regCar(result, result); /*        foo  */
}

void textOfQuotation_if(Register result, Register operands)
{
    checkArgsEQ("text-of-quotation", "p", operands);
    textOfQuotation(result, regArgs[0]);
}

void isQuasiquote_if(Register result, Register operands)
{
    checkArgsEQ("quasiquote?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "quasiquote"));
}

void isUnquote_if(Register result, Register operands)
{
    checkArgsEQ("unquote?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "unquote"));
}

void isUnquoteSplicing_if(Register result, Register operands)
{
    checkArgsEQ("unquote-splicing?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "unquote-splicing"));
}

static void makeQuote(Register result, Register text)
{
    Register regTag = regGetTemp();
    Register regNull = regGetTemp();

    regMakeNull(regNull);
    regMakeSymbol(regTag, "quote");
    cons(result, text, regNull);   /*       (text) */
    cons(result, regTag, result);  /* (quote text) */

    regFreeTemp(regTag);
    regFreeTemp(regNull);
}

/* Assignments */

void isAssignment_if(Register result, Register operands)
{
    checkArgsEQ("assignment?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "set!"));
}

static void assignmentVariable(Register result, Register exp)
{
                            /* (set! a 1) */
    regCdr(result, exp);    /*      (a 1) */
    regCar(result, result); /*       a    */
}

void assignmentVariable_if(Register result, Register operands)
{
    checkArgsEQ("assignment-variable", "p", operands);
    assignmentVariable(result, regArgs[0]);
}

static void assignmentValue(Register result, Register exp)
{
                            /* (set! a 1) */
    regCdr(result, exp);    /*      (a 1) */
    regCdr(result, result); /*        (1) */
    regCar(result, result); /*         1  */
}

void assignmentValue_if(Register result, Register operands)
{
    checkArgsEQ("assignment-value", "p", operands);
    assignmentValue(result, regArgs[0]);
}

static void
makeAssignment(Register result, Register variable, Register value)
{
    Register regTag = regGetTemp();
    Register regNull = regGetTemp();

    regMakeNull(regNull);
    regMakeSymbol(regTag, "set!");
    cons(result, value, regNull);
    cons(result, variable, result);
    cons(result, regTag, result);

    regFreeTemp(regTag);
    regFreeTemp(regNull);
}


/* Definitions */

void isDefinition_if(Register result, Register operands)
{
    checkArgsEQ("definition?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "define"));
}

/* (define foo ...)
 * (define (foo n) ...)
 */
static void definitionVariable(Register result, Register exp)
{
    regCdr(result, exp);
    regCar(result, result);
    if (!regIsSymbol(result))
	regCar(result, result);
}

void definitionVariable_if(Register result, Register operands)
{
    checkArgsEQ("definition-variable", "p", operands);
    definitionVariable(result, regArgs[0]);
}

static void
makeLambda(Register result, Register parameters, Register body)
{
    Register regTag = regGetTemp();

    regMakeSymbol(regTag, "lambda");
    cons(result, parameters, body);
    cons(result, regTag, result);

    regFreeTemp(regTag);
}

/*
 * (define foo 1)
 * (define (foo n) n)
 */
static void definitionValue(Register result, Register exp)
{
    Register regParameters = regGetTemp();
    Register regBody = regGetTemp();

    regCdr(result, exp);          /* (foo 1) */
    regCar(result, result);       /*  foo    */
    if (regIsSymbol(result)) {
        regCdr(result, exp);      /* (foo 1) */
	regCdr(result, result);   /*     (1) */
	regCar(result, result);   /*      1  */
    } else {
	regCdr(regParameters, exp);
	regCar(regParameters, regParameters);
	regCdr(regParameters, regParameters);
	regCdr(regBody, exp);
	regCdr(regBody, regBody);
	makeLambda(result, regParameters, regBody);
    }

    regFreeTemp(regParameters);
    regFreeTemp(regBody);
}

void definitionValue_if(Register result, Register operands)
{
    checkArgsEQ("definition-value", "p", operands);
    definitionValue(result, regArgs[0]);
}

/* Lambda expressions */

void isLambda_if(Register result, Register operands)
{
    checkArgsEQ("definition-value", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "lambda"));
}

static void lambdaParameters(Register result, Register exp)
{
                            /* (lambda (pars) body) */
    regCdr(result, exp);    /*        ((pars) body) */
    regCar(result, result); /*         (pars)       */
}

void lambdaParameters_if(Register result, Register operands)
{
    checkArgsEQ("lambda-parameters", "p", operands);
    lambdaParameters(result, regArgs[0]);
}

static void lambdaBody(Register result, Register exp)
{
                            /* (lambda (pars) body) */
    regCdr(result, exp);    /*        ((pars) body) */
    regCdr(result, result); /*               (body) */
}

void lambdaBody_if(Register result, Register operands)
{
    checkArgsEQ("lambda-body", "p", operands);
    lambdaBody(result, regArgs[0]);
}


/* Conditionals */

void isIf_if(Register result, Register operands)
{
    checkArgsEQ("if?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "if"));
}

static void ifPredicate(Register result, Register exp)
{
                            /* (if predicate consequent alternative) */
    regCdr(result, exp);    /*    (predicate consequent alternative) */
    regCar(result, result); /*     predicate                         */
}

void ifPredicate_if(Register result, Register operands)
{
    checkArgsEQ("if-predicate", "*", operands);
    ifPredicate(result, regArgs[0]);
}

static void ifConsequent(Register result, Register exp)
{
                            /* (if predicate consequent alternative) */
    regCdr(result, exp);    /*    (predicate consequent alternative) */
    regCdr(result, result); /*              (consequent alternative) */
    regCar(result, result); /*               consequent              */
}

void ifConsequent_if(Register result, Register operands)
{
    checkArgsEQ("if-consequent", "*", operands);
    ifConsequent(result, regArgs[0]);
}

static void ifAlternative(Register result, Register exp)
{
                            /* (if predicate consequent alternative) */
    regCdr(result, exp);    /*    (predicate consequent alternative) */
    regCdr(result, result); /*              (consequent alternative) */
    regCdr(result, result); /*                         (alternative) */
    if (!regIsNull(result))
	regCar(result, result); /*                      alternative  */
    else
	regMakeSymbol(result, "false"); /*              false        */
}

void ifAlternative_if(Register result, Register operands)
{
    checkArgsEQ("if-alternative", "*", operands);
    ifAlternative(result, regArgs[0]);
}

static void
makeIf(Register result, Register predicate, Register consequent, Register alternative)
{
    Register regTag = regGetTemp();
    Register regNull = regGetTemp();

    regMakeSymbol(regTag, "if");
    regMakeNull(regNull);
    cons(result, alternative, regNull);
    cons(result, consequent, result);
    cons(result, predicate, result);
    cons(result, regTag, result);

    regFreeTemp(regTag);
    regFreeTemp(regNull);
}

void makeIf_if(Register result, Register operands)
{
    checkArgsEQ("make-if", "***", operands);
    makeIf(result, regArgs[0], regArgs[1], regArgs[2]);
}


/* Begin */

void isBegin_if(Register result, Register operands)
{
    checkArgsEQ("begin?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "begin"));
}

static void beginActions(Register result, Register exp)
{
                         /* (begin actions) */
    regCdr(result, exp); /*       (actions) */
}

void beginActions_if(Register result, Register operands)
{
    checkArgsEQ("begin-actions", "p", operands);
    beginActions(result, regArgs[0]);
}

static void isLastExp(Register result, Register exp)
{
    regCdr(result, exp);
    regMakeBoolean(result, regIsNull(result));
}

void isLastExp_if(Register result, Register operands)
{
    checkArgsEQ("last-exp?", "*", operands);
    isLastExp(result, regArgs[0]);
}

static void firstExp(Register result, Register exp)
{
    regCar(result, exp);
}

void firstExp_if(Register result, Register operands)
{
    checkArgsEQ("first-exp", "p", operands);
    firstExp(result, regArgs[0]);
}

static void restExps(Register result, Register exp)
{
    regCdr(result, exp);
}

void restExps_if(Register result, Register operands)
{
    checkArgsEQ("rest-exps", "p", operands);
    restExps(result, regArgs[0]);
}

static void makeBegin(Register result, Register seq)
{
    Register regTag = regGetTemp();

    regMakeSymbol(regTag, "begin");
    cons(result, regTag, seq);

    regFreeTemp(regTag);
}

void makeBegin_if(Register result, Register operands)
{
    checkArgsEQ("make-begin", "p", operands);
    makeBegin(result, regArgs[0]);
}

static void sequence2exp(Register result, Register seq)
{
    if (regIsNull(seq))
	regCopy(result, seq);
    else {
	isLastExp(result, seq);
	if (regIsTrue(result))
	    firstExp(result, seq);
	else
	    makeBegin(result, seq);
    }
}

void sequence2exp_if(Register result, Register operands)
{
    checkArgsEQ("sequence->exp", "p", operands);
    sequence2exp(result, regArgs[0]);
}


/* Procedure application */

void isApplication_if(Register result, Register operands)
{
    checkArgsEQ("application?", "*", operands);
    regMakeBoolean(result, regIsPairPointer(regArgs[0]));
}

static void operator(Register result, Register exp)
{
                         /* (operator operand1 operand2) */
    regCar(result, exp); /*  operator                    */
}

void operator_if(Register result, Register operands)
{
    checkArgsEQ("operator", "p", operands);
    operator(result, regArgs[0]);
}

static void operands(Register result, Register exp)
{
                         /* (operator operand1 operand2) */
    regCdr(result, exp); /*          (operand1 operand2) */
}

void operands_if(Register result, Register perands)
{
    checkArgsEQ("operands", "p", perands);
    operands(result, regArgs[0]);
}

void isNoOperands_if(Register result, Register operands)
{
    checkArgsEQ("no-operands?", "*", operands);
    regMakeBoolean(result, regIsNull(regArgs[0]));
}

void firstOperand_if(Register result, Register operands)
{
    checkArgsEQ("first-operand", "p", operands);
    regCar(result, regArgs[0]);
}

void restOperands_if(Register result, Register operands)
{
    checkArgsEQ("rest-operands", "p", operands);
    regCdr(result, regArgs[0]);
}

static void isLastOperand(Register result, Register ops)
{
    regCdr(result, ops);
    regMakeBoolean(result, regIsNull(result));
}

void isLastOperand_if(Register result, Register operands)
{
    checkArgsEQ("last-operand?", "p", operands);
    isLastOperand(result, regArgs[0]);
}

void emptyArglist_if(Register result, Register operands)
{
    checkArgsEQ("empty-arglist", "", operands);
    regMakeNull(result);
}

void isNoMoreExps_if(Register result, Register operands)
{
    checkArgsEQ("no-more-exps?", "*", operands);
    regMakeBoolean(result, regIsNull(regArgs[0]));
}


/* Compound procedures */

static void
makeProcedure(Register result, Register parameters, Register body, Register env)
{
    Register regTag = regGetTemp();

    regMakeSymbol(regTag, "procedure");
    cons(result, body, env);
    cons(result, parameters, result);
    cons(result, regTag, result);

    regFreeTemp(regTag);
}

void makeProcedure_if(Register result, Register operands)
{
    /* operands: parameters body env */
    checkArgsEQ("make-procedure", "*pp", operands);
    makeProcedure(result, regArgs[0], regArgs[1], regArgs[2]);
}

bool regIsCompoundProcedure(Register obj)
{
    return isTaggedList(obj, "procedure");
}

void isCompoundProcedure_if(Register result, Register operands)
{
    checkArgsEQ("compound-procedure?", "*", operands);
    regMakeBoolean(result, regIsCompoundProcedure(regArgs[0]));
}

void procedureParameters(Register result, Register procedure)
{
                               /* (procedure parameters body env) */
    regCdr(result, procedure); /*           (parameters body env) */
    regCar(result, result);    /*            parameters           */
}

void procedureParameters_if(Register result, Register operands)
{
    checkArgsEQ("procedure-parameters", "*", operands);
    procedureParameters(result, regArgs[0]);
}

void procedureBody(Register result, Register procedure)
{
                               /* (procedure parameters body env) */
    regCdr(result, procedure); /*           (parameters body env) */
    regCdr(result, result);    /*                      (body env) */
    regCar(result, result);    /*                       body      */
}

void procedureBody_if(Register result, Register operands)
{
    checkArgsEQ("procedure-body", "*", operands);
    procedureBody(result, regArgs[0]);
}

static void procedureEnvironment(Register result, Register procedure)
{
                               /* (procedure parameters body env) */
    regCdr(result, procedure); /*           (parameters body env) */
    regCdr(result, result);    /*                      (body env) */
    regCdr(result, result);    /*                           (env) */
}

void procedureEnvironment_if(Register result, Register operands)
{
    checkArgsEQ("procedure-environment", "*", operands);
    procedureEnvironment(result, regArgs[0]);
}

/* Compiled procedures */

static void makeCompiledProcedure(Register result, Register entry, Register env)
{
    Register regTag = regGetTemp();

    regMakeSymbol(regTag, "compiled-procedure");
    cons(result, entry, env);
    cons(result, regTag, result);

    regFreeTemp(regTag);
}

void makeCompiledProcedure_if(Register result, Register operands)
{
    /* operands: entry-label env */

    checkArgsEQ("make-compiled-procedure", "np", operands);
    makeCompiledProcedure(result, regArgs[0], regArgs[1]);
}

bool regIsCompiledProcedure(Register obj)
{
    return isTaggedList(obj, "compiled-procedure");
}

void isCompiledProcedure_if(Register result, Register operands)
{
    checkArgsEQ("compiled-procedure?", "*", operands);
    regMakeBoolean(result, regIsCompiledProcedure(regArgs[0]));
}

static void compiledProcedureEntry(Register result, Register procedure)
{
                               /* (compiled-procedure entry env) */
    regCdr(result, procedure); /*                    (entry env) */
    regCar(result, result);    /*                     entry      */
}

void compiledProcedureEntry_if(Register result, Register operands)
{
    checkArgsEQ("compiled-procedure-entry", "*", operands);
    compiledProcedureEntry(result, regArgs[0]);
}

/* TODO: why we return the env in list? */
static void compiledProcedureEnv(Register result, Register procedure)
{
                               /* (compiled-procedure entry env) */
    regCdr(result, procedure); /*                    (entry env) */
    regCdr(result, result);    /*                          (env) */
}

void compiledProcedureEnv_if(Register result, Register operands)
{
    checkArgsEQ("compiled-procedure-env", "*", operands);
    compiledProcedureEnv(result, regArgs[0]);
}

bool regIsProcedure(Register reg)
{
    return (regIsPrimitive(reg) ||
	    regIsContinuation(reg) ||
	    regIsCompoundProcedure(reg) ||
	    regIsCompiledProcedure(reg));
}

void isProcedure_if(Register result, Register operands)
{
    checkArgsEQ("procedure?", "*", operands);
    regMakeBoolean(result, regIsProcedure(regArgs[0]));
}

/* let */

void isLet_if(Register result, Register operands)
{
    checkArgsEQ("let?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "let"));
}

/*
 * Return the variables of the let special form:
 *
 * (let ((a 1)
 *       (b 2))
 *   )
 *
 * returns (a b)
 *
 */
static void letVariables(Register result, Register exp)
{
    Register regLooper = regGetTemp();
    Register regVar = regGetTemp();

    regMakeNull(result);
    regCdr(regLooper, exp);
    regCar(regLooper, regLooper);
    
    while (!regIsNull(regLooper)) {
	regCar(regVar, regLooper);
	regCar(regVar, regVar);
	snoc(result, result, regVar);
	regCdr(regLooper, regLooper);
    }

    regFreeTemp(regLooper);
    regFreeTemp(regVar);
}

/*
 * Return the expressions of the let special form:
 *
 * (let ((a 1)
 *       (b 2))
 *   )
 *
 * returns (1 2)
 *
 */
static void letExpressions(Register result, Register exp)
{
    Register regLooper = regGetTemp();
    Register regExpression = regGetTemp();

    regMakeNull(result);
    regCdr(regLooper, exp);
    regCar(regLooper, regLooper);
    
    while (!regIsNull(regLooper)) {
	regCar(regExpression, regLooper);
	regCdr(regExpression, regExpression);
	regCar(regExpression, regExpression);
	snoc(result, result, regExpression);
	regCdr(regLooper, regLooper);
    }

    regFreeTemp(regLooper);
    regFreeTemp(regExpression);
}

/*
 * Return the bindings of the let special form:
 *
 * (let ((a 1)
 *       (b 2))
 *   (+ a b))
 *
 * returns ((a 1) (b 2))
 *
 */
static void letBindings(Register result, Register exp)
{
                            /* (let ((v 1)) (body)) */
    regCdr(result, exp);    /*     (((v 1)) (body)) */
    regCar(result, result); /*      ((v 1))         */
}

/*
 * Return the body of the let special form:
 *
 * (let ((a 1)
 *       (b 2))
 *   (+ a b))
 *
 * returns ((+ a b))
 *
 */
static void letBody(Register result, Register exp)
{
                            /* (let ((v 1)) (body)) */
    regCdr(result, exp);    /*     (((v 1)) (body)) */
    regCdr(result, result); /*             ((body)) */
}

static void
makeLet(Register result, Register bindings, Register body)
{
    Register regTag = regGetTemp();

    regMakeSymbol(regTag, "let");
    cons(result, bindings, body);
    cons(result, regTag, result);

    regFreeTemp(regTag);
}

/*
 * let2combination: convert a let into a combination,
 * for example this:
 *
 * (let ((a 1)
 *       (b 2))
 *   (+ a b))
 * 
 * is converted into this:
 * 
 * ((lambda (a b) (+ a b)) 1 2)
 * 
 */
static void let2combination(Register result, Register exp)
{
    Register regVariables = regGetTemp();
    Register regExpressions = regGetTemp();
    Register regBody = regGetTemp();

    letVariables(regVariables, exp);
    letExpressions(regExpressions, exp);
    letBody(regBody, exp);
    makeLambda(result, regVariables, regBody);
    cons(result, result, regExpressions);

    regFreeTemp(regExpressions);
    regFreeTemp(regVariables);
    regFreeTemp(regBody);
}

void let2combination_if(Register result, Register operands)
{
    checkArgsEQ("let->combination", "p", operands);
    let2combination(result, regArgs[0]);
}

/* let* 
 */
void isLetx_if(Register result, Register operands)
{
    checkArgsEQ("let*?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "let*"));
}

/* Note: recursive function: if nested deeply enough
 * we will run out of dynamic registers
 */
static void
expandBindings(Register result, Register bindings, Register body)
{
    Register regFirstBinding = regGetTemp();
    Register regRestBindings = regGetTemp();
    Register regLet = regGetTemp();
    Register regNull = regGetTemp();

    regMakeNull(regNull);

    if (regIsNull(bindings)) {
        regCopy(result, body);
    } else {
	regCdr(regRestBindings, bindings);
	expandBindings(regLet, regRestBindings, body);
        regCar(regFirstBinding, bindings);
	cons(regFirstBinding, regFirstBinding, regNull);
        makeLet(result, regFirstBinding, regLet);
	cons(result, result, regNull);
    }

    regFreeTemp(regFirstBinding);
    regFreeTemp(regRestBindings);
    regFreeTemp(regLet);
    regFreeTemp(regNull);
}

/*
 * letx2nestedLets: convert a let* into a nested lets
 * for example this:
 *
 * (let* ((a 1)
 *        (b 2))
 *   (+ a b))
 * 
 * is converted into this:
 *
 * (let ((a 1))
 *  (let ((b 2))
 *   (+ a b)))
 *
 */
static void letx2nestedLets(Register result, Register exp)
{
    Register regBindings = regGetTemp();
    Register regBinding = regGetTemp();
    Register regBody = regGetTemp();
    Register regLooper = regGetTemp();
    
    letBindings(regBindings, exp); /* ((a 1) (b 2)) */
    letBody(regBody, exp);         /* ((+ a b))     */

    expandBindings(result, regBindings, regBody);
    regCar(result, result);

    regFreeTemp(regBindings);
    regFreeTemp(regBinding);
    regFreeTemp(regBody);
    regFreeTemp(regLooper);
}

void letx2nestedLets_if(Register result, Register operands)
{
    checkArgsEQ("let*->nested-lets", "p", operands);
    letx2nestedLets(result, regArgs[0]);
}

/* letrec */

void isLetrec_if(Register result, Register operands)
{
    checkArgsEQ("letrec?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "letrec"));
}


/*
 * letrec2let: convert a letrec into a let. For example this:
 *
 * (letrec ((even?
 *           (lambda (n)
 *            (if (zero? n)
 *                 #t
 *                 (odd? (- n 1)))))
 *          (odd?
 *           (lambda (n)
 *            (if (zero? n)
 *                #f
 *                (even? (- n 1))))))
 *   (even? 88))
 * 
 * Is converted into this:
 * 
 * (let ((even? (quote *unassigned*))
 *       (odd? (quote *unassigned*)))
 *   (set! odd?
 * 	(lambda (n)
 * 	  (if (zero? n)
 * 	      false
 * 	      (even? (- n 1)))))
 *   (set! even?
 * 	(lambda (n)
 * 	  (if (zero? n)
 * 	      true
 * 	      (odd? (- n 1)))))
 *   (even? 88))
 *
 */
static void letrec2let(Register result, Register exp)
{
    Register regVariables = regGetTemp();
    Register regValues = regGetTemp();
    Register regBody = regGetTemp();
    Register regVariable = regGetTemp();
    Register regValue = regGetTemp();
    Register regBindings = regGetTemp();
    Register regBinding = regGetTemp();
    Register regAssignment = regGetTemp();
    Register regLooper = regGetTemp();
    Register regLooper2 = regGetTemp();
    Register regNull = regGetTemp();

    letVariables(regVariables, exp);
    letExpressions(regValues, exp);
    letBody(regBody, exp);
    regMakeNull(regNull);

    regMakeNull(regBindings);
    regCopy(regLooper, regVariables);
    while (!regIsNull(regLooper)) {
        regMakeSymbol(regVariable, "*unassigned*");
	makeQuote(regVariable, regVariable);
	cons(regBinding, regVariable, regNull);
	regCar(regVariable, regLooper);
	cons(regBinding, regVariable, regBinding);
	snoc(regBindings, regBindings, regBinding);
	regCdr(regLooper, regLooper);
    }
    regCopy(regLooper, regVariables);
    regCopy(regLooper2, regValues);
    while (!regIsNull(regLooper)) {
        regCar(regVariable, regLooper);
	regCar(regValue, regLooper2);
        makeAssignment(regAssignment, regVariable, regValue);
	cons(regBody, regAssignment, regBody);
	regCdr(regLooper, regLooper);
	regCdr(regLooper2, regLooper2);
    }

    makeLet(result, regBindings, regBody);

    regFreeTemp(regVariables);
    regFreeTemp(regValues);
    regFreeTemp(regBody);
    regFreeTemp(regVariable);
    regFreeTemp(regValue);
    regFreeTemp(regBindings);
    regFreeTemp(regBinding);
    regFreeTemp(regAssignment);
    regFreeTemp(regLooper);
    regFreeTemp(regLooper2);
    regFreeTemp(regNull);
}

void letrec2let_if(Register result, Register operands)
{
    checkArgsEQ("letrec->let", "p", operands);
    letrec2let(result, regArgs[0]);
}


/* Cond */

void isCond_if(Register result, Register operands)
{
    checkArgsEQ("cond?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "cond"));
}

static void expandClauses(Register result, Register clauses)
{
    Register regActions = regGetTemp();
    Register regFirst = regGetTemp();
    Register regRest = regGetTemp();
    Register regPredicate = regGetTemp();
    Register regConsequent = regGetTemp();
    Register regAlternative = regGetTemp();

    if (regIsNull(clauses))
	regMakeSymbol(result, "false");
    else {
	regCar(regFirst, clauses);
	regCdr(regRest, clauses);
	if (isTaggedList(regFirst, "else")) {
	    if (regIsNull(regRest)) {
		regCdr(regActions, regFirst);
		sequence2exp(result, regActions);
	    } else {
		eprintf("else clause is not last\n");
	    }
	} else {
	    regCar(regPredicate, regFirst);
	    regCdr(regActions, regFirst);
	    sequence2exp(regConsequent, regActions);
	    //save2(regPredicate);
	    //save2(regConsequent);
	    expandClauses(regAlternative, regRest);
	    //restore2(regConsequent);
	    //restore2(regPredicate);
	    makeIf(result, regPredicate, regConsequent, regAlternative);
	}
    }

    regFreeTemp(regActions);
    regFreeTemp(regFirst);
    regFreeTemp(regRest);
    regFreeTemp(regPredicate);
    regFreeTemp(regConsequent);
    regFreeTemp(regAlternative);
}

/*
 * cond2if: convert a cond into if,
 * for example the following:
 *
 * (cond ((= a 1) 1)
 *       ((= a 2) 2)
 *       (else 3))
 * 
 * is converted into this:
 *
 * (if (= a 1)
 *     1
 *     (if (= a 2)
 *         2
 *         3))
 * 
 */
static void cond2if(Register result, Register exp)
{
    regCdr(exp, exp);
    expandClauses(result, exp);
}

void cond2if_if(Register result, Register operands)
{
    checkArgsEQ("cond->if", "p", operands);
    cond2if(result, regArgs[0]);
}

/* and, or */

void isAnd_if(Register result, Register operands)
{
    checkArgsEQ("and?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "and"));
}

static void andExpressions(Register result, Register exp)
{
                         /* (and expr1 expr2) */
    regCdr(result, exp); /*     (expr1 expr2) */
}

void andExpressions_if(Register result, Register operands)
{
    checkArgsEQ("and-expressions", "p", operands);
    andExpressions(result, regArgs[0]);
}

void isOr_if(Register result, Register operands)
{
    checkArgsEQ("or?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "or"));
}

static void orExpressions(Register result, Register exp)
{
                         /* (or expr1 expr2) */
    regCdr(result, exp); /*    (expr1 expr2) */
}

void orExpressions_if(Register result, Register operands)
{
    checkArgsEQ("or-expressions", "p", operands);
    orExpressions(result, regArgs[0]);
}

void isNoExpressions_if(Register result, Register operands)
{
    checkArgsEQ("no-expressions?", "*", operands);
    regMakeBoolean(result, regIsNull(regArgs[0]));
}

void firstExpression_if(Register result, Register operands)
{
    checkArgsEQ("first-expression", "p", operands);
    regCar(result, regArgs[0]);
}

void restExpressions_if(Register result, Register operands)
{
    checkArgsEQ("last-expression", "p", operands);
    regCdr(result, regArgs[0]);
}

static void isLastExpression(Register result, Register exps)
{
    regCdr(result, exps);
    regMakeBoolean(result, regIsNull(result));
}

void isLastExpression_if(Register result, Register operands)
{
    checkArgsEQ("last-expression?", "p", operands);
    isLastExpression(result, regArgs[0]);
}

void isDelay_if(Register result, Register operands)
{
    checkArgsEQ("delay?", "*", operands);
    regMakeBoolean(result, isTaggedList(regArgs[0], "delay"));
}

static void delayExpression(Register result, Register exp)
{
                            /* (delay <expression>) */
    regCdr(result, exp);    /*       (<expression>) */
    regCar(result, result); /*        <expression>  */
}

void delayExpression_if(Register result, Register operands)
{
    checkArgsEQ("delay-expression", "p", operands);
    delayExpression(result, regArgs[0]);
}
