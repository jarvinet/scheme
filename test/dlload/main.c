#include "dlload.h"

int bar(int n)
{
    return n;
}

int main(void)
{
    dlAdd("plugin");
    dlLoad();

    dlUnload();
    return 0;
}
