#include <stdio.h>

#include "common.h"
#include "argcheck.h"
#include "eprint.h"

#include "symbol.h"
#include "null.h"
#include "primitive.h"
#include "pairpointer.h"
#include "boolean.h"
#include "sstring.h"
#include "number.h"
#include "character.h"
#include "eof.h"
#include "port.h"
#include "vector.h"
#include "continuation.h"
#include "math.h"
#include "env.h"
#include "util.h"

#include "syntax.h"

#include "insts.h"
#include "regsim.h"



static Register regGlobalEnv;


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

/* Make a new binding
 * The created binding is returned in <binding>
 * The variable of the binding is taken from <variable>
 * The value of the binding is taken from <value>
 */ 
static void
makeBinding(Register binding, Register variable, Register value)
{
    cons(binding, variable, value);
}

static void bindingGetVariable(Register binding, Register variable)
{
    regCar(variable, binding);
}

static void bindingGetValue(Register binding, Register value)
{
    regCdr(value, binding);
}

static void bindingSetValue(Register binding, Register value)
{
    regSetCdr(binding, value);
}


#if 0
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
    Register tag = regGetTemp();

    regMakeSymbol(tag, "*frame*");
    regMakeNull(frame);
    cons(frame, tag, frame);

    regFreeTemp(tag);
}

/* Add a new binding to a frame.
 * The frame where the binding is to be added is in <frame>.
 * The binding to be added is in <binding>.
 */
static void frameAddBinding(Register frame, Register binding)
{
    Register oldFirst = regGetTemp();
    Register newFirst = regGetTemp();

    regCdr(oldFirst, frame);
    cons(newFirst, binding, oldFirst);
    regSetCdr(frame, newFirst);

    regFreeTemp(oldFirst);
    regFreeTemp(newFirst);
}


/* Look for a binding in frame.
 * The name to look for is in <variable>
 * The frame to search is in <frame>
 * The binding found is returned in <binding>
 */
static void
frameLookupBinding(Register binding, Register frame, Register variable)
{
    Register regLooper = regGetTemp();
    Register regBindingName = regGetTemp();

    regCdr(regLooper, frame);
    while (!regIsNull(regLooper)) {
	regCar(binding, regLooper);
	regCar(regBindingName, binding);
	if (regIsEq(regBindingName, variable)) {
	    regFreeTemp(regLooper);
	    regFreeTemp(regBindingName);
	    return;
	}
	regCdr(regLooper, regLooper);
    }
    regMakeNull(binding);

    regFreeTemp(regLooper);
    regFreeTemp(regBindingName);
}

#else

static void makeFrame(Register frame)
{
    regWrite(frame, objMakeVector(NHASH, objMakeNull()));
}

static void frameAddBinding(Register frame, Register binding)
{
    Register regVariable = regGetTemp();
    Register regHash = regGetTemp();
    Register regOldHead = regGetTemp();
    Register regNewHead = regGetTemp();

    bindingGetVariable(binding, regVariable);
    regHashSymbol(regHash, regVariable);
    regVectorRef(regOldHead, frame, regHash);
    cons(regNewHead, binding, regOldHead);
    regVectorSet(frame, regHash, regNewHead);

    regFreeTemp(regVariable);
    regFreeTemp(regHash);
    regFreeTemp(regOldHead);
    regFreeTemp(regNewHead);
}

static void
frameLookupBinding(Register binding, Register frame, Register variable)
{
    Register regHash = regGetTemp();
    Register regLooper = regGetTemp();
    Register regBindingName = regGetTemp();

    regHashSymbol(regHash, variable);
    regVectorRef(regLooper, frame, regHash);
    while (!regIsNull(regLooper)) {
	regCar(binding, regLooper);
	bindingGetVariable(binding, regBindingName);
	if (regIsEq(regBindingName, variable)) {
	    regFreeTemp(regHash);
	    regFreeTemp(regLooper);
	    regFreeTemp(regBindingName);
	    return;
	}
	regCdr(regLooper, regLooper);
    }
    regMakeNull(binding);

    regFreeTemp(regHash);
    regFreeTemp(regLooper);
    regFreeTemp(regBindingName);
}

#endif



/* Environment is a list of frames */

/* Look for a binding in environment.
 * The name to look for is in <variable>
 * The environment to search is in <env>
 * The binding found is returned in <binding>
 */
static void
envLookupBinding(Register binding, Register env, Register variable)
{
    Register regLooper = regGetTemp();
    Register regFrame = regGetTemp();

    regCopy(regLooper, env);
    while (!regIsNull(regLooper)) {
	regCar(regFrame, regLooper);
	//save2(regLooper);
	frameLookupBinding(binding, regFrame, variable);
	//restore2(regLooper);
	if (!regIsNull(binding))
	    break;
	regCdr(regLooper, regLooper);
    }

    regFreeTemp(regFrame);
    regFreeTemp(regLooper);
}

static void
lookupVariableValue(Register value, Register variable, Register env)
{
    Register regBinding = regGetTemp();
    Register regBindingValue = regGetTemp();
    Register regSymbol = regGetTemp();

    envLookupBinding(regBinding, env, variable);
    if (regIsNull(regBinding)) {
	erprint("*** Unbound variable: ", variable);
    } else {
	regCdr(regBindingValue, regBinding);
	regMakeSymbol(regSymbol, "*unassigned*");
	if(regIsEq(regBindingValue, regSymbol)) {
	    erprint("*** Unassigned variable: ", variable);
	} else {
	    regCopy(value, regBindingValue);
	}
    }

    regFreeTemp(regBinding);
    regFreeTemp(regBindingValue);
    regFreeTemp(regSymbol);
}

void lookupVariableValue_if(Register result, Register operands)
{
    /* (lookup-variable-value symbol env) */
    checkArgsEQ("lookup-variable-value", "yp", operands);
    lookupVariableValue(result, regArgs[0], regArgs[1]);
}

static void
defineVariable(Register variable, Register value, Register env)
{
    Register regFrame = regGetTemp();
    Register regBinding = regGetTemp();

    regCar(regFrame, env); /* envFirstFrame */
    frameLookupBinding(regBinding, regFrame, variable);
    if (regIsNull(regBinding)) {
	makeBinding(regBinding, variable, value);
	frameAddBinding(regFrame, regBinding);
    } else {
	bindingSetValue(regBinding, value);
    }

    regFreeTemp(regFrame);
    regFreeTemp(regBinding);
}

void defineVariable_if(Register result, Register operands)
{
    /* (define-variable! symbol anything env) */
    checkArgsEQ("define-variable!", "y*p", operands);
    defineVariable(regArgs[0], regArgs[1], regArgs[2]);
    regCopy(result, regArgs[0]);
}

/* The "rest" parameters should evaluate as follows:
 *
 * (define (f a) (display a))
 *
 * (a)     (f)       => "too few arguments"
 * (a)     (f 1)     => (a . 1)
 * (a)     (f 1 2)   => "too many arguments"
 *
 * (define (f . a) (display a))
 *
 *  a      (f)       => (a . ())
 *  a      (f 1)     => (a . (1))
 *  a      (f 1 2)   => (a . (1 2))
 *
 * (define (f a b) (display a) (display b))
 *
 * (a b)   (f)       => "too few arguments"
 * (a b)   (f 1)     => "too few arguments"
 * (a b)   (f 1 2)   => (a . 1) (b . 2)
 * (a b)   (f 1 2 3) => "too many arguments"
 *
 * (define (f a . b) (display a) (display b))
 *
 * (a . b) (f)       => "too few arguments"
 * (a . b) (f 1)     => (a . 1) (b . ())
 * (a . b) (f 1 2)   => (a . 1) (b . (2))
 * (a . b) (f 1 2 3) => (a . 1) (b . (2 3))
 */
static void
extendEnvironment(Register variables, Register values, Register env)
{
    Register regFrame = regGetTemp();
    Register regVariables = regGetTemp();
    Register regVariable = regGetTemp();
    Register regValues = regGetTemp();
    Register regValue = regGetTemp();

    unsigned int checkExcessArgs = TRUE;

    /* make a new frame and prefix it to the env */
    makeFrame(regFrame);
    cons(env, regFrame, env);

    /* define the variables in the extended env */
    regCopy(regVariables, variables);
    regCopy(regValues, values);
    while (!regIsNull(regVariables)) {
	if (regIsSymbol(regVariables)) {
	    /* This is a "rest" parameter, assign the rest 
	     * arguments to it as a list */

	    defineVariable(regVariables, regValues, env);
	    checkExcessArgs = FALSE;
	    break;
	} else {
	    if (regIsNull(regValues)) {
		esprint("*** Too few arguments supplied\n");
	    }
	    regCar(regVariable, regVariables);
	    regCar(regValue,    regValues);
	    defineVariable(regVariable, regValue, env);
	    regCdr(regVariables, regVariables);
	    regCdr(regValues,    regValues);
	}
    }	
    if (checkExcessArgs && !regIsNull(regValues)) {
	printf("\nvariables: "); regDisplayToCurrentPort(variables);
	printf("\nvalues: "); regDisplayToCurrentPort(values);
	erprint("\n*** Too many arguments supplied: ", regValues);
    }

    /* TODO: if esprint or erprint is called, the dynamically-allocated
     * registers are not freed!!! Possible solution (?) free all
     * dynamically-allocated registers in the error handler.
     */

    regFreeTemp(regFrame);
    regFreeTemp(regVariables);
    regFreeTemp(regVariable);
    regFreeTemp(regValues);
    regFreeTemp(regValue);
}

void extendEnvironment_if(Register result, Register operands)
{
    /* operands: variables values env */
    checkArgsEQ("extend-environment", "*lp", operands);
    extendEnvironment(regArgs[0], regArgs[1], regArgs[2]);
    regCopy(result, regArgs[2]);
}

static void
setVariableValue(Register variable, Register value, Register env)
{
    Register regBinding = regGetTemp();

    envLookupBinding(regBinding, env, variable);
    if (regIsNull(regBinding))
	erprint("*** Unbound variable: ", variable);
    else
	bindingSetValue(regBinding, value);

    regFreeTemp(regBinding);
}

void setVariableValue_if(Register result, Register operands)
{
    checkArgsEQ("set!", "y*p", operands);
    setVariableValue(regArgs[0], regArgs[1], regArgs[2]);
}

void initEnvironment(void)
{
    regGlobalEnv = regAllocate("envGlobalEnv");
}

static void nullEnvironment(Register result)
{
    Register regFrame = regGetTemp();

    regMakeNull(result);
    makeFrame(regFrame);
    cons(result, regFrame, result);

    regFreeTemp(regFrame);
}

static void nullEnvironment_if(Register result, Register operands)
{
    checkArgsEQ("null-environment", "n", operands);
    if (regGetNumber(regArgs[0]) != 5)
	esprint("null-environment: arg should be exactly 5");
    nullEnvironment(result);
}

void interactionEnvironment(Register result)
{
    regCopy(result, regGlobalEnv);
}

void interactionEnvironment_if(Register result, Register operands)
{
    checkArgsEQ("interaction-environment", "", operands);
    interactionEnvironment(result);
}

void schemeReportEnvironment(Register result)
{
    regCopy(result, regGlobalEnv);
}

void schemeReportEnvironment_if(Register result, Register operands)
{
    checkArgsEQ("scheme-report-environment", "n", operands);
    if (regGetNumber(regArgs[0]) != 5)
	esprint("scheme-report-environment: arg should be exactly 5");
    interactionEnvironment(result);
}

static void definePrimitive(char* name, Primitive prim)
{
    Register regVariable = regGetTemp();
    Register regValue = regGetTemp();

    regMakeSymbol(regVariable, name);
    regMakePrimitive(regValue, name, prim);
    defineVariable(regVariable, regValue, regGlobalEnv);

    regFreeTemp(regVariable);
    regFreeTemp(regValue);
}

static void defineBoolean(char* name, bool boolean)
{
    Register regVariable = regGetTemp();
    Register regValue = regGetTemp();

    regMakeSymbol(regVariable, name);
    regMakeBoolean(regValue, boolean);
    defineVariable(regVariable, regValue, regGlobalEnv);

    regFreeTemp(regVariable);
    regFreeTemp(regValue);
}

/* These are the primitives we want to be available
 * in the scheme interpreter.
 */
void setupEnvironment(void)
{
    Register regVariable = regGetTemp();
    Register regValue = regGetTemp();

    /* Create an empty environment consisting of an empty frame */
    nullEnvironment(regGlobalEnv);

    /* basic memory handling */
    definePrimitive("cons",     cons_if);
    definePrimitive("car",      car_if);
    definePrimitive("cdr",      cdr_if);
    definePrimitive("set-car!", setCar_if);
    definePrimitive("set-cdr!", setCdr_if);

    /* Arithmetic operators */
    definePrimitive("integer-equal",        equal_if);
    definePrimitive("=",                    equal_if);
    definePrimitive("integer-less-than",    lessThan_if);
    definePrimitive("<",                    lessThan_if);
    definePrimitive("integer-greater-than", greaterThan_if);
    definePrimitive(">",                    greaterThan_if);
    definePrimitive("integer-add",          plus_if);
    definePrimitive("+",                    plus_if);
    definePrimitive("integer-minus",        minus_if);
    definePrimitive("-",                    minus_if);
    definePrimitive("integer-mul",          mul_if);
    definePrimitive("*",                    mul_if);
    definePrimitive("remainder",            remainder_if);
    definePrimitive("rem",                  remainder_if);

    /* Primitive predicates */
    definePrimitive("null?",          isNull_if);
    definePrimitive("pair?",          isPair_if);
    definePrimitive("symbol?",        isSymbol_if);
    definePrimitive("string?",        isString_if);
    definePrimitive("number?",        isNumber_if);
    definePrimitive("boolean?",       isBoolean_if);
    definePrimitive("primitive?",     isPrimitive_if);
    definePrimitive("true?",          isTrue_if);
    definePrimitive("eof-object?",    isEOF_if);
    definePrimitive("input-port?",    isInputPort_if);
    definePrimitive("output-port?",   isOutputPort_if);
    definePrimitive("char?",          isCharacter_if);
    definePrimitive("vector?",        isVector_if);
    definePrimitive("continuation?",  isContinuation_if);
    definePrimitive("procedure?",     isProcedure_if);

    /* Strings */
    definePrimitive("make-string",    makeString_if);
    definePrimitive("string->symbol", string2symbol_if);
    definePrimitive("number->string", number2string_if);
    definePrimitive("string->number", string2number_if);
    definePrimitive("string-append",  stringAppend_if);
    definePrimitive("string-length",  stringLength_if);
    definePrimitive("string-set!",    stringSet_if);
    definePrimitive("string-ref",     stringRef_if);
    definePrimitive("substring",      subString_if);
    definePrimitive("string-fill!",   stringFill_if);
    definePrimitive("string-copy",    stringCopy_if);

    /* Symbols */
    definePrimitive("symbol->string", symbol2string_if);
    definePrimitive("symbol-hash",    symbolHash_if);
    /* gensym is required by the macro implementation */
    definePrimitive("gensym",         generateSymbol_if);

    /* Characters */
    definePrimitive("char-alphabetic?", charIsAlphabetic_if);
    definePrimitive("char-numeric?",    charIsNumeric_if);
    definePrimitive("char-whitespace?", charIsWhitespace_if);
    definePrimitive("char-upper-case?", charIsUpperCase_if);
    definePrimitive("char-lower-case?", charIsLowerCase_if);

    definePrimitive("char=?",     charIsEqual_if);
    definePrimitive("char-ci=?",  charIsEqual_ci_if);
    definePrimitive("char<?",     charIsLessThan_if);
    definePrimitive("char-ci<?",  charIsLessThan_ci_if);
    definePrimitive("char<=?",    charIsLessThanOrEqual_if);
    definePrimitive("char-ci<=?", charIsLessThanOrEqual_ci_if);
    definePrimitive("char>?",     charIsGreaterThan_if);
    definePrimitive("char-ci>?",  charIsGreaterThan_ci_if);
    definePrimitive("char>=?",    charIsGreaterThanOrEqual_if);
    definePrimitive("char-ci>=?", charIsGreaterThanOrEqual_ci_if);

    definePrimitive("char-upcase",   charUpcase_if);
    definePrimitive("char-downcase", charDowncase_if);

    definePrimitive("char->integer", char2integer_if);
    definePrimitive("integer->char", integer2char_if);

    /* Vectors */
    definePrimitive("make-vector",    makeVector_if);
    definePrimitive("vector-ref",     vectorRef_if);
    definePrimitive("vector-set!",    vectorSet_if);
    definePrimitive("vector-length",  vectorLength_if);
    definePrimitive("vector->list",   vector2List_if);
    definePrimitive("list->vector",   list2Vector_if);
    definePrimitive("vector-fill!",   vectorFill_if);
    definePrimitive("vector",         vector_if);

    /* input and output */
    definePrimitive("open-input-file",     openInputFile_if);
    definePrimitive("open-output-file",    openOutputFile_if);
    definePrimitive("close-input-port",    closeInputPort_if);
    definePrimitive("close-output-port",   closeOutputPort_if);
    definePrimitive("current-input-port",  currentInputPort_if);
    definePrimitive("current-output-port", currentOutputPort_if);
    definePrimitive("read",                read_if);
    definePrimitive("display",             display_if);
    definePrimitive("write",               write_if);
    definePrimitive("newline",             newline_if);

    /* Boolean */
    definePrimitive("not",            not_if);
    defineBoolean("true",             TRUE);
    defineBoolean("false",            FALSE);

    /* Equivalence predicates */
    definePrimitive("eq?",            isEq_if);
    definePrimitive("eqv?",           isEq_if);
    definePrimitive("equal?",         isEqual_if);

    /* Garbage collection */
    definePrimitive("gc",              gc_if);
    definePrimitive("gc-messages?",    isGcMessages_if);
    definePrimitive("set-gc-messages", setGcMessages_if);

    /* Environments */
    definePrimitive("null-environment",          nullEnvironment_if);
    definePrimitive("interaction-environment",   interactionEnvironment_if);
    definePrimitive("scheme-report-environment", schemeReportEnvironment_if);

    regMakeSymbol(regVariable, "nil");
    regMakeNull(regValue);
    defineVariable(regVariable, regValue, regGlobalEnv);


    definePrimitive("list-copy", listCopy_if);

    definePrimitive("exit",                      exit_if);

#if 0
    definePrimitive("call-with-current-continuation", callWithCurrentContinuation_if);
    definePrimitive("call/cc", callWithCurrentContinuation_if);
    definePrimitive("make-continuation", makeContinuation_if);
#endif
#if 0
    definePrimitive("pr",             pr_if);
    definePrimitive("list",           list_if);
    definePrimitive("load",           load_if);
    definePrimitive("eval",           eval_if);
    definePrimitive("apply",          apply_if);
#endif

    /* Stuff needed in the compiler */
    definePrimitive("and?",                     isAnd_if);
    definePrimitive("and-expressions",          andExpressions_if);
    definePrimitive("or?",                      isOr_if);
    definePrimitive("or-expressions",           orExpressions_if);
    definePrimitive("no-expressions?",          isNoExpressions_if);

    regFreeTemp(regVariable);
    regFreeTemp(regValue);
}
