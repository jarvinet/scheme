#include "memory.h"
#include "regsim.h"
#include "coreprim.h"
#include "primitives.h"


extern int yydebug;


static void initRepl(void)
{
    Register exp;
    Register env;
    Register val;
    Register cont;
    Register proc;
    Register argl;
    Register unev;

    exp = allocateRegister("exp");
    env = allocateRegister("env");
    val = allocateRegister("val");
    cont = allocateRegister("continue");
    proc = allocateRegister("proc");
    argl = allocateRegister("argl");
    unev = allocateRegister("unev");


    addOperation("read", read_si);

    /* operations in syntax.scm */

    addOperation("self-evaluating?",      isSelfEvaluating_si);
    addOperation("quoted?",               isQuoted_si);
    addOperation("text-of-quotation",     textOfQuotation_si);
    addOperation("variable?",             isVariable_si);
    addOperation("assignment?",           isAssignment_si);
    addOperation("assignment-variable",   assignmentVariable_si);
    addOperation("assignment-value",      assignmentValue_si);
    addOperation("definition?",           isDefinition_si);
    addOperation("definition-variable",   definitionVariable_si);
    addOperation("definition-value",      definitionValue_si);
    addOperation("lambda?",               isLambda_si);
    addOperation("lambda-parameters",     lambdaParameters_si);
    addOperation("lambda-body",           lambdaBody_si);
    addOperation("if?",                   isIf_si);
    addOperation("if-predicate",          ifPredicate_si);
    addOperation("if-consequent",         ifConsequent_si);
    addOperation("if-alternative",        ifAlternative_si);
    addOperation("begin?",                isBegin_si);
    addOperation("begin-actions",         beginActions_si);
    addOperation("last-exp?",             isLastExp_si);
    addOperation("first-exp",             firstExp_si);
    addOperation("rest-exps",             restExps_si);
    addOperation("application?",          isApplication_si);
    addOperation("operator",              operator_si);
    addOperation("operands",              operands_si);
    addOperation("no-operands?",          isNoOperands_si);
    addOperation("first-operand",         firstOperand_si);
    addOperation("rest-operands",         restOperands_si);

    /* operations in eceval-support.scm */

    addOperation("true?",                 isTrue_si);
    addOperation("make-procedure",        makeProcedure_si);
    addOperation("compound-procedure?",   isCompoundProcedure_si);
    addOperation("procedure-parameters",  procedureParameters_si);
    addOperation("procedure-body",        procedureBody_si);
    addOperation("procedure-environment", procedureEnvironment_si);
    addOperation("extend-environment",    extendEnvironment_si);
    addOperation("lookup-variable-value", lookupVariableValue_si);
    addOperation("set-variable-value!",   setVariableValue_si);
    addOperation("define-variable!",      defineVariable_si);
    addOperation("primitive-procedure?",  isPrimitive_si);
    addOperation("apply-primitive-procedure", applyPrimitive_si);
    addOperation("prompt-for-input",      promptForInput_si);
    addOperation("announce-output",       announceOutput_si);
    addOperation("user-print",            userPrint_si);
    addOperation("empty-arglist",         emptyArglist_si);
    addOperation("adjoin-arg",            snoc_si);
    addOperation("last-operand?",         isLastOperand_si);
    addOperation("no-more-exps?",         isNoMoreExps_si);
    addOperation("get-global-environment", getGlobalEnvironment_si);

    addOperation("initialize-stack",      initStack_si);
}


int main(void)
{
    Register regText;

    initMemory(10000);
    initParser();
    initEnvironment();
    initSyntax();
    initRegSim();

    regText = allocateRegister("regText");

    initRepl();

    yydebug = 0;

    setupEnvironment();

#if 0
    read(regText);
#else
    readFile(regText, "repl.reg");
#endif

    printf("******************\n");
    execute(regText);

#if 0
    printRegisters();
#endif
}
