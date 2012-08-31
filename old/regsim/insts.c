#include <stdlib.h>

#include "insts.h"
#include "regsim.h"


/*
  (assign <register-name> (reg <register-name>))
  (assign <register-name> (const <constant-value>))
  (assign <register-name> (op <operation-name>) <input1> ... <inputn>)
  (assign <register-name> (label <label-name>))
  
  (perform (op <operation-name>) <input1> ... <inputn>)
     
  (test (op <operation-name>) <input1> ... <inputn>)

  (branch (label <label-name>))

  (goto (label <label-name>))
  (goto (reg <register-name>))

  (save <register-name>)

  (restore <register-name>)
*/

/*****/

Register regMake(char* name)
{
    Register reg;
    reg.name = name;
    return reg;
}

void regPrint(Register reg)
{
    printf("%s", reg.name);
}

char* regGetName(Register reg)
{
    return reg.name;
}


Constant conMakeNumber(int num)
{
    Constant con;
    con.type = CONST_NUMBER;
    con.u.number = num;
    return con;
}

Constant conMakeString(char* str)
{
    Constant con;
    con.type = CONST_STRING;
    con.u.string = str;
    return con;
}

void conPrint(Constant con)
{
    switch (con.type) {
    case CONST_NUMBER:
    printf("(const %d)", con.u.number);
	break;
    case CONST_STRING:
    printf("(const %s)", con.u.string);
	break;
    case CONST_LIST:
	break;
    default:
	printf("Unknown constant type\n");
	break;
    }
}

Input inpMakeRegister(Register reg)
{
    Input inp;
    inp.type = INPUT_REG;
    inp.u.reg = reg;
    return inp;
}

Input inpMakeConst(Constant con)
{
    Input inp;
    inp.type = INPUT_CONST;
    inp.u.con = con;
    return inp;
}

void inpPrint(Input inp)
{
    switch (inp.type){
    case INPUT_REG:
	printf("(reg ");
	regPrint(inp.u.reg);
	printf(")");
	break;
    case INPUT_CONST:
	conPrint(inp.u.con);
	break;
    default:
	printf("Unknown input type\n");
	break;
    }
}

List* lstMake(Input input)
{
    List* list;
    list = (List*)emalloc(sizeof(List));
    list->input = input;
    list->next = NULL;
    return list;
}

List* lstAppend(List* listp, List* newp)
{
    List* p;

    if (listp == NULL)
	return newp;

    for (p = listp; p->next != NULL; p = p->next)
	;
    p->next = newp;
    return listp;
}

void lstPrint(List* listp)
{
    for (; listp != NULL; listp = listp->next) {
	printf(" ");
	inpPrint(listp->input);
    }
}

Operation opMake(char* name, List* inputs)
{
    Operation op;
    op.name = name;
    op.inputs = inputs;
    return op;
}

void opPrint(Operation op)
{
    printf("(op %s)", op.name);
    lstPrint(op.inputs);
}


Label lblMake(char *name)
{
    Label lbl;
    lbl.name = name;
    return lbl;
}

void lblPrint(Label lbl)
{
    printf("%s", lbl.name);
}

char* lblGetName(Label lbl)
{
    return lbl.name;
}

unsigned int lblGetIndex(Label lbl)
{
    return lbl.index;
}


Source srcMakeReg(Register reg)
{
    Source src;
    src.type = SRC_REG;
    src.u.reg = reg;
    return src;
}

Source srcMakeConst(Constant con)
{
    Source src;
    src.type = SRC_CONST;
    src.u.con = con;
    return src;
}

Source srcMakeOp(Operation op)
{
    Source src;
    src.type = SRC_OP;
    src.u.op = op;
    return src;
}

Source srcMakeLabel(Label label)
{
    Source src;
    src.type = SRC_LABEL;
    src.u.lbl = label;
    return src;
}

void srcPrint(Source src)
{
    switch (src.type) {
    case SRC_REG:
	printf("(reg ");
	regPrint(src.u.reg);
	printf(")");
	break;
    case SRC_CONST:
	conPrint(src.u.con);
	break;
    case SRC_OP:
	opPrint(src.u.op);
	break;
    case SRC_LABEL:
	printf("(label ");
	lblPrint(src.u.lbl);
	printf(")");
	break;
    default:
	printf("Unknown source type\n");
	break;
    }
}


Target trgMakeReg(Register reg)
{
    Target target;
    target.type = TRG_REG;
    target.u.reg = reg;
    return target;
}

Target trgMakeLabel(Label label)
{
    Target target;
    target.type = TRG_LABEL;
    target.u.label = label;
    return target;
}

void trgPrint(Target trg)
{
    switch (trg.type) {
    case TRG_REG:
	printf("(reg ");
	regPrint(trg.u.reg);
	printf(")");
	break;
    case TRG_LABEL:
	printf("(label ");
	lblPrint(trg.u.label);
	printf(")");
	break;
    default:
	printf("Unknown target type\n");
	break;
    }
}

Register trgGetRegister(Target trg)
{
    if (trg.type != TRG_REG)
	eprintf("target is not a register");
    return trg.u.reg;
}

Label trgGetLabel(Target trg)
{
    if (trg.type != TRG_LABEL)
	eprintf("target is not a label");
    return trg.u.label;
}

static void trgJumpTo(Target trg, RegSim* rs)
{
    Label lbl;
    Register reg;

    switch (trg.type) {
    case TRG_REG:
	reg = trgGetRegister(trg);
	
	break;
    case TRG_LABEL:
	lbl = trgGetLabel(trg);
	/* label target should be resolved prior
	 * to running this thing */
	rsSetPc(rs, rsGetLabel(rs, lblGetName(lbl)));
	break;
    }
}



Inst insMakeAssign(Register target, Source source)
{
    Inst inst;
    inst.type = INST_ASSIGN;
    inst.u.assign.target = target;
    inst.u.assign.source = source;
    return inst;
}

Inst insMakePerform(Operation op)
{
    Inst inst;
    inst.type = INST_PERFORM;
    inst.u.oper.op = op;
    return inst;
}

Inst insMakeTest(Operation op)
{
    Inst inst;
    inst.type = INST_TEST;
    inst.u.oper.op = op;
    return inst;
}

Inst insMakeLabel(Label lbl)
{
    Inst inst;
    inst.type = INST_LABEL;
    inst.u.label.lbl = lbl;
    return inst;
}

Inst insMakeBranch(Target target)
{
    Inst inst;
    inst.type = INST_BRANCH;
    inst.u.jump.target = target;
    return inst;
}

Inst insMakeGoto(Target target)
{
    Inst inst;
    inst.type = INST_GOTO;
    inst.u.jump.target = target;
    return inst;
}

Inst insMakeSave(Register reg)
{
    Inst inst;
    inst.type = INST_SAVE;
    inst.u.stackOp.reg = reg;
    return inst;
}

Inst insMakeRestore(Register reg)
{
    Inst inst;
    inst.type = INST_RESTORE;
    inst.u.stackOp.reg = reg;
    return inst;
}

void insPrint(Inst inst)
{
    switch (inst.type) {
    case INST_ASSIGN:
	printf("  (assign ");
	regPrint(inst.u.assign.target);
	printf(" ");
	srcPrint(inst.u.assign.source);
	printf(")\n");
	break;
    case INST_PERFORM:
	printf("  (perform ");
	opPrint(inst.u.oper.op);
	printf(")\n");
	break;
    case INST_TEST:
	printf("  (test ");
	opPrint(inst.u.oper.op);
	printf(")\n");
	break;
    case INST_LABEL:
	lblPrint(inst.u.label.lbl);
	printf("\n");
	break;
    case INST_BRANCH:
	printf("  (branch ");
	trgPrint(inst.u.jump.target);
	printf(")\n");
	break;
    case INST_GOTO:
	printf("  (goto ");
	trgPrint(inst.u.jump.target);
	printf(")\n");
	break;
    case INST_SAVE:
	printf("  (save ");
	regPrint(inst.u.stackOp.reg);
	printf(")\n");
	break;
    case INST_RESTORE:
	printf("  (restore ");
	regPrint(inst.u.stackOp.reg);
	printf(")\n");
	break;
    default:
	printf("Unknown instruction type\n");
	break;
    }
}

