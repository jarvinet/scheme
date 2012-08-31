#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"
#include "util.h"
#include "boolean.h"
#include "number.h"
#include "argcheck.h"


static void equal(Register result, Register r1, Register r2)
{
    regMakeBoolean(result, regGetNumber(r1) == regGetNumber(r2));
}

void equal_if(Register result, Register operands)
{
    checkArgsEQ("integer-equal", "nn", operands);
    equal(result, regArgs[0], regArgs[1]);
}

static void lessThan(Register result, Register r1, Register r2)
{
    regMakeBoolean(result, regGetNumber(r1) < regGetNumber(r2));
}

void lessThan_if(Register result, Register operands)
{
    checkArgsEQ("integer-less-than", "nn", operands);
    lessThan(result, regArgs[0], regArgs[1]);
}

static void greaterThan(Register result, Register r1, Register r2)
{
    regMakeBoolean(result, regGetNumber(r1) > regGetNumber(r2));
}

void greaterThan_if(Register result, Register operands)
{
    checkArgsEQ("integer-greater-than", "nn", operands);
    greaterThan(result, regArgs[0], regArgs[1]);
}

static void remainder(Register result, Register r1, Register r2)
{
    int n1 = regGetNumber(r1);
    int n2 = regGetNumber(r2);
    while (n1 >= n2) n1 -= n2;
    regMakeNumber(result, n1);
}

void remainder_if(Register result, Register operands)
{
    checkArgsEQ("remainder", "nn", operands);
    remainder(result, regArgs[0], regArgs[1]);
}

static void plus(Register result, Register r1, Register r2)
{
    regMakeNumber(result, regGetNumber(r1) + regGetNumber(r2));
}

void plus_if(Register result, Register operands)
{
    checkArgsEQ("integer-plus", "nn", operands);
    plus(result, regArgs[0], regArgs[1]);
}

static void minus(Register result, Register r1, Register r2)
{
    regMakeNumber(result, regGetNumber(r1) - regGetNumber(r2));
}

void minus_if(Register result, Register operands)
{
    checkArgsEQ("integer-minus", "nn", operands);
    minus(result, regArgs[0], regArgs[1]);
}

static void mul(Register result, Register r1, Register r2)
{
    regMakeNumber(result, regGetNumber(r1) * regGetNumber(r2));
}

void mul_if(Register result, Register operands)
{
    checkArgsEQ("integer-mul", "nn", operands);
    mul(result, regArgs[0], regArgs[1]);
}
