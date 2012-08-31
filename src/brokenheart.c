#include <stdio.h>

#include "common.h"
#include "parameters.h"

Object objMakeBrokenHeart(void)
{
    Object obj;
    obj.type = OBJTYPE_BROKENHEART;
    return obj;
}

void objDisplayBrokenHeart(Object obj, FILE* file)
{
    fprintf(file, "*** Broken Heart ***");
}

void objWriteBrokenHeart(Object obj, FILE* file)
{
    objDisplayBrokenHeart(obj, file);
}

bool objIsEqBrokenHeart(Object o1, Object o2)
{
    return TRUE;
}

bool objIsEqualBrokenHeart(Object o1, Object o2)
{
    return TRUE;
}
