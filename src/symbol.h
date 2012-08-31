#ifndef _SYMBOL_H
#define _SYMBOL_H

void initSymbols(void);
void freeSymbols(void);

Object objMakeSymbol(char* symbol);
char* objGetSymbol(Object obj);
void objDisplaySymbol(Object obj, FILE* file);
void objWriteSymbol(Object obj, FILE* file);
bool objIsEqSymbol(Object o1, Object o2);
bool objIsEqualSymbol(Object o1, Object o2);

void regMakeSymbol(Register reg, char* symbol);
char* regGetSymbol(Register reg);
void regHashSymbol(Register result, Register symbol);
void regGenerateSymbol(Register result, Register prefix);

void symbol2string_if(Register result, Register operands);
void symbolHash_if(Register result, Register operands);
void generateSymbol_if(Register result, Register operands);

#endif /* _SYMBOL_H */
