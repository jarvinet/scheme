#include "memory.h"
#include "read.h"


void cons_si(Register result, Register operands)
{
    checkArgsEQ("cons", "**", operands);
    cons(result, regArgs[0], regArgs[1]);
}

void snoc_si(Register result, Register operands)
{
    checkArgsEQ("adjoin-arg", "**", operands);
    /* the arguments are swapped on purpose */
    snoc(result, regArgs[1], regArgs[0]);
}

void car_si(Register result, Register operands)
{
    checkArgsEQ("car", "p", operands);
    car(result, regArgs[0]);
}

void cdr_si(Register result, Register operands)
{
    checkArgsEQ("cdr", "p", operands);
    cdr(result, regArgs[0]);
}

void setCar_si(Register result, Register operands)
{
    checkArgsEQ("set-car!", "p*", operands);
    setCar(regArgs[0], regArgs[1]);
}

void setCdr_si(Register result, Register operands)
{
    checkArgsEQ("set-cdr!", "p*", operands);
    setCdr(regArgs[0], regArgs[1]);
}

void applyPrimitive_si(Register result, Register operands)
{
    checkArgsEQ("apply-primitive-procedure", "rp", operands);
    applyPrimitive(result, regArgs[0], regArgs[1]);
}

void equal_si(Register result, Register operands)
{
    checkArgsEQ("=", "nn", operands);
    equal(result, regArgs[0], regArgs[1]);
}

void lessThan_si(Register result, Register operands)
{
    checkArgsEQ("<", "nn", operands);
    lessThan(result, regArgs[0], regArgs[1]);
}

void greaterThan_si(Register result, Register operands)
{
    checkArgsEQ(">", "nn", operands);
    greaterThan(result, regArgs[0], regArgs[1]);
}

void remainder_si(Register result, Register operands)
{
    checkArgsEQ("rem", "nn", operands);
    remainder(result, regArgs[0], regArgs[1]);
}

void plus_si(Register result, Register operands)
{
    checkArgsEQ("+", "nn", operands);
    plus(result, regArgs[0], regArgs[1]);
}

void minus_si(Register result, Register operands)
{
    checkArgsEQ("-", "nn", operands);
    minus(result, regArgs[0], regArgs[1]);
}

void printObject_si(Register result, Register operands)
{
    checkArgsEQ("display", "*", operands);
    printObject(regArgs[0]);
}

void newline_si(Register result, Register operands)
{
    checkArgsEQ("newline", "", operands);
    newline();
}

void read_si(Register result, Register operands)
{
    checkArgsEQ("read", "", operands);
    read(result);
}

void isPair_si(Register result, Register operands)
{
    checkArgsEQ("pair?", "*", operands);
    makeBoolean(result, isPair(regArgs[0]));
}

void isSymbol_si(Register result, Register operands)
{
    checkArgsEQ("symbol?", "*", operands);
    makeBoolean(result, isSymbol(regArgs[0]));
}

void isString_si(Register result, Register operands)
{
    checkArgsEQ("string?", "*", operands);
    makeBoolean(result, isString(regArgs[0]));
}

void isNumber_si(Register result, Register operands)
{
    checkArgsEQ("number?", "*", operands);
    makeBoolean(result, isNumber(regArgs[0]));
}

void isNull_si(Register result, Register operands)
{
    checkArgsEQ("null?", "*", operands);
    makeBoolean(result, isNull(regArgs[0]));
}

void isBoolean_si(Register result, Register operands)
{
    checkArgsEQ("boolean?", "*", operands);
    makeBoolean(result, isBoolean(regArgs[0]));
}

void isPrimitive_si(Register result, Register operands)
{
    checkArgsEQ("primitive?", "*", operands);
    makeBoolean(result, isPrimitive(regArgs[0]));
}

void isTrue_si(Register result, Register operands)
{
    checkArgsEQ("true?", "*", operands);
    makeBoolean(result, isTrue(regArgs[0]));
}

void isEOF_si(Register result, Register operands)
{
    checkArgsEQ("eof?", "*", operands);
    makeBoolean(result, isEOF(regArgs[0]));
}

void initStack_si(Register result, Register operands)
{
    checkArgsEQ("initialize-stack", "", operands);
    initStack();
}

