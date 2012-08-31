#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#include "common.h"
#include "parameters.h"
#include "symbol.h"
#include "util.h"
#include "sstring.h"
#include "boolean.h"
#include "number.h"
#include "argcheck.h"

static Hashtable obarray;

void initSymbols(void)
{
    obarray = htCreate();
}

/* TODO: how to free the properties-hashtable? */
void freeSymbols(void)
{
    htDelete(obarray);
}

Object objMakeSymbol(char* symbol)
{
    Object obj;
    obj.type = OBJTYPE_SYMBOL;
    obj.u.symbol = htLookup(obarray, symbol, HASHOP_CREATE, (void*)0);
    return obj;
}

void regMakeSymbol(Register reg, char* symbol)
{
    regWrite(reg, objMakeSymbol(symbol));
}

char* objGetSymbol(Object obj)
{
    assert(objIsSymbol(obj));
    return bindGetName(obj.u.symbol);
}

char* regGetSymbol(Register reg)
{
    return objGetSymbol(regRead(reg));
}

void objDisplaySymbol(Object obj, FILE* file)
{
    fprintf(file, "%s", objGetSymbol(obj));
}

void objWriteSymbol(Object obj, FILE* file)
{
    objDisplaySymbol(obj, file);
}

static void symbol2string(Register result, Register symbol)
{
    regMakeString(result, estrdup(regGetSymbol(symbol)));
}

void symbol2string_if(Register result, Register operands)
{
    checkArgsEQ("symbol->string", "y", operands);
    symbol2string(result, regArgs[0]);
}

bool objIsEqSymbol(Object o1, Object o2)
{
    return (objGetSymbol(o1) == objGetSymbol(o2));
}

bool objIsEqualSymbol(Object o1, Object o2)
{
    return objIsEqSymbol(o1, o2);
}

unsigned int objHashSymbol(Object obj)
{
    return hash(objGetSymbol(obj));
}

void regHashSymbol(Register result, Register symbol)
{
    regMakeNumber(result, objHashSymbol(regRead(symbol)));
}

void symbolHash_if(Register result, Register operands)
{
    checkArgsEQ("symbol-hash", "y", operands);
    regHashSymbol(result, regArgs[0]);
}

void regGenerateSymbol(Register result, Register prefix)
{
    time_t time1 = time(NULL);
    struct tm *time2 = localtime(&time1);
    char time3[64];
    char time4[64];
    static char prev[64];
    static unsigned int count = 0;

    strftime(time3, 60, "%Y%m%d%H%M%S", time2);

    if (strcmp(time3, prev) == 0) {
      count++;
    }
    else {
      strcpy(prev, time3);
      count = 0;
    }
    sprintf(time4, "%s%s%u", regGetSymbol(prefix), time3, count);

    regMakeSymbol(result, time4);
}

void generateSymbol_if(Register result, Register operands)
{
    if (checkArgs("gensym", 0, "y", operands) < 1)
	regMakeSymbol(regArgs[0], "s");
    regGenerateSymbol(result, regArgs[0]);
}
