#include <stdio.h>
#include <setjmp.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"

#include "primitive.h"
#include "boolean.h"
#include "symbol.h"
#include "port.h"

#include "support.h"
#include "scscan.h"
#include "util.h"
#include "syntax.h"
#include "env.h"

#include "insts.h"
#include "regsim.h"


/*
user-print
  (test (op compound-procedure?) (reg val))
  (branch (label display-compound-procedure))
  (test (op compiled-procedure?) (reg val))
  (branch (label display-compiled-procedure))
  (perform (op display) (reg val))
  (goto (reg continue))
display-compound-procedure
  (perform (op display) (const "[compound-procedure]"))
  (goto (reg continue))
display-compiled-procedure
  (perform (op display) (const "[compiled-procedure]"))
  (goto (reg continue))
 */
#if 0
static void userPrint(Register result, Register object)
{
    isCompoundProcedure(result, object);
    if (regIsTrue(result)) {
	regMakeSymbol(result, "[compound-procedure]");
	regDisplayToCurrentPort(result);
    } else {
	isCompiledProcedure(result, object);
	if (regIsTrue(result)) {
	    regMakeSymbol(result, "[compiled-procedure]");
	    regDisplayToCurrentPort(result);
	} else {
	    regDisplayToCurrentPort(object);
	}
    }
}
#else
static void userPrint(Register result, Register object)
{
    if (regIsCompoundProcedure(object)) {
	regMakeSymbol(result, "[compound-procedure]");
	regDisplayToCurrentPort(result);
    } else {
	if (regIsCompiledProcedure(object)) {
	    regMakeSymbol(result, "[compiled-procedure]");
	    regDisplayToCurrentPort(result);
	} else {
	    regDisplayToCurrentPort(object);
	}
    }
}
#endif

void userPrint_if(Register result, Register operands)
{
    checkArgsEQ("user-print", "*", operands);
    userPrint(result, regArgs[0]);
}

#if 0
static void
eval(Register result, Register expression, Register environment)
{
    save(env);
    save(exp);
    save(unev);
    regMakeNumber(unev, rsGetPc());
    save(unev);
    regMakeNumber(cont, rsLookupLabel("exit-interpreter"));

    regCopy(env, environment);
    regCopy(exp, expression);    
    rsSetPc(rsLookupLabel("eval-dispatch"));
    rsExecInstSeq();

    restore(unev);
    rsSetPc(regGetNumber(unev));
    restore(unev);
    restore(exp);
    restore(env);
}

void eval_if(Register result, Register operands)
{
    /* (eval exp env) */
    checkArgsEQ("eval", "*p", operands);
    eval(result, regArgs[0], regArgs[1]);
}


/* "apply" works by entering the register machine simulator
 * recursively after setting up the required registers.
 * The continue register is set to a special label
 * "exit-interpreter" that is the last instruction in the
 * instruction sequence, causing the simulator to exit and
 * return into this function. The simulator uses entry point
 * "apply-dispatch" to do the actual application. We use
 * the register "exp" to save and restore the PC.
 */
static void
apply(Register result, Register procedure, Register arguments)
{
    save(exp);
    regMakeNumber(exp, rsGetPc());
    save(exp);
    regMakeNumber(cont, rsLookupLabel("exit-interpreter"));

    regCopy(proc, procedure);
    regCopy(argl, arguments);
    rsSetPc(rsLookupLabel("apply-dispatch-1"));
    rsExecInstSeq();

    restore(exp);
    rsSetPc(regGetNumber(exp));
    restore(exp);
}

void apply_if(Register result, Register operands)
{
    /* (apply proc args) */
    checkArgsEQ("apply", "**", operands);
    apply(result, regArgs[0], regArgs[1]);
}

static void load(Register result, Register filename)
{
    openInputFile(unev, filename);
    pushInputPort(unev);
    save(cont);
    save(env);
    save(unev);
    while (1) {
	readPort(exp, unev);
	if (regIsEOF(exp)) break;
	interactionEnvironment(env);
	eval(result, exp, env);
    }
    restore(unev);
    restore(env);
    restore(cont);
    popInputPort();
    regCloseInputPort(unev);
    regCopy(result, val);
}

void load_if(Register result, Register operands)
{
    /* (load "filename") */
    checkArgsEQ("load", "s", operands);
    load(result, regArgs[0]);
}


void repl(void)
{
    int retval;

    while (1) {
	if ((retval = setjmp(jumpBuffer)) == 0) {
	    initStack();
	    printf("\n;;; TMJ-Eval input:\n\n");
	    readCurrentPort(exp);
	    if (regIsEOF(exp)) break;
	    interactionEnvironment(env);
	    eval(val, exp, env);
	    printf("\n;;; TMJ-Eval value:\n\n");
	    pr(val);
	    printStackStatistics();
	} else {
	    printf("*** Reset\n");
	}
    }
}

#endif
