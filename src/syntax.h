#ifndef _SYNTAX_H
#define _SYNTAX_H

void initSyntax(void);

unsigned int isTaggedList(Register exp, char* tag);

/* Self-evaluating expressions */
bool regIsSelfEvaluating(Register exp);
void isSelfEvaluating_if(Register result, Register operands);

/* Variables */
bool regIsVariable(Register reg);
void isVariable_if(Register result, Register operands);

/* Quotations */
void isQuote_if(Register result, Register operands);
void textOfQuotation_if(Register result, Register operands);
void isQuasiquote_if(Register result, Register operands);
void isUnquote_if(Register result, Register operands);
void isUnquoteSplicing_if(Register result, Register operands);

/* Assignments */
void isAssignment_if(Register result, Register operands);
void assignmentVariable_if(Register result, Register operands);
void assignmentValue_if(Register result, Register operands);

/* Definitions */
void isDefinition_if(Register result, Register operands);
void definitionVariable_if(Register result, Register operands);
void definitionValue_if(Register result, Register operands);

/* Lambda expressions */
void isLambda_if(Register result, Register operands);
void lambdaParameters_if(Register result, Register operands);
void lambdaBody_if(Register result, Register operands);

/* Conditionals */
void isIf_if(Register result, Register operands);
void ifPredicate_if(Register result, Register operands);
void ifConsequent_if(Register result, Register operands);
void ifAlternative_if(Register result, Register operands);
void makeIf_if(Register result, Register operands);

/* Begin */
void isBegin_if(Register result, Register operands);
void beginActions_if(Register result, Register operands);
void isLastExp_if(Register result, Register operands);
void firstExp_if(Register result, Register operands);
void restExps_if(Register result, Register operands);
void makeBegin_if(Register result, Register operands);
void sequence2exp_if(Register result, Register operands);

/* Procedure application */
void isApplication_if(Register result, Register operands);
void operator_if(Register result, Register operands);
void operands_if(Register result, Register perands);
void isNoOperands_if(Register result, Register operands);
void firstOperand_if(Register result, Register operands);
void restOperands_if(Register result, Register operands);
void isLastOperand_if(Register result, Register operands);
void emptyArglist_if(Register result, Register operands);
void isNoMoreExps_if(Register result, Register operands);

/* Compound procedures */
void makeProcedure_if(Register result, Register operands);
bool regIsCompoundProcedure(Register obj);
void isCompoundProcedure_if(Register result, Register operands);
void procedureParameters(Register result, Register procedure);
void procedureParameters_if(Register result, Register operands);
void procedureBody(Register result, Register procedure);
void procedureBody_if(Register result, Register operands);
void procedureEnvironment_if(Register result, Register operands);

/* Compiled procedures */
void makeCompiledProcedure_if(Register result, Register operands);
bool regIsCompiledProcedure(Register obj);
void isCompiledProcedure_if(Register result, Register operands);
void compiledProcedureEntry_if(Register result, Register operands);
void compiledProcedureEnv_if(Register result, Register operands);

void isProcedure_if(Register result, Register operands);

/* let */
void isLet_if(Register result, Register operands);
void let2combination_if(Register result, Register operands);

/* let* */
void isLetx_if(Register result, Register operands);
void letx2nestedLets_if(Register result, Register operands);

/* letrec */
void isLetrec_if(Register result, Register operands);
void letrec2let_if(Register result, Register operands);

/* cond */
void isCond_if(Register result, Register operands);
void cond2if_if(Register result, Register operands);

/* and, or */
void isAnd_if(Register result, Register operands);
void andExpressions_if(Register result, Register operands);
void isOr_if(Register result, Register operands);
void orExpressions_if(Register result, Register operands);
void isNoExpressions_if(Register result, Register operands);
void firstExpression_if(Register result, Register operands);
void restExpressions_if(Register result, Register operands);
void isLastExpression_if(Register result, Register operands);

void isDelay_if(Register result, Register operands);
void delayExpression_if(Register result, Register operands);

#endif /* _SYNTAX_H */
