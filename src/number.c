#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"

#include "number.h"
#include "util.h"
#include "boolean.h"
#include "sstring.h"


Object objMakeNumber(int value)
{
    Object obj;
    obj.type = OBJTYPE_NUMBER;
    obj.u.number = value;
    return obj;
}

void regMakeNumber(Register reg, int value)
{
    regWrite(reg, objMakeNumber(value));
}

int objGetNumber(Object obj)
{
    assert(objIsNumber(obj));
    return obj.u.number;
}

int regGetNumber(Register reg)
{
    return objGetNumber(regRead(reg));
}

void objDisplayNumber(Object obj, FILE* file)
{
    fprintf(file, "%d", objGetNumber(obj));
}

void objWriteNumber(Object obj, FILE* file)
{
    objDisplayNumber(obj, file);
}

static void number2string(Register result, Register number)
{
    char string[32];
    sprintf(string, "%d", regGetNumber(number));
    regMakeString(result, estrdup(string));
}

void number2string_if(Register result, Register operands)
{
    checkArgsEQ("number->string", "n", operands);
    number2string(result, regArgs[0]);
}

bool objIsEqNumber(Object o1, Object o2)
{
    return (objGetNumber(o1) == objGetNumber(o2));
}

bool objIsEqualNumber(Object o1, Object o2)
{
    return objIsEqNumber(o1, o2);
}
