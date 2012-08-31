#ifndef _NUMBER_H
#define _NUMBER_H

Object objMakeNumber(int value);

int objGetNumber(Object obj);
void objDisplayNumber(Object obj, FILE* file);
void objWriteNumber(Object obj, FILE* file);
bool objIsEqNumber(Object o1, Object o2);
bool objIsEqualNumber(Object o1, Object o2);

void regMakeNumber(Register reg, int value);
int regGetNumber(Register reg);

void number2string_if(Register result, Register operands);

#endif /* _NUMBER_H */
