#ifndef _MEMORY_H
#define _MEMORY_H


extern Register regStack;

void memInit(unsigned int size);
void memFree(void);

void memWrite(Object* theCrs, unsigned int i, Object newValue);
Object memRead(Object* theCrs, unsigned int i);

void memRelocate(Object* newCrs, unsigned int index, unsigned int gcId);
void dumpMemory(unsigned int amount);

void snoc(Register to, Register front, Register last);
void cons(Register to, Register car, Register cdr);
void listSetCdr(Register to, Register front, Register last);
Object objCar(Object obj);
Object objCdr(Object obj);

void regCar(Register to, Register from);
void regCdr(Register to, Register from);
void regSetCar(Register reg, Register car);
void regSetCdr(Register reg, Register cdr);

void cons_if(Register result, Register operands);
void snoc_if(Register result, Register operands);
void car_if(Register result, Register operands);
void cdr_if(Register result, Register operands);
void setCar_if(Register result, Register operands);
void setCdr_if(Register result, Register operands);

void initStack(void);

void save(Register reg);
void restore(Register reg);

void save2(char* name, Register reg);
void restore2(char* name, Register reg);
void printStack(void);


void printStackStatistics(void);

void isGcMessages_if(Register result, Register operands);
void setGcMessages_if(Register result, Register operands);
void gc_if(Register result, Register operands);
void initStack_if(Register result, Register operands);
void printStackStatistics_if(Register result, Register operands);

void listCopy(Register result, Register list);
void listCopy_if(Register result, Register operands);

#endif /* _MEMORY_H */
