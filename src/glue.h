#ifndef _GLUE_H
#define _GLUE_H

typedef struct glue *Glue;

Glue glueCreate(void* value);
void* glueGetValue(Glue glue);
void glueDelete(Glue glue);
int glueGetRefCount(Glue glue);
int glueIncRefCount(Glue glue);
int glueDecRefCount(Glue glue);

#endif /* _GLUE_H */
