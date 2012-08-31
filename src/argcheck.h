#ifndef _ARGCHECK_H
#define _ARGCHECK_H

/* checkArgsEQ checks the arguments according to the <types>
 * parameter. <types> is a string containing the following
 * type declaration characters:
 *
 *   p pair
 *   l list (null or pair)
 *   y symbol
 *   s string
 *   n number
 *   b boolean
 *   r primitive
 *   i input port
 *   o output port
 *   * any
 * 
 * <operands> is a list containing objects, whose types
 * are to be checked. checkArgsEQ requires that <operands>
 * contains exactly as many objects as <types> has type
 * declaration characters.
 * In addition to checking the types of <operands>,
 * checkArgsEQ stores the individual operands to 
 * regArgs[0] ... regArgs[4]
 * Returns the actual number of arguments.
 */
unsigned int checkArgsEQ(char* name, char* types, Register operands);


/* checkArgsLE is as checkArgsEQ, except that 
 * there may be fewer operands than there is type declaration
 * characters. The minimun number of arguments is 
 * specified using the <minArgs> parameter, the maximum number
 * is specified by the number of type checker charaters in
 * <types>
 */
unsigned int
checkArgs(char* name, unsigned int minArgs, char* types, Register operands);

/* Check for any nymber of arguments that all are of type specified in
 * the first type declaration character. Only the first type declaration
 * character is ever looked at. regArgs are _NOT_ filled.
 */
unsigned int
checkArgsN(char* name, char* type, Register operands);


#endif /* _ARGCHECK_H */
