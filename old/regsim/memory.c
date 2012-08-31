#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#include "util.h"
#include "hash.h"
#include "object.h"
#include "memory.h"
#include "obarray.h"


/*
; Register list is a list of registers with a head node whose
; car is "*register list*"
;
;       +-+-+       +-+-+       +-+-+
;       | | +------>| | |------>| |/|
;       +-+-+       +-+-+       +-+-+
;        |           |           |
;        V           V           V
; *register list*  +-+-+       +-+-+
;                  | | |       | | |
;                  +-+-+       +-+-+
;                   | |         | |
;                   V V         V V
;                name value  name value
;
*/
static Object registerList;


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
    printf("Garbage collect ... ");

    /* Reassign root */
    freePtr = 0;
    scanPtr = 0;
    newCars[scanPtr] = theCars[registerList.u.pair];
    newCdrs[scanPtr] = theCdrs[registerList.u.pair];
    freePtr++;

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

    printf("Done (memory used: %u/%u, %.0f%%)\n",
	   freePtr, memSize, memoryUsagePercentage());
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
	setReg("gc", makePair(freePtr));

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

    registerList = cons(makeSymbol("*register list*"), makeNull());
    allocateRegister("pc");    /* program counter */
    allocateRegister("flag");  /* used by test and branch insts */
    allocateRegister("stack"); /* the stack */
    allocateRegister("gc");    /* used in cons when in need of gc */
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

static Object
getRegister(char* name)
{
    return assoc(makeSymbol(name), cdr(registerList));
}

void
allocateRegister(char* name)
{
    Object reg;

    reg = getRegister(name);
    if (!isNull(reg))
	eprintf("Multiply defined register: %s", name);

    reg = makeRegister(name);
    setCdr(registerList, cons(reg, cdr(registerList)));
}

/* getReg: Get Register Contents */
Object
getReg(char* name)
{
    Object reg = getRegister(name);
    if (isNull(reg))
	eprintf("Register not defined: %s", name);
    return registerValue(reg);
}

/* setReg: Set Register Contents */
void
setReg(char* name, Object newValue)
{
    Object reg = getRegister(name);
    if (isNull(reg))
	eprintf("Register not defined: %s", name);
    setCdr(reg, newValue);
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
    for (obj = cdr(registerList); !isNull(obj); obj = cdr(obj))
	dumpRegister(car(obj));
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
    printObject(registerList);
    printf("\n");
#endif
}

/* stack operations */
void initializeStack(void)
{
    setReg("stack", makeNull());
}

void save(Object obj)
{
    setReg("stack", cons(obj, getReg("stack")));
}

Object restore(void)
{
    Object obj = car(getReg("stack"));
    setReg("stack", cdr(getReg("stack")));
    return obj;
}


