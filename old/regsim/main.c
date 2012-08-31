#include <stdlib.h>

#include "regsim.h"
#include "insts.h"
#include "object.h"
#include "memory.h"


static void test(void)
{
    Inst inst;
    List* list;

    list = lstAppend(NULL, NULL);
    list = lstAppend(list, lstMake(inpMakeRegister(regMake("foo"))));
    list = lstAppend(list, lstMake(inpMakeConst(conMakeNumber(12))));
    insPrint(insMakeTest(opMake("oper", list)));
    printf("\n");
}

int main(void)
{
    RegSim* rs = makeRegSim();

    initObarray();
    initMemory(1024);

    rsReadInstSeq(rs);
    rsPrintInstSeq(rs);

    return 0;
}
