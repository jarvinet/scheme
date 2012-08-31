#include <stdio.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"
#include "glue.h"
#include "argcheck.h"
#include "util.h"

#include "pairpointer.h"
#include "boolean.h"
#include "continuation.h"


Object objMakeContinuation(Register regStack)
{
    Object obj;
    Register reg;
    obj.type = OBJTYPE_CONTINUATION;
    reg = regGetTemp();
    listCopy(reg, regStack); /* TODO: use regCopyDeep here ??? */
    obj.u.continuation = glueCreate((void*)reg);
    return obj;
}

void regMakeContinuation(Register result)
{
    regWrite(result, objMakeContinuation(regStack));
}

void makeContinuation_if(Register result, Register operands)
{
    checkArgsEQ("make-continuation", "", operands);
    regMakeContinuation(result);
}

void objDeleteContinuation(Object obj)
{
    Glue glue = obj.u.continuation;
    Register reg = (Register)glueGetValue(glue);
    regFreeTemp(reg);
    glueDelete(glue);
}

static Register objGetContinuation(Object obj)
{
    assert(objIsContinuation(obj));
    return (Register)glueGetValue(obj.u.continuation);
}

static Register regGetContinuation(Register reg)
{
    return objGetContinuation(regRead(reg));
}

unsigned int objUnrefContinuation(Object obj)
{
    Glue glue = obj.u.continuation;
    int refCount = glueDecRefCount(glue);
#ifdef DEBUG_CONTINUATION_REFS
    printf("Continuation Unref, Refcount %d\n", refCount);
#endif
    if (refCount <= 0) {
	objDeleteContinuation(obj);
    }
    return refCount;
}

unsigned int objRefContinuation(Object obj)
{
    Glue glue = obj.u.continuation;
    int refCount = glueIncRefCount(glue);
#ifdef DEBUG_CONTINUATION_REFS
    printf("Continuation Ref, Refcount %d\n", refCount);
#endif
    return refCount;
}

bool objIsEqContinuation(Object o1, Object o2)
{
    return FALSE;
}

bool objIsEqualContinuation(Object o1, Object o2)
{
    return FALSE;
}

void objDisplayContinuation(Object obj, FILE* file)
{
    fprintf(file, "[continuation]");
}

void objWriteContinuation(Object obj, FILE* file)
{
    objDisplayContinuation(obj, file);
}

void applyContinuation_if(Register result, Register operands)
{
    checkArgsEQ("apply-continuation", "tl", operands);
    regCopy(regStack, regGetContinuation(regArgs[0]));
    regCar(result, regArgs[1]);
}
