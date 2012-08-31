#include <stdio.h>

#include "common.h"
#include "parameters.h"


Object objMakeNull(void)
{
    Object obj;
    obj.type = OBJTYPE_NULL;
    return obj;
}

void regMakeNull(Register reg)
{
    regWrite(reg, objMakeNull());
}
#if 0
static Object objCopyNull(Object obj)
{
    return objMakeNull();
}

void regCopyNull(Register reg, Register regNull)
{
    regWrite(reg, objCopyNull(regRead(regNull)));
}
#endif
void objDisplayNull(Object obj, FILE* file)
{
    fprintf(file, "()");
}

void objWriteNull(Object obj, FILE* file)
{
    objDisplayNull(obj, file);    
}

bool objIsEqNull(Object o1, Object o2)
{
    return TRUE;
}

bool objIsEqualNull(Object o1, Object o2)
{
    return TRUE;
}
