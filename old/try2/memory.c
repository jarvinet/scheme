#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#include "util.h"
#include "hash.h"
#include "object.h"
#include "memory.h"
#include "obarray.h"


static Register registerCount = 0;
static Hashtable* registers;

Register regExp;  /* hold expressions to be evaluated */
Register regEnv;  /* the environment in which the evaluation is to be performed */
Register regVal;  /* value of the evaluated expression */
Register regCont; /* to implement recursion */
Register regProc; /* for evaluating combinations */
Register regArgl;
Register regUnev;

Register pc;      /* program counter */
Register flag;    /* used by test and branch insts */
Register stack;   /* the stack */
Register gc;      /* used in cons when in need of gc */

Register regText;   /* the program text of the regsim */
Register regInsts;  /* the instruction sequence */
Register regLabels; /* the labels of the program text */


/* freePtr and scanPtr are used by the memory
 * management routines
 */
static unsigned int freePtr = 0;
static unsigned int scanPtr = 0;

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
static int gcMessages = 0;


static Object
carVectorRef(unsigned int index)
{
    return theCars[index];
}

static Object
cdrVectorRef(unsigned int index)
{
    return theCdrs[index];
}

static void
carVectorSet(unsigned int index, Object obj)
{
    theCars[index] = obj;
}

static void
cdrVectorSet(unsigned int index, Object obj)
{
    theCdrs[index] = obj;
}


int isGcMessages(void)
{
    return gcMessages;
}

void setGcMessages(int state)
{
    gcMessages = state;
}

static unsigned int
freeMemory(void)
{
    return (memSize-freePtr);
}

static double
memoryUsagePercentage(void)
{
    return (100*((double)freePtr)/memSize);
}


static Object
relocate(Object obj)
{
    unsigned int oldPtr;

    if (isPair(obj)) {
	oldPtr = obj.u.pair;
	if (!isBrokenHeart(theCars[oldPtr])) {

	    /* copy the pointed-to object to the new location */
	    newCars[freePtr] = theCars[oldPtr];
	    newCdrs[freePtr] = theCdrs[oldPtr];

	    /* set up broken heart in the car position */
	    theCars[oldPtr] = makeBrokenHeart();

	    /* set the forwarding address in the cdr position */
	    theCdrs[oldPtr] = makePair(freePtr);

	    freePtr++;
	}
	return theCdrs[oldPtr];
    } else {
	return obj;
    }
}

static void
gcRelocateMemory(void)
{
    unsigned int i;

    if (isGcMessages()) {
	printf("Garbage collect ... ");
    }
    /* Move registers */
    freePtr = 0;
    scanPtr = 0;
    for (i = 0; i < registerCount; i++)
	newCars[i] = theCars[i];
    freePtr = registerCount;

    /* Relocate memory */
    while (scanPtr < freePtr) {
	newCars[scanPtr] = relocate(newCars[scanPtr]);
	newCdrs[scanPtr] = relocate(newCdrs[scanPtr]);
	scanPtr++;
    }
}

static void
gcFlip(void)
{
    Object* temp;

    /* swap the roles of working and new memory */
    temp    = newCars;
    newCars = theCars;
    theCars = temp;
    temp    = newCdrs;
    newCdrs = theCdrs;
    theCdrs = temp;

    if (freeMemory() == 0)
	eprintf("Unable to recycle memory\n");

    if (isGcMessages()) {
	printf("Done (memory used: %u/%u, %.0f%%)\n",
	       freePtr, memSize, memoryUsagePercentage());
    }
}


void
garbageCollect(void)
{
    gcRelocateMemory();
    gcFlip();
}

Object
cons(Object car, Object cdr)
{
    Object obj;

    if (freeMemory() < 2) {
	/* make the parameters reachable from the registers
	 * so that they are not invalidated by the gc */
	carVectorSet(freePtr, car);
	cdrVectorSet(freePtr, cdr);
	setReg(gc, makePair(freePtr));

	/* Do garbage collection */
	gcRelocateMemory();
	car = relocate(car);
	cdr = relocate(cdr);
	gcFlip();
    }

    carVectorSet(freePtr, car);
    cdrVectorSet(freePtr, cdr);
    obj = makePair(freePtr);
    freePtr++;
    return obj;
}

Object
car(Object obj)
{
    if (!isPair(obj))
	eprintf("object is not a pair");
    return carVectorRef(obj.u.pair);
}

Object
cdr(Object obj)
{
    if (!isPair(obj))
	eprintf("object is not a pair");
    return cdrVectorRef(obj.u.pair);
}

void
setCar(Object obj, Object value)
{
    if (!isPair(obj))
	eprintf("object is not a pair");
    carVectorSet(obj.u.pair, value);
}

void
setCdr(Object obj, Object value)
{
    if (!isPair(obj))
	eprintf("object is not a pair");
    cdrVectorSet(obj.u.pair, value);
}



void
initMemory(unsigned int size)
{
    unsigned int maxMemSize;
    unsigned int objectSize;

    maxMemSize = UINT_MAX;
    memSize = size;
    objectSize = 8*sizeof(Object);

#if 0
    printf("objectSize = %u bits\n", objectSize);
    printf("max memory size = %u\n", maxMemSize);
#endif

    theCars = (Object*)emalloc(memSize*sizeof(Object));
    theCdrs = (Object*)emalloc(memSize*sizeof(Object));
    newCars = (Object*)emalloc(memSize*sizeof(Object));
    newCdrs = (Object*)emalloc(memSize*sizeof(Object));

    registers = htCreate();
    pc    = allocateRegister("pc");
    flag  = allocateRegister("flag");
    stack = allocateRegister("stack");
    gc    = allocateRegister("gc");

    regText   = allocateRegister("text");
    regInsts  = allocateRegister("insts");
    regLabels = allocateRegister("labels");

    initializeStack();
}

/* Registers */

static Object 
makeRegister(char* name)
{
    return cons(makeSymbol(name), makeSymbol("*unassigned*"));
}

static Object
registerName(Object reg)
{
    return car(reg);
}

static Object
registerValue(Object reg)
{
    return cdr(reg);
}

Register allocateRegister(char* regName)
{
    Register reg;

    reg = registerCount;
    registerCount++;
    freePtr = registerCount;

    if (htLookup(registers, regName, 0, reg) != NULL)
	eprintf("Multiply defined register: %s\n", regName);
    htLookup(registers, regName, 1, reg);
    return reg;
}

/* getReg: Get Register Contents */
Object getReg(Register reg)
{
    return carVectorRef(reg);
}

/* setReg: Set Register Contents */
void
setReg(Register reg, Object newValue)
{
    carVectorSet(reg, newValue);
}

void
printRegister(Object reg)
{
    printObject(registerName(reg));
    printf(": ");
    printObject(registerValue(reg));
    printf("\n");
}

void
dumpRegister(Object reg)
{
    printObject(registerName(reg));
    printf(": ");
    dumpObject(registerValue(reg));
    printf("\n");
}


/* Memory and register dumping */

static void
dumpMem(Object* mem, unsigned int amount)
{
    unsigned int i;
    for (i = 0; i < amount; i++) {
	dumpObject(mem[i]);
    }
}

void
dumpMemory(unsigned int amount)
{
    unsigned int i;

    printf("Memory dump:\n");
    printf("         ");
    for (i = 0; i < amount; i++) {
	printf("  %02u", i);
    }
    printf("\n");

    printf("theCars: "); dumpMem(theCars, amount); printf("\n");
    printf("theCdrs: "); dumpMem(theCdrs, amount); printf("\n");
    printf("newCars: "); dumpMem(newCars, amount); printf("\n");
    printf("newCdrs: "); dumpMem(newCdrs, amount); printf("\n");
}

void
dumpRegisters(void)
{
    Object obj;

    printf("Register dump:\n");
#if 0
    for (obj = cdr(registerList); !isNull(obj); obj = cdr(obj))
	dumpRegister(car(obj));
#endif
}

void
printRegisters(void)
{
    Object obj;
#if 0
    printf("Register print:\n");
    for (obj = cdr(registerList); !isNull(obj); obj = cdr(obj))
	printRegister(car(obj));
#else
#endif
}

/* stack operations */
void initializeStack(void)
{
    setReg(stack, makeNull());
}

void save(Register reg)
{
    setReg(stack, cons(getReg(reg), getReg(stack)));
}
void restore(Register reg)
{
    setReg(reg, car(getReg(stack)));
    setReg(stack, cdr(getReg(stack)));
}
