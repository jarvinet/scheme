#include <stdio.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"

#include "primitive.h"
#include "null.h"
#include "symbol.h"
#include "number.h"
#include "sstring.h"
#include "boolean.h"
#include "port.h"

#include "argcheck.h"
#include "regsim2.h"

#include "eprint.h"
#include "util.h"


static Register regLabels;
static Register regInstsHead;
static Register regInstsTail;
static Register regInstsCurr;
static Register regPC;   /* Program counter */
static Register regFlag; /* used by test and branch -instructions */
static Register regNull;
static Register regEmptyPair;
static Register regInitialize;

static Hashtable primitives;


void initRegsim(void)
{
    regLabels = regAllocate("labels");
    regInstsHead = regAllocate("InstsHead");
    regInstsTail = regAllocate("InstsTail");
    regInstsCurr = regAllocate("InstsCurrent");
    regPC = regAllocate("PC");
    regFlag = regAllocate("flag");
    regNull = regAllocate("null");
    regEmptyPair = regAllocate("emptypair");
    regInitialize = regAllocate("init");

    regMakeNull(regNull);
    cons(regEmptyPair, regNull, regNull);

    /* We keep an empty pair at the tail of the list.
     * This is where the next instruction will be stored.
     * It is used by the labels construction process.
     */
    regCopy(regInstsHead, regEmptyPair);
    regCopy(regInstsTail, regEmptyPair);
    regCopy(regInstsCurr, regEmptyPair);

    regCopy(regLabels, regNull);

    regMakeNumber(regInitialize, 1);

    primitives = htCreate();
}

void rsAddPrimitive(char* primName, Primitive prim)
{
    Binding b = htLookup(primitives, primName, HASHOP_LOOKUP, (void*)prim);
    if (b != NULL)
      eprintf("multiply defined primitive: %s\n", primName);
    htLookup(primitives, primName, HASHOP_CREATE, (void*)prim);
}

Primitive rsLookupPrimitive(char* primName)
{
    Binding b = htLookup(primitives, primName, HASHOP_LOOKUP, 0);
    if (b == NULL)
      eprintf("primitive not found: %s\n", primName);
    return (Primitive)bindGetValue(b);
}

static bool regsimContinue = TRUE;

void exit_if(Register result, Register operands)
{
    checkArgsEQ("exit", "", operands);
    regsimContinue = FALSE;
}


static void lookupLabel(Register regPair, Register regLabelName)
{
    Register regLooper = regGetTemp();
    Register regLabel = regGetTemp();
    Register regInst = regGetTemp();
    Register regName = regGetTemp();
    
    regMakeNull(regPair);

    for (regCopy(regLooper, regLabels); !regIsNull(regLooper);
	 regCdr(regLooper, regLooper)) {
	regCar(regLabel, regLooper);

	regCar(regName, regLabel);
	
	if (regIsEqual(regLabelName, regName)) {
	    regCdr(regPair, regLabel);
	}
    }
    
    regFreeTemp(regLooper);
    regFreeTemp(regLabel);
    regFreeTemp(regInst);
    regFreeTemp(regName);
}

static bool isTaggedList(Register exp, char* tag)
{
    Register regSymbol = regGetTemp();
    Register listTag = regGetTemp();

    bool result = FALSE;

    if (regIsPairPointer(exp)) {
	regCar(listTag, exp);
	regMakeSymbol(regSymbol, tag);
	result = regIsEq(regSymbol, listTag);
    }

    regFreeTemp(regSymbol);
    regFreeTemp(listTag);
    return result;
}

static bool isAssign(Register regInstruction)
{
    return isTaggedList(regInstruction, "assign");
}

static bool isPerform(Register regInstruction)
{
    return isTaggedList(regInstruction, "perform");
}

static bool isTest(Register regInstruction)
{
    return isTaggedList(regInstruction, "test");
}

static bool isBranch(Register regInstruction)
{
    return isTaggedList(regInstruction, "branch");
}

static bool isGoto(Register regInstruction)
{
    return isTaggedList(regInstruction, "goto");
}

static bool isSave(Register regInstruction)
{
    return isTaggedList(regInstruction, "save");
}

static bool isRestore(Register regInstruction)
{
    return isTaggedList(regInstruction, "restore");
}

static bool isReg(Register regInstruction)
{
    return isTaggedList(regInstruction, "reg");
}

static bool isConst(Register regInstruction)
{
    return isTaggedList(regInstruction, "const");
}

static bool isOp(Register regInstruction)
{
    return isTaggedList(regInstruction, "op");
}

static bool isLabel(Register regInstruction)
{
    return isTaggedList(regInstruction, "label");
}

/* Assemble the instructions having a register name
 * as a second element in a list. These operations are:
 * assign, save, and restore.
 *
 * (<register-name>)
 * =>
 * ((<register-name> . <register(as a number)> ))
 *
 *                   +---+---+
 *        regInst -> |   | / |
 *                   +---+---+
 *                     |
 *                     V
 *                    regname
 * =>
 *                   +---+---+
 *        regInst -> |   | / |
 *                   +---+---+
 *                     |
 *                     V
 *                   +---+---+
 *                   |   |   |<----regNewPair
 *                   +---+---+
 *                     |   |
 *                     V   V
 *		regname  <register>
 *
 *
 */
static void assembleRegisterExp(Register regInst)
{
    Register regRegName = regGetTemp();
    Register regRegister = regGetTemp();
    Register regNewPair = regGetTemp();
    Register reg;
    char* name;

    /*                              (<register-name>) */
    regCar(regRegName, regInst); /*  <register-name>  */

    name = regGetSymbol(regRegName);
    if (!regLookup(name, &reg)) {
        printf("Allocating register %s\n", name);
	reg = regAllocate(name);
    }

    regMakeNumber(regRegister, reg);
    cons(regNewPair, regRegName, regRegister);
    regSetCar(regInst, regNewPair);

    regFreeTemp(regRegName);
    regFreeTemp(regRegister);
    regFreeTemp(regNewPair);
}

/* Assemble the instructions having a label name
 * as a second element in a list. These operations are:
 * assign, save, and restore.
 *
 * (<label-name>)
 * =>
 * ((<label-name> . <label(as a pairpointer)> ))
 *
 *                   +---+---+
 *        regLabel-> |   | / |
 *                   +---+---+
 *                     |
 *                     V
 *                    regname
 * =>
 *                   +---+---+
 *        regLabel-> |   | / |
 *                   +---+---+
 *                     |
 *                     V
 *                   +---+---+
 *                   |   |   |<----regNewPair
 *                   +---+---+
 *                     |   |
 *                     V   V
 *		regname  <register>
 *
 *
 */
static void assembleLabel(Register regLabel)
{
    Register regLabelName = regGetTemp();
    Register regPair = regGetTemp();
    Register regNewPair = regGetTemp();

    /*                                 (<label-name>) */
    regCar(regLabelName, regLabel); /*  <label-name>  */

    lookupLabel(regPair, regLabelName);
    if (regIsNull(regPair)) {
	printf("Label %s not defined\n", regGetSymbol(regLabelName));
    } else {
	cons(regNewPair, regLabelName, regPair);
	regSetCar(regLabel, regNewPair);
    }

    regFreeTemp(regLabelName);
    regFreeTemp(regPair);
    regFreeTemp(regNewPair);
}

/*
 * Assemble label or reg instruction.
 *
 * (label <label-name>)
 * (reg <register-name>)
 *
 *
 *    +---+---+    +---+---+
 *    |   |   +--->|   | / |
 *    +---+---+	   +---+---+
 *      |	     |
 *      V	     V
 *     goto	   +---+---+    +---+---+
 *                 |   |   +--->|   | / |
 *                 +---+---+    +---+---+
 *                   |    	  |
 *                   V            V
 *                 label         foo
 *
 * =>
 *
 *    +---+---+    +---+---+
 *    |   |   +--->|   | / |
 *    +---+---+	   +---+---+    regPair
 *      |	     |            |
 *      V	     V            V
 *     goto	   +---+---+    +---+---+
 *                 |   |   +--->|   | / |
 *                 +---+---+    +---+---+
 *                   |            |
 *                   V            V
 *                 label        +---+---+
 *                              |   | / |
 *                              +---+---+
 *                                |   |
 *                                V   V
 *                              foo   <label>
 *
 */
static void assembleTarget(Register regTarget)
{
    Register regPair = regGetTemp();

    /*                             (reg <register-name>) */
    regCdr(regPair, regTarget); /*     (<register-name>) */

    if (isReg(regTarget)) {
	assembleRegisterExp(regPair);
    } else if (isLabel(regTarget)) {
	assembleLabel(regPair);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regTarget);
	printf("assembleTarget: unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regPair);
}

/*
 * (op <operation-name>)
 * =>
 * (op (<operation-name> . <operation>))
 *
 */
static void assembleOperation(Register regOperation)
{
    Register regPrimitive = regGetTemp();
    Register regOperationName = regGetTemp();
    Register regOldPair = regGetTemp();
    Register regNewPair = regGetTemp();
    char* name;

    /*                                       (op <operation-name>) */
    regCdr(regOldPair, regOperation);     /*    (<operation-name>) */
    regCar(regOperationName, regOldPair); /*     <operation-name>  */

    name = regGetSymbol(regOperationName);
    regMakePrimitive(regPrimitive, name, rsLookupPrimitive(name));
    cons(regNewPair, regOperationName, regPrimitive);
    regSetCar(regOldPair, regNewPair);

    regFreeTemp(regPrimitive);
    regFreeTemp(regOperationName);
    regFreeTemp(regOldPair);
    regFreeTemp(regNewPair);
}

/*
 * <inpup> is one of the following:
 *
 * (reg <register-name>)
 * (const <whatever>)
 * (label <label-name>)
 *
 */
static void assembleInput(Register regInput)
{
    Register regTemp = regGetTemp();
    
    if (isReg(regInput)) {
	regCdr(regTemp, regInput); /* (<register-name>) */
	assembleRegisterExp(regTemp);
    } else if (isConst(regInput)) {
	/* Do nothing */
    } else if (isLabel(regInput)) {
	regCdr(regTemp, regInput); /* (<label-name>) */
	assembleLabel(regTemp);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regInput);
	printf("assembleInput: unknown tag: %s\n",
	       regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regTemp);
}

/*
 * (<inp1> ... <inpn>)
 */
static void assembleInputs(Register regInputs)
{
    Register regLooper = regGetTemp();
    Register regInput = regGetTemp();

    for (regCopy(regLooper, regInputs); !regIsNull(regLooper);
	 regCdr(regLooper, regLooper)) {
        regCar(regInput, regLooper);
	assembleInput(regInput);
    }
    regFreeTemp(regLooper);
    regFreeTemp(regInput);
}

/*
 * ((op <operation>) <inp1> ... <inpn>)
 */
static void assembleOperationExp(Register regOperExp)
{
    Register regOperation = regGetTemp();
    Register regInputs = regGetTemp();

    /*                                  ((op <operation>) <inp1> ... <inpn>) */
    regCar(regOperation, regOperExp); /* (op <operation>)                    */
    regCdr(regInputs, regOperExp);    /*                 (<inp1> ... <inpn>) */
    
    assembleOperation(regOperation);
    assembleInputs(regInputs);

    regFreeTemp(regOperation);
    regFreeTemp(regInputs);
}

/*
 *  ((reg <register-name>))
 *  ((const <constant-value>))
 *  ((op <operation-name>) <input1> ... <inputn>)
 *  ((label <label-name>))
 */
static void assembleSource(Register regSource)
{
    Register regFirst = regGetTemp();
    Register regRest = regGetTemp();

    /*                             ((reg <register-name>)) */
    regCar(regFirst, regSource); /* (reg <register-name>)  */

    if (isReg(regFirst)) {
	regCdr(regRest, regFirst); /* (<register-name>) */
	assembleRegisterExp(regRest);
    } else if (isConst(regFirst)) {
	/* Do nothing */
    } else if (isOp(regFirst)) {
	assembleOperationExp(regSource);
    } else if (isLabel(regFirst)) {
	regCdr(regRest, regFirst); /* (<label-name>) */
	assembleLabel(regRest);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regFirst);
        printf("assembleSource. unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regFirst);
    regFreeTemp(regRest);
}

static void assembleInstructions(void)
{
    Register regLooper = regGetTemp();
    Register regInstruction = regGetTemp();
    Register regTemp = regGetTemp();

    for (regCopy(regLooper, regInstsCurr); !regIsNull(regLooper);
	 regCdr(regLooper, regLooper)) {
	regCar(regInstruction, regLooper);

	if (isAssign(regInstruction)) {

	    /*                                  (assign val <src>) */
	    regCdr(regTemp, regInstruction); /*        (val <src>) */
	    assembleRegisterExp(regTemp);    
	    regCdr(regTemp, regTemp);        /*            (<src>) */
	    assembleSource(regTemp);

	} else if (isPerform(regInstruction) || isTest(regInstruction)) {

	    /*                                  (perform (op <operation>) <inp1> ... <inpn>) */
	    regCdr(regTemp, regInstruction); /*         ((op <operation>) <inp1> ... <inpn>) */
	    assembleOperationExp(regTemp);

	} else if (isBranch(regInstruction) || isGoto(regInstruction)) {

	    /*                                  (branch (label foo)) */
	    regCdr(regTemp, regInstruction); /*        ((label foo)) */ 
	    regCar(regTemp, regTemp);        /*         (label foo)  */
	    assembleTarget(regTemp);

	} else if (isSave(regInstruction) || isRestore(regInstruction)) {

	    /*                                  (save continue) */
	    regCdr(regTemp, regInstruction); /*      (continue) */
	    assembleRegisterExp(regTemp);
	}
    }

    regFreeTemp(regLooper);
    regFreeTemp(regInstruction);
    regFreeTemp(regTemp);
}

/*  ((a . 123) ... )
 */
static Register regExpGetRegister(Register regExp)
{
    Register regNumber = regGetTemp();
    Register reg;

    regCar(regNumber, regExp);    /*  (a . 123)  */
    regCdr(regNumber, regNumber); /*       123   */
    reg = regGetNumber(regNumber);
    regFreeTemp(regNumber);

    return reg;
}

/*
 * regSource:
 * (reg (<register-name> . <register as a number>))
 */
static void executeRegisterExp(Register regTarget, Register regSource)
{
    Register regSrc = regGetTemp();

    regCdr(regSrc, regSource); /* ((<register-name> . <register as a number>)) */
    regCar(regSrc, regSrc);    /*  (<register-name> . <register as a number>)  */
    regCdr(regSrc, regSrc);    /*                     <register as a number>   */

    regCopy(regTarget, regGetNumber(regSrc));

    regFreeTemp(regSrc);
}

/*
 * regSource
 * ((const <constant-value>))
 */
static void executeConstant(Register regTarget, Register regSource)
{
    Register regConst = regGetTemp();

    regCdr(regConst, regSource); /* (<constant-value>) */
    regCar(regConst, regConst);  /*  <constant-value>  */

    regCopy(regTarget, regConst);

    regFreeTemp(regConst);
}

/*
 *  (op (<operation-name> . <primitive>))
 */
static void getPrimitive(Register regPrimitive, Register regOpExp)
{
    regCdr(regPrimitive, regOpExp);     /* ((<operation-name> . <primitive>)) */
    regCar(regPrimitive, regPrimitive); /*  (<operation-name> . <primitive>)  */
    regCdr(regPrimitive, regPrimitive); /*                      <primitive>   */
}

/*
 *  (op (<operation-name> . <primitive>))
 */
static void getPrimitiveName(Register regPrimitive, Register regOpExp)
{
    regCdr(regPrimitive, regOpExp);     /* ((<operation-name> . <primitive>)) */
    regCar(regPrimitive, regPrimitive); /*  (<operation-name> . <primitive>)  */
    regCar(regPrimitive, regPrimitive); /*   <operation-name>                 */
}

/*
 * regSource:
 *  (label (<label-name> . <pointer to memory>))
 */
static void executeLabel(Register regTarget, Register regSource)
{
    Register regLabel = regGetTemp();

    regCdr(regLabel, regSource); /*       ((<label-name> . <pointer to memory>)) */
    regCar(regLabel, regLabel);  /*        (<label-name> . <pointer to memory>)  */
    regCdr(regLabel, regLabel);  /*                        <pointer to memory>   */
    
    regCopy(regTarget, regLabel);

    regFreeTemp(regLabel);
}

/*
 *  regInput
 *  (reg (<registername> . <register as a number>))
 */
static void executeInput(Register regResult, Register regInput)
{
    Register regTemp = regGetTemp();
    
    if (isReg(regInput)) {
	executeRegisterExp(regResult, regInput);
    } else if (isConst(regInput)) {
	executeConstant(regResult, regInput);
    } else if (isLabel(regInput)) {
	executeLabel(regResult, regInput);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regInput);
	printf("executeInput: unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regTemp);
}

/*
 *  (<input1> ... <inputn>)
 */
static void executeOperands(Register regArguments, Register regOperands)
{
    Register regLooper = regGetTemp();
    Register regInput = regGetTemp();
    Register regResult = regGetTemp();

    regMakeNull(regArguments);
    for (regCopy(regLooper, regOperands); !regIsNull(regLooper);
	 regCdr(regLooper, regLooper)) {
	regCar(regInput, regLooper);
	executeInput(regResult, regInput);
	snoc(regArguments, regArguments, regResult);
    }    

    regFreeTemp(regLooper);
    regFreeTemp(regInput);
    regFreeTemp(regResult);
}

/*
 * regSource:
 *  ((op (<operation-name> . <primitive>)) <input1> ... <inputn>)
 */
static void executeOperationExp(Register regTarget, Register regSource)
{
    Register regArguments = regGetTemp();
    Register regPrimitive = regGetTemp();
    Register regOperands = regGetTemp();
    Register regTemp = regGetTemp();
    Primitive primitive;

    regCar(regTemp, regSource);       /* (op (<operation-name> . <primitive>)) */
    getPrimitive(regPrimitive, regTemp);

    regCdr(regOperands, regSource);   /* (<input1> ... <inputn>) */
    executeOperands(regArguments, regOperands);

    primitive = regGetPrimitive(regPrimitive);
    (*primitive)(regTarget, regArguments);

    regFreeTemp(regArguments);
    regFreeTemp(regPrimitive);
    regFreeTemp(regOperands);
    regFreeTemp(regTemp);
}

/*
 *  ((reg (<register-name> . <register as a number>)))
 *  ((const <constant-value>))
 *  ((op (<operation-name> . <primitive>) <input1> ... <inputn>)
 *  ((label (<label-name> . <pointer to memory>)))
 *
 * ((op (= . [primitive =])) (reg (b . 121)) (const 3))
 */
static void executeSource(Register regTarget, Register regSource)
{
    Register regFirst = regGetTemp();

    /*                             ((reg (<register-name> . <register as a number>))) */
    regCar(regFirst, regSource); /* (reg (<register-name> . <register as a number>))  */

    if (isReg(regFirst)) {
	executeRegisterExp(regTarget, regFirst);
    } else if (isConst(regFirst)) {
	executeConstant(regTarget, regFirst);
    } else if (isOp(regFirst)) {
	executeOperationExp(regTarget, regSource);
    } else if (isLabel(regFirst)) {
	executeLabel(regTarget, regFirst);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regFirst);
        printf("executeSource. unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regFirst);
}

/* (assign (a . 123) (op (= . [primitive =])) (reg (b . 121)) (const 3))
 *
 */
static void executeAssign(Register regInst)
{
    Register regRegisterExp = regGetTemp();
    Register regRest = regGetTemp();
    Register regTarget;

    regCdr(regRegisterExp, regInst);        /* ((a . 123)  ... ) */
    regCdr(regRest, regRegisterExp);        /*           ( ... ) */

    regTarget = regExpGetRegister(regRegisterExp);

    executeSource(regTarget, regRest);

    regFreeTemp(regRegisterExp);
    regFreeTemp(regRest);
}

/*
 * (perform (op (= . [primitive =])) (reg (b . 121)) (const 3))
 */
static void executePerform(Register regInst)
{
    Register regRest = regGetTemp();
    Register regTarget = regGetTemp();

    /*                           (perform (op (= . [primitive =])) (reg (b . 121)) (const 3)) */
    regCdr(regRest, regInst); /*         ((op (= . [primitive =])) (reg (b . 121)) (const 3)) */

    executeOperationExp(regTarget, regRest);

    regFreeTemp(regRest);
    regFreeTemp(regTarget);
}

/*
 *  (test (op <operation-name>) <input1> ... <inputn>)
 */
static void executeTest(Register regInst)
{
    Register regRest = regGetTemp();

    regCdr(regRest, regInst);
    executeOperationExp(regFlag, regRest);

    regFreeTemp(regRest);
}

static void advancePC(void)
{
    regCdr(regPC, regPC);
}

/*
 *  ((reg (<register-name> . <register as a number>)))
 *  ((label (<label-name> . <pointer to memory>)))
 *
 */
static void executeTarget(Register regTarget, Register regSource)
{
    Register regFirst = regGetTemp();

    /*                             ((reg (<register-name> . <register as a number>))) */
    regCar(regFirst, regSource); /* (reg (<register-name> . <register as a number>))  */

    if (isReg(regFirst)) {
	executeRegisterExp(regTarget, regFirst);
    } else if (isLabel(regFirst)) {
	executeLabel(regTarget, regFirst);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regFirst);
        printf("executeTarget. unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regFirst);
}

/*
 * regInst:
 * (goto (label (<labelname> . <pointer to memory>)))
 * (goto (reg (<registername> . <register as a number>)))
 */
static void executeGoto(Register regInst)
{
    Register regLabel = regGetTemp();

    /*                            (goto (label (<labelname> . <pointer to memory>))) */
    regCdr(regLabel, regInst);  /*     ((label (<labelname> . <pointer to memory>))) */
    executeTarget(regPC, regLabel);

    regFreeTemp(regLabel);
}

/*
 *  (branch (label (<label-name> . <pointer to memory>)))
 */
static void executeBranch(Register regInst)
{

    if (regIsTrue(regFlag)) {
	executeGoto(regInst);
    } else {
	advancePC();
    }
}

/*
 *  (save (<register-name> . <register>))
 */
static void executeSave(Register regInst)
{
    Register regExp = regGetTemp();
    Register regRegister;

    regCdr(regExp, regInst);
    regRegister = regExpGetRegister(regExp);
    save(regRegister);

    regFreeTemp(regExp);
}

/*
 *  (restore (<register-name> . <register>))
 */
static void executeRestore(Register regInst)
{
    Register regRegister;
    Register regExp = regGetTemp();

    regCdr(regExp, regInst);
    regRegister = regExpGetRegister(regExp);
    restore(regRegister);

    regFreeTemp(regExp);
}

static void executeInstruction(Register regInst)
{
    if (isAssign(regInst)) {
	executeAssign(regInst);
	advancePC();
    } else if (isPerform(regInst)) {
	executePerform(regInst);
	advancePC();
    } else if (isTest(regInst)) {
	executeTest(regInst);
	advancePC();
    } else if (isBranch(regInst)) {
	executeBranch(regInst);
    } else if (isGoto(regInst)) {
	executeGoto(regInst);
    } else if (isSave(regInst)) {
	executeSave(regInst);
	advancePC();
    } else if (isRestore(regInst)) {
	executeRestore(regInst);
	advancePC();
    } else {
	advancePC();
    }
}

/*
 * ((a . 123)  ... ) 
 */
static void printRegExp(Register regExp)
{
    Register regSrc = regGetTemp();
    char* name;

    regCar(regSrc, regExp);    /*  (<register-name> . <register as a number>)  */
    regCar(regSrc, regSrc);    /*   <register-name>                            */
    name = regGetSymbol(regSrc);
    printf("%s", name);

    regFreeTemp(regSrc);
}

/*
 * regSource:
 * (reg (<register-name> . <register as a number>))
 */
static void printRegisterExp(Register regSource)
{
    Register regSrc = regGetTemp();

    printf("(reg ");
    regCdr(regSrc, regSource); /* ((<register-name> . <register as a number>)) */
    printRegExp(regSrc);
    printf(")");

    regFreeTemp(regSrc);
}



/*
 * regSource
 * ((const <constant-value>))
 */
static void printConstant(Register regSource)
{
    Register regConst = regGetTemp();

    printf("(const ");
    regCdr(regConst, regSource); /* (<constant-value>) */
    regCar(regConst, regConst);  /*  <constant-value>  */
    regPrint(regConst);
    printf(")");

    regFreeTemp(regConst);
}

/*
 * regSource:
 *  (label (<label-name> . <pointer to memory>))
 */
static void printLabel(Register regSource)
{
    Register regLabel = regGetTemp();

    printf("(label ");
    regCdr(regLabel, regSource); /*       ((<label-name> . <pointer to memory>)) */
    regCar(regLabel, regLabel);  /*        (<label-name> . <pointer to memory>)  */
    regCar(regLabel, regLabel);  /*         <label-name>                         */
    regPrint(regLabel);
    printf(")");

    regFreeTemp(regLabel);
}

/*
 */
static void printLabel2(Register regLabel)
{
    printf("%s\n", regGetSymbol(regLabel));
}

/*
 *  regInput
 *  (reg (<registername> . <register as a number>))
 */
static void printInput(Register regInput)
{
    Register regTemp = regGetTemp();
    
    if (isReg(regInput)) {
	printRegisterExp(regInput);
    } else if (isConst(regInput)) {
	printConstant(regInput);
    } else if (isLabel(regInput)) {
	printLabel(regInput);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regInput);
	printf("printInput: unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regTemp);
}

/*
 *  (<input1> ... <inputn>)
 */
static void printOperands(Register regOperands)
{
    Register regLooper = regGetTemp();
    Register regInput = regGetTemp();
    Register regResult = regGetTemp();

    for (regCopy(regLooper, regOperands); !regIsNull(regLooper);
	 regCdr(regLooper, regLooper)) {
	regCar(regInput, regLooper);
	printf(" ");
	printInput(regInput);
    }    

    regFreeTemp(regLooper);
    regFreeTemp(regInput);
    regFreeTemp(regResult);
}

/*
 * regSource:
 *  ((op (<operation-name> . <primitive>)) <input1> ... <inputn>)
 */
static void printOperationExp(Register regSource)
{
    Register regPrimitiveName = regGetTemp();
    Register regOperands = regGetTemp();
    Register regTemp = regGetTemp();

    regCar(regTemp, regSource);       /* (op (<operation-name> . <primitive>)) */
    getPrimitiveName(regPrimitiveName, regTemp);

    printf("(op ");
    regPrint(regPrimitiveName);
    printf(")");

    regCdr(regOperands, regSource);   /* (<input1> ... <inputn>) */
    printOperands(regOperands);

    regFreeTemp(regPrimitiveName);
    regFreeTemp(regOperands);
    regFreeTemp(regTemp);
}

static void printSource(Register regSource)
{
    Register regFirst = regGetTemp();

    /*                             ((reg (<register-name> . <register as a number>))) */
    regCar(regFirst, regSource); /* (reg (<register-name> . <register as a number>))  */

    if (isReg(regFirst)) {
	printRegisterExp(regFirst);
    } else if (isConst(regFirst)) {
	printConstant(regFirst);
    } else if (isOp(regFirst)) {
	printOperationExp(regSource);
    } else if (isLabel(regFirst)) {
	printLabel(regFirst);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regFirst);
        printf("printSource. unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regFirst);
}

static void printAssign(Register regInst)
{
    Register regRegisterExp = regGetTemp();
    Register regRest = regGetTemp();

    regCdr(regRegisterExp, regInst);        /* ((a . 123)  ... ) */
    regCdr(regRest, regRegisterExp);        /*           ( ... ) */

    printf("  (assign ");
    printRegExp(regRegisterExp);
    printf(" ");
    printSource(regRest);
    printf(")\n");

    regFreeTemp(regRegisterExp);
    regFreeTemp(regRest);
}

/*
 * (perform (op (= . [primitive =])) (reg (b . 121)) (const 3))
 */
static void printPerform(Register regInst)
{
    Register regRest = regGetTemp();
    Register regTarget = regGetTemp();

    /*                           (perform (op (= . [primitive =])) (reg (b . 121)) (const 3)) */
    regCdr(regRest, regInst); /*         ((op (= . [primitive =])) (reg (b . 121)) (const 3)) */

    printf("  (perform ");
    printOperationExp(regRest);
    printf(")\n");

    regFreeTemp(regRest);
    regFreeTemp(regTarget);
}

/*
 *  (test (op <operation-name>) <input1> ... <inputn>)
 */
static void printTest(Register regInst)
{
    Register regRest = regGetTemp();

    regCdr(regRest, regInst);
    printf("  (test ");
    printOperationExp(regRest);
    printf(")\n");

    regFreeTemp(regRest);
}

/*
 *  ((reg (<register-name> . <register as a number>)))
 *  ((label (<label-name> . <pointer to memory>)))
 *
 */
static void printTarget(Register regSource)
{
    Register regFirst = regGetTemp();

    /*                             ((reg (<register-name> . <register as a number>))) */
    regCar(regFirst, regSource); /* (reg (<register-name> . <register as a number>))  */

    if (isReg(regFirst)) {
	printRegisterExp(regFirst);
    } else if (isLabel(regFirst)) {
	printLabel(regFirst);
    } else {
	Register regTag = regGetTemp();
	regCar(regTag, regFirst);
        printf("executeTarget. unknown tag: %s\n", regGetSymbol(regTag));
	regFreeTemp(regTag);
    }

    regFreeTemp(regFirst);
}

/*
 * regInst:
 * (goto (label (<labelname> . <pointer to memory>)))
 */
static void printGoto(Register regInst)
{
    Register regLabel = regGetTemp();

    /*                            (goto (label (<labelname> . <pointer to memory>))) */
    regCdr(regLabel, regInst);  /*     ((label (<labelname> . <pointer to memory>))) */

    printf("  (goto ");
    printTarget(regLabel);
    printf(")\n");

    regFreeTemp(regLabel);
}

/*
 *  (branch (label (<label-name> . <pointer to memory>)))
 */
static void printBranch(Register regInst)
{
    Register regLabel = regGetTemp();

    /*                            (branch (label (<labelname> . <pointer to memory>))) */
    regCdr(regLabel, regInst);  /*       ((label (<labelname> . <pointer to memory>))) */

    printf("  (branch ");
    printTarget(regLabel);
    printf(")\n");

    regFreeTemp(regLabel);
}

/*
 *  (save (<register-name> . <register>))
 */
static void printSave(Register regInst)
{
    Register regExp = regGetTemp();

    regCdr(regExp, regInst); /* ((<register-name> . <register>)) */

    printf("  (save ");
    printRegExp(regExp);
    printf(")\n");

    regFreeTemp(regExp);
}

/*
 *  (restore (<register-name> . <register>))
 */
static void printRestore(Register regInst)
{
    Register regExp = regGetTemp();

    regCdr(regExp, regInst); /* ((<register-name> . <register>)) */

    printf("  (restore ");
    printRegExp(regExp);
    printf(")\n");

    regFreeTemp(regExp);
}

static void printInstruction(Register regInst)
{
    if (isAssign(regInst)) {
	printAssign(regInst);
    } else if (isPerform(regInst)) {
	printPerform(regInst);
    } else if (isTest(regInst)) {
	printTest(regInst);
    } else if (isBranch(regInst)) {
	printBranch(regInst);
    } else if (isGoto(regInst)) {
	printGoto(regInst);
    } else if (isSave(regInst)) {
	printSave(regInst);
    } else if (isRestore(regInst)) {
	printRestore(regInst);
    } else {
	printLabel2(regInst);
    }
}


static void executeInstructions(void)
{
    Register regInst = regGetTemp();

    regCopy(regPC, regInstsCurr);

    while (!regIsNull(regPC) && regsimContinue) {
	regCar(regInst, regPC);
#if 0
	printInstruction(regInst);
#endif
	executeInstruction(regInst);
    }

    regFreeTemp(regInst);
}

static void extractLabels(Register regProgram)
{
    Register regInst = regGetTemp();
    Register regLabel = regGetTemp();
    Register regSymbol = regGetTemp();
    Register regLooper = regGetTemp();

    /*                                 ( () () (  ) ) */
    regCdr(regProgram, regProgram); /*    ( () (  ) ) */
    regCdr(regProgram, regProgram); /*       ( (  ) ) */
    regCar(regProgram, regProgram); /*         (  )   */


    /* Separate labels and instructions */
    for (regCopy(regLooper, regProgram); !regIsNull(regLooper);
	 regCdr(regLooper, regLooper)) {
	regCar(regInst, regLooper);
	if (regIsSymbol(regInst)) {
	    /* a label */
	    cons(regLabel, regInst, regInstsTail);
	    cons(regLabels, regLabel, regLabels);
	}
	regSetCar(regInstsTail, regInst);
	cons(regEmptyPair, regNull, regNull);
	regSetCdr(regInstsTail, regEmptyPair);
	regCopy(regInstsTail, regEmptyPair);
    }
    regMakeSymbol(regSymbol, "end-of-insts");
    regSetCar(regInstsTail, regSymbol);

    regFreeTemp(regInst);
    regFreeTemp(regLabel);
    regFreeTemp(regLooper);
    regFreeTemp(regSymbol);
}


void printInstructions(void)
{
    Register regInst = regGetTemp();
    Register regLooper = regGetTemp();

    for (regCopy(regLooper, regInstsHead); !regIsNull(regLooper);
	 regCdr(regLooper, regLooper)) {
	regCar(regInst, regLooper);
	printInstruction(regInst);
    }

    regFreeTemp(regInst);
    regFreeTemp(regLooper);
}

static void loadFile(char* fileName)
{
    Register regFilename = regGetTemp();
    Register regProgram = regGetTemp();
    Register regPort = regGetTemp();

    regMakeString(regFilename, estrdup(fileName));
    openInputFile(regPort, regFilename);
    readPort(regProgram, regPort);
    regCloseInputPort(regPort);

    extractLabels(regProgram);
    assembleInstructions();
    executeInstructions();
    regCopy(regInstsCurr, regInstsTail);

    regFreeTemp(regFilename);
    regFreeTemp(regProgram);
    regFreeTemp(regPort);
}


void loadFiles(unsigned int regsimFileCount, char** regsimFilenames)
{
    unsigned int i;

    for (i = 0; i < regsimFileCount; i++) {
	loadFile(regsimFilenames[i]);
    }
}
