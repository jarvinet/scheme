#include "hash.h"
#include "object.h"
#include "memory.h"
#include "env.h"


/* Bindings
 * Binding is a name-value pair:
 *
 *        +-+-+
 *        | | |
 *        +-+-+
 *         | | 
 *         V V 
 *      name value
*/

/* Reads:
 * Writes:
 */

/* Reads:
 *  "unev" variable
 *  "argl" value
 * Writes:
 *  "val"  the new binding
 */ 
static void makeBinding(void)
{
    setReg(regVal, cons(getReg(regUnev), getReg(regArgl)));
}

static Object bindingName(Object binding)
{
    return car(binding);
}

static Object bindingValue(Object binding)
{
    return cdr(binding);
}

static void bindingSetValue(Object binding, Object newValue)
{
    setCdr(binding, newValue);
}


/*
;-----------------------------------
; Frame is a list of bindings, with a "head node" whose
; car is *frame*:
;
;    +-+-+       +-+-+       +-+-+
;    | | +------>| | |------>| |/|
;    +-+-+       +-+-+       +-+-+
;     |           |           |
;     V           V           V
;  *frame*      +-+-+       +-+-+
;               | | |       | | |
;               +-+-+       +-+-+
;                | |         | |
;                V V         V V
;             name value  name value
*/

/* Reads:
 * Writes:
 *  "val" the new frame
 */
static void makeFrame(void)
{
    setReg(regVal, cons(makeSymbol("*frame*"), makeNull()));
}

/* Reads:
 *  "env" frame
 *  "val" binding
 * Writes:
 *  -
 */
static void frameAddBinding(void)
{
    Object o = cons(getReg(regVal), cdr(getReg(regEnv)));
    setCdr(getReg(regEnv), o);
}


static Object frameLookupBinding(Object frame, Object name)
{
    Object bindings;
    Object binding;

    for (bindings = cdr(frame); !isNull(bindings);
	 bindings = cdr(bindings)) {
	binding = car(bindings);
	if (isEq(bindingName(binding), name))
	    return binding;
    }
    return makeNull();
}



/* Environment is a list of frames */


static Object
firstFrame(Object env)
{
    return car(env);
}

static Object
enclosingEnvironment(Object env)
{
    return cdr(env);
}

static Object
envLookupBinding(Object env, Object name)
{
    Object frame;
    Object binding;
    
    if (isEq(env, theEmptyEnvironment()))
	return makeNull();

    frame = firstFrame(env);
    binding = frameLookupBinding(frame, name);
    if (isNull(binding))
	return envLookupBinding(enclosingEnvironment(env), name);
    else
	return binding;
}

Object
lookupVariableValue(Object var, Object env)
{
    Object binding;
    Object value;

    binding = envLookupBinding(env, var);
    if (isNull(binding))
	eprintf("Unbound variable");
    else {
	value = bindingValue(binding);
	if (isEq(value, makeSymbol("*unassigned*")))
	    eprintf("Unassigned variable");
	else
	    return value;
    }
}

/* Read: 
 *  "unev" variables
 *  "argl" values
 *  "env"  frame to add the bindings to
 * Write:
 *  -
 */
static void extEnvLoop(void)
{
    while (!isNull(getReg(regUnev))) {	
	save(regUnev);
	save(regArgl);
	save(regVal);

	setReg(regUnev, car(getReg(regUnev)));
	setReg(regArgl, car(getReg(regArgl)));
	makeBinding();

	frameAddBinding();

	restore(regVal);
	restore(regArgl);
	restore(regUnev);

	setReg(regUnev, cdr(getReg(regUnev)));
	setReg(regArgl, cdr(getReg(regArgl)));
    }
}



/* Reads:
 *  "unev" variables
 *  "argl" values
 *  "env"  baseEnv
 * Writes:
 *  "env"  the extended environment
 */
void extendEnvironment(void)
{
    Object variables = getReg(regUnev);
    Object values = getReg(regArgl);
    Object frame;
    
    if (length(variables) == length(values)) {
	save(regEnv);
	save(regVal);
	makeFrame();
	setReg(regEnv, getReg(regVal));
	restore(regVal);
	extEnvLoop();
	frame = getReg(regEnv);
	restore(regEnv);
	setReg(regEnv, cons(frame, getReg(regEnv)));
    } else if (length(variables) < length(values))
	eprintf("Too many arguments supplied");
    else
	eprintf("Too few arguments supplied");
}

/* Reads:
 *  "unev" variable
 *  "val"  value
 *  "env"  env
 * Writes:
 *  -
 */
void defineVariable(void)
{
    Object frame;
    Object binding;

    frame = firstFrame(getReg(regEnv));
    binding = frameLookupBinding(frame, getReg(regUnev));
    if (isNull(binding)) {
	save(regArgl);
	setReg(regArgl, getReg(regVal));
	makeBinding(); /* result in val */

	save(regEnv);
	setReg(regEnv, frame);
	frameAddBinding();
	restore(regEnv);
	restore(regArgl);
    } else
	bindingSetValue(binding, getReg(regVal));
}

void
setVariableValue(Object variable, Object value, Object env)
{
    Object binding;

    binding = envLookupBinding(env, variable);
    if (isNull(binding))
	eprintf("Unbound variable");
    else
	bindingSetValue(binding, value);
}


Object
theEmptyEnvironment(void)
{
    return makeNull();
}
