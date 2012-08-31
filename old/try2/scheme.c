#include <stdio.h>

#include "hash.h"
#include "object.h"
#include "memory.h"
#include "obarray.h"
#include "read.h"
#include "eval.h"
#include "env.h"
#include "util.h"
#include "primitives.h"


static unsigned int memorySize;


static Object foo(int i)
{
    return (i <= 0) ? makeNull() : cons(makeNumber(i), foo(i-1));
}

static void pr(void)
{
    dumpMemory((memorySize>16)?16:memorySize);
    dumpRegisters();
    printRegisters();
}


static void
defVar(Object var, Object val)
{
    setReg(regUnev, var);
    setReg(regVal,  val);
    defineVariable();
}

static Object
setupEnvironment(void)
{
    Object initialEnv;

    setReg(regUnev, makeNull());
    setReg(regArgl, makeNull());
    setReg(regEnv,  theEmptyEnvironment());
    extendEnvironment();
    initialEnv = getReg(regEnv);

    defVar(makeSymbol("car"),  makePrimitive(car_si));
    defVar(makeSymbol("cdr"),  makePrimitive(cdr_si));
    defVar(makeSymbol("cons"),     makePrimitive(cons_si));
    defVar(makeSymbol("set-car!"), makePrimitive(setCar_si));
    defVar(makeSymbol("set-cdr!"), makePrimitive(setCdr_si));

    defVar(makeSymbol("true"), makeBoolean(TRUE));
    defVar(makeSymbol("false"), makeBoolean(FALSE));

    defVar(makeSymbol("caar"),  makePrimitive(caar_si));
    defVar(makeSymbol("cadr"),  makePrimitive(cadr_si));
    defVar(makeSymbol("cdar"),  makePrimitive(cdar_si));
    defVar(makeSymbol("cddr"),  makePrimitive(cddr_si));

    defVar(makeSymbol("pair?"),    makePrimitive(isPair_si));
    defVar(makeSymbol("symbol?"),  makePrimitive(isSymbol_si));
    defVar(makeSymbol("string?"),  makePrimitive(isString_si));
    defVar(makeSymbol("number?"),  makePrimitive(isNumber_si));
    defVar(makeSymbol("null?"),    makePrimitive(isNull_si));
    defVar(makeSymbol("boolean?"), makePrimitive(isBoolean_si));
    defVar(makeSymbol("eq?"),      makePrimitive(isEq_si));

    defVar(makeSymbol("="), makePrimitive(equal_si));
    defVar(makeSymbol("<"), makePrimitive(lessThan_si));
    defVar(makeSymbol(">"), makePrimitive(greaterThan_si));
    defVar(makeSymbol("+"), makePrimitive(plus_si));
    defVar(makeSymbol("-"), makePrimitive(minus_si));
    defVar(makeSymbol("*"), makePrimitive(mul_si));

    defVar(makeSymbol("load"), makePrimitive(load_si));

    defVar(makeSymbol("gc-messages?"), makePrimitive(isGcMessages_si));
    defVar(makeSymbol("set-gc-messages"), makePrimitive(setGcMessages_si));

    return initialEnv;
}


static void testGC(void)
{
    /* This test demonstrates the problem with the 
     * objects invalidated by the garbage collection.
     * The cons in line marked with *** causes gc.
     * The temporary object (created by C) that getReg("exp")
     * has returned is created before the gc. Then gc kicks in
     * and the data this object represents is suddenly invalid,
     * but it is still used as the argument to cons.
     * This causes an infinite loop in the register
     * printout.
     *
     * This should now work due to the changes in cons.
     */

    Register regFoo;

    memorySize = 16;

    initObarray();
    initMemory(memorySize);

    regFoo = allocateRegister("foo");

    pr();

    setReg(regFoo,  makeNull());
    setReg(regFoo,  cons(makeNumber(1), getReg(regFoo)));
    setReg(regFoo,  cons(makeNumber(2), getReg(regFoo)));
    cons(makeNumber(8), makeNumber(9));
    setReg(regFoo,  cons(makeNumber(3), getReg(regFoo)));

    pr();

    setReg(regFoo,  cons(makeNumber(4), getReg(regFoo))); /***/

    pr();
}

static void repl(void)
{
    memorySize = 10000;

    initObarray();
    initMemory(memorySize);

    regExp  = allocateRegister("exp");  /* hold expressions to be evaluated */
    regEnv  = allocateRegister("env");  /* the environment in which the evaluation is to be performed */
    regVal  = allocateRegister("val");  /* value of the evaluated expression */
    regCont = allocateRegister("cont"); /* to implement recursion */
    regProc = allocateRegister("proc"); /* for evaluating combinations */
    regArgl = allocateRegister("argl");
    regUnev = allocateRegister("unev");

    setReg(regEnv, setupEnvironment());

    if (isNull(loadFile("init.scm"))) {
	printf("cannot open file init.scm\n");
    }

    while (1) {
	printf("\ninput ==>\n");
	setReg(regExp, read());
	if (isEOF(getReg(regExp)))
	    break;
	eval();
	printf("\nvalue:\n");
	printObject(getReg(regVal));
	printf("\n");
    }
}

static void regsim(void)
{
    Object obj;

    memorySize = 10000;

    initObarray();
    initMemory(memorySize);

    regExp  = allocateRegister("exp");  /* hold expressions to be evaluated */
    regEnv  = allocateRegister("env");  /* the environment in which the evaluation is to be performed */
    regVal  = allocateRegister("val");  /* value of the evaluated expression */
    regCont = allocateRegister("cont"); /* to implement recursion */
    regProc = allocateRegister("proc"); /* for evaluating combinations */
    regArgl = allocateRegister("argl");
    regUnev = allocateRegister("unev");

#if 0
    setReg(regText, readFile("gcd.rms"));
    printObject(obj);
    printf("\n");
#endif

#if 0
    extractLabels();
    execute();
#endif
}

int
main(void)
{
#if 1
    repl();
#endif

#if 0
    testGC();
#endif

#if 0
    regsim();
#endif

    return 0;
}


