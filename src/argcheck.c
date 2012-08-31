#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"
#include "eprint.h"

#include "symbol.h"
#include "null.h"
#include "primitive.h"
#include "pairpointer.h"
#include "boolean.h"
#include "sstring.h"
#include "number.h"
#include "character.h"
#include "port.h"



/*

z, z1, ... zj , complex number
x, x1, ... xj , real number
y, y1, ... yj , real number
q, q1, ... qj , rational number
n, n1, ... nj , integer
k, k1, ... kj , exact non-negative integer

*/

static int checkType(char typeDecl, Register arg)
{
    switch (typeDecl) {
    case 'p': return regIsPairPointer(arg);
	/* TODO: change list checking to use "list?" */
    case 'l': return (regIsPairPointer(arg) || regIsNull(arg));
    case 'y': return regIsSymbol(arg);
    case 's': return regIsString(arg);
    case 'n': return regIsNumber(arg);
    case 'b': return regIsBoolean(arg);
    case 'r': return regIsPrimitive(arg);
    case 'i': return regIsInputPort(arg);
    case 'o': return regIsOutputPort(arg);
    case 'c': return regIsCharacter(arg);
    case 'v': return regIsVector(arg);
    case 't': return regIsContinuation(arg);
    case '*': return 1;	/* accept all types */
    default:
	eprintf("checkType: unknown arg type: %c\n", typeDecl);
	break;
    }
    return 1;
}

static char* typeCharToString(char typeDecl)
{
    switch (typeDecl) {
    case 'p': return "pair";
    case 'l': return "list";
    case 'y': return "symbol";
    case 's': return "string";
    case 'n': return "number";
    case 'b': return "boolean";
    case 'r': return "primitive";
    case 'i': return "input port";
    case 'o': return "output port";
    case 'c': return "character";
    case 'v': return "vector";
    case 't': return "continuation";
    case '*': return "<any type>";
    default:  return "<unknown type checker character>";
    }
}

unsigned int
checkArgs(char* name, unsigned int minArgs, char* types, Register operands)
{
    unsigned int nargs = regListLength(operands);
    unsigned int maxArgs = strlen(types);
    unsigned int i;

    if ((nargs < minArgs) || (nargs > maxArgs)) {
	if (minArgs == maxArgs) {
	    esprint("*** %s: want exactly %d arguments\n",
		    name, minArgs);
	} else {
	    esprint("*** %s: want min %d, max %d arguments\n",
		    name, minArgs, maxArgs);
	}
    }
    for (i = 0; i < nargs; i++) {
	regCar(regArgs[i], operands);
	if (!checkType(types[i], regArgs[i]))
	    esprint("*** %s: arg %d must be a %s\n",
		    name, i, typeCharToString(types[i]));
	regCdr(operands, operands);
    }

    return nargs;
}

unsigned int
checkArgsEQ(char* name, char* types, Register operands)
{
    return checkArgs(name, strlen(types), types, operands);
}

unsigned int
checkArgsN(char* name, char* type, Register operands)
{
    unsigned int nargs = regListLength(operands);
    unsigned int i;

    for (i = 0; i < nargs; i++) {
	regCar(regArgs[0], operands);
	if (!checkType(type[0], regArgs[0]))
	    esprint("*** %s: arg %d must be a %s\n",
		    name, i, typeCharToString(type[0]));
	regCdr(operands, operands);
    }

    return nargs;
}
