#ifndef _NULL_H
#define _NULL_H

Object objMakeNull(void);

void objDisplayNull(Object obj, FILE* file);
void objWriteNull(Object obj, FILE* file);
bool objIsEqNull(Object o1, Object o2);
bool objIsEqualNull(Object o1, Object o2);

void regMakeNull(Register reg);
#if 0
void regCopyNull(Register reg, Register regNull);
#endif

#endif /* _NULL_H */
