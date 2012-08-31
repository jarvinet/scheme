#ifndef _CONTINUATION_H
#define _CONTINUATION_H

unsigned int objRefContinuation(Object obj);
unsigned int objUnrefContinuation(Object obj);

bool objIsEqContinuation(Object o1, Object o2);
bool objIsEqualContinuation(Object o1, Object o2);
void objDisplayContinuation(Object obj, FILE* file);
void objWriteContinuation(Object obj, FILE* file);
void makeContinuation_if(Register result, Register operands);

void applyContinuation_if(Register result, Register operands);

#endif /* _CONTINUATION_H */
