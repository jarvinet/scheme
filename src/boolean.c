#include <stdio.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"


Object objMakeBoolean(bool boolean)
{
    Object obj;
    obj.type = OBJTYPE_BOOLEAN;
    obj.u.boolean = boolean;
    return obj;
}

void regMakeBoolean(Register reg, bool boolean)
{
    regWrite(reg, objMakeBoolean(boolean));
}

bool objGetBoolean(Object obj)
{
    assert(objIsBoolean(obj));
    return obj.u.boolean;
}

bool regGetBoolean(Register reg)
{
    return objGetBoolean(regRead(reg));
}

bool objIsTrue(Object obj)
{
    return (objGetType(obj) == OBJTYPE_BOOLEAN) ? objGetBoolean(obj) : TRUE;
}

bool regIsTrue(Register reg)
{
    return objIsTrue(regRead(reg));
}

void isTrue_if(Register result, Register operands)
{
    checkArgsEQ("true?", "*", operands);
    regMakeBoolean(result, regIsTrue(regArgs[0]));
}

bool objIsFalse(Object obj)
{
    return (objGetType(obj) == OBJTYPE_BOOLEAN) ? !objGetBoolean(obj) : FALSE;
}

bool regIsFalse(Register reg)
{
    return objIsFalse(regRead(reg));
}

void isFalse_if(Register result, Register operands)
{
    checkArgsEQ("false?", "*", operands);
    regMakeBoolean(result, regIsFalse(regArgs[0]));
}

static void not(Register result, Register reg)
{
    regMakeBoolean(result, !regIsTrue(reg));
}

void not_if(Register result, Register operands)
{
    checkArgsEQ("not", "*", operands);
    not(result, regArgs[0]);
}

void objDisplayBoolean(Object obj, FILE* file)
{
    fprintf(file, "%s", objGetBoolean(obj) ? "#t" : "#f");
}

void objWriteBoolean(Object obj, FILE* file)
{
    objDisplayBoolean(obj, file);
}

bool objIsEqBoolean(Object o1, Object o2)
{
    return (objGetBoolean(o1) == objGetBoolean(o2));
}

bool objIsEqualBoolean(Object o1, Object o2)
{
    return objIsEqBoolean(o1, o2);
}
