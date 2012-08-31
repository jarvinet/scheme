#include <stdio.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"
#include "eprint.h"

#include "vector.h"
#include "null.h"
#include "util.h"
#include "port.h"


static Register registerCount = 0;
static unsigned int maxRegisters;

static Hashtable registers;

static Object registerVector;

#define DYNREGCOUNT 200
typedef struct dynamicRegister {
    Register reg;
    bool inUse;
    char* name;
} DynamicRegister;
DynamicRegister dynregs[DYNREGCOUNT];

Register regArgs[MAXARGS];


Object regRead(Register reg)
{
    return objVectorRef(registerVector, reg);
}

void regWrite(Register reg, Object value)
{
    objVectorSet(registerVector, reg, value);
}

void regCopy(Register to, Register from)
{
    if (to == from)
	return;
    else
	regWrite(to, regRead(from));
}

void regRelocate(unsigned int gcId)
{
    objVectorRelocate(registerVector, gcId);
}

/* Registers */

/* Allocate a new register.
 */
Register regAllocate(char* regName)
{
    Register reg;

    if (htLookup(registers, regName, HASHOP_LOOKUP, 0))
	eprintf("register %s already defined\n", regName);

    reg = registerCount;
    registerCount++;
    if (registerCount >= maxRegisters)
	eprintf("Trying to allocate too many registers\n");

    htLookup(registers, regName, HASHOP_CREATE, (void*)reg);

    return reg;
}

/* Get register by its name
 * return FALSE if the register is not found
 */
bool regLookup(char* name, Register* reg)
{
    Binding binding = htLookup(registers, name, HASHOP_LOOKUP, 0);
    if (binding == NULL)
	return FALSE;
    *reg = (Register)bindGetValue(binding);
    return TRUE;
}

/* dynamically-allocatable registers */
static void regAllocateTemp(void)
{
    unsigned int i;
    char name[16];
    
    for (i = 0; i < DYNREGCOUNT; i++) {
	sprintf(name, "regDynTemp%d", i);
	dynregs[i].reg = regAllocate(name);
	dynregs[i].inUse = FALSE;
    }
}

Register regGetTemp(void)
{
    unsigned int i;
    
    for (i = 0; i < DYNREGCOUNT; i++) {
	if (dynregs[i].inUse == FALSE) {
	    dynregs[i].inUse = TRUE;
	    return i;
	}
    }
    eprintf("regGetTemp: cannot get dynamic register\n");
    return 0; /* not possible */
}

void regFreeTemp(Register reg)
{
    if (dynregs[reg].inUse == FALSE) {
	eprintf("regFreeTemp: dynamic register not in use\n");
    } else {
	dynregs[reg].inUse = FALSE;
	regMakeNull(dynregs[reg].reg);
    }
}

void regPrint(Register reg)
{
    objDisplay(regRead(reg), stdout, 0, maxDepthToPrint());
}

void pr(Register reg)
{
    fprintf(stdout, "[%d]", reg);
    printf(": ");
    objDisplay(regRead(reg), stdout, 0, maxDepthToPrint());
    printf("\n");
}

static void regDump(Register reg)
{
    printf(": ");
    objDump(regRead(reg));
    printf("\n");
}

void dumpRegisters(void)
{
    unsigned int i;
    printf("Register dump:\n");
    for (i = 0; i < registerCount; i++)
	regDump(i);
}

void printRegisters(void)
{
    unsigned int i;
    printf("Register print:\n");
    for (i = 0; i < registerCount; i++)
	regPrint(i);
}

void pr_if(Register result, Register operands)
{
    checkArgsEQ("pr", "", operands);
    printRegisters();
}

void regInit(unsigned int regCount)
{
    char name[16];
    unsigned int i;

    maxRegisters = regCount;
    registers  = htCreate();
    registerVector = objMakeVector(regCount, objMakeNull());
    regAllocateTemp();

    for (i = 0; i < MAXARGS; i++) {
	sprintf(name, "memArg%d", i);
	regArgs[i] = regAllocate(name);
    }
}

void regFree(void)
{
    /* TODO: Check here for not deallocated dynamic registers */
    htDelete(registers);
    objDeleteVector(registerVector);
}
