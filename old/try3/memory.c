#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

#include "hash.h"
#include "memory.h"
#include "util.h"


#define OBJTYPE_NULL        0x00
#define OBJTYPE_PAIRPOINTER 0x01
#define OBJTYPE_SYMBOL      0x02
#define OBJTYPE_STRING      0x03
#define OBJTYPE_NUMBER      0x04
#define OBJTYPE_BROKENHEART 0x05
#define OBJTYPE_BOOLEAN     0x06
#define OBJTYPE_PRIMITIVE   0x07
#define OBJTYPE_EOF         0x08
#define OBJTYPE_OUTPUT_PORT 0x09
#define OBJTYPE_INPUT_PORT  0x0a

typedef struct object Object;

struct object {
    unsigned char type;

    union {
	unsigned int pair;      /* pointer to the memory */
	Binding      *symbol;   /* pointer to obarray */
	char         *string;   /* the string */
	int          number;    /* the number */
	char         boolean;   /* boolean true or false */
	Primitive    primitive; /* primitives */
	FILE         *port;     /* input and output port */
    } u;
};



static Register registerCount = 0;

static Register stack;   /* the stack */
static Register regName;
static Register regRecord;
static Register regLooper;
static Register regOperands;

Register reg0;
Register reg1;
Register reg2;
Register reg3;
Register reg4;
Register reg5;
Register reg6;
Register reg7;
Register reg8;
Register reg9;

Register regArgs[MAXARGS];


static Hashtable* registers;
static Hashtable *obarray;


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
static int gcMessages = 1;




static Object makePair_(unsigned int value)
{
    Object obj;
    obj.type = OBJTYPE_PAIRPOINTER;
    obj.u.pair = value;
    return obj;
}

static Object makeBrokenHeart_(void)
{
    Object obj;
    obj.type = OBJTYPE_BROKENHEART;
    return obj;
}

static Object makeSymbol_(char* symbol)
{
    Object obj;
    obj.type = OBJTYPE_SYMBOL;
    obj.u.symbol = htLookup(obarray, symbol, 1, 0);
    return obj;
}

void makeSymbol(Register reg, char* symbol)
{
    theCars[reg] = makeSymbol_(symbol);
}

void makeString(Register reg, char* str)
{
    Object obj;
    obj.type = OBJTYPE_STRING;
    str[strlen(str)-1] = '\0'; /* strip off trailing doublequote */
    obj.u.string = str+1;      /* strip off leading doublequote */
    theCars[reg] = obj;
}

void makeNumber(Register reg, int value)
{
    Object obj;
    obj.type = OBJTYPE_NUMBER;
    obj.u.number = value;
    theCars[reg] = obj;
}

static Object makeNull_(void)
{
    Object obj;
    obj.type = OBJTYPE_NULL;
    return obj;
}

void makeNull(Register reg)
{
    theCars[reg] = makeNull_();
}

void makeBoolean(Register reg, char boolean)
{
    Object obj;
    obj.type = OBJTYPE_BOOLEAN;
    obj.u.boolean = boolean;
    theCars[reg] = obj;
}

void makePrimitive(Register reg, Primitive primitive)
{
    Object obj;
    obj.type = OBJTYPE_PRIMITIVE;
    obj.u.primitive = primitive;
    theCars[reg] = obj;
}

void makeEOF(Register reg)
{
    Object obj;
    obj.type = OBJTYPE_EOF;
    theCars[reg] = obj;
}

static unsigned int isPair_(Object obj)
{
    return (obj.type == OBJTYPE_PAIRPOINTER);
}

unsigned int isPair(Register reg)
{
    return isPair_(theCars[reg]);
}

static unsigned int isBrokenHeart_(Object obj)
{
    return (obj.type == OBJTYPE_BROKENHEART);
}

unsigned int isSymbol(Register reg)
{
    Object obj = theCars[reg];
    return (obj.type == OBJTYPE_SYMBOL);
}

unsigned int isNumber(Register reg)
{
    Object obj = theCars[reg];
    return (obj.type == OBJTYPE_NUMBER);
}

static unsigned isNull_(Object obj)
{
    return (obj.type == OBJTYPE_NULL);
}

unsigned int isNull(Register reg)
{
    return isNull_(theCars[reg]);
}

unsigned int isString(Register reg)
{
    Object obj = theCars[reg];
    return (obj.type == OBJTYPE_STRING);
}

unsigned int isBoolean(Register reg)
{
    Object obj = theCars[reg];
    return (obj.type == OBJTYPE_BOOLEAN);
}

unsigned int isPrimitive(Register reg)
{
    Object obj = theCars[reg];
    return (obj.type == OBJTYPE_PRIMITIVE);
}

unsigned int isTrue(Register reg)
{
    Object obj = theCars[reg];
    return obj.u.boolean;
}

unsigned int isEOF(Register reg)
{
    Object obj = theCars[reg];
    return (obj.type == OBJTYPE_EOF);
}





static Object carVectorRef(unsigned int index)
{
    return theCars[index];
}

static Object cdrVectorRef(unsigned int index)
{
    return theCdrs[index];
}

static void carVectorSet(unsigned int index, Object obj)
{
    theCars[index] = obj;
}

static void cdrVectorSet(unsigned int index, Object obj)
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

static unsigned int freeMemory(void)
{
    return (memSize-freePtr);
}

static double memoryUsagePercentage(void)
{
    return (100*((double)freePtr)/memSize);
}


static void relocate(Object* newCrs, unsigned int index)
{
    Object o;
    unsigned int oldPtr;

    o = newCrs[index];
    if (isPair_(o)) {
	oldPtr = o.u.pair;
	if (!isBrokenHeart_(theCars[oldPtr])) {

	    /* copy the pointed-to object to the new location */
	    newCars[freePtr] = theCars[oldPtr];
	    newCdrs[freePtr] = theCdrs[oldPtr];

	    /* set up broken heart in the car position */
	    theCars[oldPtr] = makeBrokenHeart_();

	    /* set the forwarding address in the cdr position */
	    theCdrs[oldPtr] = makePair_(freePtr);

	    freePtr++;
	}
	newCrs[index] = theCdrs[oldPtr];
    }
}

static void gcRelocateMemory(void)
{
    unsigned int i;

    if (isGcMessages()) {
	printf("Garbage collect ... ");
    }

    freePtr = 0;
    scanPtr = 0;

    /* Move registers */
    for (i = 0; i < registerCount; i++)
	newCars[i] = theCars[i];
    freePtr = registerCount;

    /* Relocate memory */
    while (scanPtr < freePtr) {
	relocate(newCars, scanPtr);
	relocate(newCdrs, scanPtr);
	scanPtr++;
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

    if (freeMemory() == 0)
	eprintf("Unable to recycle memory\n");

    if (isGcMessages()) {
	printf("Done (memory used: %u/%u, %.0f%%)\n",
	       freePtr, memSize, memoryUsagePercentage());
    }
}


void garbageCollect(void)
{
    gcRelocateMemory();
    gcFlip();
}


/* getReg: Get Register Contents */
static Object getReg(Register reg)
{
    return carVectorRef(reg);
}

/* setReg: Set Register Contents */
static void setReg(Register reg, Object newValue)
{
    carVectorSet(reg, newValue);
}


void cons(Register to, Register car, Register cdr)
{
    if (freeMemory() < 1) {
	/* Do garbage collection */
	gcRelocateMemory();
	gcFlip();
    }

    theCars[freePtr] = theCars[car];
    theCdrs[freePtr] = theCars[cdr];
    theCars[to] = makePair_(freePtr);
    freePtr++;
}


static Object car_(Object obj)
{
    return theCars[obj.u.pair];
}

void car(Register to, Register from)
{
    Object o;
    if (!isPair(from))
	eprintf("object is not a pair");
    o = theCars[from];
    theCars[to] = theCars[o.u.pair];
}

static Object cdr_(Object obj)
{
    return theCdrs[obj.u.pair];
}

void cdr(Register to, Register from)
{
    Object o;
    if (!isPair(from))
	eprintf("object is not a pair");
    o = theCars[from];
    theCars[to] = theCdrs[o.u.pair];
}

void setCar(Register to, Register from)
{
    Object o;
    if (!isPair(to))
	eprintf("object is not a pair");
    o = theCars[to];
    theCars[o.u.pair] = theCars[from];
}

void setCdr(Register to, Register from)
{
    Object o;
    if (!isPair(to))
	eprintf("object is not a pair");
    o = theCars[to];
    theCdrs[o.u.pair] = theCars[from];
}



void initMemory(unsigned int size)
{
    unsigned int maxMemSize;
    unsigned int objectSize;
    unsigned int i;
    char name[16];

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
    obarray = htCreate();

    stack     = allocateRegister("stack");
    regName   = allocateRegister("memName");
    regRecord = allocateRegister("memRecord");
    regLooper = allocateRegister("memLooper");
    regOperands = allocateRegister("memOperands");
    reg0  = allocateRegister("memTemp0");
    reg1  = allocateRegister("memTemp1");
    reg2  = allocateRegister("memTemp2");
    reg3  = allocateRegister("memTemp3");
    reg4  = allocateRegister("memTemp4");
    reg5  = allocateRegister("memTemp5");
    reg6  = allocateRegister("memTemp6");
    reg7  = allocateRegister("memTemp7");
    reg8  = allocateRegister("memTemp8");
    reg9  = allocateRegister("memTemp9");

    for (i = 0; i < MAXARGS; i++) {
	sprintf(name, "memArg%d", i);
	regArgs[i] = allocateRegister(estrdup(name));
    }

    initStack();
}

/* Registers */

/* Allocate a new register.
 * Memory must be initialized (initMemory) before
 * allocating registers.
 * All registers must be allocated before using cons.
 */
Register allocateRegister(char* regName)
{
    Register reg;

    if (htLookup(registers, regName, 0, 0))
	eprintf("register %s already defined\n", regName);

    reg = registerCount;
    registerCount++;
    freePtr = registerCount;

    htLookup(registers, regName, 1, reg);

    /* Register contents is stored in the car position
     * Register name is stored in the cdr position
     */
    theCars[reg] = makeNull_();
    theCdrs[reg] = makeSymbol_(regName);

    return reg;
}

/* Get register by its name */
Register lookupRegister(Register regName)
{
    Binding* binding;
    Object obj;
    char* name;

    obj = getReg(regName);
    name = obj.u.symbol->name;
    binding = htLookup(registers, name, 0, 0);
    if (binding == NULL)
	eprintf("lookupRegister: register %s not defined\n",
		name);
    return binding->value;
}

/* copyReg: Set Register Contents */
void copyReg(Register to, Register from)
{
    carVectorSet(to, carVectorRef(from));
}


/* Memory and register dumping */

static void printObject_(Object obj);

static void printPair(Object obj)
{
    Object cdr1;

    printObject_(car_(obj));

    cdr1 = cdr_(obj);
    if (isPair_(cdr1)) {
	printf(" ");
	printPair(cdr1);
    } else if (!isNull_(cdr1)) {
	printf(" . ");
	printObject_(cdr1);
    }
}

static void printObject_(Object obj)
{
    switch (obj.type) {
    case OBJTYPE_PAIRPOINTER:
	printf("(");
	printPair(obj);
	printf(")");
	break;
    case OBJTYPE_BROKENHEART:
	printf("Broken Heart");
	break;
    case OBJTYPE_SYMBOL:
	printf("%s", obj.u.symbol->name);
	break;
    case OBJTYPE_STRING:
	printf("\"%s\"", obj.u.string);
	break;
    case OBJTYPE_NUMBER:
	printf("%d", obj.u.number);
	break;
    case OBJTYPE_NULL:
	printf("()");
	break;
    case OBJTYPE_BOOLEAN:
	printf("%s", obj.u.boolean ? "#t" : "#f");
	break;
    case OBJTYPE_PRIMITIVE:
	printf("primitive");
	break;
    case OBJTYPE_EOF:
	printf("EOF");
	break;
    default:
	printf("UNKNOWN OBJECT: %u\n", obj);
	break;
    }
}

void printObject(Register reg)
{
    printObject_(getReg(reg));
}

void dumpObject_(Object obj)
{
    switch (obj.type) {
    case OBJTYPE_PAIRPOINTER:
	printf(" p%02u", obj.u.pair);
	break;
    case OBJTYPE_BROKENHEART:
	printf("  BH");
	break;
    case OBJTYPE_SYMBOL:
	printf("  sy");
	break; 
    case OBJTYPE_STRING:
	printf("  st");
	break;
   case OBJTYPE_NUMBER:
	printf("  n%u", obj.u.number);
	break;
    case OBJTYPE_NULL:
	printf("  e0");
	break;
    case OBJTYPE_EOF:
	printf(" EOF");
	break;
    default:
	printf("  UO");
	break;
    }
}

void dumpObject(Register reg)
{
    dumpObject_(getReg(reg));
}

static void dumpMem(Object* mem, unsigned int amount)
{
    unsigned int i;
    for (i = 0; i < amount; i++) {
	dumpObject_(mem[i]);
    }
}

void dumpMemory(unsigned int amount)
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

static void printRegister(Register reg)
{
    printObject_(theCdrs[reg]);
    printf(": ");
    printObject_(theCars[reg]);
    printf("\n");
}

static void dumpRegister(Register reg)
{
    dumpObject_(theCdrs[reg]);
    printf(": ");
    dumpObject_(theCars[reg]);
    printf("\n");
}

void dumpRegisters(void)
{
    unsigned int i;

    printf("Register dump:\n");
    for (i = 0; i < registerCount; i++)
	dumpRegister(i);
}

void printRegisters(void)
{
    unsigned int i;

    printf("Register print:\n");
    for (i = 0; i < registerCount; i++)
	printRegister(i);
}

void newline(void)
{
    printf("\n");
}

/* stack operations */

void initStack(void)
{
    makeNull(stack);
}

void save(Register reg)
{
    cons(stack, reg, stack);
}

void restore(Register reg)
{
    car(reg, stack);
    cdr(stack, stack);
}



unsigned int length(Register reg)
{
    Object o;
    unsigned int result = 0;

    for (o = getReg(reg); !isNull_(o); o = cdr_(o))
	result++;

    return result;
}

static unsigned int is_eq(Object o1, Object o2)
{
    if (o1.type != o2.type)
	return (FALSE);

    switch (o1.type) {
    case OBJTYPE_NULL:
	return (TRUE);
	break;
    case OBJTYPE_PAIRPOINTER:
	return (o1.u.pair == o2.u.pair);
	break;
    case OBJTYPE_SYMBOL:
	return (o1.u.symbol == o2.u.symbol);
	break;
    case OBJTYPE_STRING:
	return (o1.u.string == o2.u.string);
	break;
    case OBJTYPE_NUMBER:
	return (o1.u.number == o2.u.number);
	break;
    case OBJTYPE_BROKENHEART:
	return (TRUE);
	break;
    case OBJTYPE_PRIMITIVE:
	return (o1.u.primitive == o2.u.primitive);
	break;
    }
    return (FALSE);
}

unsigned int isEq(Register r1, Register r2)
{
    return is_eq(getReg(r1), getReg(r2));
}


/* listSetCdr: find the end of list <front> and set its
 * cdr to <last>
 *
 * Needs
 * Modifies
 *  reg0, reg1 
 */
void listSetCdr(Register result,
		Register front, Register last)
{
    copyReg(reg0, front);
    cdr(reg1, reg0);
    while (!isNull(reg1)) {
	cdr(reg0, reg0);
	cdr(reg1, reg0);
    }
    /* reg0 points now to the last pair */
    setCdr(reg0, last);
    copyReg(result, front);
}


/* snoc: the opposite of cons
 * add <last> to the tail of the list
 * <front> may be null
 * (snoc '() 3) => (3)
 * (snoc '(1 2) 3) => (1 2 3)
 * (snoc '(1 2) '(3 4)) => (1 2 (3 4))
 *
 * Needs
 * Modifies
 */
void snoc(Register result,
	  Register front, Register last)
{
    makeNull(reg1);
    cons(reg1, last, reg1);

    if (isNull(front)) {
	copyReg(result, reg1);
    } else {
	listSetCdr(result, front, reg1);
    }
}

void applyPrimitive(Register result,
		    Register operation, Register operands)
{
    Object op = getReg(operation);
    /* The following register copy is to avoid aliasing
     * regArgs[1] and operands (this happens when the
     * applied primitive is applyPrimitive itself)
     */
    copyReg(regOperands, operands); 
    (*op.u.primitive)(result, regOperands);
}

/* Needs
 *  
 * Modifies
 *  regLooper, regRecord, regName
 */
void assoc(Register result, Register name, Register list)
{
    makeNull(result);
    copyReg(regLooper, list);
    while (!isNull(regLooper)) {
	car(regRecord, regLooper);
	car(regName, regRecord);
	if (isEq(regName, name)) {
	    copyReg(result, regRecord);
	    break;
	}
	cdr(regLooper, regLooper);
    }
}

/* the arithmetic equal (=) */
void equal(Register result, Register r1, Register r2)
{
    Object o1 = getReg(r1);
    Object o2 = getReg(r2);

    makeBoolean(result, (o1.u.number == o2.u.number));
}

void lessThan(Register result, Register r1, Register r2)
{
    Object o1 = getReg(r1);
    Object o2 = getReg(r2);

    makeBoolean(result, (o1.u.number < o2.u.number));
}

void greaterThan(Register result, Register r1, Register r2)
{
    Object o1 = getReg(r1);
    Object o2 = getReg(r2);

    makeBoolean(result, (o1.u.number > o2.u.number));
}

void remainder(Register result, Register r1, Register r2)
{
    Object o1 = getReg(r1);
    Object o2 = getReg(r2);
    int n1 = o1.u.number;
    int n2 = o2.u.number;

    while (n1 >= n2)
	n1 -= n2;

    makeNumber(result, n1);
}

void plus(Register result, Register r1, Register r2)
{
    Object o1 = getReg(r1);
    Object o2 = getReg(r2);
    int n1 = o1.u.number;
    int n2 = o2.u.number;
    makeNumber(result, n1+n2);
}

void minus(Register result, Register r1, Register r2)
{
    Object o1 = getReg(r1);
    Object o2 = getReg(r2);
    int n1 = o1.u.number;
    int n2 = o2.u.number;
    makeNumber(result, n1-n2);
}



/* Return output port */
void openOutputFile(Register result, Register filename)
{
}

void openInputFile(Register result, Register filename)
{
}

void closeInputPort(Register result, Register port)
{
}

void closeOutputPort(Register result, Register port)
{
}

void currentInputPort(Register result)
{
}

void currentOutputPort(Register result)
{
}

unsigned int isOutputPort(Register port)
{
}

unsigned int isInputPort(Register port)
{
}


