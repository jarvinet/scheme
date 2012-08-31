#ifndef _BOOLEAN_H
#define _BOOLEAN_H

Object objMakeBoolean(bool boolean);
bool objGetBoolean(Object obj);
bool objIsTrue(Object obj);
bool objIsFalse(Object obj);
void objDisplayBoolean(Object obj, FILE* file);
void objWriteBoolean(Object obj, FILE* file);
bool objIsEqBoolean(Object o1, Object o2);
bool objIsEqualBoolean(Object o1, Object o2);

void regMakeBoolean(Register reg, bool boolean);
bool regGetBoolean(Register reg);
bool regIsTrue(Register reg);
bool regIsFalse(Register reg);

void isTrue_if(Register result, Register operands);
void isFalse_if(Register result, Register operands);
void not_if(Register result, Register operands);

#endif /* _BOOLEAN_H */
