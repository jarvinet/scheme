#ifndef _REGISTER_H
#define _REGISTER_H

/* max number of arguments to a primitive */
#define MAXARGS 5
extern Register regArgs[MAXARGS];

void regInit(unsigned int regCount);
void regFree(void);

Object regRead(Register reg);
void regWrite(Register reg, Object value);
void regCopy(Register to, Register from);

void regRelocate(unsigned int gcId);

void regPrint(Register reg);
Register regAllocate(char* regName);
bool regLookup(char* name, Register* reg);

Register regGetTemp(void);
void regFreeTemp(Register reg);

void dumpRegisters(void);
void printRegisters(void);

void pr_if(Register result, Register operands);

#endif /* _REGISTER_H */
