#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"
#include "eprint.h"
#include "util.h"

#include "port.h"
#include "null.h"
#include "eof.h"
#include "character.h"
#include "number.h"
#include "boolean.h"
#include "symbol.h"
#include "sstring.h"
#include "primitive.h"
#include "pairpointer.h"
#include "brokenheart.h"
#include "vector.h"
#include "continuation.h"


ObjectType objGetType(Object obj)
{
    return obj.type;
}

bool objIsBoolean(Object obj)
{
    return (objGetType(obj) == OBJTYPE_BOOLEAN);
}

bool regIsBoolean(Register reg)
{
    return objIsBoolean(regRead(reg));
}

void isBoolean_if(Register result, Register operands)
{
    checkArgsEQ("boolean?", "*", operands);
    regMakeBoolean(result, regIsBoolean(regArgs[0]));
}

bool objIsBrokenHeart(Object obj)
{
    return (objGetType(obj) == OBJTYPE_BROKENHEART);
}

bool objIsCharacter(Object obj)
{
    return (objGetType(obj) == OBJTYPE_CHARACTER);
}

bool regIsCharacter(Register reg)
{
    return objIsCharacter(regRead(reg));
}

void isCharacter_if(Register result, Register operands)
{
    checkArgsEQ("char?", "*", operands);
    regMakeBoolean(result, regIsCharacter(regArgs[0]));
}

bool objIsEOF(Object obj)
{
    return (objGetType(obj) == OBJTYPE_EOF);
}

bool regIsEOF(Register reg)
{
    return objIsEOF(regRead(reg));
}

void isEOF_if(Register result, Register operands)
{
    checkArgsEQ("eof-object?", "*", operands);
    regMakeBoolean(result, regIsEOF(regArgs[0]));
}

bool objIsNull(Object obj)
{
    return (objGetType(obj) == OBJTYPE_NULL);
}

bool regIsNull(Register reg)
{
    return objIsNull(regRead(reg));
}

void isNull_if(Register result, Register operands)
{
    checkArgsEQ("null?", "*", operands);
    regMakeBoolean(result, regIsNull(regArgs[0]));
}

bool objIsNumber(Object obj)
{
    return (objGetType(obj) == OBJTYPE_NUMBER);
}

bool regIsNumber(Register reg)
{
    return objIsNumber(regRead(reg));
}

void isNumber_if(Register result, Register operands)
{
    checkArgsEQ("number?", "*", operands);
    regMakeBoolean(result, regIsNumber(regArgs[0]));
}

bool objIsPairPointer(Object obj)
{
    return (objGetType(obj) == OBJTYPE_PAIRPOINTER);
}

bool regIsPairPointer(Register reg)
{
    return objIsPairPointer(regRead(reg));
}

void isPair_if(Register result, Register operands)
{
    checkArgsEQ("pair?", "*", operands);
    regMakeBoolean(result, regIsPairPointer(regArgs[0]));
}

bool objIsInputPort(Object obj)
{
    return (objGetType(obj) == OBJTYPE_INPUT_PORT);
}

bool regIsInputPort(Register reg)
{
    return objIsInputPort(regRead(reg));
}

void isInputPort_if(Register result, Register operands)
{
    checkArgsEQ("input-port?", "*", operands);
    regMakeBoolean(result, regIsInputPort(regArgs[0]));
}

bool objIsOutputPort(Object obj)
{
    return (objGetType(obj) == OBJTYPE_OUTPUT_PORT);
}

bool regIsOutputPort(Register reg)
{
    return objIsOutputPort(regRead(reg));
}

void isOutputPort_if(Register result, Register operands)
{
    checkArgsEQ("output-port?", "*", operands);
    regMakeBoolean(result, regIsOutputPort(regArgs[0]));
}

bool objIsPrimitive(Object obj)
{
    return (objGetType(obj) == OBJTYPE_PRIMITIVE);
}

bool regIsPrimitive(Register reg)
{
    return objIsPrimitive(regRead(reg));
}

void isPrimitive_if(Register result, Register operands)
{
    checkArgsEQ("primitive?", "*", operands);
    regMakeBoolean(result, regIsPrimitive(regArgs[0]));
}

bool objIsString(Object obj)
{
    return (objGetType(obj) == OBJTYPE_STRING);
}

bool regIsString(Register reg)
{
    return objIsString(regRead(reg));
}

void isString_if(Register result, Register operands)
{
    checkArgsEQ("string?", "*", operands);
    regMakeBoolean(result, regIsString(regArgs[0]));
}

bool objIsSymbol(Object obj)
{
    return (objGetType(obj) == OBJTYPE_SYMBOL);
}

bool regIsSymbol(Register reg)
{
    return objIsSymbol(regRead(reg));
}

void isSymbol_if(Register result, Register operands)
{
    checkArgsEQ("symbol?", "*", operands);
    regMakeBoolean(result, regIsSymbol(regArgs[0]));
}

bool objIsVector(Object obj)
{
    return (objGetType(obj) == OBJTYPE_VECTOR);
}

bool regIsVector(Register reg)
{
    return objIsVector(regRead(reg));
}

void isVector_if(Register result, Register operands)
{
    checkArgsEQ("vector?", "*", operands);
    regMakeBoolean(result, regIsVector(regArgs[0]));
}

bool objIsContinuation(Object obj)
{
    return (objGetType(obj) == OBJTYPE_CONTINUATION);
}

bool regIsContinuation(Register reg)
{
    return objIsContinuation(regRead(reg));
}

void isContinuation_if(Register result, Register operands)
{
    checkArgsEQ("continuation?", "*", operands);
    regMakeBoolean(result, regIsContinuation(regArgs[0]));
}

unsigned int objUnref(Object obj)
{
    unsigned int result;
    switch (objGetType(obj)) {
    case OBJTYPE_STRING:
	result = objUnrefString(obj);
	break;
    case OBJTYPE_INPUT_PORT:
	result = objUnrefInputPort(obj);
	break;
    case OBJTYPE_OUTPUT_PORT:
	result = objUnrefOutputPort(obj);
	break;
    case OBJTYPE_VECTOR:
	result = objUnrefVector(obj);
	break;
    case OBJTYPE_CONTINUATION:
	result = objUnrefContinuation(obj);
	break;
    default:
	result = 0;
	break;
    }
    return result;
}

unsigned int objRef(Object obj)
{
    unsigned int result;
    switch (objGetType(obj)) {
    case OBJTYPE_STRING:
	result = objRefString(obj);
	break;
    case OBJTYPE_INPUT_PORT:
	result = objRefInputPort(obj);
	break;
    case OBJTYPE_OUTPUT_PORT:
	result = objRefOutputPort(obj);
	break;
    case OBJTYPE_VECTOR:
	result = objRefVector(obj);
	break;
    case OBJTYPE_CONTINUATION:
	result = objRefContinuation(obj);
	break;
    default:
	result = 0;
	break;
    }
    return result;
}

void objDisplay(Object obj, FILE* file,
		unsigned int depth, unsigned int quitThisDeep)
{
    switch (objGetType(obj)) {
    case OBJTYPE_PAIRPOINTER:
	fprintf(file, "(");
	objDisplayPairPointer(obj, file, depth, quitThisDeep);
	fprintf(file, ")");
	break;
    case OBJTYPE_BROKENHEART:
	objDisplayBrokenHeart(obj, file);
	break;
    case OBJTYPE_SYMBOL:
	objDisplaySymbol(obj, file);
	break;
    case OBJTYPE_STRING:
	objDisplayString(obj, file);
	break;
    case OBJTYPE_NUMBER:
	objDisplayNumber(obj, file);
	break;
    case OBJTYPE_NULL:
	objDisplayNull(obj, file);
	break;
    case OBJTYPE_BOOLEAN:
	objDisplayBoolean(obj, file);
	break;
    case OBJTYPE_PRIMITIVE:
	objDisplayPrimitive(obj, file);
	break;
    case OBJTYPE_EOF:
	objDisplayEOF(obj, file);
	break;
    case OBJTYPE_OUTPUT_PORT:
	objDisplayOutputPort(obj, file);
	break;
    case OBJTYPE_INPUT_PORT:
	objDisplayInputPort(obj, file);
	break;
    case OBJTYPE_CHARACTER:
	objDisplayCharacter(obj, file);
        break;
    case OBJTYPE_VECTOR:
	objDisplayVector(obj, file, depth, quitThisDeep);
	break;
    case OBJTYPE_CONTINUATION:
	objDisplayContinuation(obj, file);
	break;
    default:
	fprintf(file, "UNKNOWN OBJECT: %u\n", objGetType(obj));
	break;
    }
}

void po(Object obj)
{
    objDisplay(obj, stdout, 0, maxDepthToPrint());
    printf("\n");
}

void objWrite(Object obj, FILE* file,
	      unsigned int depth, unsigned int quitThisDeep)
{
    switch (objGetType(obj)) {
    case OBJTYPE_PAIRPOINTER:
	fprintf(file, "(");
	objWritePairPointer(obj, file, depth, quitThisDeep);
	fprintf(file, ")");
	break;
    case OBJTYPE_BROKENHEART:
	objWriteBrokenHeart(obj, file);
	break;
    case OBJTYPE_SYMBOL:
	objWriteSymbol(obj, file);
	break;
    case OBJTYPE_STRING:
	objWriteString(obj, file);
	break;
    case OBJTYPE_NUMBER:
	objWriteNumber(obj, file);
	break;
    case OBJTYPE_NULL:
	objWriteNull(obj, file);
	break;
    case OBJTYPE_BOOLEAN:
	objWriteBoolean(obj, file);
	break;
    case OBJTYPE_PRIMITIVE:
	objWritePrimitive(obj, file);
	break;
    case OBJTYPE_EOF:
	objWriteEOF(obj, file);
	break;
    case OBJTYPE_OUTPUT_PORT:
	objWriteOutputPort(obj, file);
	break;
    case OBJTYPE_INPUT_PORT:
	objWriteInputPort(obj, file);
	break;
    case OBJTYPE_CHARACTER:
	objWriteCharacter(obj, file);
        break;
    case OBJTYPE_VECTOR:
	objWriteVector(obj, file, depth, quitThisDeep);
	break;
    case OBJTYPE_CONTINUATION:
	objWriteContinuation(obj, file);
	break;
    default:
	fprintf(file, "UNKNOWN OBJECT: %u\n", objGetType(obj));
	break;
    }
}

void objDump(Object obj)
{
    switch (objGetType(obj)) {
    case OBJTYPE_PAIRPOINTER:
	printf(" p%02u", objGetPairPointer(obj));
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
	printf("  n%u", objGetNumber(obj));
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

bool objIsEq(Object o1, Object o2)
{
    if (objGetType(o1) != objGetType(o2))
	return (FALSE);

    switch (objGetType(o1)) {
    case OBJTYPE_NULL:
	return objIsEqNull(o1, o2);
	break;
    case OBJTYPE_PAIRPOINTER:
	return objIsEqPairPointer(o1, o2);
	break;
    case OBJTYPE_SYMBOL:
	return objIsEqSymbol(o1, o2);
	break;
    case OBJTYPE_BOOLEAN:
	return objIsEqBoolean(o1, o2);
	break;
    case OBJTYPE_STRING:
	return objIsEqString(o1, o2);
	break;
    case OBJTYPE_NUMBER:
	return objIsEqNumber(o1, o2);
	break;
    case OBJTYPE_BROKENHEART:
	return objIsEqBrokenHeart(o1, o2);
	break;
    case OBJTYPE_PRIMITIVE:
	return objIsEqPrimitive(o1, o2);
	break;
    case OBJTYPE_EOF:
	return objIsEqEOF(o1, o2);
	break;
    case OBJTYPE_OUTPUT_PORT:
	return objIsEqOutputPort(o1, o2);
	break;
    case OBJTYPE_INPUT_PORT:
	return objIsEqInputPort(o1, o2);
	break;
    case OBJTYPE_CHARACTER:
	return objIsEqCharacter(o1, o2);
	break;
    case OBJTYPE_VECTOR:
	return objIsEqVector(o1, o2);
	break;
    case OBJTYPE_CONTINUATION:
	return objIsEqContinuation(o1, o2);
	break;
    }
    return (FALSE);
}

bool regIsEq(Register r1, Register r2)
{
    return objIsEq(regRead(r1), regRead(r2));
}

void isEq_if(Register result, Register operands)
{
    checkArgsEQ("eq?", "**", operands);
    regMakeBoolean(result, regIsEq(regArgs[0], regArgs[1]));
}

bool objIsEqual(Object o1, Object o2)
{
    if (objGetType(o1) != objGetType(o2))
	return (FALSE);

    switch (objGetType(o1)) {
    case OBJTYPE_NULL:
	return objIsEqualNull(o1, o2);
	break;
    case OBJTYPE_PAIRPOINTER:
	return objIsEqualPairPointer(o1, o2);
	break;
    case OBJTYPE_SYMBOL:
	return objIsEqualSymbol(o1, o2);
	break;
    case OBJTYPE_BOOLEAN:
	return objIsEqualBoolean(o1, o2);
	break;
    case OBJTYPE_STRING:
	return objIsEqualString(o1, o2);
	break;
    case OBJTYPE_NUMBER:
	return objIsEqualNumber(o1, o2);
	break;
    case OBJTYPE_BROKENHEART:
	return objIsEqualBrokenHeart(o1, o2);
	break;
    case OBJTYPE_PRIMITIVE:
	return objIsEqualPrimitive(o1, o2);
	break;
    case OBJTYPE_EOF:
	return objIsEqualEOF(o1, o2);
	break;
    case OBJTYPE_OUTPUT_PORT:
	return objIsEqualOutputPort(o1, o2);
	break;
    case OBJTYPE_INPUT_PORT:
	return objIsEqualInputPort(o1, o2);
	break;
    case OBJTYPE_CHARACTER:
	return objIsEqualCharacter(o1, o2);
	break;
    case OBJTYPE_VECTOR:
	return objIsEqualVector(o1, o2);
	break;
    case OBJTYPE_CONTINUATION:
	return objIsEqualContinuation(o1, o2);
	break;
    }
    return (FALSE);
}

bool regIsEqual(Register r1, Register r2)
{
    return objIsEqual(regRead(r1), regRead(r2));
}

void isEqual_if(Register result, Register operands)
{
    checkArgsEQ("equal?", "**", operands);
    regMakeBoolean(result, regIsEqual(regArgs[0], regArgs[1]));
}
