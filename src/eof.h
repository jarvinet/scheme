#ifndef _EOF_H
#define _EOF_H

Object objMakeEOF(void);
void objDisplayEOF(Object obj, FILE* file);
void objWriteEOF(Object obj, FILE* file);
bool objIsEqEOF(Object o1, Object o2);
bool objIsEqualEOF(Object o1, Object o2);

void regMakeEOF(Register reg);

#endif /* _EOF_H */
