#ifndef _PAIRPOINTER_H
#define _PAIRPOINTER_H

Object objMakePairPointer(MemRef value);
MemRef objGetPairPointer(Object obj);
void objDisplayPairPointer(Object obj, FILE* file, unsigned int depth, unsigned int quitThisDeep);
void objWritePairPointer(Object obj, FILE* file, unsigned int depth, unsigned int quitThisDeep);
bool objIsEqPairPointer(Object o1, Object o2);
bool objIsEqualPairPointer(Object o1, Object o2);

MemRef regGetPairPointer(Register reg);
unsigned int regListLength(Register reg);

void list_if(Register result, Register operands);

#endif /* _PAIRPOINTER_H */
