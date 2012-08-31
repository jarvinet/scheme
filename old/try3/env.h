#ifndef _ENV_H
#define _ENV_H


/* Returns the value that is bound to the symbol <var>
 * in the environment <env>, or signals an error if the variable
 * is unbound:
 * The environment is read from register <env>
 * The variable is read from register <variable>
 * The value is written to the register <value>
 */
void lookupVariableValue(Register value, Register variable, Register env);

/* returns a new environment, consisting of a new frame
 * in which the symbols in the list <variables> are bound to the
 * corresponding elements in the list <values>, where the 
 * enclosing environment is the environment <baseEnv>
 * (extend-environment)
 */
void extendEnvironment(Register variables, Register values, Register env);

/* Adds to the first frame in the environment a new
 * binding that associates the variable <var> with the 
 * value 'value'
 * (define-variable!)
*/
void defineVariable(Register variable, Register value, Register env);

/* changes the binding of the variable <var> in the
 * environment <env> so that the variable is now bound to the value
 * <value>, or signals an error if the variable is unbound.
 * (set-variable-value!)
 */
void setVariableValue(Register variable, Register value, Register env);

void initEnvironment(void);

void getGlobalEnvironment(Register result);
void setupEnvironment(void);

#endif /* _ENV_H */
