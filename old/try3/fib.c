#include "memory.h"
#include "read.h"
#include "regsim.h"
#include "coreprim.h"


extern int yydebug;

static void initFib(void)
{
    Register n;
    Register val;
    Register cont;

    n = allocateRegister("n");
    val = allocateRegister("val");
    cont = allocateRegister("continue");

    addOperation("cons",     cons_si);
    addOperation("car",      car_si);
    addOperation("cdr",      cdr_si);
    addOperation("set-car!", setCar_si);
    addOperation("set-cdr!", setCdr_si);

    addOperation("=", equal_si);
    addOperation("<", lessThan_si);
    addOperation(">", greaterThan_si);
    addOperation("+", plus_si);
    addOperation("-", minus_si);

    addOperation("rem", remainder_si);

    addOperation("display", printObject_si);
    addOperation("newline", newline_si);
    addOperation("read",    read_si);

    makeNumber(n, 9);
}


int main(void)
{
    Register regText;

    initMemory(10000);
    initParser();
    initRegSim();

    regText = allocateRegister("regText");

    initFib();

    yydebug = 0;

    read(regText);

    printf("******************\n");
    execute(regText);

#if 0
    printRegisters();
#endif
}
