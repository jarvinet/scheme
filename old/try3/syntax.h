#ifndef _SYNTAX_H
#define _SYNTAX_H

void initSyntax(void);

/* Self-evaluating expressions */
void isSelfEvaluating(Register result, Register exp);

/* Variables */
void isVariable(Register result, Register exp);

/* Quotations */
void isQuoted(Register result, Register exp);
void textOfQuotation(Register result, Register exp);

/* Assignments */
void isAssignment(Register result, Register exp);
void assignmentVariable(Register result, Register exp);
void assignmentValue(Register result, Register exp);

/* Definitions */
void isDefinition(Register result, Register exp);
void definitionVariable(Register result, Register exp);
void definitionValue(Register result, Register exp);

/* Lambda expressions */
void isLambda(Register result, Register exp);
void lambdaParameters(Register result, Register exp);
void lambdaBody(Register result, Register exp);

/* Conditionals */
void isIf(Register result, Register exp);
void ifPredicate(Register result, Register exp);
void ifConsequent(Register result, Register exp);
void ifAlternative(Register result, Register exp);
void makeIf(Register result, Register predicate,
	    Register consequent, Register alternative);

/* Begin */
void isBegin(Register result, Register exp);
void beginActions(Register result, Register exp);
void isLastExp(Register result, Register exp);
void firstExp(Register result, Register exp);
void restExps(Register result, Register exp);
void makeBegin(Register result, Register seq);
void sequenceToExp(Register result, Register seq);

/* Procedure application */
void isApplication(Register result, Register exp);
void operator(Register result, Register exp);
void operands(Register result, Register exp);
void isNoOperands(Register result, Register ops);
void firstOperand(Register result, Register ops);
void restOperands(Register result, Register ops);
void isLastOperand(Register result, Register ops);

/* Compound procedures */
void makeProcedure(Register result, Register parameters,
		   Register body, Register env);
void isCompoundProcedure(Register result, Register procedure);
void procedureParameters(Register result, Register procedure);
void procedureBody(Register result, Register procedure);
void procedureEnvironment(Register result, Register procedure);

#endif /* _SYNTAX_H */
