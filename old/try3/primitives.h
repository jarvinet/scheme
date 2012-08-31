#ifndef _PRIMITIVES_H
#define _PRIMITIVES_H


/* Interface functions to the Scheme interpreter
 * primitives from env.c, syntax.c, and support.c'
 */


/**************************************************/
/* environment */

void lookupVariableValue_si(Register result, Register operands);
void extendEnvironment_si(Register result, Register operands);
void defineVariable_si(Register result, Register operands);
void setVariableValue_si(Register result, Register operands);
void getGlobalEnvironment_si(Register result, Register operands);

/**************************************************/
/* syntax procedures */

void isSelfEvaluating_si(Register result, Register operands);
void isVariable_si(Register result, Register operands);
void isQuoted_si(Register result, Register operands);
void textOfQuotation_si(Register result, Register operands);
void isAssignment_si(Register result, Register operands);
void assignmentVariable_si(Register result, Register operands);
void assignmentValue_si(Register result, Register operands);
void isDefinition_si(Register result, Register operands);
void definitionVariable_si(Register result, Register operands);
void definitionValue_si(Register result, Register operands);
void isLambda_si(Register result, Register operands);
void lambdaParameters_si(Register result, Register operands);
void lambdaBody_si(Register result, Register operands);
void isIf_si(Register result, Register operands);
void ifPredicate_si(Register result, Register operands);
void ifConsequent_si(Register result, Register operands);
void ifAlternative_si(Register result, Register operands);
void makeIf_si(Register result, Register operands);
void isBegin_si(Register result, Register operands);
void beginActions_si(Register result, Register operands);
void isLastExp_si(Register result, Register operands);
void firstExp_si(Register result, Register operands);
void restExps_si(Register result, Register operands);
void makeBegin_si(Register result, Register operands);
void sequenceToExp_si(Register result, Register operands);
void isApplication_si(Register result, Register operands);
void operator_si(Register result, Register operands);
void operands_si(Register result, Register perands);
void isNoOperands_si(Register result, Register operands);
void firstOperand_si(Register result, Register operands);
void restOperands_si(Register result, Register operands);
void isLastOperand_si(Register result, Register operands);
void emptyArglist_si(Register result, Register operands);
void isNoMoreExps_si(Register result, Register operands);
void makeProcedure_si(Register result, Register operands);
void isCompoundProcedure_si(Register result, Register operands);
void procedureParameters_si(Register result, Register operands);
void procedureBody_si(Register result, Register operands);
void procedureEnvironment_si(Register result, Register operands);


/**************************************************/
/* run-time support */

void promptForInput_si(Register result, Register operands);
void announceOutput_si(Register result, Register operands);
void userPrint_si(Register result, Register operands);

#endif /* _PRIMITIVES_H */
