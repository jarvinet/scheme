#include "memory.h"


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

Each <inputn> is either
    (reg <register-name>); or
    (const <constant-value>)
*/


static Register regLabels;
static Register regLabel;
static Register regInsts;
static Register regInst;
static Register regOperations;
static Register regOperation;
static Register regOperands;
static Register regLooper;
static Register regRecord;
static Register regName;
static Register regValue;
static Register regValues;
static Register regPc;
static Register regFlag;


#if 0
regSymbol
regSubExp
regInst
regValueExp
regTarget
#endif

/* Needs
 * Modifies
 */

/* Needs
 * Modifies
 *   regLabels, regInsts, regLooper, regInst, regLabel, reg0
 */
static void extractLabels(Register text)
{
    Register restInsts = reg0;

    makeNull(regLabels);
    makeNull(regInsts);

    copyReg(regLooper, text);
    while (!isNull(regLooper)) {
	car(regInst, regLooper);

	if (isSymbol(regInst)) {
	    cdr(restInsts, regLooper);
	    cons(regLabel, regInst, restInsts);
	    snoc(regLabels, regLabels, regLabel);
        } else {
	    snoc(regInsts, regInsts, regInst);
	}

	cdr(regLooper, regLooper);
    }
}

/* Needs
 * Modifies
 *  regLooper, regRecord, regName
 */
static void lookupLabel(Register result, Register labelName)
{
    assoc(regRecord, labelName, regLabels);
    if (isNull(regRecord))
	eprintf("lookupLabel: not found\n");
    cdr(result, regRecord);
}

/* Needs
 * Modifies
 */
static unsigned int isLabel(Register RegInst)
{
    return isSymbol(regInst);
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
static unsigned int isAssign(Register regInst)
{
    return isTaggedList(regInst, "assign");
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
static unsigned int isTest(Register regInst)
{
    return isTaggedList(regInst, "test");
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
static unsigned int isBranch(Register regInst)
{
    return isTaggedList(regInst, "branch");
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
static unsigned int isGoto(Register regInst)
{
    return isTaggedList(regInst, "goto");
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
static unsigned int isSave(Register regInst)
{
    return isTaggedList(regInst, "save");
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
static unsigned int isRestore(Register regInst)
{
    return isTaggedList(regInst, "restore");
}

/* Needs
 * Modifies
 *   reg0, reg1
 */
static unsigned int isPerform(Register regInst)
{
    return isTaggedList(regInst, "perform");
}

/* Needs
 * Modifies
 *   regPc
 */
static void advancePc(void)
{
    cdr(regPc, regPc);
}

/* Needs
 * Modifies
 *   regPc
 */
static void setPc(Register target)
{
    copyReg(regPc, target);
}

/* Needs
 * Modifies
 *   regSymbol
 */
static unsigned int isOperationExp(Register regValueExp)
{
                                  /*  ((op =) (reg a) (reg b)) */
    car(regSymbol, regValueExp);  /*   (op =)                  */
    return isTaggedList(regSymbol, "op");
}

/* Needs
 * Modifies
 *   regSymbol
 */
static unsigned int isConstantExp(Register regValueExp)
{
                                    /* ((const 3)) */
    car(regSymbol, regValueExp);    /*  (const 3)  */
    return isTaggedList(regSymbol, "const");
}

/* Needs
 * Modifies
 *   regSymbol
 */
static unsigned int isRegisterExp(Register valueExp)
{
                                       /*  ((reg a)) */
    car(regSymbol, valueExp);          /*   (reg a)  */
    return isTaggedList(regSymbol, "reg");
}

/* Needs
 * Modifies
 *   regSymbol
 */
static unsigned int isLabelExp(Register valueExp)
{
                                /* ((label done)) */
    car(regSymbol, valueExp);   /*  (label done)  */
    return isTaggedList(regSymbol, "label");
}

/* Needs
 * Modifies
 */
static void opExpOperationName(Register result, Register valueExp)
{
                           /* ((op =) (reg a) (reg b)) */
    car(result, valueExp); /*  (op =)                  */
    cdr(result, result);   /*     (=)                  */
    car(result, result);   /*      =                   */
}

/* Needs
 * Modifies
 */
static void opExpOperands(Register result, Register valueExp)
{
                            /* ((op =) (reg a) (reg b)) */
    cdr(result, valueExp);  /*        ((reg a) (reg b)) */
}


/* Needs
 * Modifies
 *  regLooper, regRecord, regName
 */
static void lookupOperation(Register result, Register name)
{
    assoc(regRecord, name, regOperations);
    if (isNull(regRecord))
	eprintf("lookupOperation: not found\n");
    cdr(result, regRecord);
}

/* Needs
 * Modifies
 */
static void execConstant(Register result, Register valueExp)
{
                           /* ((const <constant-value>)) */
    car(result, valueExp); /*  (const <constant-value>)  */
    cdr(result, result);   /*        (<constant-value>)  */
    car(result, result);   /*         <constant-value>   */
}

/* Needs
 * Modifies
 *  regLooper, regRecord, regName
 */
static void execLabel(Register result, Register valueExp)
{
                                 /* ((label <label-name>)) */
    car(result, valueExp);       /*  (label <label-name>)  */
    cdr(result, result);         /*        (<label-name>)  */
    car(result, result);         /*         <label-name>   */
    lookupLabel(result, result);
}

/* Needs
 * Modifies
 */
static void execRegister(Register result, Register valueExp)
{
                                /* ((reg <register-name>)) */
    car(result, valueExp);      /*  (reg <register-name>)  */
    cdr(result, result);        /*      (<register-name>)  */
    car(result, result);        /*       <register-name>   */
    copyReg(result, lookupRegister(result));
}


/* Needs
 * Modifies
 *  regLooper, regSymbol, regValue, ***********
 */
static void evalOperands(Register result, Register operands)
{
    /* ((reg <register-name>) (const <constant-value>)) */

    makeNull(result);

    copyReg(regLooper, operands);
    while (!isNull(regLooper)) {
	if (isConstantExp(regLooper))
	    execConstant(regValue, regLooper);
	else if (isRegisterExp(regLooper))
	    execRegister(regValue, regLooper);
	else
	    eprintf("evalOperands: unknown operand\n");

	snoc(result, result, regValue);
	cdr(regLooper, regLooper);
    }
}

static void execOperation(Register regTarget,
			  Register regValueExp)
{
    opExpOperationName(regName, regValueExp);
    opExpOperands(regOperands, regValueExp);
    lookupOperation(regOperation, regName);
    evalOperands(regValues, regOperands);
    applyPrimitive(regTarget, regOperation, regValues);
}

static void assignRegisterName(Register regName, Register inst)
{
    /* (assign <regname> (reg <regname>))                 */
    cdr(regName, inst);    /* (<regname> (reg <regname>)) */
    car(regName, regName); /* <regname>                   */
}

static void assignValueExp(Register valueExp, Register inst)
{
    /* (assign <regname> (reg <regname>))                   */
    cdr(valueExp, inst);     /* (<regname> (reg <regname>)) */
    cdr(valueExp, valueExp); /* ((reg <regname>))           */
}

static void execAssign(Register regInst)
{
    assignRegisterName(regName, regInst);
    regTarget = lookupRegister(regName);

    assignValueExp(regValueExp, regInst);
    if (isOperationExp(regValueExp))
	execOperation(regTarget, regValueExp);
    else if (isConstantExp(regValueExp))
	execConstant(regTarget, regValueExp);
    else if (isLabelExp(regValueExp))
	execLabel(regTarget, regValueExp);
    else if (isRegisterExp(regValueExp))
	execRegister(regTarget, regValueExp);
    else
	eprintf("execAssign: unknown value expression\n");

    advancePc();
}

static void getTestOperExp(operExp, inst)
{
    /* (test (op <opname>) <input1> <inputn>)                */
    cdr(operExp, inst); /* ((op <opname>) <input1> <inputn>) */
}


static void execTest(Register inst)
{
    Register operExp = reg1;

    getTestOperExp(operExp, inst);
    if (isOperationExp(operExp))
	execOperation(regValue, operExp);
    else
	eprintf("execTest: unknown value expression\n");
    copyReg(regFlag, regValue);
    advancePc();
}

static void getJumpTarget(Register to, Register inst)
{
    /* (goto (label <label-name>))            */
    cdr(to, inst);  /* ((label <label-name>)) */
}

static void execBranch(Register inst)
{
    Register targetExp = reg2;

    if (isTrue(regFlag)) {

	getJumpTarget(targetExp, inst);
	if (isLabelExp(targetExp))
	    execLabel(regValue, targetExp);
	else
	    eprintf("execBranch: unknown target expression\n");

	setPc(regValue);
    } else
	advancePc();
}

static void execGoto(Register regInst)
{
    Register target    = reg1;
    Register targetExp = reg2;

    getJumpTarget(targetExp, inst);
    if (isLabelExp(targetExp))
	execLabel(target, targetExp);
    else if (isRegisterExp(targetExp))
	execRegister(target, targetExp);
    setPc(target);
}

static void stackOpRegName(Register regName, Register inst)
{
    /* (save <register-name>)              */
    cdr(regName, inst);    /* (<regname>)  */
    car(regName, regName); /* <regname>    */
}

static void execSave(Register inst)
{
    /* (save <register-name>) */
    stackOpRegName(regName, inst);
    save(lookupRegister(regName));
    advancePc();
}

static void execRestore(Register inst)
{
    /* (restore <register-name>) */
    stackOpRegName(regName, inst);
    restore(lookupRegister(regName));
    advancePc();
}

static void execPerform(Register inst)
{
    /* (perform (op <operation-name>) <input1> ... <inputn>) */
    Register operExp = reg1;

    getTestOperExp(operExp, inst);
    if (isOperationExp(operExp))
	execOperation(regValue, operExp);
    else
	eprintf("execTest: unknown value expression\n");
    advancePc();
}

/* Needs
 * Modifies
 */
void execute(Register text)
{
    extractLabels(text);

    /* Replace the names of labels, registers and operations
     * with the pointers to the actual objects. This can and should
     * be done before the execution phase.
     */

    copyReg(regPc, regInsts);
    while (!isNull(regPc)) {
	car(regInst, regPc);
#if 0
	printObject(regInst); newline();
#endif
	if (isLabel(regInst))
	    advancePc(); /* jump over labels */
	else if (isAssign(regInst))
	    execAssign(regInst);
	else if (isTest(regInst))
	    execTest(regInst);
	else if (isBranch(regInst))
	    execBranch(regInst);
	else if (isGoto(regInst))
	    execGoto(regInst);
	else if (isSave(regInst))
	    execSave(regInst);
	else if (isRestore(regInst))
	    execRestore(regInst);
	else if (isPerform(regInst))
	    execPerform(regInst);
	else
	    printf("unknown\n");
    }
    printf("done\n");
}

void addOperation(char* primName, Primitive prim)
{
    makePrimitive(regOperation, prim);
    makeSymbol(regName, primName);
    cons(regRecord, regName, regOperation);
    cons(regOperations, regRecord, regOperations);
}

void initRegSim(void)
{
    regLabels     = allocateRegister("regsimLabels");
    regLabel      = allocateRegister("regsimLabel");
    regInsts      = allocateRegister("regsimInsts");
    regInst       = allocateRegister("regsimInst");
    regOperations = allocateRegister("regsimOperations");
    regOperation  = allocateRegister("regsimOperation");
    regOperands   = allocateRegister("regsimOperands");
    regLooper     = allocateRegister("regsimLooper");
    regRecord     = allocateRegister("regsimRecord");
    regName       = allocateRegister("regsimName");
    regValue      = allocateRegister("regsimValue");
    regValues     = allocateRegister("regsimValues");
    regPc         = allocateRegister("regsimPc");
    regFlag       = allocateRegister("regsimFlag");

    makeNull(regOperations);
}
