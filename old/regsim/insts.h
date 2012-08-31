#ifndef _REGSIM_H
#define _REGSIM_H


typedef struct reg RegisterExp;
struct reg {
    char* name;
};
RegisterExp regMake(char* name);
void regPrint(RegisterExp reg);
char* regGetName(RegisterExp reg);

typedef enum {CONST_NUMBER, CONST_STRING, CONST_LIST} ConstType;
typedef struct constant Constant;
struct constant {
    ConstType type;
    union {
	int number;
	char* string;
    } u;
};
Constant conMakeNumber(int num);
Constant conMakeString(char* str);
void conPrint(Constant const);

typedef enum {INPUT_REG, INPUT_CONST} InputType;
typedef struct input Input;
struct input {
    InputType type;
    union {
	RegisterExp reg;
	Constant con;
    } u;
};
Input inpMakeRegister(RegisterExp reg);
Input inpMakeConst(Constant const);
void inpPrint(Input inp);

typedef struct listnode List;
struct listnode {
    Input input;
    List* next;
};
List* lstMake(Input inp);
List* lstAppend(List* listp, List* newp);
void lstPrint(List* listp);

typedef struct operation OperationExp;
struct operation {
    char* name;
    /* Object (*op)(Object args); */
    List* inputs; /* of type Input */
};
OperationExp opMake(char* name, List* inputs);
void opPrint(OperationExp op);

typedef struct label Label;
struct label {
    char* name;
    unsigned int index; /* index in the instruction sequence */
};
Label lblMake(char *name);
void lblPrint(Label lbl);
char* lblGetName(Label lbl);
unsigned int lblGetIndex(Label lbl);

/* Sources of the assign instruction:
 *  (assign <register-name> (reg <register-name>))
 *  (assign <register-name> (const <constant-value>))
 *  (assign <register-name> (op <operation-name>) <input1> ... <inputn>)
 *  (assign <register-name> (label <label-name>))
 */
typedef enum {SRC_REG, SRC_CONST, SRC_OP, SRC_LABEL} SourceType;
typedef struct source Source;
struct source {
    SourceType type;
    union {
	RegisterExp  reg;
	Constant     con;
	OperationExp op;
	Label        lbl;
    } u;
};
Source srcMakeReg(RegisterExp reg);
Source srcMakeConst(Constant const);
Source srcMakeOp(OperationExp op);
Source srcMakeLabel(Label label);
void srcPrint(Source src);

/* Targets of the goto instruction:
 *  (goto (label <label-name>))
 *  (goto (reg <register-name>))
 */
typedef enum {TRG_REG, TRG_LABEL} TargetType;
typedef struct target Target;
struct target {
    unsigned int type;
    union {
	RegisterExp reg;
	Label       label;
    } u;
};
Target trgMakeReg(RegisterExp reg);
Target trgMakeLabel(Label label);
void trgPrint(Target trg);
RegisterExp trgGetRegister(Target trg);
Label trgGetLabel(Target trg);

/* Instruction types
 */
typedef enum {
    INST_ASSIGN, INST_PERFORM, INST_TEST, INST_LABEL,
    INST_BRANCH, INST_GOTO, INST_SAVE, INST_RESTORE
} InstType;
typedef struct instruction Inst;
struct instruction
{
    InstType type;
    union {
	struct {
	    RegisterExp target;
	    Source source;
	} assign;
	struct {
	    OperationExp op;
	} oper;    /* test and perform */
	struct {
	    Label lbl;
	} label;
	struct {
	    Target target;
	} jump;    /* branch and goto */
	struct {
	    RegisterExp reg;
	} stackOp; /* save and restore */
    } u;
};
Inst insMakeAssign(RegisterExp target, Source source);
Inst insMakePerform(OperationExp op);
Inst insMakeTest(OperationExp op);
Inst insMakeLabel(Label lbl);
Inst insMakeBranch(Target target);
Inst insMakeGoto(Target target);
Inst insMakeSave(RegisterExp reg);
Inst insMakeRestore(RegisterExp reg);
void insPrint(Inst inst);

#endif /* _REGSIM_H */
