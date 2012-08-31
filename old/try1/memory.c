#include <stdio.h>
#include <stdlib.h>

#include "memory.h"


#define OBJTYPE_PAIRPOINTER 0x00
#define OBJTYPE_BROKENHEART 0x01 // a broken heart is used in garbage-collection
#define OBJTYPE_SYMBOL      0x02
#define OBJTYPE_NUMBER      0x03
#define OBJTYPE_NULL        0x04
/*
#define OBJTYPE_STRING      0x05
*/

// Registers
Object expr; // hold expressions to be evaluated
Object env;  // the environment in which the evaluation is to be performed
Object val;  // value of the evaluated expressiobn
Object cont; // to implement recusion
Object proc; // for evaluating combinations
Object argl;
Object unev;
static unsigned int numberOfRegisters = 7;

// helpers to manipulate the register list
static Object exprPtr;
static Object envPtr;
static Object valPtr;
static Object contPtr;
static Object procPtr;
static Object arglPtr;
static Object unevPtr;

static unsigned int objectSize;
static unsigned int typeFieldSize;
static unsigned int valueFieldSize;
static unsigned int typeFieldPos;
static unsigned int valueFieldPos; 
static unsigned int valueMask;
static unsigned int typeMask;

static unsigned int freePtr = 0;
static unsigned int scanPtr = 0;
static unsigned int rootPtr = 0;

static unsigned int memSize;

/* working memory */
static Object* theCars;
static Object* theCdrs;

/* free memory */
static Object* newCars;
static Object* newCdrs;



unsigned int
getType(Object obj)
{
    return ((obj & typeMask) >> typeFieldPos);
}

void
setType(Object* obj, unsigned int type)
{
    *obj = ((type << typeFieldPos) & typeMask) | (*obj & valueMask);
}

unsigned int
getValue(Object obj)
{
    return ((obj & valueMask) >> valueFieldPos);
}

void
setValue(Object* obj, unsigned int value)
{
    *obj = ((value << valueFieldPos) & valueMask) | (*obj & typeMask);
}

void
copyObject(Object* to, Object from)
{
    *to = from;
}

unsigned int
isPair(Object obj)
{
    return (getType(obj) == OBJTYPE_PAIRPOINTER);
}

static unsigned int
isBrokenHeart(Object obj)
{
    return (getType(obj) == OBJTYPE_BROKENHEART);
}

unsigned int
isSymbol(Object obj)
{
    return (getType(obj) == OBJTYPE_SYMBOL);
}

unsigned int
isNumber(Object obj)
{
    return (getType(obj) == OBJTYPE_NUMBER);
}

unsigned int
isNull(Object obj)
{
    return (getType(obj) == OBJTYPE_NULL);
}

Object
makePair(unsigned int value)
{
    Object obj = 0;
    setType(&obj, OBJTYPE_PAIRPOINTER);
    setValue(&obj, value);
    return obj;
}

static Object
makeBrokenHeart(void)
{
    Object obj = 0;
    setType(&obj, OBJTYPE_BROKENHEART);
    return obj;
}

Object
makeSymbol(unsigned int index)
{
    Object obj = 0;
    setType(&obj, OBJTYPE_SYMBOL);
    setValue(&obj, index); // index to the obarray
    return obj;
}

Object
makeNumber(unsigned int value)
{
    Object obj = 0;
    setType(&obj, OBJTYPE_NUMBER);
    setValue(&obj, value);
    return obj;
}

Object
makeNull(void)
{
    Object obj = 0;
    setType(&obj, OBJTYPE_NULL);
    return obj;
}

void
printObject(Object obj)
{
    switch (getType(obj)) {
    case OBJTYPE_PAIRPOINTER:
	printf("(");
	printObject(theCars[getValue(obj)]);
	printf(" . ");
	printObject(theCdrs[getValue(obj)]);
	printf(")");
	break;
    case OBJTYPE_BROKENHEART:
	printf("Broken Heart");
	break;
    case OBJTYPE_SYMBOL:
	printf("%s", lookup(getValue(obj)));
	break;
    case OBJTYPE_NUMBER:
	printf("%d", (signed int)getValue(obj));
	break;
    case OBJTYPE_NULL:
	printf("()");
	break;
    default:
	printf("UNKNOWN OBJECT: %u\n", obj);
	break;
    }
}

void
dumpObject(Object obj)
{
    switch (getType(obj)) {
    case OBJTYPE_PAIRPOINTER:
	printf("p%u ", getValue(obj));
	break;
    case OBJTYPE_BROKENHEART:
	printf("BH ");
	break;
    case OBJTYPE_SYMBOL:
	printf("s%u ", getValue(obj));
	break;
    case OBJTYPE_NUMBER:
	printf("n%u ", getValue(obj));
	break;
    case OBJTYPE_NULL:
	printf("e0 ");
	break;
    default:
	printf("UO ");
	break;
    }
}

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
    printf("        ");
    for (i = 0; i < amount; i++) {
	printf("%3u", i);
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
    printf("Register dump:\n");
    printf("expr:"); dumpObject(expr); printf("");
    printf("env:");  dumpObject(env);  printf("");
    printf("val:");  dumpObject(val);  printf("");
    printf("cont:"); dumpObject(cont); printf("");
    printf("proc:"); dumpObject(proc); printf("");
    printf("argl:"); dumpObject(argl); printf("");
    printf("unev:"); dumpObject(unev); printf("\n");

    printf("exprPtr:"); dumpObject(exprPtr); printf("");
    printf("envPtr:");  dumpObject(envPtr);  printf("");
    printf("valPtr:");  dumpObject(valPtr);  printf("");
    printf("contPtr:"); dumpObject(contPtr); printf("");
    printf("procPtr:"); dumpObject(procPtr); printf("");
    printf("arglPtr:"); dumpObject(arglPtr); printf("");
    printf("unevPtr:"); dumpObject(unevPtr); printf("\n");

    printf("rootPtr: %u\n", rootPtr);

}

void
printRegisters(void)
{
    printf("Register print:\n");
    printf("expr: "); printObject(expr); printf("\n");
    printf("env : "); printObject(env);  printf("\n");
    printf("val : "); printObject(val);  printf("\n");
    printf("cont: "); printObject(cont); printf("\n");
    printf("proc: "); printObject(proc); printf("\n");
    printf("argl: "); printObject(argl); printf("\n");
    printf("unev: "); printObject(unev); printf("\n");
}

Object
cons(Object car, Object cdr)
{
    Object obj;
    if (freePtr == memSize) {
	garbageCollect();
    }
    copyObject(&theCars[freePtr], car);
    copyObject(&theCdrs[freePtr], cdr);
    obj = makePair(freePtr);
    freePtr++;
    return obj;

}

Object
car(Object obj)
{
    if (isPair(obj)) {
	return theCars[getValue(obj)];
    } else {
	printf("object is not a pair: ");
	printObject(obj);
	printf("\n");
	exit(1);
    }
}

Object
cdr(Object obj)
{
    if (isPair(obj)) {
	return theCdrs[getValue(obj)];
    } else {
	printf("object is not a pair: ");
	printObject(obj);
	printf("\n");
	exit(1);
    }
}

void
setCar(Object obj, Object value)
{
    if (isPair(obj)) {
	copyObject(&theCars[getValue(obj)], value);
    } else {
	printf("object is not a pair: ");
	printObject(obj);
	printf("\n");
	exit(1);
    }
}

void
setCdr(Object obj, Object value)
{
    if (isPair(obj)) {
	copyObject(&theCdrs[getValue(obj)], value);
    } else {
	printf("object is not a pair: ");
	printObject(obj);
	printf("\n");
	exit(1);
    }
}


// Begin Stop and Copy Garbage Collector
static void
refreshRegisterList(void)
{
    setCar(exprPtr, expr);
    setCar(envPtr,  env);
    setCar(valPtr,  val);
    setCar(contPtr, cont);
    setCar(procPtr, proc);
    setCar(arglPtr, argl);
    setCar(unevPtr, unev);
}

static Object
relocate(Object obj)
{
    unsigned int oldPtr;
    unsigned int newPtr;

    if (isPair(obj)) {
	oldPtr = getValue(obj);
	if (!isBrokenHeart(theCars[oldPtr])) {
	    copyObject(&newCars[freePtr], theCars[oldPtr]);
	    copyObject(&newCdrs[freePtr], theCdrs[oldPtr]);
	    // set up broken heart in the car position
	    setType(&theCars[oldPtr], OBJTYPE_BROKENHEART);
	    // set the forwarding address in the cdr position
	    setType(&theCdrs[oldPtr], OBJTYPE_PAIRPOINTER);
	    setValue(&theCdrs[oldPtr], freePtr);
	    freePtr++;
	}
	newPtr = getValue(theCdrs[oldPtr]);
	return makePair(newPtr);
    } else {
	return obj;
    }
}


void
garbageCollect(void)
{
    Object* temp;

    printf("Begin garbage collect...");
	
    refreshRegisterList();

    freePtr = 0;
    scanPtr = 0;
    copyObject(&newCars[scanPtr], theCars[rootPtr]);
    copyObject(&newCdrs[scanPtr], theCdrs[rootPtr]);
    freePtr++;

    while (scanPtr < freePtr) {
	copyObject(&newCars[scanPtr], relocate(newCars[scanPtr]));
	copyObject(&newCdrs[scanPtr], relocate(newCdrs[scanPtr]));
	scanPtr++;
    }

    // relocate registers
    copyObject(&expr, relocate(expr));
    copyObject(&env,  relocate(env));
    copyObject(&val,  relocate(val));
    copyObject(&cont, relocate(cont));
    copyObject(&proc, relocate(proc));
    copyObject(&argl, relocate(argl));
    copyObject(&unev, relocate(unev));

    copyObject(&exprPtr, relocate(exprPtr));
    copyObject(&envPtr,  relocate(envPtr));
    copyObject(&valPtr,  relocate(valPtr));
    copyObject(&contPtr, relocate(contPtr));
    copyObject(&procPtr, relocate(procPtr));
    copyObject(&arglPtr, relocate(arglPtr));
    copyObject(&unevPtr, relocate(unevPtr));

    rootPtr = exprPtr;

    // swap the roles of working and new memory
    temp    = newCars;
    newCars = theCars;
    theCars = temp;
    temp    = newCdrs;
    newCdrs = theCdrs;
    theCdrs = temp;

    if (freePtr > memSize) {
	printf("Unable to recycle memory\n");
	exit(1);
    }

    printf("Done (free: %u, memory usage: %.0f%%)\n", freePtr, 100*((double)freePtr)/memSize);
}
// End Stop and Copy Garbage Collector


void
initMemory(unsigned int size)
{
    unsigned int maxMemSize;

    objectSize     = 8*sizeof(Object);
    typeFieldSize  = 3; // 3 leftmost bits of Object determines the object type
    valueFieldSize = objectSize - typeFieldSize;
    typeFieldPos   = valueFieldSize;
    valueFieldPos  = 0; 

    // typemask  = 1100 0000 0000 0000
    // valuemask = 0011 1111 1111 1111

    // beware: right-shifting may not give the same results in all architectures
    // the result may depend on the signed/unsigned status of the value to be shifted
    valueMask = ((unsigned int)~0) >> typeFieldSize;
    typeMask  = ~valueMask;

    maxMemSize = valueMask; //(unsigned int)pow(2, valueFieldSize+1)-1;
    memSize = size + numberOfRegisters;

    printf("objectSize = %d bits\nmax memory size = %d\n",
	   objectSize, maxMemSize);

    if ((theCars = (Object*)malloc(memSize*sizeof(Object))) == NULL) {
	printf("Allocation of theCars failed.\n");
	exit(1);
    }

    if ((theCdrs = (Object*)malloc(memSize*sizeof(Object))) == NULL) {
	printf("Allocation of theCdrs failed.\n");
	exit(1);
    }

    if ((newCars = (Object*)malloc(memSize*sizeof(Object))) == NULL) {
	printf("Allocation of newCars failed.\n");
	exit(1);
    }

    if ((newCdrs = (Object*)malloc(memSize*sizeof(Object))) == NULL) {
	printf("Allocation of newCdrs failed.\n");
	exit(1);
    }


    // construct a list containing all registers

    expr = makeNull();
    env  = makeNull();
    val  = makeNull();
    cont = makeNull();
    proc = makeNull();
    argl = makeNull();
    unev = makeNull();

    unevPtr = cons(unev, makeNull());
    arglPtr = cons(argl, unevPtr);
    procPtr = cons(proc, arglPtr);
    contPtr = cons(cont, procPtr);
    valPtr  = cons(val,  contPtr);
    envPtr  = cons(env,  valPtr);
    exprPtr = cons(expr, envPtr);

    rootPtr = exprPtr;
}

