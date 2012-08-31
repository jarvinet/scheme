#include <stdlib.h>
#include <stdio.h>
#include <limits.h>
#include <unistd.h>

#include "common.h"
#include "parameters.h"

#include "symbol.h"
#include "null.h"
#include "primitive.h"
#include "boolean.h"
#include "sstring.h"
#include "number.h"
#include "character.h"
#include "eof.h"
#include "port.h"
#include "math.h"
#include "pairpointer.h"
#include "continuation.h"

#include "insts.h"
#include "regsim.h"

#include "util.h"



static unsigned int memoryToReserve = 10000;
static unsigned int numberOfRegisters = 400;
static char* regsimFilenames[10];
static unsigned int regsimFileCount = 0;
static bool prettyPrinter = FALSE;

static void usage(void)
{
    unsigned int maxMemSize = UINT_MAX;
    unsigned int objectSize = 8*sizeof(Object);

    printf("Usage: regsim file.reg\n"
	   "options:\n\n"

	   "\t-l module\n"
	   "\t\tLoad dynamic library libmodule.so\n"

	   "\t-m k\n"
	   "\t\tSet memory size to k (default %u)\n"

	   "\t-r n\n"
	   "\t\tSet register amount to n (default %u)\n"

	   "\t-p\n"
	   "\t\tPretty-print the program and exit\n"

	   "\t-h\n"
	   "\t\tPrint this help message\n",

	   memoryToReserve, numberOfRegisters
	   );

    printf("\nmemory size: %u, "
	   "object size: %u bits, "
	   "max memory size = %u\n\n",
	   memoryToReserve, objectSize, maxMemSize);
}

static void getOptions(int argc, char* argv[])
{
    int c;
    while (1) {
	c = getopt(argc, argv, "hl:m:r:p");
	if (c == -1) break;
	switch (c) {
	case 'l':
#if 0
	    dlAdd(optarg);
#endif
	    break;
	case 'm':
	    memoryToReserve = atoi(optarg);
	    break;
	case 'r':
	    numberOfRegisters = atoi(optarg);
	    break;
	case 'p':
	    prettyPrinter = TRUE;
	    break;
	case 'h':
	    usage();
	    exit(2);
	    break;

	default:
	    printf ("?? getopt returned character code 0%o ??\n", c);
	}
    }
    if (optind < argc) {
	/* non-option ARGV-elements */
	while (optind < argc) {
	    regsimFilenames[regsimFileCount++] = argv[optind++];
	}
	printf ("\n");
    }
}

static void addPrimitives(void)
{
    rsAddPrimitive("cons",                      cons_if);
    rsAddPrimitive("adjoin-arg",                snoc_if);
    rsAddPrimitive("car",                       car_if);
    rsAddPrimitive("cdr",                       cdr_if);
    rsAddPrimitive("set-car!",                  setCar_if);
    rsAddPrimitive("set-cdr!",                  setCdr_if);

    rsAddPrimitive("gc",                        gc_if);
    rsAddPrimitive("gc-messages?",              isGcMessages_if);
    rsAddPrimitive("set-gc-messages",           setGcMessages_if);

    rsAddPrimitive("symbol->string",            symbol2string_if);
    rsAddPrimitive("string->symbol",            string2symbol_if);
    rsAddPrimitive("number->string",            number2string_if);
    rsAddPrimitive("string->number",            string2number_if);
    rsAddPrimitive("string-append",             stringAppend_if);
    rsAddPrimitive("string-length",             stringLength_if);
    rsAddPrimitive("string-set!",               stringSet_if);
    rsAddPrimitive("string-ref" ,               stringRef_if);

    rsAddPrimitive("null?",                     isNull_if);
    rsAddPrimitive("pair?",                     isPair_if);
    rsAddPrimitive("symbol?",                   isSymbol_if);
    rsAddPrimitive("string?",                   isString_if);
    rsAddPrimitive("number?",                   isNumber_if);
    rsAddPrimitive("boolean?",                  isBoolean_if);
    rsAddPrimitive("primitive?",                isPrimitive_if);
    rsAddPrimitive("primitive-procedure?",      isPrimitive_if);
    rsAddPrimitive("true?",                     isTrue_if);
    rsAddPrimitive("false?",                    isFalse_if);
    rsAddPrimitive("eof-object?",               isEOF_if);
    rsAddPrimitive("input-port?",               isInputPort_if);
    rsAddPrimitive("output-port?",              isOutputPort_if);
    rsAddPrimitive("char?",                     isCharacter_if);
    rsAddPrimitive("continuation?",             isContinuation_if);
    rsAddPrimitive("make-continuation",         makeContinuation_if);
    rsAddPrimitive("apply-continuation",        applyContinuation_if);

    rsAddPrimitive("apply-primitive-procedure", applyPrimitiveProcedure_if);

    rsAddPrimitive("initialize-stack",          initStack_if);
    rsAddPrimitive("print-stack-statistics",    printStackStatistics_if);
#if 0
    rsAddPrimitive("pr",                   pr_if);
#endif
    rsAddPrimitive("open-input-file",           openInputFile_if);
    rsAddPrimitive("open-output-file",          openOutputFile_if);
    rsAddPrimitive("close-input-port",          closeInputPort_if);
    rsAddPrimitive("close-output-port",         closeOutputPort_if);
    rsAddPrimitive("current-input-port",        currentInputPort_if);
    rsAddPrimitive("current-output-port",       currentOutputPort_if);
    rsAddPrimitive("push-input-port",           pushInputPort_if);
    rsAddPrimitive("pop-input-port",            popInputPort_if);
    rsAddPrimitive("read",                      read_if);
    rsAddPrimitive("display",                   display_if);
    rsAddPrimitive("newline",                   newline_if);

    rsAddPrimitive("eq?",                       isEq_if);
    rsAddPrimitive("eqv?",                      isEq_if);
    rsAddPrimitive("equal?",                    isEqual_if);

    rsAddPrimitive("=",                         equal_if);
    rsAddPrimitive("integer-equal",             equal_if);
    rsAddPrimitive("<",                         lessThan_if);
    rsAddPrimitive("integer-less-than",         lessThan_if);
    rsAddPrimitive(">",                         greaterThan_if);
    rsAddPrimitive("integer-greater-than",      greaterThan_if);
    rsAddPrimitive("+",                         plus_if);
    rsAddPrimitive("integer-plus",              plus_if);
    rsAddPrimitive("-",                         minus_if);
    rsAddPrimitive("integer-minus",             minus_if);
    rsAddPrimitive("*",                         mul_if);
    rsAddPrimitive("integer-mul",               mul_if);
    rsAddPrimitive("rem",                       remainder_if);
    rsAddPrimitive("remainder",                 remainder_if);

    rsAddPrimitive("not",                       not_if);

    rsAddPrimitive("list",                      list_if);

    rsAddPrimitive("exit",                      exit_if);
}

/****************************************************/

static void loadRegsimPrograms(void)
{
    unsigned int i;
    for (i = 0; i < regsimFileCount; i++) {
	rsReadInstSeq(regsimFilenames[i]);
    }
}

int main(int argc, char* argv[])
{
    extern int scdebug;
    scdebug = 0; /* Parser debugging, 0=off, 1=on */

    getOptions(argc, argv);

    if (regsimFileCount == 0) {
	printf("regsim: no regsim files\n");
	exit(2);
    }
    regInit(numberOfRegisters);
    memInit(memoryToReserve);
    initPrimitives();
    initSymbols();
    makeRegSim();
    portInit();

    if (prettyPrinter) {
	loadRegsimPrograms();
	rsPrintInstSeq();
    } else {

	addPrimitives();
#if 0
	dlLoad();
#else
	regsimInit();
#endif

	initStack();
	initPorts();

	loadRegsimPrograms();
	rsExpandInstSeq();

	rsExecInstSeq();
#if 0
	dlUnload();
#endif
    }
    deleteRegSim();
    freeSymbols();
    freePrimitives();
    memFree();
    regFree();

    return 0;
}
