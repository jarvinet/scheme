#include "hash.h"

Hashtable *obarray;

void initObarray(void)
{
    obarray = htCreate();
}
