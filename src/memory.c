#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <setjmp.h>

#include "common.h"
#include "parameters.h"


#include "pairpointer.h"
#include "brokenheart.h"
#include "primitive.h"
#include "port.h"
#include "util.h"
#include "boolean.h"
#include "null.h"
#include "symbol.h"
#include "sstring.h"
#include "vector.h"

#include "argcheck.h"
#include "eprint.h"

#include "memory.h"

Register regStack;

/* freePtr and scanPtr are used by the memory
 * management routines
 */
static MemRef freePtr = 0;
static MemRef scanPtr = 0;

static unsigned int memSize;

/* working memory */
static Object* theCars;
static Object* theCdrs;

/* free memory */
static Object* newCars;
static Object* newCdrs;


/* controls whether the garbage collector emits
 * messages about its operation during gc.
 */
static bool gcMessages = 1;


/* write a new object into the memory location */
void memWrite(Object* theCrs, MemRef i, Object newValue)
{
    if (!objIsEq(theCrs[i], newValue)) {
        objRef(newValue);
	objUnref(theCrs[i]);
	theCrs[i] = newValue;
    }
}

/* return an object from a memory location */
Object memRead(Object* theCrs, MemRef i)
{
    return theCrs[i];
}

static bool isGcMessages(void)
{
    return gcMessages;
}

void isGcMessages_if(Register result, Register operands)
{
    checkArgsEQ("gc-messages?", "", operands);
    regMakeBoolean(result, isGcMessages());
}

static void setGcMessages(bool state)
{
    gcMessages = state;
}

void setGcMessages_if(Register result, Register operands)
{
    checkArgsEQ("set-gc-messages", "b", operands);
    setGcMessages(regGetBoolean(regArgs[0]));
}

static unsigned int memAmountFree(void)
{
    return (memSize-freePtr);
}

static double memUsagePercentage(void)
{
    return (100*((double)freePtr)/memSize);
}

void memRelocate(Object* mem, MemRef index, unsigned int gcId)
{
    Object obj = memRead(mem, index);
    
    if (objIsPairPointer(obj)) {
	MemRef referredAddress = objGetPairPointer(obj);
	if (!objIsBrokenHeart(memRead(theCars, referredAddress))) {
	    /* This object has not yet been moved. Copy it to the
	     * new memory into the location pointed to by freePtr
	     * and set up the broken heart (the forwarding address)
	     * to the old location. */

	    /* copy the pointed-to object to the new location */
	    memWrite(newCars, freePtr, memRead(theCars, referredAddress));
	    memWrite(newCdrs, freePtr, memRead(theCdrs, referredAddress));

	    /* set up broken heart in the car position so we know this 
	     * has been moved */
	    memWrite(theCars, referredAddress, objMakeBrokenHeart());
	    /* set the forwarding address in the cdr position so we know
	     * where this has been moved to */
	    memWrite(theCdrs, referredAddress, objMakePairPointer(freePtr));

	    freePtr++;
	}
	/* Read the new address and store it to the referring memory */
	memWrite(mem, index, memRead(theCdrs, referredAddress));
    } else if (objIsVector(obj)) {
	objVectorRelocate(obj, gcId);
    }
}

static void gcRelocateMemory(unsigned int gcId)
{
    freePtr = 0;

    /* Move registers */
    regRelocate(gcId);

    /* Relocate memory */
    for (scanPtr = 0; scanPtr < freePtr; scanPtr++) {
	memRelocate(newCars, scanPtr, gcId);
	memRelocate(newCdrs, scanPtr, gcId);
    }
}

static void gcFlip(void)
{
    Object* temp;

    /* swap the roles of working and new memory */
    temp    = newCars;
    newCars = theCars;
    theCars = temp;
    temp    = newCdrs;
    newCdrs = theCdrs;
    theCdrs = temp;
}

static void newCrsClear(void)
{
    MemRef i;
    for (i = 0; i < memSize; i++) {
	memWrite(newCars, i, objMakeNull());
	memWrite(newCdrs, i, objMakeNull());
    }
}

static void memInitialize(void)
{
    MemRef i;
    for (i = 0; i < memSize; i++) {
	theCars[i] = objMakeNull();
	theCdrs[i] = objMakeNull();
	newCars[i] = objMakeNull();
	newCdrs[i] = objMakeNull();
    }
}

static void memClear(void)
{
    MemRef i;
    for (i = 0; i < memSize; i++) {
	memWrite(theCars, i, objMakeNull());
	memWrite(theCdrs, i, objMakeNull());
	memWrite(newCars, i, objMakeNull());
	memWrite(newCdrs, i, objMakeNull());
    }
}

static void garbageCollect(void)
{
    static unsigned int gcId = 1;

    if (isGcMessages())
	printf("Garbage collect ... ");
    gcRelocateMemory(gcId);
    gcFlip();

    /* The old memory could be cleared here to unrefer the objects there
     * and thus speed up the reclaiming of dynamically-allocated memory.
     * The choice between doing and not doing the clearing is between
     * speed of garbage collection (not doing) and speed of freeing the
     * dynamically allocated memory (doing).
     */
    newCrsClear();

    if (memAmountFree() == 0)
	eprintf("Unable to recycle memory\n");

    if (isGcMessages())
	printf("Done (memory used: %u/%u, %.0f%%, gcId: %u)\n",
	       freePtr, memSize, memUsagePercentage(), gcId);
    gcId++;
}

void gc_if(Register result, Register operands)
{
    checkArgsEQ("gc", "", operands);
    garbageCollect();
    regMakeSymbol(result, "ok");
}

void cons(Register to, Register car, Register cdr)
{
    if (memAmountFree() < 1) {
	garbageCollect();
    }
    memWrite(theCars, freePtr, regRead(car));
    memWrite(theCdrs, freePtr, regRead(cdr));
    regWrite(to, objMakePairPointer(freePtr));
    freePtr++;
}

void cons_if(Register result, Register operands)
{
    checkArgsEQ("cons", "**", operands);
    cons(result, regArgs[0], regArgs[1]);
}

Object objCar(Object obj)
{
    return memRead(theCars, objGetPairPointer(obj));
}

void regCar(Register to, Register from)
{
    regWrite(to, objCar(regRead(from)));
}

void car_if(Register result, Register operands)
{
    checkArgsEQ("car", "p", operands);
    regCar(result, regArgs[0]);
}

Object objCdr(Object obj)
{
    return memRead(theCdrs, objGetPairPointer(obj));
}

void regCdr(Register to, Register from)
{
    regWrite(to, objCdr(regRead(from)));
}

void cdr_if(Register result, Register operands)
{
    checkArgsEQ("cdr", "p", operands);
    regCdr(result, regArgs[0]);
}

void regSetCar(Register to, Register from)
{
    memWrite(theCars, regGetPairPointer(to), regRead(from));
}

void setCar_if(Register result, Register operands)
{
    checkArgsEQ("set-car!", "p*", operands);
    regSetCar(regArgs[0], regArgs[1]);
    regMakeSymbol(result, "ok");
}

void regSetCdr(Register to, Register from)
{
    memWrite(theCdrs, regGetPairPointer(to), regRead(from));
}

void setCdr_if(Register result, Register operands)
{
    checkArgsEQ("set-cdr!", "p*", operands);
    regSetCdr(regArgs[0], regArgs[1]);
    regMakeSymbol(result, "ok");
}

void memInit(unsigned int size)
{
    memSize = size;

    theCars = (Object*)emalloc(memSize*sizeof(Object));
    theCdrs = (Object*)emalloc(memSize*sizeof(Object));
    newCars = (Object*)emalloc(memSize*sizeof(Object));
    newCdrs = (Object*)emalloc(memSize*sizeof(Object));

    memInitialize();

    regStack = regAllocate("stack");
}

void memFree(void)
{
    memClear();

    free(theCars);
    free(theCdrs);
    free(newCars);
    free(newCdrs);
}

static void memDump(Object* mem, unsigned int amount)
{
    MemRef i;
    for (i = 0; i < amount; i++) {
	objDump(mem[i]);
    }
}

void dumpMemory(unsigned int amount)
{
    MemRef i;

    printf("Memory dump:\n");
    printf("         ");
    for (i = 0; i < amount; i++) {
	printf("  %02u", i);
    }
    printf("\n");

    printf("theCars: "); memDump(theCars, amount); printf("\n");
    printf("theCdrs: "); memDump(theCdrs, amount); printf("\n");
    printf("newCars: "); memDump(newCars, amount); printf("\n");
    printf("newCdrs: "); memDump(newCdrs, amount); printf("\n");
}


/* Begin stack operations */

#ifdef STACK_INSTRUMENTED
static unsigned int stackDepth = 0;
static unsigned int stackMaxDepth = 0;
static unsigned int stackPushes = 0;
static unsigned int stackPops = 0;
#endif

void initStack(void)
{
    regMakeNull(regStack);
#ifdef STACK_INSTRUMENTED
    stackDepth = 0;
    stackMaxDepth = 0;
    stackPushes = 0;
    stackPops = 0;
#endif
}

void initStack_if(Register result, Register operands)
{
    checkArgsEQ("initialize-stack", "", operands);
    initStack();
}


void save(Register reg)
{
#ifdef STACK_GUARDED
    save2("", reg);
#else
    cons(regStack, reg, regStack);
#endif

#ifdef STACK_INSTRUMENTED
    stackDepth++;
    if (stackDepth > stackMaxDepth)
	stackMaxDepth = stackDepth;
    stackPushes++;
#endif
}

void restore(Register reg)
{
#ifdef STACK_GUARDED
    restore2("", reg);
#else
    regCar(reg, regStack);
    regCdr(regStack, regStack);
#endif

#ifdef STACK_INSTRUMENTED
    stackDepth--;
    stackPops++;
#endif
}

#ifdef STACK_GUARDED
void save2(char* name, Register reg)
{
    Register reg0 = regGetTemp();
    regMakeString(reg0, estrdup(name));
    cons(reg0, reg0, reg);
    cons(regStack, reg0, regStack);
    regFreeTemp(reg0);
}

void restore2(char* name, Register reg)
{
    Register reg0 = regGetTemp();
    char* name2;

    regCar(reg0, regStack);
    regCdr(reg, reg0);
    regCar(reg0, reg0);
    name2 = regGetString(reg0);
    if (strcmp(name, name2) != 0)
      printf("restoring non-matching register: wanting %s getting %s\n",
	     name, name2);
    regCdr(regStack, regStack);
    regFreeTemp(reg0);
}

void printStack(void) 
{
    Register reg0 = regGetTemp();
    Register reg1 = regGetTemp();

    regCopy(reg0, regStack);
    while (!regIsNull(reg0)) {
      regCar(reg1, reg0);
      regCar(reg1, reg1);
      printf("%s ", regGetString(reg1));
      regCdr(reg0, reg0);
    }
    printf("\n");
    regFreeTemp(reg0);
    regFreeTemp(reg1);
}
#endif


void printStackStatistics(void)
{
#ifdef STACK_INSTRUMENTED
    printf("pushes    = %d\n"
	   "pops      = %d\n"
	   "max depth = %d\n",
	   stackPushes, stackPops, stackMaxDepth);
#endif
}

void printStackStatistics_if(Register result, Register operands)
{
    checkArgsEQ("print-stack-statistics", "", operands);
    printStackStatistics();
}

/* End stack operations */


/* listSetCdr: find the end of list <front> and set its
 * cdr to <last>
 */
void listSetCdr(Register result, Register front, Register last)
{
    Register reg0 = regGetTemp();
    Register reg1 = regGetTemp();

    regCopy(reg0, front);
    regCdr(reg1, reg0);
    while (!regIsNull(reg1)) {
	regCdr(reg0, reg0);
	regCdr(reg1, reg0);
    }
    /* reg0 points now to the last pair */
    regSetCdr(reg0, last);
    regCopy(result, front);

    regFreeTemp(reg0);
    regFreeTemp(reg1);
}

/* snoc: the opposite of cons
 * add <last> to the tail of the list
 * <front> may be null
 * (snoc '() 3) => (3)
 * (snoc '(1 2) 3) => (1 2 3)
 * (snoc '(1 2) '(3 4)) => (1 2 (3 4))
 */
void snoc(Register result, Register front, Register last)
{
    Register reg2 = regGetTemp();

    regMakeNull(reg2);
    cons(reg2, last, reg2);
    if (regIsNull(front))
	regCopy(result, reg2);
    else
	listSetCdr(result, front, reg2);

    regFreeTemp(reg2);
}

void snoc_if(Register result, Register operands)
{
    checkArgsEQ("adjoin-arg", "**", operands);
    /* the arguments are swapped on purpose */
    snoc(result, regArgs[1], regArgs[0]);
}

void listCopy(Register result, Register list)
{
    Register regLooper = regGetTemp();
    Register regItem = regGetTemp();

    regCopy(regLooper, list);
    regMakeNull(result);
    while (!regIsNull(regLooper)) {
	regCar(regItem, regLooper);
	snoc(result, result, regItem);
	regCdr(regLooper, regLooper);
    }


    regFreeTemp(regLooper);
    regFreeTemp(regItem);
}

void listCopy_if(Register result, Register operands)
{
    checkArgsEQ("list-copy", "l", operands);
    listCopy(result, regArgs[0]);
}
