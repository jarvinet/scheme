#ifndef _MEMORY_H
#define _MEMORY_H

typedef unsigned int Register;

extern Register regExp;
extern Register regEnv;
extern Register regVal;
extern Register regCont;
extern Register regProc;
extern Register regArgl;
extern Register regUnev;


void initMemory(unsigned int size);
void garbageCollect(void);
int isGcMessages(void);
void setGcMessages(int state);


/* NOTE: cons triggers the garbage collection when the 
 * memory is exhausted. Garbage collection invalidates
 * _every_ object that is not in the memory, e.g.
 * local variables and function arguments. Tere is no
 * way to know when the gc is triggered, so you have
 * to assume that every call to cons invalidates all objects
 * not in memory. So you have to be careful with the local
 * Object variables. It is always safe to operate with
 * the registers.
 */
Object cons(Object car, Object cdr);
Object car(Object obj);
Object cdr(Object obj);
void setCar(Object obj, Object value);
void setCdr(Object obj, Object value);

Register allocateRegister(char* regName);
Object getReg(Register reg);
void setReg(Register reg, Object newValue);

void dumpRegisters(void);
void printRegisters(void);
void dumpMemory(unsigned int amount);


/* stack operations */
void initializeStack(void);
void save(Register reg);
void restore(Register reg);



#endif /* _MEMORY_H */
