#include "memory.h"
#include "env.h"
#include "coreprim.h"

#if 0
static Register regBinding;
static Register regFrame;
static Register regGlobalEnv;
static Register regVariables;
static Register regValues;
#endif

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

/* Make a new binding
 * The created binding is returned in <binding>
 * The variable of the binding is taken from <variable>
 * The value of the binding is taken from <value>
 */ 
static void makeBinding(Register binding,
			Register variable, Register value)
{
    cons(binding, variable, value);
}

static void bindingSetValue(Register binding, Register value)
{
    setCdr(binding, value);
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


static void makeFrame(Register frame)
{
    Register tag = reg0;
    Register null = reg1;
    save(reg0);
    save(reg1);
    makeSymbol(tag, "*frame*");
    makeNull(null);
    cons(frame, tag, null);
    restore(reg1);
    restore(reg0);
}

/* Add a new binding to a frame.
 * The frame where the binding is to be added is in <frame>.
 * The binding to be added is in <binding>.
 */
static void frameAddBinding(Register frame, Register binding)
{
    Register oldFirst = reg0;
    Register newFirst = reg1;
    save(reg0);
    save(reg1);
    cdr(oldFirst, frame);
    cons(newFirst, binding, oldFirst);
    setCdr(frame, newFirst);
    restore(reg1);
    restore(reg0);
}


/* Look for a binding in frame.
 * The name to look for is in <variable>
 * The frame to search is in <frame>
 * The binding found is returned in <binding>
 */
static void frameLookupBinding(Register binding,
			       Register frame, Register variable)
{
    Register looper = reg0;
    Register name = reg1;

    save(reg0);
    save(reg1);

    makeNull(binding);

    cdr(looper, frame);
    while (!isNull(looper)) {
	car(binding, looper); /* the binding */
	car(name, binding);   /* binding name */
	if (isEq(name, variable)) {
	    break;
	}
	cdr(looper, looper);
    }

    restore(reg1);
    restore(reg0);
}



/* Environment is a list of frames */

/* Look for a binding in environment.
 * The name to look for is in <variable>
 * The environment to search is in <env>
 * The binding found is returned in <binding>
 */
static void envLookupBinding(Register binding,
			     Register env, Register variable)
{
    Register looper = reg1;

    if (isNull(env)) {
	makeNull(binding);
	return;
    }

    copyReg(looper, env);
    while (!isNull(looper)) {
	car(regFrame, looper);
	frameLookupBinding(binding, regFrame, variable);
	if (!isNull(binding))
	    return;
	cdr(looper, looper);
    }
}

void lookupVariableValue(Register value,
			 Register variable, Register env)
{
    Register bindingValue = reg1;
    Register unassigned = reg2;

    envLookupBinding(regBinding, env, variable);
    if (isNull(regBinding))
	eprintf("Unbound variable");
    else {
	cdr(bindingValue, regBinding);
	makeSymbol(unassigned, "*unassigned*");
	if(isEq(bindingValue, unassigned))
	    eprintf("Unassigned variable");
	else
	    copyReg(value, bindingValue);
    }
}

void extendEnvironment(Register variables, Register values,
		       Register env)
{
    Register varLooper = reg1;
    Register valLooper = reg2;
    Register variable = reg3;
    Register value = reg4;

    if (length(variables) == length(values)) {
	/* make a new frame and prefix it to the env */
	makeFrame(regFrame);
	cons(env, regFrame, env);

	/* define the variables in the extended env */
	copyReg(varLooper, variables);
	copyReg(valLooper, values);
	while (!isNull(varLooper)) {
	    car(variable, varLooper);
	    car(value, valLooper);

	    defineVariable(variable, value, env);

	    cdr(varLooper, varLooper);
	    cdr(valLooper, valLooper);
	}
	
    } else if (length(variables) < length(values))
	eprintf("Too many arguments supplied");
    else
	eprintf("Too few arguments supplied");
}


void defineVariable(Register variable, Register value,
		    Register env)
{

    car(regFrame, env);
    frameLookupBinding(regBinding, regFrame, variable);
    if (isNull(regBinding)) {
	makeBinding(regBinding, variable, value);
	frameAddBinding(regFrame, regBinding);
    } else {
	bindingSetValue(regBinding, value);
    }
}

void setVariableValue(Register variable, Register value,
		      Register env)
{
    envLookupBinding(regBinding, env, variable);
    if (isNull(regBinding))
	eprintf("Unbound variable");
    else
	bindingSetValue(regBinding, value);
}


void initEnvironment(void)
{
#if 0
    regBinding = allocateRegister("envBinding");
    regFrame = allocateRegister("envFrame");
    regGlobalEnv = allocateRegister("envGlobalEnv");
    regVariables = allocateRegister("envVariables");
    regValues = allocateRegister("envValues");
#endif
}

void getGlobalEnvironment(Register result)
{
    copyReg(result, regGlobalEnv);
}

static void defVar(char* name, Primitive prim)
{
    makeSymbol(regVariables, name);
    makePrimitive(regValues, prim);
    defineVariable(regVariables, regValues, regGlobalEnv);
}

void setupEnvironment(void)
{
    makeFrame(regFrame);
    makeNull(regGlobalEnv);
    cons(regGlobalEnv, regFrame, regGlobalEnv);

    defVar("cons", cons_si);
    defVar("car", car_si);
    defVar("cdr", cdr_si);
    defVar("set-car!", setCar_si);
    defVar("set-cdr!", setCdr_si);

    defVar("=", equal_si);
    defVar("<", lessThan_si);
    defVar(">", greaterThan_si);
    defVar("+", plus_si);
    defVar("-", minus_si);
}
