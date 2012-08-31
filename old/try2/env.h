#ifndef _ENV_H
#define _ENV_H


/* returns the value that is bound to the symbol <var>
 * in the environment <env>, or signals an error if the variable
 * is unbound
 * (lookup-variable-value)
 */
Object lookupVariableValue(Object var, Object env);

/* returns a new environment, consisting of a new frame
 * in which the symbols in the list <variables> are bound to the
 * corresponding elements in the list <values>, where the 
 * enclosing environment is the environment <baseEnv>
 * (extend-environment)
 */
void extendEnvironment(void);

/* Adds to the first frame in the environment a new
 * binding that associates the variable <var> with the 
 * value 'value'
 * (define-variable!)
*/
void defineVariable(void);

/* changes the binding of the variable <var> in the
 * environment <env> so that the variable is now bound to the value
 * <value>, or signals an error if the variable is unbound.
 * (set-variable-value!)
 */
void setVariableValue(Object variable, Object value, Object env);

Object theEmptyEnvironment(void);

#endif /* _ENV_H */
