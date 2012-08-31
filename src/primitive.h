#ifndef _PRIMITIVE_H
#define _PRIMITIVE_H

typedef void (*Primitive)(Register result, Register operands);

void initPrimitives(void);
void freePrimitives(void);

Object objMakePrimitive(char* name, Primitive primitive);
Primitive objGetPrimitive(Object obj);
char* objGetPrimitiveName(Object obj);

void objDisplayPrimitive(Object obj, FILE* file);
void objWritePrimitive(Object obj, FILE* file);
bool objIsEqPrimitive(Object o1, Object o2);
bool objIsEqualPrimitive(Object o1, Object o2);

void regMakePrimitive(Register reg, char* name, Primitive primitive);
Primitive regGetPrimitive(Register reg);
void applyPrimitiveProcedure_if(Register result, Register operands);

#endif /* _PRIMITIVE_H */

