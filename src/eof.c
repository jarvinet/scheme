#include <stdio.h>

#include "common.h"
#include "parameters.h"
#include "util.h"


Object objMakeEOF(void)
{
    Object obj;
    obj.type = OBJTYPE_EOF;
    return obj;
}

void regMakeEOF(Register reg)
{
    regWrite(reg, objMakeEOF());
}

void objDisplayEOF(Object obj, FILE* file)
{
    fprintf(file, "EOF");
}

void objWriteEOF(Object obj, FILE* file)
{
    objDisplayEOF(obj, file);
}

bool objIsEqEOF(Object o1, Object o2)
{
    return TRUE;
}

bool objIsEqualEOF(Object o1, Object o2)
{
    return TRUE;
}
