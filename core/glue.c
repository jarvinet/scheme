#include <stdlib.h>

#include "glue.h"
#include "util.h"


struct glue {
    void         *value;
    unsigned int referenceCount;
};


Glue glueCreate(void* value)
{
    Glue glue;
    glue = (Glue)emalloc(sizeof(struct glue));
    glue->value = value;
    glue->referenceCount = 0;
    return glue;
}

void* glueGetValue(Glue glue)
{
    return glue->value;
}

void glueDelete(Glue glue)
{
    free(glue);
}

int glueGetRefCount(Glue glue)
{
    return glue->referenceCount;
}

int glueIncRefCount(Glue glue)
{
    return ++glue->referenceCount;
}

int glueDecRefCount(Glue glue)
{
    return --glue->referenceCount;
}
