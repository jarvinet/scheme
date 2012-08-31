#ifndef _INSTS_H
#define _INSTS_H


void strPrint(char* str);
void strDelete(char* str);

typedef struct reg *RegisterExp;
RegisterExp rexMake(char* name);
char*       rexGetName(RegisterExp reg);
void        rexSetReg(RegisterExp regExp, Register reg);
Register    rexGetReg(RegisterExp reg);
void        rexPrint(RegisterExp reg);

typedef struct label *Label;
Label        lblMake(char *name);
void         lblPrint(Label lbl);
char*        lblGetName(Label lbl);
unsigned int lblGetIndex(Label lbl);
void         lblSetIndex(Label lbl, unsigned int idx);

typedef struct constant *Constant;
Constant  conMake(char* str);
void      conPrint(Constant con);
char*     conGetString(Constant con);

typedef enum {
    INPUT_REG,
    INPUT_CONST,
    INPUT_LABEL
} InputType;
typedef struct input *Input;
Input       inpMakeRegister(RegisterExp reg);
Input       inpMakeConst(Constant const);
Input       inpMakeLabel(Label lbl);
void        inpPrint(Input inp);
InputType   inpGetType(Input inp);
RegisterExp inpGetReg(Input inp);
Constant    inpGetConst(Input inp);
Label       inpGetLabel(Input inp);
void        inpDelete(Input inp);


typedef struct operation *OperationExp;
OperationExp opMake(char* name, List inputs);
void      opPrint(OperationExp op);
char*     opGetName(OperationExp op);
Primitive opGetPrimitive(OperationExp op);
void      opSetPrimitive(OperationExp op, Primitive primitive);
List      opGetInputs(OperationExp op);

/* Sources of the assign instruction:
 *  (assign <register-name> (reg <register-name>))
 *  (assign <register-name> (const <constant-value>))
 *  (assign <register-name> (op <operation-name>) <input1> ... <inputn>)
 *  (assign <register-name> (label <label-name>))
 */
typedef enum {
    SRC_REG,
    SRC_CONST,
    SRC_OP,
    SRC_LABEL
} SourceType;
typedef struct source *Source;
Source       srcMakeReg(RegisterExp reg);
Source       srcMakeConst(Constant const);
Source       srcMakeOp(OperationExp op);
Source       srcMakeLabel(Label label);
void         srcPrint(Source src);
SourceType   srcGetType(Source src);
RegisterExp  srcGetReg(Source src);
Constant     srcGetConst(Source src);
OperationExp srcGetOp(Source src);
Label        srcGetLabel(Source src);

/* Targets of the goto instruction:
 *  (goto (label <label-name>))
 *  (goto (reg <register-name>))
 */
typedef enum {
    TRG_REG,
    TRG_LABEL
} TargetType;
typedef struct target *Target;
Target      trgMakeReg(RegisterExp reg);
Target      trgMakeLabel(Label label);
void        trgPrint(Target trg);
TargetType  trgGetType(Target trg);
RegisterExp trgGetReg(Target trg);
Label       trgGetLabel(Target trg);

/* Types on instructions:
 *
 *  (assign <register-name> (reg <register-name>))
 *  (assign <register-name> (const <constant-value>))
 *  (assign <register-name> (op <operation-name>) <input1> ... <inputn>)
 *  (assign <register-name> (label <label-name>))
 *  
 *  (perform (op <operation-name>) <input1> ... <inputn>)
 *     
 *  (test (op <operation-name>) <input1> ... <inputn>)
 *
 *  (branch (label <label-name>))
 *
 *  (goto (label <label-name>))
 *  (goto (reg <register-name>))
 *
 *  (save <register-name>)
 *
 *  (restore <register-name>)
 *
 *  (comment any free-form comment)
 */
typedef enum {
    INST_ASSIGN,
    INST_PERFORM,
    INST_TEST,
    INST_LABEL,
    INST_BRANCH,
    INST_GOTO,
    INST_SAVE,
    INST_RESTORE,
    INST_COMMENT
} InstType;
typedef struct instruction *Inst;
Inst insMakeAssign(char* fileName, unsigned int lineNumber, RegisterExp target, Source source);
Inst insMakePerform(char* fileName, unsigned int lineNumber, OperationExp op);
Inst insMakeTest(char* fileName, unsigned int lineNumber, OperationExp op);
Inst insMakeLabel(char* fileName, unsigned int lineNumber, Label lbl);
Inst insMakeBranch(char* fileName, unsigned int lineNumber, Target target);
Inst insMakeGoto(char* fileName, unsigned int lineNumber, Target target);
Inst insMakeSave(char* fileName, unsigned int lineNumber, RegisterExp reg);
Inst insMakeRestore(char* fileName, unsigned int lineNumber, RegisterExp reg);
Inst insMakeComment(char* fileName, unsigned int lineNumber, char* comment);
void insDelete(Inst inst);
void insPrint(Inst inst);
void insDump(Inst inst);

InstType     insGetType(Inst inst);
unsigned int insGetLineNumber(Inst inst);
RegisterExp  insGetAssignTarget(Inst inst);
Source       insGetAssignSource(Inst inst);
OperationExp insGetPerform(Inst inst);
OperationExp insGetTest(Inst inst);
Label        insGetLabel(Inst inst);
Target       insGetBranch(Inst inst);
Target       insGetGoto(Inst inst);
RegisterExp  insGetSave(Inst inst);
RegisterExp  insGetRestore(Inst inst);

#endif /* _INSTS_H */
