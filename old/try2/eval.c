#include "hash.h"
#include "object.h"
#include "memory.h"
#include "env.h"
#include "syntax.h"
#include "eval.h"


void evSelfEval(void)
{
    setReg(regVal, getReg(regExp));
}

void evVariable(void)
{
    setReg(regVal, lookupVariableValue(getReg(regExp), getReg(regEnv)));
}

void evQuoted(void)
{
    setReg(regVal, textOfQuotation(getReg(regExp)));
}

void evAssignment(void)
{
    setReg(regUnev, assignmentVariable(getReg(regExp)));
    save(regUnev);
    setReg(regExp, assignmentValue(getReg(regExp)));
    save(regEnv);
    /* save(regCont); */
    /* setReg(regCont, label("ev-assignment")); */
    /* goto(label("eval-dispatch")); */
    eval();
    /* restore(regCont); */
    restore(regEnv);
    restore(regUnev);
    setVariableValue(getReg(regUnev), getReg(regVal), getReg(regEnv));
    setReg(regVal, makeSymbol("ok"));
}

void evDefinition(void)
{
    setReg(regUnev, definitionVariable(getReg(regExp)));
    save(regUnev);
    setReg(regExp, definitionValue(getReg(regExp)));
    save(regEnv);
    /* save(regCont); */
    /* setReg(regCont, label("ev-assignment")); */
    /* goto(label("eval-dispatch")); */
    eval();
    /* restore(RegCont); */
    restore(regEnv);
    restore(regUnev);
    defineVariable();
    setReg(regVal, makeSymbol("ok"));
}

void evIf(void)
{
    save(regExp);
    save(regEnv);
    /* save(regCont); */
    /* setReg(regCont, label("ev-if-decide")); */
    setReg(regExp, ifPredicate(getReg(regExp)));
    /* goto(label("eval-dispatch")); */
    eval();
    /* restore(regCont); */
    restore(regEnv);
    restore(regExp);
    if (isTrue(getReg(regVal))) {
	setReg(regExp, ifConsequent(getReg(regExp)));
    } else {
	setReg(regExp, ifAlternative(getReg(regExp)));
    }
    eval();
}

void evLambda(void)
{
    setReg(regUnev, lambdaParameters(getReg(regExp)));
    setReg(regExp,  lambdaBody(getReg(regExp)));
    setReg(regVal,  makeProcedure(getReg(regUnev),
				  getReg(regExp),
				  getReg(regEnv)));
}

void
evSequence(void)
{
    while (!isNull(getReg(regUnev))) {
	setReg(regExp, firstExp(getReg(regUnev)));
	save(regUnev);
	save(regEnv);
	eval();
	restore(regEnv);
	restore(regUnev);
	setReg(regUnev, restExps(getReg(regUnev)));
    }
}

void
evBegin(void)
{
    setReg(regUnev, beginActions(getReg(regExp)));
    /* save(regCont); */
    evSequence();
}


void
applyPrimitiveProcedure(void)
{
    Object procedure = getReg(regProc);
    setReg(regVal, (*procedure.u.primitive)(getReg(regArgl)));
}


void
applyCompoundProcedure(void)
{
    setReg(regUnev, procedureParameters(getReg(regProc)));
    setReg(regEnv,  procedureEnvironment(getReg(regProc)));
    extendEnvironment();
    setReg(regUnev, procedureBody(getReg(regProc)));
    evSequence();
}

void
apply(void)
{
    if (isPrimitive(getReg(regProc)))
	applyPrimitiveProcedure();
    else if (isCompoundProcedure(getReg(regProc)))
	applyCompoundProcedure();
    else
	eprintf("apply: unknown procedure type");
	
}

static Object
emptyArglist(void)
{
    return makeNull();
}

#if 0
static Object
adjoinArg(Object arg, Object arglist)
{
    return append(arglist, list(1, arg));
}
#endif

static void
listOfValues(void)
{
    save(regProc);
    while (!isNull(getReg(regUnev))) {
	setReg(regExp, firstOperand(getReg(regUnev)));
	save(regArgl);
	save(regEnv);
	save(regUnev);
	eval();
	restore(regUnev);
	restore(regEnv);
	restore(regArgl);
	setReg(regVal,  cons(getReg(regVal), makeNull()));
	if (isNull(getReg(regArgl)))
	    setReg(regArgl, getReg(regVal));
	else
	    setReg(regArgl, appendBang(getReg(regArgl), getReg(regVal)));
	setReg(regUnev, restOperands(getReg(regUnev)));
    }
    restore(regProc);
    apply();
}


void evApplication(void)
{
    /* save(regCont); */
    save(regEnv);
    setReg(regUnev, operands(getReg(regExp)));
    save(regUnev);
    setReg(regExp, operator(getReg(regExp)));
    /* setReg(regCont, label("ev-appl-did-operator")); */
    eval();
    restore(regUnev);               /* the operands */
    restore(regEnv);
    setReg(regArgl, emptyArglist());
    setReg(regProc, getReg(regVal)); /* the operator */
    if (isNoOperands(getReg(regUnev))) {
	apply();
    } else {
	listOfValues();
    }
}


void
eval(void)
{
    if (isSelfEvaluating(getReg(regExp)))
	evSelfEval();
    else if (isVariable(getReg(regExp)))
	evVariable();
    else if (isQuoted(getReg(regExp)))
	evQuoted();
    else if (isAssignment(getReg(regExp)))
	evAssignment();
    else if (isDefinition(getReg(regExp)))
	evDefinition();
    else if (isIf(getReg(regExp)))
	evIf();
    else if (isLambda(getReg(regExp)))
	evLambda();
    else if (isBegin(getReg(regExp)))
	evBegin();
    else if (isApplication(getReg(regExp)))
	evApplication();
    else
	eprintf("Unknown expression type");
}
