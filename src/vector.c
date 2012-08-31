#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"
#include "glue.h"
#include "util.h"
#include "eprint.h"
#include "argcheck.h"

#include "boolean.h"
#include "symbol.h"
#include "number.h"
#include "null.h"
#include "character.h"
#include "pairpointer.h"


typedef struct vector Vector;
struct vector {
    unsigned int size;
    Object* objects;

    /* id of the last garbage collection round this vector has participated
     * This is to avoid garbage-collecting this vector more than once
     */
    unsigned int gcId; 
};

static unsigned int vecGetSize(Vector* vector)
{
    return vector->size;
}

/* Return true if index is within the bounds of the vector,
 * return false otherwise.
 */
static bool vecCheckIndex(Vector* vector, unsigned int index)
{
    return ((index >= 0) && (index < vector->size));
}

static Object vecRef(Vector* vector, unsigned int index)
{
    return memRead(vector->objects, index);
}

static void vecSet(Vector* vector, unsigned int index, Object obj)
{
    memWrite(vector->objects, index, obj);
}

static void vecFill(Vector* vector, Object fill)
{
    unsigned int size = vecGetSize(vector);
    unsigned int i;

    for (i = 0; i < size; i++) {
	vecSet(vector, i, fill);
    }
}

/* vecFill is used only to avoid valgrind (a memory debugger)
 * messages of reading uninitialized memory. These messages
 * would result if we initialized a new vector with vecFill.
 */
static void vecInit(Vector* vector, Object fill)
{
    unsigned int size = vecGetSize(vector);
    unsigned int i;

    for (i = 0; i < size; i++) {
	vector->objects[i] = fill;
    }
}

static Vector* makeVector(unsigned int size, Object init)
{
    Vector* vector;

    vector = emalloc(sizeof(struct vector));
    vector->size = size;
    vector->objects = (Object*)emalloc(size*sizeof(Object));
    vector->gcId = 0;
    vecInit(vector, init);

    return vector;
}

static void vecRelocate(Vector* vector, unsigned int gcIdentifier)
{
    unsigned int size = vecGetSize(vector);
    unsigned int i;

    if (vector->gcId == gcIdentifier) {
	/* This vector has been garbage-colleted in this round
	 * To avoid aliasing problems, don't do it again
	 */
	return;
    }
    vector->gcId = gcIdentifier;

    for (i = 0; i < size; i++) {
	memRelocate(vector->objects, i, gcIdentifier);
    }
}

static void vecDelete(Vector* vector)
{
    unsigned int size = vecGetSize(vector);
    unsigned int i;

    for (i = 0; i < size; i++) {
	objUnref(vecRef(vector, i));
    }
    free(vector->objects);
    free(vector);
}

static void vecDisplay(Vector* vector, FILE* file,
		       unsigned int depth, unsigned int quitThisDeep)
{
    unsigned int size = vecGetSize(vector);
    unsigned int i;

    for (i = 0; i < size; i++) {
	objDisplay(vecRef(vector, i), file, depth, quitThisDeep);
	if (i < size-1)
	    fprintf(file, " ");
    }
}

static void vecWrite(Vector* vector, FILE* file,
		     unsigned int depth, unsigned int quitThisDeep)
{
    unsigned int size = vecGetSize(vector);
    unsigned int i;

    for (i = 0; i < size; i++) {
	objWrite(vecRef(vector, i), file, depth, quitThisDeep);
	if (i < size-1)
	    fprintf(file, " ");
    }
}

static void regVec2List(Register result, Vector* vector)
{
    unsigned int size = vecGetSize(vector);
    int i;
    Register reg = regGetTemp();

    regMakeNull(result);
    for (i = size-1; i >= 0; i--) {
	regWrite(reg, vecRef(vector, i));
	cons(result, reg, result);
    }

    regFreeTemp(reg);
}

static bool vecIsEqual(Vector* v1, Vector* v2)
{
    unsigned int i;
    unsigned int size = vecGetSize(v1);

    if (size != vecGetSize(v2))
	return FALSE;

    for (i = 0; i < size; i++) {
	if (!objIsEqual(vecRef(v1, i), vecRef(v2, i)))
	    return FALSE;
    }
    return TRUE;
}

Object objMakeVector(unsigned int size, Object init)
{
    Object obj;
    Vector* vector = makeVector(size, init);
    obj.type = OBJTYPE_VECTOR;
    obj.u.vector = glueCreate((void*)vector);
    return obj;
}

void regMakeVector(Register reg, Register size, Register initial)
{
    int sz = regGetNumber(size);
    Object init = regRead(initial);
    /* TODO: check that sz > 0 */
    regWrite(reg, objMakeVector(sz, init));
}

void makeVector_if(Register result, Register operands)
{
    /* If no initialization object is specified, init elements with null
     * (make-vector 5)
     * (make-vector 5 "foo")
     */
    if (checkArgs("make-vector", 1, "n*", operands) < 2)
	regMakeNull(regArgs[1]);
    regMakeVector(result, regArgs[0], regArgs[1]);
}

void objDeleteVector(Object obj)
{
    Glue glue = obj.u.vector;
    Vector* vector = (Vector*)glueGetValue(glue);
    vecDelete(vector);
    glueDelete(glue);
}

static Vector* objGetVector(Object obj)
{
    Glue glue = obj.u.vector;
    return (Vector*)glueGetValue(glue);
}

static Vector* regGetVector(Register reg)
{
    return objGetVector(regRead(reg));
}

unsigned int objVectorLength(Object vector)
{
    return vecGetSize(objGetVector(vector));
}

void regVectorLength(Register result, Register vector)
{
    regMakeNumber(result, objVectorLength(regRead(vector)));
}

void vectorLength_if(Register result, Register operands)
{
    checkArgsEQ("vector-length", "v", operands);
    regVectorLength(result, regArgs[0]);
}

unsigned int objUnrefVector(Object obj)
{
    Glue glue = obj.u.vector;
    int refCount = glueDecRefCount(glue);
#ifdef DEBUG_VECTOR_REFS
    Vector* vector = (Vector*)glueGetValue(glue);
    printf("Vector size %d Unref, Refcount %d\n", vecGetSize(vector), refCount);
#endif
    if (refCount <= 0) {
	objDeleteVector(obj);
    }
    return refCount;
}

unsigned int objRefVector(Object obj)
{
    Glue glue = obj.u.vector;
    int refCount = glueIncRefCount(glue);
#ifdef DEBUG_VECTOR_REFS
    Vector* vector = (Vector*)glueGetValue(glue);
    printf("Vector size %d Ref, Refcount %d\n", vecGetSize(vector), refCount);
#endif
    return refCount;
}

void objVectorRelocate(Object obj, unsigned int gcId)
{
    vecRelocate(objGetVector(obj), gcId);
}

void objDisplayVector(Object obj, FILE* file,
		      unsigned int depth, unsigned int quitThisDeep)
{
    fprintf(file, "#(");
    vecDisplay(objGetVector(obj), file, depth, quitThisDeep);
    fprintf(file, ")");
}

void objWriteVector(Object obj, FILE* file,
		    unsigned int depth, unsigned int quitThisDeep)
{
    fprintf(file, "#(");
    vecWrite(objGetVector(obj), file, depth, quitThisDeep);
    fprintf(file, ")");
}

Object objVectorRef(Object vector, int index)
{
    Vector* vec = objGetVector(vector);
    if (vecCheckIndex(vec, index) == FALSE)
	esprint("*** vector-ref: Index out of bounds\n");
    return vecRef(vec, index);
}

void regVectorRef(Register result, Register vector, Register index)
{
    regWrite(result, objVectorRef(regRead(vector), regGetNumber(index)));
}

void vectorRef_if(Register result, Register operands)
{
    checkArgsEQ("vector-ref", "vn", operands);
    regVectorRef(result, regArgs[0], regArgs[1]);
}

void objVectorSet(Object vector, int index, Object value)
{
    Vector* vec = objGetVector(vector);
    if (vecCheckIndex(vec, index) == FALSE)
	esprint("*** vectot-set!: Index out of bounds\n");
    vecSet(vec, index, value);
}

void regVectorSet(Register vector, Register index, Register value)
{
    objVectorSet(regRead(vector), regGetNumber(index), regRead(value));
}

void vectorSet_if(Register result, Register operands)
{
    checkArgsEQ("vector-set!", "vn*", operands);
    regVectorSet(regArgs[0], regArgs[1], regArgs[2]);
    regMakeSymbol(result, "ok");
}

static void vector(Register result, Register operands)
{
    unsigned int i;
    unsigned int len = regListLength(operands);
    Object obj = objMakeVector(len, objMakeNull());
    Vector* vec = objGetVector(obj);
    Register regLooper = regGetTemp();
    Register reg = regGetTemp();

    regCopy(regLooper, operands);
    for (i = 0; i < len; i++) {
	regCar(reg, regLooper);
	vecSet(vec, i, regRead(reg));
	regCdr(regLooper, regLooper);
    }

    regFreeTemp(reg);
    regFreeTemp(regLooper);
    regWrite(result, obj);
}

void vector_if(Register result, Register operands)
{
    vector(result, operands);
}

void regVector2List(Register result, Register vector)
{
    Vector* vec = regGetVector(vector);
    regVec2List(result, vec);
}

void vector2List_if(Register result, Register operands)
{
    checkArgsEQ("vector->list", "v", operands);
    regVector2List(result, regArgs[0]);
}

void regList2Vector(Register result, Register list)
{
    vector(result, list);
}

void list2Vector_if(Register result, Register operands)
{
    checkArgsEQ("list->vector", "l", operands);
    regList2Vector(result, regArgs[0]);
}

void regVectorFill(Register vector, Register fill)
{
    Vector* vec = regGetVector(vector);
    Object  obj = regRead(fill);
    vecFill(vec, obj);
}

void vectorFill_if(Register result, Register operands)
{
    checkArgsEQ("vector-fill!", "v*", operands);
    regVectorFill(regArgs[0], regArgs[1]);
    regMakeSymbol(result, "ok");
}

bool objIsEqVector(Object o1, Object o2)
{
    return (objGetVector(o1) == objGetVector(o2));
}

bool objIsEqualVector(Object o1, Object o2)
{
    return vecIsEqual(objGetVector(o1), objGetVector(o2));
}
