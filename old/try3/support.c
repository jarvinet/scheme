#include "memory.h"
#include "support.h"


void promptForInput(Register result, Register string)
{
    newline();
    newline();
    printObject(string);
    newline();
}

void announceOutput(Register result, Register string)
{
    newline();
    printObject(string);
    newline();
}

void userPrint(Register result, Register object)
{
    isCompoundProcedure(result, object);
    if (isTrue(result)) {
	makeSymbol(result, "compound-procedure");
	printObject(result);
	procedureParameters(result, object);
	printObject(result);
	procedureBody(result, object);
	printObject(result);
    } else {
	printObject(object);
    }
}

