#ifndef _SSTRING_H
#define _SSTRING_H

Object objMakeString(char* str);

char* objGetString(Object obj);
unsigned int objUnrefString(Object obj);
unsigned int objRefString(Object obj);
void objDisplayString(Object obj, FILE* file);
void objWriteString(Object obj, FILE* file);
bool objIsEqString(Object o1, Object o2);
bool objIsEqualString(Object o1, Object o2);

void regMakeString(Register reg, char* str);
char* regGetString(Register reg);
void makeString_if(Register result, Register operands);
void string2symbol_if(Register result, Register operands);
void string2number_if(Register result, Register operands);
void stringAppend_if(Register result, Register operands);
void stringLength_if(Register result, Register operands);
void stringRef_if(Register result, Register operands);
void stringSet_if(Register result, Register operands);
void subString_if(Register result, Register operands);
void stringFill_if(Register result, Register operands);
void stringCopy_if(Register result, Register operands);

#endif /* _SSTRING_H */
