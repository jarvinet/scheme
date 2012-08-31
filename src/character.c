#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#include "common.h"
#include "parameters.h"
#include "argcheck.h"

#include "util.h"
#include "boolean.h"
#include "number.h"


Object objMakeCharacter(char ch)
{
    Object obj;
    obj.type = OBJTYPE_CHARACTER;
    obj.u.character = ch;
    return obj;
}

void regMakeCharacter(Register reg, char ch)
{
    regWrite(reg, objMakeCharacter(ch));
}

char objGetCharacter(Object obj)
{
    assert(objIsCharacter(obj));
    return obj.u.character;
}

char regGetCharacter(Register reg)
{
    return objGetCharacter(regRead(reg));
}

void objDisplayCharacter(Object obj, FILE* file)
{
    fprintf(file, "%c", objGetCharacter(obj));
}

void objWriteCharacter(Object obj, FILE* file)
{
    fprintf(file, "#\\%c", objGetCharacter(obj));
}

void charIsAlphabetic_if(Register result, Register operands)
{
    bool isAlpha;
    checkArgsEQ("char-alphabetic?", "c", operands);
    isAlpha = (isalpha(regGetCharacter(regArgs[0])) != 0);
    regMakeBoolean(result, isAlpha);
}

void charIsNumeric_if(Register result, Register operands)
{
    bool isNumeric;
    checkArgsEQ("char-numeric?", "c", operands);
    isNumeric = (isdigit(regGetCharacter(regArgs[0])) != 0);
    regMakeBoolean(result, isNumeric);
}

void charIsWhitespace_if(Register result, Register operands)
{
    bool isWhitespace;
    checkArgsEQ("char-whitespace?", "c", operands);
    isWhitespace = (isspace(regGetCharacter(regArgs[0])) != 0);
    regMakeBoolean(result, isWhitespace);
}

void charIsUpperCase_if(Register result, Register operands)
{
    bool isUpperCase;
    checkArgsEQ("char-upper-case?", "c", operands);
    isUpperCase = (isupper(regGetCharacter(regArgs[0])) != 0);
    regMakeBoolean(result, isUpperCase);
}

void charIsLowerCase_if(Register result, Register operands)
{
    bool isLowerCase;
    checkArgsEQ("char-lower-case?", "c", operands);
    isLowerCase = (islower(regGetCharacter(regArgs[0])) != 0);
    regMakeBoolean(result, isLowerCase);
}

void charIsEqual_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char=?", "cc", operands);
    c1 = regGetCharacter(regArgs[0]);
    c2 = regGetCharacter(regArgs[1]);
    regMakeBoolean(result, (c1 == c2));
}

void charIsEqual_ci_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char-ci=?", "cc", operands);
    c1 = toupper(regGetCharacter(regArgs[0]));
    c2 = toupper(regGetCharacter(regArgs[1]));
    regMakeBoolean(result, (c1 == c2));
}

void charIsLessThan_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char<?", "cc", operands);
    c1 = regGetCharacter(regArgs[0]);
    c2 = regGetCharacter(regArgs[1]);
    regMakeBoolean(result, (c1 < c2));
}

void charIsLessThan_ci_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char-ci<?", "cc", operands);
    c1 = toupper(regGetCharacter(regArgs[0]));
    c2 = toupper(regGetCharacter(regArgs[1]));
    regMakeBoolean(result, (c1 < c2));
}

void charIsLessThanOrEqual_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char<=?", "cc", operands);
    c1 = regGetCharacter(regArgs[0]);
    c2 = regGetCharacter(regArgs[1]);
    regMakeBoolean(result, (c1 <= c2));
}

void charIsLessThanOrEqual_ci_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char-ci<=?", "cc", operands);
    c1 = toupper(regGetCharacter(regArgs[0]));
    c2 = toupper(regGetCharacter(regArgs[1]));
    regMakeBoolean(result, (c1 <= c2));
}

void charIsGreaterThan_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char>?", "cc", operands);
    c1 = regGetCharacter(regArgs[0]);
    c2 = regGetCharacter(regArgs[1]);
    regMakeBoolean(result, (c1 > c2));
}

void charIsGreaterThan_ci_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char>?", "cc", operands);
    c1 = toupper(regGetCharacter(regArgs[0]));
    c2 = toupper(regGetCharacter(regArgs[1]));
    regMakeBoolean(result, (c1 > c2));
}

void charIsGreaterThanOrEqual_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char>=?", "cc", operands);
    c1 = regGetCharacter(regArgs[0]);
    c2 = regGetCharacter(regArgs[1]);
    regMakeBoolean(result, (c1 >= c2));
}

void charIsGreaterThanOrEqual_ci_if(Register result, Register operands)
{
    char c1, c2;
    checkArgsEQ("char>=?", "cc", operands);
    c1 = toupper(regGetCharacter(regArgs[0]));
    c2 = toupper(regGetCharacter(regArgs[1]));
    regMakeBoolean(result, (c1 >= c2));
}

void charUpcase_if(Register result, Register operands)
{
    checkArgsEQ("char-upcase", "c", operands);
    regMakeCharacter(result, toupper(regGetCharacter(regArgs[0])));
}

void charDowncase_if(Register result, Register operands)
{
    checkArgsEQ("char-downcase", "c", operands);
    regMakeCharacter(result, tolower(regGetCharacter(regArgs[0])));
}

void char2integer_if(Register result, Register operands)
{
    checkArgsEQ("char->integer", "c", operands);
    regMakeNumber(result, regGetCharacter(regArgs[0]));
}

void integer2char_if(Register result, Register operands)
{
    checkArgsEQ("integer->char", "n", operands);
    regMakeCharacter(result, regGetNumber(regArgs[0]));
}

bool objIsEqCharacter(Object o1, Object o2)
{
    return (objGetCharacter(o1) == objGetCharacter(o2));
}

bool objIsEqualCharacter(Object o1, Object o2)
{
    return objIsEqCharacter(o1, o2);
}
