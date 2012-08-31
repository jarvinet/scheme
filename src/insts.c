#include <stdlib.h>
#include <stdio.h>

#include "common.h"
#include "parameters.h"
#include "primitive.h"
#include "insts.h"
#include "regsim.h"
#include "util.h"


void strPrint(char* str)
{
    printf("%s ", str);
}

void strDelete(char* str)
{
    free(str);
}

struct reg {
    char* name;
    Register reg;
};

RegisterExp rexMake(char* name)
{
    RegisterExp reg = emalloc(sizeof(struct reg));
    reg->name = name;
    return reg;
}

static void rexDelete(RegisterExp reg)
{
    free(reg->name);
    free(reg);
}

char* rexGetName(RegisterExp reg)
{
    return reg->name;
}


Register rexGetReg(RegisterExp reg)
{
    return reg->reg;
}

void rexSetReg(RegisterExp regExp, Register reg)
{
    regExp->reg = reg;
}

void rexPrint(RegisterExp reg)
{
    printf("%s", rexGetName(reg));
}


struct label {
    char* name;
    unsigned int index; /* index in the instruction sequence */
};

Label lblMake(char *name)
{
    Label lbl = emalloc(sizeof(struct label));
    lbl->name = name;
    return lbl;
}

char* lblGetName(Label lbl)
{
    return lbl->name;
}

unsigned int lblGetIndex(Label lbl)
{
    return lbl->index;
}

void lblSetIndex(Label lbl, unsigned int idx)
{
    lbl->index = idx;
}

static void lblDelete(Label lbl)
{
    free(lbl->name);
    free(lbl);
}

void lblPrint(Label lbl)
{
    printf("%s", lblGetName(lbl));
}


struct constant {
    char* string;
};

Constant conMake(char* str)
{
    Constant con = emalloc(sizeof(struct constant));
    con->string = str;
    return con;
}

char* conGetString(Constant con)
{
    return con->string;
}

static void conDelete(Constant con)
{
    free(conGetString(con));
    free(con);
}

void conPrint(Constant con)
{
    printf(" (const %s)", conGetString(con));
}


struct input {
    InputType type;
    union {
	RegisterExp reg;
	Constant    con;
	Label       lbl;
    } u;
};

Input inpMakeRegister(RegisterExp reg)
{
    Input inp = emalloc(sizeof(struct input));
    inp->type = INPUT_REG;
    inp->u.reg = reg;
    return inp;
}

Input inpMakeConst(Constant con)
{
    Input inp = emalloc(sizeof(struct input));
    inp->type = INPUT_CONST;
    inp->u.con = con;
    return inp;
}

Input inpMakeLabel(Label lbl)
{
    Input inp = emalloc(sizeof(struct input));
    inp->type = INPUT_LABEL;
    inp->u.lbl = lbl;
    return inp;
}

InputType inpGetType(Input inp)
{
    return inp->type;
}

RegisterExp inpGetReg(Input inp)
{
    assert(inpGetType(inp) == INPUT_REG);
    return inp->u.reg;
}

Constant inpGetConst(Input inp)
{
    assert(inpGetType(inp) == INPUT_CONST);
    return inp->u.con;
}

Label inpGetLabel(Input inp)
{
    assert(inpGetType(inp) == INPUT_LABEL);
    return inp->u.lbl;
}

void inpDelete(Input inp)
{
    switch (inpGetType(inp)) {
    case INPUT_REG:
	rexDelete(inpGetReg(inp));
	break;
    case INPUT_CONST:
	conDelete(inpGetConst(inp));
	break;
    case INPUT_LABEL:
	lblDelete(inpGetLabel(inp));
	break;
    default:
	printf("Unknown input type\n");
	break;
    }
    free(inp);
}

void inpPrint(Input inp)
{
    switch (inpGetType(inp)) {
    case INPUT_REG:
	printf(" (reg ");
	rexPrint(inpGetReg(inp));
	printf(")");
	break;
    case INPUT_CONST:
	conPrint(inpGetConst(inp));
	break;
    case INPUT_LABEL:
	printf(" (label ");
	lblPrint(inpGetLabel(inp));
	printf(")");
	break;
    default:
	printf("Unknown input type\n");
	break;
    }
}


struct operation {
    char*     name;
    Primitive primitive;
    List      inputs; /* of type Input */
};

OperationExp opMake(char* name, List inputs)
{
    OperationExp op = emalloc(sizeof(struct operation));
    op->name = name;
    op->inputs = inputs;
    return op;
}

char* opGetName(OperationExp op)
{
    return op->name;
}

Primitive opGetPrimitive(OperationExp op)
{
    return op->primitive;
}

void opSetPrimitive(OperationExp op, Primitive primitive)
{
    op->primitive = primitive;
}

List opGetInputs(OperationExp op)
{
    return op->inputs;
}

static void opDelete(OperationExp op)
{
    free(opGetName(op));
    lstDelete(opGetInputs(op), (ListFunc)inpDelete);
    free(op);
}

void opPrint(OperationExp op)
{
    printf("(op %s)", opGetName(op));
    lstPrint(opGetInputs(op), (ListFunc)inpPrint);
}



struct source {
    SourceType type;
    union {
	RegisterExp  reg;
	Constant     con;
	OperationExp op;
	Label        lbl;
    } u;
};

Source srcMakeReg(RegisterExp reg)
{
    Source src = emalloc(sizeof(struct source));
    src->type = SRC_REG;
    src->u.reg = reg;
    return src;
}

Source srcMakeConst(Constant con)
{
    Source src = emalloc(sizeof(struct source));
    src->type = SRC_CONST;
    src->u.con = con;
    return src;
}

Source srcMakeOp(OperationExp op)
{
    Source src = emalloc(sizeof(struct source));
    src->type = SRC_OP;
    src->u.op = op;
    return src;
}

Source srcMakeLabel(Label label)
{
    Source src = emalloc(sizeof(struct source));
    src->type = SRC_LABEL;
    src->u.lbl = label;
    return src;
}

SourceType srcGetType(Source src)
{
    return src->type;
}

RegisterExp srcGetReg(Source src)
{
    assert(srcGetType(src) == SRC_REG);
    return src->u.reg;
}

Constant srcGetConst(Source src)
{
    assert(srcGetType(src) == SRC_CONST);
    return src->u.con;
}

OperationExp srcGetOp(Source src)
{
    assert(srcGetType(src) == SRC_OP);
    return src->u.op;
}

Label srcGetLabel(Source src)
{
    assert(srcGetType(src) == SRC_LABEL);
    return src->u.lbl;
}

static void srcDelete(Source src)
{
    switch (srcGetType(src)) {
    case SRC_REG:
	rexDelete(srcGetReg(src));
	break;
    case SRC_CONST:
	conDelete(srcGetConst(src));
	break;
    case SRC_OP:
	opDelete(srcGetOp(src));
	break;
    case SRC_LABEL:
	lblDelete(srcGetLabel(src));
	break;
    default:
	printf("Unknown source type\n");
	break;
    }
    free(src);
}

void srcPrint(Source src)
{
    switch (srcGetType(src)) {
    case SRC_REG:
	printf("(reg ");
	rexPrint(srcGetReg(src));
	printf(")");
	break;
    case SRC_CONST:
	conPrint(srcGetConst(src));
	break;
    case SRC_OP:
	opPrint(srcGetOp(src));
	break;
    case SRC_LABEL:
	printf("(label ");
	lblPrint(srcGetLabel(src));
	printf(")");
	break;
    default:
	printf("Unknown source type\n");
	break;
    }
}


struct target {
    TargetType type;
    union {
	RegisterExp reg;
	Label       label;
    } u;
};

Target trgMakeReg(RegisterExp reg)
{
    Target target = emalloc(sizeof(struct target));
    target->type = TRG_REG;
    target->u.reg = reg;
    return target;
}

Target trgMakeLabel(Label label)
{
    Target target = emalloc(sizeof(struct target));
    target->type = TRG_LABEL;
    target->u.label = label;
    return target;
}

TargetType trgGetType(Target trg)
{
    return trg->type;
}
    
RegisterExp trgGetReg(Target trg)
{
    assert(trgGetType(trg) == TRG_REG);
    return trg->u.reg;
}

Label trgGetLabel(Target trg)
{
    assert(trgGetType(trg) == TRG_LABEL);
    return trg->u.label;
}

static void trgDelete(Target trg)
{
    switch (trgGetType(trg)) {
    case TRG_REG:
	rexDelete(trgGetReg(trg));
	break;
    case TRG_LABEL:
	lblDelete(trgGetLabel(trg));
	break;
    default:
	printf("Unknown target type\n");
	break;
    }
    free(trg);
}

void trgPrint(Target trg)
{
    switch (trgGetType(trg)) {
    case TRG_REG:
	printf("(reg ");
	rexPrint(trgGetReg(trg));
	printf(")");
	break;
    case TRG_LABEL:
	printf("(label ");
	lblPrint(trgGetLabel(trg));
	printf(")");
	break;
    default:
	printf("Unknown target type\n");
	break;
    }
}


struct instruction
{
    InstType type;
    unsigned int lineNumber;
    char* fileName;
    union {
	struct {
	    RegisterExp target;
	    Source source;
	} assign;  /* assign */
	struct {
	    OperationExp op;
	} oper;    /* test and perform */
	struct {
	    Label lbl;
	} label;   /* label */
	struct {
	    Target target;
	} jump;    /* branch and goto */
	struct {
	    RegisterExp reg;
	} stackOp; /* save and restore */
        struct {
            char* comment;
	} comment; /* comment */
    } u;
};

Inst insMakeAssign(char* fileName, unsigned int lineNumber, RegisterExp target, Source source)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_ASSIGN;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.assign.target = target;
    inst->u.assign.source = source;
    return inst;
}

Inst insMakePerform(char* fileName, unsigned int lineNumber, OperationExp op)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_PERFORM;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.oper.op = op;
    return inst;
}

Inst insMakeTest(char* fileName, unsigned int lineNumber, OperationExp op)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_TEST;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.oper.op = op;
    return inst;
}

Inst insMakeLabel(char* fileName, unsigned int lineNumber, Label lbl)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_LABEL;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.label.lbl = lbl;
    return inst;
}

Inst insMakeBranch(char* fileName, unsigned int lineNumber, Target target)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_BRANCH;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.jump.target = target;
    return inst;
}

Inst insMakeGoto(char* fileName, unsigned int lineNumber, Target target)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_GOTO;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.jump.target = target;
    return inst;
}

Inst insMakeSave(char* fileName, unsigned int lineNumber, RegisterExp reg)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_SAVE;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.stackOp.reg = reg;
    return inst;
}

Inst insMakeRestore(char* fileName, unsigned int lineNumber, RegisterExp reg)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_RESTORE;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.stackOp.reg = reg;
    return inst;
}

Inst insMakeComment(char* fileName, unsigned int lineNumber, char* comment)
{
    Inst inst = emalloc(sizeof(struct instruction));
    inst->type = INST_COMMENT;
    inst->lineNumber = lineNumber;
    inst->fileName = fileName;
    inst->u.comment.comment = comment;
    return inst;
}

InstType insGetType(Inst inst)
{
    return inst->type;
}

unsigned int insGetLineNumber(Inst inst)
{
    return inst->lineNumber;
}

char* insGetFileName(Inst inst)
{
    return inst->fileName;
}

RegisterExp insGetAssignTarget(Inst inst)
{
    assert(insGetType(inst) == INST_ASSIGN);
    return inst->u.assign.target;
}

Source insGetAssignSource(Inst inst)
{
    assert(insGetType(inst) == INST_ASSIGN);
    return inst->u.assign.source;
}

OperationExp insGetPerform(Inst inst)
{
    assert(insGetType(inst) == INST_PERFORM);
    return inst->u.oper.op;
}

OperationExp insGetTest(Inst inst)
{
    assert(insGetType(inst) == INST_TEST);
    return inst->u.oper.op;
}

Label insGetLabel(Inst inst)
{
    assert(insGetType(inst) == INST_LABEL);
    return inst->u.label.lbl;
}

Target insGetBranch(Inst inst)
{
    assert(insGetType(inst) == INST_BRANCH);
    return inst->u.jump.target;
}

Target insGetGoto(Inst inst)
{
    assert(insGetType(inst) == INST_GOTO);
    return inst->u.jump.target;
}

RegisterExp insGetSave(Inst inst)
{
    assert(insGetType(inst) == INST_SAVE);
    return inst->u.stackOp.reg;
}

RegisterExp insGetRestore(Inst inst)
{
    assert(insGetType(inst) == INST_RESTORE);
    return inst->u.stackOp.reg;
}

char* insGetComment(Inst inst)
{
    assert(insGetType(inst) == INST_COMMENT);
    return inst->u.comment.comment;
}

void insDelete(Inst inst)
{
    switch (insGetType(inst)) {
    case INST_ASSIGN:
	rexDelete(insGetAssignTarget(inst));
	srcDelete(insGetAssignSource(inst));
	break;
    case INST_PERFORM:
	opDelete(insGetPerform(inst));
	break;
    case INST_TEST:
	opDelete(insGetTest(inst));
	break;
    case INST_LABEL:
	lblDelete(insGetLabel(inst));
	break;
    case INST_BRANCH:
	trgDelete(insGetBranch(inst));
	break;
    case INST_GOTO:
	trgDelete(insGetGoto(inst));
	break;
    case INST_SAVE:
	rexDelete(insGetSave(inst));
	break;
    case INST_RESTORE:
	rexDelete(insGetRestore(inst));
	break;
    case INST_COMMENT:
        strDelete(insGetComment(inst));
	break;
    default:
	printf("Unknown instruction type\n");
	break;
    }
    free(inst);
}

void insPrint(Inst inst)
{
    switch (insGetType(inst)) {
    case INST_ASSIGN:
	printf("  (assign ");
	rexPrint(insGetAssignTarget(inst));
	printf(" ");
	srcPrint(insGetAssignSource(inst));
	printf(")");
	break;
    case INST_PERFORM:
	printf("  (perform ");
	opPrint(insGetPerform(inst));
	printf(")");
	break;
    case INST_TEST:
	printf("  (test ");
	opPrint(insGetTest(inst));
	printf(")");
	break;
    case INST_LABEL:
	lblPrint(insGetLabel(inst));
	break;
    case INST_BRANCH:
	printf("  (branch ");
	trgPrint(insGetBranch(inst));
	printf(")");
	break;
    case INST_GOTO:
	printf("  (goto ");
	trgPrint(insGetGoto(inst));
	printf(")");
	break;
    case INST_SAVE:
	printf("  (save ");
	rexPrint(insGetSave(inst));
	printf(")");
	break;
    case INST_RESTORE:
	printf("  (restore ");
	rexPrint(insGetRestore(inst));
	printf(")");
	break;
    case INST_COMMENT:
	printf("  (comment ");
	printf("%s", insGetComment(inst));
	printf(")");
	break;
    default:
	printf("Unknown instruction type\n");
	break;
    }
}

void insDump(Inst inst)
{
    printf("%s:", insGetFileName(inst));
    printf("%5u: ", insGetLineNumber(inst));
    insPrint(inst);
    printf("\n");
}

void pi(Inst inst)
{
    insDump(inst);
}
