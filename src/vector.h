#ifndef _VECTOR_H
#define _VECTOR_H

void objVectorRelocate(Object obj, unsigned int gcId);
unsigned int objUnrefVector(Object obj);
unsigned int objRefVector(Object obj);
void objDisplayVector(Object obj, FILE* file,
		      unsigned int depth, unsigned int quitThisDeep);
void objWriteVector(Object obj, FILE* file,
		    unsigned int depth, unsigned int quitThisDeep);
Object objMakeVector(unsigned int size, Object init);

void objDeleteVector(Object vector);
bool objIsEqVector(Object o1, Object o2);
bool objIsEqualVector(Object o1, Object o2);

Object objVectorRef(Object vector, int index);
void objVectorSet(Object vector, int index, Object value);

void regVectorRef(Register result, Register vector, Register index);
void regVectorSet(Register vector, Register index, Register obj);

void regList2Vector(Register result, Register list);

void makeVector_if(Register result, Register operands);
void vectorRef_if(Register result, Register operands);
void vectorSet_if(Register result, Register operands);
void vectorLength_if(Register result, Register operands);
void vector2List_if(Register result, Register operands);
void list2Vector_if(Register result, Register operands);
void vectorFill_if(Register result, Register operands);
void vector_if(Register result, Register operands);

#endif /* _VECTOR_H */
