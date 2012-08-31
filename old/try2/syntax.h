#ifndef _SYNTAX_H
#define _SYNTAX_H


/* Self-evaluating expressions */
unsigned int isSelfEvaluating(Object exp);

/* Variables */
unsigned int isVariable(Object exp);

/* Quotations */
unsigned int isQuoted(Object exp);
Object textOfQuotation(Object exp);

/* Assignments */
unsigned int isAssignment(Object exp);
Object assignmentVariable(Object exp);
Object assignmentValue(Object exp);

/* Definitions */
unsigned int isDefinition(Object exp);
Object definitionVariable(Object exp);
Object makeLambda(Object parameters, Object body);
Object definitionValue(Object exp);

/* Lambda expressions */
unsigned int isLambda(Object exp);
Object lambdaParameters(Object exp);
Object lambdaBody(Object exp);

/* Conditionals */
unsigned int isIf(Object exp);
Object ifPredicate(Object exp);
Object ifConsequent(Object exp);
Object ifAlternative(Object exp);
Object makeIf(Object predicate, Object consequent, Object alternative);

/* Begin */
unsigned int isBegin(Object exp);
Object beginActions(Object exp);
unsigned int isLastExp(Object seq);
Object firstExp(Object seq);
Object restExps(Object seq);
Object makeBegin(Object seq);
Object sequenceToExp(Object seq);

/* Procedure application */
unsigned int isApplication(Object exp);
Object operator(Object exp);
Object operands(Object exp);
unsigned int isNoOperands(Object ops);
Object firstOperand(Object ops);
Object restOperands(Object ops);

/* Compound procedures */
Object makeProcedure(Object parameters, Object body, Object env);
unsigned int isCompoundProcedure(Object p);
Object procedureParameters(Object p);
Object procedureBody(Object p);
Object procedureEnvironment(Object p);


#endif /* _SYNTAX_H */
