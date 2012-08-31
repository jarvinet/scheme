#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"

#include "util.h"
#include "primitive.h"
#include "argcheck.h"


static Hashtable primitives;

void initPrimitives(void)
{
    primitives = htCreate();
}

void freePrimitives(void)
{
    htDelete(primitives);
}

Object objMakePrimitive(char* name, Primitive primitive)
{
    Object obj;
    obj.type = OBJTYPE_PRIMITIVE;
    obj.u.primitive = htLookup(primitives, name, HASHOP_CREATE, (void*)primitive);
    return obj;
}

void regMakePrimitive(Register reg, char* name, Primitive primitive)
{
    regWrite(reg, objMakePrimitive(name, primitive));
}

Primitive objGetPrimitive(Object obj)
{
    assert(objIsPrimitive(obj));
    return (Primitive)bindGetValue(obj.u.primitive);
}

Primitive regGetPrimitive(Register reg)
{
    return objGetPrimitive(regRead(reg));
}

char* objGetPrimitiveName(Object obj)
{
    return bindGetName(obj.u.primitive);
}

void objDisplayPrimitive(Object obj, FILE* file)
{
    fprintf(file, "[primitive %s]", objGetPrimitiveName(obj));
}

void objWritePrimitive(Object obj, FILE* file)
{
    objDisplayPrimitive(obj, file);
}

bool objIsEqPrimitive(Object o1, Object o2)
{
    return (objGetPrimitive(o1) == objGetPrimitive(o2));
}

bool objIsEqualPrimitive(Object o1, Object o2)
{
    return objIsEqPrimitive(o1, o2);
}

static void
applyPrimitiveProcedure(Register result, Register primitive, Register operands)
{
    Register regOperands = regGetTemp();

    Primitive prim = regGetPrimitive(primitive);
    regCopy(regOperands, operands);
    (*prim)(result, regOperands);

    regFreeTemp(regOperands);
}

void applyPrimitiveProcedure_if(Register result, Register operands)
{
    checkArgsEQ("apply-primitive-procedure", "rl", operands);
    applyPrimitiveProcedure(result, regArgs[0], regArgs[1]);
}
