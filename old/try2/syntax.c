#include "hash.h"
#include "object.h"
#include "memory.h"
#include "util.h"


/* syntax procedures */


static unsigned int
isTaggedList(Object exp, Object tag)
{
    if (isPair(exp))
	return isEq(car(exp), tag);
    else
	return FALSE;
}


/* Self-evaluating expressions */

unsigned int
isSelfEvaluating(Object exp)
{
    if (isNumber(exp))
	return TRUE;
    else if (isString(exp))
	return TRUE;
    return FALSE;
}


/* Variables */

unsigned int
isVariable(Object exp)
{
    return isSymbol(exp);
}


/* Quotations */

unsigned int
isQuoted(Object exp)
{
    return isTaggedList(exp, makeSymbol("quote"));
}

Object
textOfQuotation(Object exp)
{
    return cadr(exp);
}


/* Assignments */

unsigned int
isAssignment(Object exp)
{
    return isTaggedList(exp, makeSymbol("set!"));
}

Object
assignmentVariable(Object exp)
{
    return cadr(exp);
}

Object
assignmentValue(Object exp)
{
    return caddr(exp);
}


/* Definitions */

unsigned int
isDefinition(Object exp)
{
    return isTaggedList(exp, makeSymbol("define"));
}

Object
definitionVariable(Object exp)
{
    return isSymbol(cadr(exp)) ? cadr(exp) : caadr(exp);
}

Object
makeLambda(Object parameters, Object body)
{
    return cons(makeSymbol("lambda"),
		cons(parameters, body));
}

Object
definitionValue(Object exp)
{
    if (isSymbol(cadr(exp)))
	return caddr(exp);
    else
	return makeLambda(cdadr(exp), cddr(exp));
}


/* Lambda expressions */

unsigned int
isLambda(Object exp)
{
    return isTaggedList(exp, makeSymbol("lambda"));
}

Object
lambdaParameters(Object exp)
{
    return cadr(exp);
}

Object
lambdaBody(Object exp)
{
    return cddr(exp);
}



/* Conditionals */

unsigned int
isIf(Object exp)
{
    return isTaggedList(exp, makeSymbol("if"));
}

Object
ifPredicate(Object exp)
{
    return cadr(exp);
}

Object
ifConsequent(Object exp)
{
    return caddr(exp);
}

Object
ifAlternative(Object exp)
{
    if (!isNull(cdddr(exp)))
	return cadddr(exp);
    else
	return makeSymbol("false");
}

Object
makeIf(Object predicate, Object consequent, Object alternative)
{
    return list(4, makeSymbol("if"), predicate, consequent, alternative);
}


/* Begin */

unsigned int
isBegin(Object exp)
{
    return isTaggedList(exp, makeSymbol("begin"));
}

Object
beginActions(Object exp)
{
    return cdr(exp);
}

unsigned int
isLastExp(Object seq)
{
    return isNull(cdr(seq));
}

Object
firstExp(Object seq)
{
    return car(seq);
}

Object
restExps(Object seq)
{
    return cdr(seq);
}

Object
makeBegin(Object seq)
{
    return cons(makeSymbol("begin"), seq);
}

Object
sequenceToExp(Object seq)
{
    if (isNull(seq))
	return seq;
    else if (isLastExp(seq))
	return firstExp(seq);
    else
	return makeBegin(seq);
}


/* Procedure application */

unsigned int
isApplication(Object exp)
{
    return isPair(exp);
}

Object
operator(Object exp)
{
    return car(exp);
}

Object
operands(Object exp)
{
    return cdr(exp);
}

unsigned int
isNoOperands(Object ops)
{
    return isNull(ops);
}

Object
firstOperand(Object ops)
{
    return car(ops);
}

Object
restOperands(Object ops)
{
    return cdr(ops);
}


/* Derived expression */



/* Evaluator data structures */


/* Compound procedures */

Object
makeProcedure(Object parameters, Object body, Object env)
{
    return list(4, makeSymbol("procedure"), parameters, body, env);
}

unsigned int
isCompoundProcedure(Object procedure)
{
    return isTaggedList(procedure, makeSymbol("procedure"));
}

Object
procedureParameters(Object procedure)
{
    return cadr(procedure);
}

Object
procedureBody(Object procedure)
{
    return caddr(procedure);
}

Object
procedureEnvironment(Object procedure)
{
    return cadddr(procedure);
}
