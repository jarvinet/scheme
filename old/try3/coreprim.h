#ifndef _COREPRIM_H
#define _COREPRIM_H


/* Interface functions to the core primitives
 * from memory.c and read.c
 */

void cons_si(Register result, Register operands);
void snoc_si(Register result, Register operands);
void car_si(Register result, Register operands);
void cdr_si(Register result, Register operands);
void setCar_si(Register result, Register operands);
void setCdr_si(Register result, Register operands);

void applyPrimitive_si(Register result, Register operands);

void equal_si(Register result, Register operands);
void lessThan_si(Register result, Register operands);
void greaterThan_si(Register result, Register operands);
void remainder_si(Register result, Register operands);
void plus_si(Register result, Register operands);
void minus_si(Register result, Register operands);

void printObject_si(Register result, Register operands);
void newline_si(Register result, Register operands);
void read_si(Register result, Register operands);


void isPair_si(Register result, Register operands);
void isSymbol_si(Register result, Register operands);
void isString_si(Register result, Register operands);
void isNumber_si(Register result, Register operands);
void isNull_si(Register result, Register operands);
void isBoolean_si(Register result, Register operands);
void isPrimitive_si(Register result, Register operands);
void isTrue_si(Register result, Register operands);
void isEOF_si(Register result, Register operands);

void initStack_si(Register result, Register operands);

#endif /* _COREPRIM_H */
