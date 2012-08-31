#include "hash.h"
#include "object.h"
#include "memory.h"
#include "util.h"
#include "read.h"

static void
checkArgsEQ(char* name, unsigned int nargs, Object args)
{
    unsigned int len = length(args);

    if (!(len == nargs))
	eprintf("%s should have exactly %d arguments", name, nargs);
}

static void
checkArgsLE(char* name, unsigned int nargs, Object args)
{
    unsigned int len = length(args);

    if (!(len <= nargs))
	eprintf("%s should have at most %d arguments", name, nargs);
}

static void
checkArgsGE(char* name, unsigned int nargs, Object args)
{
    unsigned int len = length(args);

    if (!(len >= nargs))
	eprintf("%s should have at least %d arguments", name, nargs);
}


/***********************************************************/


Object cons_si(Object args)
{
    checkArgsEQ("cons", 2, args);
    return cons(listRef(args, 0), listRef(args, 1));
}

Object car_si(Object args)
{
    checkArgsEQ("car", 1, args);
    return car(listRef(args, 0));
}

Object cdr_si(Object args)
{
    checkArgsEQ("cdr", 1, args);
    return cdr(listRef(args, 0));
}

Object
setCar_si(Object args)
{
    checkArgsEQ("set-car!", 2, args);
    setCar(listRef(args, 0), listRef(args, 1));
    return makeSymbol("ok");
}

Object
setCdr_si(Object args)
{
    checkArgsEQ("set-cdr!", 2, args);
    setCdr(listRef(args, 0), listRef(args, 1));
    return makeSymbol("ok");
}

Object
isPair_si(Object args)
{
    checkArgsEQ("pair?", 1, args);
    return makeBoolean(isPair(listRef(args, 0)));
}

Object
isSymbol_si(Object args)
{
    checkArgsEQ("symbol?", 1, args);
    return makeBoolean(isSymbol(listRef(args, 0)));
}

Object
isNumber_si(Object args)
{
    checkArgsEQ("number?", 1, args);
    return makeBoolean(isNumber(listRef(args, 0)));
}

Object
isNull_si(Object args)
{
    checkArgsEQ("null?", 1, args);
    return makeBoolean(isNull(listRef(args, 0)));
}

Object
isString_si(Object args)
{
    checkArgsEQ("string?", 1, args);
    return makeBoolean(isString(listRef(args, 0)));
}

Object
isBoolean_si(Object args)
{
    checkArgsEQ("boolean?", 1, args);
    return makeBoolean(isBoolean(listRef(args, 0)));
}

Object
isEq_si(Object args)
{
    checkArgsEQ("eq?", 2, args);
    return makeBoolean(isEq(listRef(args, 0), listRef(args, 1)));
}

Object
equal_si(Object args)
{
    if (isNull(args))
	return makeBoolean(TRUE);
    else if (isNull(cdr(args)))
	return makeBoolean(TRUE);
    else if (equal(car(args), cadr(args)))
	return equal_si(cdr(args));
    else
	return makeBoolean(FALSE);
}

Object
lessThan_si(Object args)
{
    if (isNull(args))
	return makeBoolean(TRUE);
    else if (isNull(cdr(args)))
	return makeBoolean(TRUE);
    else if (lessThan(car(args), cadr(args)))
	return lessThan_si(cdr(args));
    else
	return makeBoolean(FALSE);
}

Object
greaterThan_si(Object args)
{
    if (isNull(args))
	return makeBoolean(TRUE);
    else if (isNull(cdr(args)))
	return makeBoolean(TRUE);
    else if (greaterThan(car(args), cadr(args)))
	return greaterThan_si(cdr(args));
    else
	return makeBoolean(FALSE);
}

static int
plus(Object args)
{
    Object obj;
    Object num;
    int result = 0;

    for (obj = args; !isNull(obj); obj = cdr(obj)) {
	num = car(obj);
	result += num.u.number;
    }
    return (result);
}

Object
plus_si(Object args)
{
    return makeNumber(plus(args));
}

static int
minus(Object args)
{
    Object obj = args;
    Object num = car(obj);
    int result = num.u.number;

    for (obj = cdr(args); !isNull(obj); obj = cdr(obj)) {
	num = car(obj);
	result -= num.u.number;
    }
    return (result);
}

Object
minus_si(Object args)
{
    checkArgsGE("-", 2, args);
    return makeNumber(minus(args));
}

static int
mul(Object args)
{
    Object obj;
    Object num;
    int result = 1;

    for (obj = args; !isNull(obj); obj = cdr(obj)) {
	num = car(obj);
	result *= num.u.number;
    }
    return (result);
}

Object
mul_si(Object args)
{
    return makeNumber(mul(args));
}

Object caar_si(Object args)
{
    checkArgsEQ("caar", 1, args);
    return caar(listRef(args, 0));
}

Object cadr_si(Object args)
{
    checkArgsEQ("cadr", 1, args);
    return cadr(listRef(args, 0));
}

Object cdar_si(Object args)
{
    checkArgsEQ("cdar", 1, args);
    return cdar(listRef(args, 0));
}

Object cddr_si(Object args)
{
    checkArgsEQ("cddr", 1, args);
    return cddr(listRef(args, 0));
}


Object load_si(Object args)
{
    Object filename;
    checkArgsEQ("load", 1, args);
    filename = listRef(args, 0);
    if (!isString(filename))
	eprintf("load: argument not a string\n");
    return loadFile(filename.u.string);
}


Object isGcMessages_si(Object args)
{
    checkArgsEQ("gc-messages?", 0, args);
    return makeBoolean(isGcMessages());
}

Object setGcMessages_si(Object args)
{
    Object state;
    checkArgsEQ("set-gc-messages", 1, args);
    state = listRef(args, 0);
    if (isBoolean(state))
	eprintf("set-gc-messages: arg must be boolean\n");
    setGcMessages(state.u.boolean);
    return makeBoolean(isGcMessages());
}
