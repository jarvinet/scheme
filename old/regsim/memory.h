#ifndef _MEMORY_H
#define _MEMORY_H

void initMemory(unsigned int size);
void garbageCollect(void);

Object cons(Object car, Object cdr);
Object car(Object obj);
Object cdr(Object obj);
void setCar(Object obj, Object value);
void setCdr(Object obj, Object value);

void allocateRegister(char* name);
Object getReg(char* name);
void setReg(char* name, Object newValue);

void dumpRegisters(void);
void printRegisters(void);
void dumpMemory(unsigned int amount);


/* stack operations */
void initializeStack(void);
void save(Object obj);
Object restore(void);

#endif /* _MEMORY_H */
