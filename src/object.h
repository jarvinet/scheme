#ifndef _OBJECT_H
#define _OBJECT_H

#include "glue.h"


typedef enum objectType ObjectType;
enum objectType {
    OBJTYPE_NULL,
    OBJTYPE_PAIRPOINTER,
    OBJTYPE_SYMBOL,
    OBJTYPE_STRING,
    OBJTYPE_NUMBER,
    OBJTYPE_BROKENHEART,
    OBJTYPE_BOOLEAN,
    OBJTYPE_PRIMITIVE,
    OBJTYPE_EOF,
    OBJTYPE_OUTPUT_PORT,
    OBJTYPE_INPUT_PORT,
    OBJTYPE_CHARACTER,
    OBJTYPE_VECTOR,
    OBJTYPE_CONTINUATION
};

typedef unsigned int MemRef;

typedef struct object Object;
struct object {
    ObjectType type;

    union {
	MemRef  pairPointer;  /* pointer to the memory */
	Binding symbol;       /* pointer to the obarray table */
	int     number;       /* number */
	bool    boolean;      /* boolean true or false */
        Glue    string;       /* strings */
        Binding primitive;    /* primitives */
	Glue    port;         /* input and output port */
        char    character;    /* characters */
	Glue    vector;       /* vector */
	Glue    continuation; /* continuation */

	/* NULL, BROKENHEART and EOF do not store any data */
    } u;
};


ObjectType objGetType(Object obj);

bool objIsBoolean(Object obj);
bool regIsBoolean(Register reg);

bool objIsBrokenHeart(Object obj);

bool objIsCharacter(Object obj);
bool regIsCharacter(Register reg);

bool objIsEOF(Object obj);
bool regIsEOF(Register reg);

bool objIsNull(Object obj);
bool regIsNull(Register reg);

bool objIsNumber(Object obj);
bool regIsNumber(Register reg);

bool objIsPairPointer(Object obj);
bool regIsPairPointer(Register reg);

bool objIsInputPort(Object obj);
bool regIsInputPort(Register reg);

bool objIsOutputPort(Object obj);
bool regIsOutputPort(Register reg);

bool objIsPrimitive(Object obj);
bool regIsPrimitive(Register reg);

bool objIsString(Object obj);
bool regIsString(Register reg);

bool objIsSymbol(Object obj);
bool regIsSymbol(Register reg);

bool objIsEq(Object o1, Object o2);
bool regIsEq(Register r1, Register r2);

bool objIsEqual(Object o1, Object o2);
bool regIsEqual(Register r1, Register r2);

bool objIsVector(Object obj);
bool regIsVector(Register reg);

bool objIsContinuation(Object obj);
bool regIsContinuation(Register reg);

unsigned int objUnref(Object obj);
unsigned int objRef(Object obj);

void objDisplay(Object obj, FILE* file, unsigned int depth, unsigned int quitThisDeep);
void objWrite(Object obj, FILE* file, unsigned int depth, unsigned int quitThisDeep);
void objDump(Object obj);

void isBoolean_if(Register result, Register operands);
void isCharacter_if(Register result, Register operands);
void isEOF_if(Register result, Register operands);
void isNull_if(Register result, Register operands);
void isNumber_if(Register result, Register operands);
void isPair_if(Register result, Register operands);
void isInputPort_if(Register result, Register operands);
void isOutputPort_if(Register result, Register operands);
void isPrimitive_if(Register result, Register operands);
void isString_if(Register result, Register operands);
void isSymbol_if(Register result, Register operands);
void isVector_if(Register result, Register operands);
void isContinuation_if(Register result, Register operands);

void isEq_if(Register result, Register operands);
void isEqual_if(Register result, Register operands);

#endif /* _OBJECT_H */
