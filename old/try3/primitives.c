#include "memory.h"
#include "util.h"
#include "support.h"
#include "syntax.h"


/**************************************************/
/* environment */

void lookupVariableValue_si(Register result, Register operands)
{
    checkArgsEQ("lookup-variable-value", "yp", operands);
    lookupVariableValue(result, regArgs[0], regArgs[1]);
}

void extendEnvironment_si(Register result, Register operands)
{
    /* operands: variables values env */
    /* variables and values may be null, so type checker character
     * p cannot be used here. A better would be l for list
     * that accepts both null and pair
     */
    checkArgsEQ("extend-environment", "**p", operands);
    extendEnvironment(regArgs[0], regArgs[1], regArgs[2]);
}

void defineVariable_si(Register result, Register operands)
{
    checkArgsEQ("define", "y*p", operands);
    defineVariable(regArgs[0], regArgs[1], regArgs[2]);
}

void setVariableValue_si(Register result, Register operands)
{
    checkArgsEQ("set!", "y*p", operands);
    setVariableValue(regArgs[0], regArgs[1], regArgs[2]);
}

void getGlobalEnvironment_si(Register result, Register operands)
{
    checkArgsEQ("get-global-environment", "", operands);
    getGlobalEnvironment(result);
}

/**************************************************/
/* syntax procedures */

void isSelfEvaluating_si(Register result, Register operands)
{
    checkArgsEQ("self-evaluating?", "*", operands);
    isSelfEvaluating(result, regArgs[0]);
}

void isVariable_si(Register result, Register operands)
{
    checkArgsEQ("variable?", "*", operands);
    isVariable(result, regArgs[0]);
}

void isQuoted_si(Register result, Register operands)
{
    checkArgsEQ("quoted?", "*", operands);
    isQuoted(result, regArgs[0]);
}

void textOfQuotation_si(Register result, Register operands)
{
    checkArgsEQ("text-of-quotation", "p", operands);
    textOfQuotation(result, regArgs[0]);
}

void isAssignment_si(Register result, Register operands)
{
    checkArgsEQ("assignment?", "*", operands);
    isAssignment(result, regArgs[0]);
}

void assignmentVariable_si(Register result, Register operands)
{
    checkArgsEQ("assignment-variable", "p", operands);
    assignmentVariable(result, regArgs[0]);
}

void assignmentValue_si(Register result, Register operands)
{
    checkArgsEQ("assignment-value", "p", operands);
    assignmentValue(result, regArgs[0]);
}

void isDefinition_si(Register result, Register operands)
{
    checkArgsEQ("definition?", "*", operands);
    isDefinition(result, regArgs[0]);
}

void definitionVariable_si(Register result, Register operands)
{
    checkArgsEQ("definition-variable", "p", operands);
    definitionVariable(result, regArgs[0]);
}

void definitionValue_si(Register result, Register operands)
{
    checkArgsEQ("definition-value", "p", operands);
    definitionValue(result, regArgs[0]);
}

void isLambda_si(Register result, Register operands)
{
    checkArgsEQ("definition-value", "*", operands);
    isLambda(result, regArgs[0]);
}

void lambdaParameters_si(Register result, Register operands)
{
    checkArgsEQ("lambda-parameters", "p", operands);
    lambdaParameters(result, regArgs[0]);
}

void lambdaBody_si(Register result, Register operands)
{
    checkArgsEQ("lambda-body", "p", operands);
    lambdaBody(result, regArgs[0]);
}

void isIf_si(Register result, Register operands)
{
    checkArgsEQ("if?", "*", operands);
    isIf(result, regArgs[0]);
}

void ifPredicate_si(Register result, Register operands)
{
    checkArgsEQ("if-predicate", "*", operands);
    ifPredicate(result, regArgs[0]);
}

void ifConsequent_si(Register result, Register operands)
{
    checkArgsEQ("if-consequent", "*", operands);
    ifConsequent(result, regArgs[0]);
}

void ifAlternative_si(Register result, Register operands)
{
    checkArgsEQ("if-alternative", "*", operands);
    ifAlternative(result, regArgs[0]);
}

void makeIf_si(Register result, Register operands)
{
    checkArgsEQ("make-if", "***", operands);
    makeIf(result, regArgs[0], regArgs[1], regArgs[2]);
}

void isBegin_si(Register result, Register operands)
{
    checkArgsEQ("begin?", "*", operands);
    isBegin(result, regArgs[0]);
}

void beginActions_si(Register result, Register operands)
{
    checkArgsEQ("begin-actions", "p", operands);
    beginActions(result, regArgs[0]);
}

void isLastExp_si(Register result, Register operands)
{
    checkArgsEQ("last-exp?", "*", operands);
    isLastExp(result, regArgs[0]);
}

void firstExp_si(Register result, Register operands)
{
    checkArgsEQ("first-exp", "p", operands);
    firstExp(result, regArgs[0]);
}

void restExps_si(Register result, Register operands)
{
    checkArgsEQ("rest-exps", "p", operands);
    restExps(result, regArgs[0]);
}

void makeBegin_si(Register result, Register operands)
{
    checkArgsEQ("make-begin", "p", operands);
    makeBegin(result, regArgs[0]);
}

void sequenceToExp_si(Register result, Register operands)
{
    checkArgsEQ("sequence->exp", "p", operands);
    sequenceToExp(result, regArgs[0]);
}

void isApplication_si(Register result, Register operands)
{
    checkArgsEQ("application?", "*", operands);
    isApplication(result, regArgs[0]);
}

void operator_si(Register result, Register operands)
{
    checkArgsEQ("operator", "p", operands);
    operator(result, regArgs[0]);
}

void operands_si(Register result, Register perands)
{
    checkArgsEQ("operands", "p", perands);
    operands(result, regArgs[0]);
}

void isNoOperands_si(Register result, Register operands)
{
    checkArgsEQ("no-operands?", "*", operands);
    isNoOperands(result, regArgs[0]);
}

void firstOperand_si(Register result, Register operands)
{
    checkArgsEQ("first-operand", "p", operands);
    firstOperand(result, regArgs[0]);
}

void restOperands_si(Register result, Register operands)
{
    checkArgsEQ("rest-operands", "p", operands);
    restOperands(result, regArgs[0]);
}

void isLastOperand_si(Register result, Register operands)
{
    checkArgsEQ("last-operand?", "p", operands);
    isLastOperand(result, regArgs[0]);
}

void emptyArglist_si(Register result, Register operands)
{
    checkArgsEQ("empty-arglist", "", operands);
    makeNull(result);
}

void isNoMoreExps_si(Register result, Register operands)
{
    checkArgsEQ("no-more-exps?", "*", operands);
    makeBoolean(result, isNull(regArgs[0]));
}

void makeProcedure_si(Register result, Register operands)
{
    /* operands: parameters body env */
    checkArgsEQ("make-procedure", "*pp", operands);
    makeProcedure(result, regArgs[0], regArgs[1], regArgs[2]);
}

void isCompoundProcedure_si(Register result, Register operands)
{
    checkArgsEQ("compound-procedure?", "*", operands);
    isCompoundProcedure(result, regArgs[0]);
}

void procedureParameters_si(Register result, Register operands)
{
    checkArgsEQ("procedure-parameters", "*", operands);
    procedureParameters(result, regArgs[0]);
}

void procedureBody_si(Register result, Register operands)
{
    checkArgsEQ("procedure-body", "*", operands);
    procedureBody(result, regArgs[0]);
}

void procedureEnvironment_si(Register result, Register operands)
{
    checkArgsEQ("procedure-environment", "*", operands);
    procedureEnvironment(result, regArgs[0]);
}


/**************************************************/
/* run-time support */

void promptForInput_si(Register result, Register operands)
{
    checkArgsEQ("prompt-for-input", "s", operands);
    promptForInput(result, regArgs[0]);
}

void announceOutput_si(Register result, Register operands)
{
    checkArgsEQ("announce-output", "s", operands);
    announceOutput(result, regArgs[0]);
}

void userPrint_si(Register result, Register operands)
{
    checkArgsEQ("user-print", "*", operands);
    userPrint(result, regArgs[0]);
}
