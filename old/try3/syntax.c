#include "memory.h"
#include "util.h"



/* syntax procedures */


/* Self-evaluating expressions */

void isSelfEvaluating(Register result, Register exp)
{
    makeBoolean(result, (isNumber(exp) || isString(exp)));
}


/* Variables */

void isVariable(Register result, Register exp)
{
    makeBoolean(result, isSymbol(exp));
}


/* Quotations */

void isQuoted(Register result, Register exp)
{
    makeBoolean(result, isTaggedList(exp, "quote"));
}

void textOfQuotation(Register result, Register exp)
{
    cdr(result, exp);
    car(result, result);
}


/* Assignments */

void isAssignment(Register result, Register exp)
{
    makeBoolean(result, isTaggedList(exp, "set!"));
}

void assignmentVariable(Register result, Register exp)
{
    cdr(result, exp);
    car(result, result);
}

void assignmentValue(Register result, Register exp)
{
    cdr(result, exp);
    cdr(result, result);
    car(result, result);
}


/* Definitions */

void isDefinition(Register result, Register exp)
{
    makeBoolean(result, isTaggedList(exp, "define"));
}

/* (define foo ...)
 * (define (foo n) ...)
 */
void definitionVariable(Register result, Register exp)
{
    cdr(result, exp);
    car(result, result);
    if (!isSymbol(result))
	car(result, result);
}

static void makeLambda(Register result,
		       Register parameters, Register body)
{
    Register tag = reg0;
    save(reg0);
    makeSymbol(tag, "lambda");
    cons(result, parameters, body);
    cons(result, tag, result);
    restore(reg0);
}

/*
 * (define foo 1)
 * (define (foo n) n)
 */
void definitionValue(Register result, Register exp)
{
    Register params = reg0;
    Register body = reg1;

    cdr(result, exp);
    car(result, result);
    if (isSymbol(result)) {
	cdr(result, exp);
	cdr(result, result);
	car(result, result);
    } else {
	save(reg0);
	save(reg1);
	cdr(params, exp);
	car(params, params);
	cdr(params, params);
	cdr(rbody, exp);
	cdr(body, body);
	makeLambda(result, params, body);
	restore(reg1);
	restore(reg0);
    }
}


/* Lambda expressions */

void isLambda(Register result, Register exp)
{
    makeBoolean(result, isTaggedList(exp, "lambda"));
}

void lambdaParameters(Register result, Register exp)
{
    cdr(result, exp);
    car(result, result);
}

void lambdaBody(Register result, Register exp)
{
    cdr(result, exp);
    cdr(result, result);
}


/* Conditionals */

void isIf(Register result, Register exp)
{
    makeBoolean(result, isTaggedList(exp, "if"));
}

void ifPredicate(Register result, Register exp)
{
    cdr(result, exp);
    car(result, result);
}

void ifConsequent(Register result, Register exp)
{
    cdr(result, exp);
    cdr(result, result);
    car(result, result);
}

void ifAlternative(Register result, Register exp)
{
    cdr(result, exp);
    cdr(result, result);
    cdr(result, result);
    if (!isNull(result))
	car(result, result);
    else
	makeSymbol(result, "false");
}

void makeIf(Register result, Register predicate,
	    Register consequent, Register alternative)
{
    Register tag = reg0;
    save(reg0);
    makeSymbol(tag, "if");
    cons(result, consequent, alternative);
    cons(result, predicate, result);
    cons(result, tag, result);
    restore(reg0);
}


/* Begin */

void isBegin(Register result, Register exp)
{
    makeBoolean(result, isTaggedList(exp, "begin"));
}

void beginActions(Register result, Register exp)
{
    cdr(result, exp);
}

void isLastExp(Register result, Register exp)
{
    cdr(result, exp);
    makeBoolean(result, isNull(result));
}

void firstExp(Register result, Register exp)
{
    car(result, exp);
}

void restExps(Register result, Register exp)
{
    cdr(result, exp);
}

void makeBegin(Register result, Register seq)
{
    Register tag = reg0;
    save(reg0);
    makeSymbol(tag, "begin");
    cons(result, tag, seq);
    restore(reg0);
}

void sequenceToExp(Register result, Register seq)
{
    if (isNull(seq))
	copyReg(result, seq);
    else {
	isLastExp(result, seq);
	if (isTrue(result))
	    firstExp(result, seq);
	else
	    makeBegin(result, seq);
    }
}


/* Procedure application */

void isApplication(Register result, Register exp)
{
    makeBoolean(result, isPair(exp));
}

void operator(Register result, Register exp)
{
    car(result, exp);
}

void operands(Register result, Register exp)
{
    cdr(result, exp);
}

void isNoOperands(Register result, Register ops)
{
    makeBoolean(result, isNull(ops));
}

void firstOperand(Register result, Register ops)
{
    car(result, ops);
}

void restOperands(Register result, Register ops)
{
    cdr(result, ops);
}

void isLastOperand(Register result, Register ops)
{
    cdr(result, ops);
    makeBoolean(result, isNull(result));
}


/* Derived expression */



/* Evaluator data structures */


/* Compound procedures */

void makeProcedure(Register result, Register parameters,
		   Register body, Register env)
{
    Register tag = reg0;
    save(reg0);
    makeSymbol(tag, "procedure");
    cons(result, body, env);
    cons(result, parameters, result);
    cons(result, tag, result);
    restore(reg0);
}

void isCompoundProcedure(Register result, Register procedure)
{
    makeBoolean(result, isTaggedList(procedure, "procedure"));
}

void procedureParameters(Register result, Register procedure)
{
    cdr(result, procedure);
    car(result, result);
}

void procedureBody(Register result, Register procedure)
{
    cdr(result, procedure);
    cdr(result, result);
    car(result, result);
}

void procedureEnvironment(Register result, Register procedure)
{
    cdr(result, procedure);
    cdr(result, result);
    cdr(result, result);
    car(result, result);
}
