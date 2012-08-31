#ifndef _MEMORY_H
#define _MEMORY_H


/* The Register type.
 * You may only use registers returned by allocateRegistes.
 */
typedef unsigned int Register;

typedef void (*Primitive)(Register result, Register operands);

#define MAXARGS 10

extern Register reg0;
extern Register reg1;
extern Register reg2;
extern Register reg3;
extern Register reg4;
extern Register reg5;
extern Register reg6;
extern Register reg7;
extern Register reg8;
extern Register reg9;

extern Register regArgs[MAXARGS];


void initMemory(unsigned int size);
void garbageCollect(void);
int isGcMessages(void);
void setGcMessages(int state);

void makeSymbol(Register reg, char* symbol);
void makeString(Register reg, char* string);
void makeNumber(Register reg, int value);
void makeNull(Register reg);
void makeBoolean(Register reg, char boolean);
void makePrimitive(Register reg, Primitive primitive);
void makeEOF(Register reg);
void makeInputPort(Register reg, char* filename);
void makeOutputPort(Register reg, char* filename);

unsigned int isPair(Register reg);
unsigned int isSymbol(Register reg);
unsigned int isString(Register reg);
unsigned int isNumber(Register reg);
unsigned int isNull(Register reg);
unsigned int isBoolean(Register reg);
unsigned int isPrimitive(Register reg);
unsigned int isTrue(Register reg);
unsigned int isEOF(Register reg);
unsigned int isInputPort(Register reg);
unsigned int isOutputPort(Register reg);

void cons(Register to, Register car, Register cdr);
void snoc(Register to, Register front, Register last);
void listSetCdr(Register to, Register front, Register last);
void car(Register to, Register from);
void cdr(Register to, Register from);
void setCar(Register reg, Register car);
void setCdr(Register reg, Register cdr);

void applyPrimitive(Register result, Register operator, Register operands);

Register allocateRegister(char* regName);
void copyReg(Register to, Register from);
Register lookupRegister(Register reg);

void dumpRegisters(void);
void printRegisters(void);
void dumpMemory(unsigned int amount);

/* stack operations */
void initStack(void);
void save(Register reg);
void restore(Register reg);

void printObject(Register reg);
void dumpObject(Register reg);
void newline(void);

unsigned int isEq(Register r1, Register r2);
unsigned int isEqual(Register r1, Register r2);

unsigned int length(Register reg);

void listSetCdr(Register to, Register front, Register last);
void snoc(Register to, Register front, Register last);

/* arithmetic stuff */
void equal(Register result, Register r1, Register r2);
void lessThan(Register result, Register r1, Register r2);
void greaterThan(Register result, Register r1, Register r2);
void remainder(Register result, Register r1, Register r2);
void plus(Register result, Register r1, Register r2);
void minus(Register result, Register r1, Register r2);


#endif /* _MEMORY_H */
