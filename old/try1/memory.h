#ifndef _MEMORY_H
#define _MEMORY_H

typedef unsigned int Object;



// Registers
extern Object expr; // hold expressions to be evaluated
extern Object env;  // the environment in which the evaluation is to be performed
extern Object val;  // value of the evaluated expressiobn
extern Object cont; // to implement recusion
extern Object proc; // for evaluating combinations
extern Object argl;
extern Object unev;


void initMemory(unsigned int size);
void garbageCollect(void);

Object cons(Object car, Object cdr);
Object car(Object obj);
Object cdr(Object obj);
void setCar(Object obj, Object value);
void setCdr(Object obj, Object value);
unsigned int isPair(Object obj);
unsigned int isSymbol(Object obj);
unsigned int isNumber(Object obj);
unsigned int isNull(Object obj);
Object makePair(unsigned int value);
Object makeSymbol(unsigned int index);
Object makeNumber(unsigned int value);
Object makeNull(void);

void dumpRegisters(void);
void printRegisters(void);
void printObject(Object obj);
void dumpObject(Object obj);
void dumpMemory(unsigned int amount);

#endif /* _MEMORY_H */
