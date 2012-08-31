#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"
#include "glue.h"
#include "argcheck.h"
#include "eprint.h"

#include "util.h"
#include "boolean.h"
#include "symbol.h"
#include "number.h"
#include "character.h"


/* objMakeString expects the string has been allocated
 * elsewhere.
 * Note that objUnrefString frees the string.
 * This is not symmetric as it should be, but the parsed string
 * has to be allocated in the scanner.
 */
Object objMakeString(char* str)
{
    Object obj;
    obj.type = OBJTYPE_STRING;
    obj.u.string = glueCreate((void*)str);
    return obj;
}

void regMakeString(Register reg, char* str)
{
    regWrite(reg, objMakeString(str));
}

void makeString_if(Register result, Register operands)
{
    char* str;
    char chr;
    int length;
    unsigned int i;

    /* If no initialization object is specified, init elements with '.'
     * (make-string 5)
     * (make-string 5 #\a)
     */
    if (checkArgs("make-string", 1, "nc", operands) < 2)
	regMakeCharacter(regArgs[1], '.');
    length = regGetNumber(regArgs[0]);
    chr = regGetCharacter(regArgs[1]);
    str = emalloc(length+1);
    for (i = 0; i < length; i++)
	str[i] = chr;
    str[length] = '\0';
    regMakeString(result, estrdup(str));
    free(str);
}

/* (string char ...) */ 
void string_if(Register result, Register operands)
{
#if 0
    unsigned int length;
    char* str;
    char chr;
    unsigned int i;

    length = checkArgsN("string", "c", operands);
    for (i = 0; i < length; i++) {
    }
#endif
}

void objDeleteString(Object obj)
{
    Glue glue = obj.u.string;
    char* string = (char*)glueGetValue(glue);
    free(string);
    glueDelete(glue);
}

char* objGetString(Object obj)
{
    assert(objIsString(obj));
    return (char*)glueGetValue(obj.u.string);
}

char* regGetString(Register reg)
{
    return objGetString(regRead(reg));
}

unsigned int objUnrefString(Object obj)
{
    Glue glue = obj.u.string;
    int refCount = glueDecRefCount(glue);
#ifdef DEBUG_STRING_REFS
    char* string = (char*)glueGetValue(glue);
    printf("String %s Unref, Refcount %d\n", string, refCount);
#endif
    if (refCount <= 0) {
	objDeleteString(obj);
    }
    return refCount;
}

unsigned int objRefString(Object obj)
{
    Glue glue = obj.u.string;
    int refCount = glueIncRefCount(glue);
#ifdef DEBUG_STRING_REFS
    char* string = (char*)glueGetValue(glue);
    printf("String %s Ref, Refcount %d\n", string, refCount);
#endif
    return refCount;
}

void objDisplayString(Object obj, FILE* file)
{
    fprintf(file, "%s", objGetString(obj));
}

void objWriteString(Object obj, FILE* file)
{
    /* TODO: embedded backslashes and double quotes should be
     * escaped with a bacslash */
    fprintf(file, "\"%s\"", objGetString(obj));
}

static void string2symbol(Register result, Register string)
{
    regMakeSymbol(result, regGetString(string));
}

void string2symbol_if(Register result, Register operands)
{
    checkArgsEQ("string->symbol", "s", operands);
    string2symbol(result, regArgs[0]);
}

static void string2number(Register result, Register string)
{
    regMakeNumber(result, atoi(regGetString(string)));
}

void string2number_if(Register result, Register operands)
{
    checkArgsEQ("string->number", "s", operands);
    string2number(result, regArgs[0]);
}

static void stringAppend(Register result, Register s1, Register s2)
{
    char* string1 = regGetString(s1);
    char* string2 = regGetString(s2);
    char *str = emalloc(strlen(string1)+ strlen(string2)+1);
    sprintf(str, "%s%s", string1, string2);
    regMakeString(result, estrdup(str));
    free(str);
}

void stringAppend_if(Register result, Register operands)
{
    checkArgsEQ("string-append", "ss", operands);
    stringAppend(result, regArgs[0], regArgs[1]);
}

unsigned int regStringLength(Register string)
{
    return strlen(regGetString(string));
}

void stringLength_if(Register result, Register operands)
{
    checkArgsEQ("string-length", "s", operands);
    regMakeNumber(result, regStringLength(regArgs[0]));
}

static void stringRef(Register result, Register string, Register index)
{
    char* str = regGetString(string);
    int   ndx = regGetNumber(index);

    if ((ndx < 0) || (ndx >= strlen(str)))
	esprint("*** string-ref: Index out of bounds\n");
    else
	regMakeCharacter(result, str[ndx]);
}

void stringRef_if(Register result, Register operands)
{
    checkArgsEQ("string-ref", "sn", operands);
    stringRef(result, regArgs[0], regArgs[1]);
}

static void
stringSet(Register string, Register index, Register character)
{
    char* str = regGetString(string);
    int   ndx = regGetNumber(index);
    char  chr = regGetCharacter(character);

    if ((ndx < 0) || (ndx >= strlen(str)))
	esprint("*** string-set!: Index out of bounds\n");
    else
	str[ndx] = chr;
}

void stringSet_if(Register result, Register operands)
{
    checkArgsEQ("string-set!", "snc", operands);
    stringSet(regArgs[0], regArgs[1], regArgs[2]);
    regMakeSymbol(result, "ok");
}

void subString_if(Register result, Register operands)
{
    char* str;
    int length;
    int start; /* start index of the substring, inclusive */
    int end;   /* end index of the substring, exclusive */
    char* subString;
    int subStringLength;
    int i;

    checkArgsEQ("substring", "snn", operands);
    str    = regGetString(regArgs[0]);
    start  = regGetNumber(regArgs[1]);
    end    = regGetNumber(regArgs[2]);
    length = regStringLength(regArgs[0]);
    if (0 > start)    esprint("*** Start index must be greater than or equal to 0\n");
    if (start > end)  esprint("*** End index must be greater than or equal to start index\n");
    if (end > length) esprint("*** End index must be less than string length\n");
    subStringLength = end-start;
    subString = emalloc(subStringLength+1);
    for (i = start; i < end; i++)
	subString[i] = str[i];
    subString[subStringLength] = '\0';
    regMakeString(result, estrdup(subString));
    free(subString);
}

void stringFill_if(Register result, Register operands)
{
    char* str;
    char chr;
    int length;
    int i;
    checkArgsEQ("string-fill!", "sc", operands);
    str = regGetString(regArgs[0]);
    chr = regGetCharacter(regArgs[1]);
    length = regStringLength(regArgs[0]);
    for (i = 0; i < length; i++)
	str[i] = chr;
    regMakeSymbol(result, "ok");
}
 
void stringCopy_if(Register result, Register operands)
{
    checkArgsEQ("string-copy", "s", operands);
    regMakeString(result, estrdup(regGetString(regArgs[0])));
}

bool objIsEqString(Object o1, Object o2)
{
    return (objGetString(o1) == objGetString(o2));
}

bool objIsEqualString(Object o1, Object o2)
{
    return (strcmp(objGetString(o1), objGetString(o2)) == 0);
}
