#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"

#include "util.h"
#include "boolean.h"
#include "null.h"


Object objMakePairPointer(MemRef value)
{
    Object obj;
    obj.type = OBJTYPE_PAIRPOINTER;
    obj.u.pairPointer = value;
    return obj;
}

MemRef objGetPairPointer(Object obj)
{
    assert(objIsPairPointer(obj));
    return obj.u.pairPointer;
}

MemRef regGetPairPointer(Register reg)
{
    return objGetPairPointer(regRead(reg));
}

void objDisplayPairPointer(Object obj, FILE* file,
			   unsigned int depth, unsigned int quitThisDeep)
{
    Object cdr1;

#if 0
    if (depth > quitThisDeep) {
	fprintf(file, "<<<qdr>>>"); /* quitting deep recursion */
	return;
    }
#endif

    objDisplay(objCar(obj), file, depth+1, quitThisDeep);

    cdr1 = objCdr(obj);
    if (objIsPairPointer(cdr1)) {
	fprintf(file, " ");
	objDisplayPairPointer(cdr1, file, depth+1, quitThisDeep);
    } else if (!objIsNull(cdr1)) {
	fprintf(file, " . ");
	objDisplay(cdr1, file, depth+1, quitThisDeep);
    }
}

void objWritePairPointer(Object obj, FILE* file,
			 unsigned int depth, unsigned int quitThisDeep)
{
    Object cdr1;

#if 0
    if (depth > quitThisDeep) {
	fprintf(file, "<<<qdr>>>"); /* quitting deep recursion */
	return;
    }
#endif

    objWrite(objCar(obj), file, depth+1, quitThisDeep);

    cdr1 = objCdr(obj);
    if (objIsPairPointer(cdr1)) {
	fprintf(file, " ");
	objWritePairPointer(cdr1, file, depth+1, quitThisDeep);
    } else if (!objIsNull(cdr1)) {
	fprintf(file, " . ");
	objWrite(cdr1, file, depth+1, quitThisDeep);
    }
}

bool objIsEqPairPointer(Object o1, Object o2)
{
    return (objGetPairPointer(o1) == objGetPairPointer(o2));
}

bool objIsEqualPairPointer(Object o1, Object o2)
{
    return (objIsEqual(objCar(o1), objCar(o2)) &&
	    objIsEqual(objCdr(o1), objCdr(o2)));
}

bool isList(Register reg)
{
    Register hare = regGetTemp();
    Register tortoise = regGetTemp();

    bool tortoiseAdvance = TRUE;
    bool result = FALSE;
    regCopy(hare, reg);
    regCopy(tortoise, reg);
    while (TRUE) {
	if (regIsNull(hare)) {
	    result = TRUE;
	    break;
	}
	if (!regIsPairPointer(hare)) {
	    result = FALSE;
	    break;
	}
	regCdr(hare, hare);
	if ((tortoiseAdvance = !tortoiseAdvance))
	    regCdr(tortoise, tortoise);
	if (regIsEq(hare, tortoise)) {
	    result = FALSE;
	    break;
	}
    }

    regFreeTemp(hare);
    regFreeTemp(tortoise);

    return result;
}

static void list(Register result, Register operands)
{
    regCopy(result, operands);
}

void list_if(Register result, Register operands)
{
    list(result, operands);
}

unsigned int regListLength(Register reg)
{
    Object o;
    unsigned int result = 0;

    for (o = regRead(reg); !objIsNull(o); o = objCdr(o))
	result++;

    return result;
}
