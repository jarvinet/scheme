#ifndef _CHARACTER_H
#define _CHARACTER_H

Object objMakeCharacter(char ch);
char objGetCharacter(Object obj);
void objDisplayCharacter(Object obj, FILE* file);
void objWriteCharacter(Object obj, FILE* file);
bool objIsEqCharacter(Object o1, Object o2);
bool objIsEqualCharacter(Object o1, Object o2);

void regMakeCharacter(Register reg, char ch);
char regGetCharacter(Register reg);

void charIsAlphabetic_if(Register result, Register operands);
void charIsNumeric_if(Register result, Register operands);
void charIsWhitespace_if(Register result, Register operands);
void charIsUpperCase_if(Register result, Register operands);
void charIsLowerCase_if(Register result, Register operands);

void charIsEqual_if(Register result, Register operands);
void charIsEqual_ci_if(Register result, Register operands);
void charIsLessThan_if(Register result, Register operands);
void charIsLessThan_ci_if(Register result, Register operands);
void charIsLessThanOrEqual_if(Register result, Register operands);
void charIsLessThanOrEqual_ci_if(Register result, Register operands);
void charIsGreaterThan_if(Register result, Register operands);
void charIsGreaterThan_ci_if(Register result, Register operands);
void charIsGreaterThanOrEqual_if(Register result, Register operands);
void charIsGreaterThanOrEqual_ci_if(Register result, Register operands);

void charUpcase_if(Register result, Register operands);
void charDowncase_if(Register result, Register operands);

void char2integer_if(Register result, Register operands);
void integer2char_if(Register result, Register operands);

#endif /* _CHARACTER_H */
