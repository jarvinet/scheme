#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "common.h"
#include "parameters.h"
#include "glue.h"
#include "argcheck.h"
#include "eprint.h"

#include "sstring.h"
#include "boolean.h"
#include "character.h"
#include "symbol.h"
#include "null.h"
#include "port.h"
#include "util.h"
#include "scscan.h"


/* Number of nested items to print from a (non)cyclic
 * data structures */
static unsigned int cyclicMaxDepth = 20;

static Register reg0;
static Register regInputPorts;
static Register regOutputPorts;

/* parser registers */
Register regSimple;
Register regCompound;


typedef enum {
    PORT_STATE_OPEN,
    PORT_STATE_CLOSED
} PortState;
typedef struct port Port;
struct port {
    char* filename;
    FILE* file;
    void* yy_buffer_state; /* flex buffer, real type is YY_BUFFER_STATE */
    PortState state;
};


void portInit(void)
{
    reg0           = regAllocate("portReg0");
    regInputPorts  = regAllocate("portInputPorts");
    regOutputPorts = regAllocate("portOutputPorts");
    regSimple      = regAllocate("parserSimple");
    regCompound    = regAllocate("parserCompound");
}

void initPorts(void)
{
    regMakeNull(regInputPorts);
    regMakeInputPort(reg0, "stdin", stdin, scCreateYYBuffer(stdin));
    pushInputPort(reg0);

    regMakeNull(regOutputPorts);
    regMakeOutputPort(reg0, "stdout", stdout);
    pushOutputPort(reg0);
}


static Port* makePort(char* filename, FILE* file, void* yyBuffer)
{
    Port* port;
    port = emalloc(sizeof(struct port));
    port->filename = estrdup(filename);
    port->file = file;
    port->yy_buffer_state = yyBuffer;
    port->state = PORT_STATE_OPEN;
    return port;
}

static char* portGetFilename(Port* port)
{
    return port->filename;
}

static FILE* portGetFile(Port* port)
{
    return port->file;
}

static void* portGetYYBuffer(Port* port)
{
    return port->yy_buffer_state;
}

static bool portIsOpen(Port* port)
{
    return (port->state == PORT_STATE_OPEN);
}

static void portSetState(Port* port, PortState portState)
{
    port->state = portState;
}

static void portDelete(Port* port)
{
    free(port->filename);
    free(port);
}


Object objMakeInputPort(char* fileName, FILE* file, void* yyBuffer)
{
    Object obj;
    Port* port = makePort(fileName, file, yyBuffer);
    obj.type = OBJTYPE_INPUT_PORT;
    obj.u.port = glueCreate((void*)port);
    return obj;
}

void regMakeInputPort(Register reg, char* fileName, FILE* file, void* yyBuffer)
{
    regWrite(reg, objMakeInputPort(fileName, file, yyBuffer));
}

void objDeleteInputPort(Object obj)
{
    Glue glue = obj.u.port;
    Port* port = (Port*)glueGetValue(glue);

    if (portIsOpen(port))
	objCloseInputPort(obj);
    portDelete(port);
    glueDelete(glue);
}

char* objGetInputPortFilename(Object obj)
{
    Port* port;
    assert(objIsInputPort(obj));
    port = (Port*)glueGetValue(obj.u.port);
    return portGetFilename(port);
}

char* regGetInputPortFilename(Register reg)
{
    return objGetInputPortFilename(regRead(reg));
}

FILE* objGetInputPortFile(Object obj)
{
    Port* port;
    assert(objIsInputPort(obj));
    port = (Port*)glueGetValue(obj.u.port);
    return portGetFile(port);
}

FILE* regGetInputPortFile(Register reg)
{
    return objGetInputPortFile(regRead(reg));
}

void* objGetInputPortYYBuffer(Object obj)
{
    Port* port;
    assert(objIsInputPort(obj));
    port = (Port*)glueGetValue(obj.u.port);
    return portGetYYBuffer(port);
}

void* regGetInputPortYYBuffer(Register reg)
{
    return objGetInputPortYYBuffer(regRead(reg));
}

void objCloseInputPort(Object obj)
{
    Port* port = (Port*)glueGetValue(obj.u.port);
    FILE* file = portGetFile(port);

    /* Do not close the stdin */
    if (strcmp(portGetFilename(port), "stdin"))
	fclose(file);

    scDeleteYYBuffer(portGetYYBuffer(port));
    portSetState(port, PORT_STATE_CLOSED);
}

void regCloseInputPort(Register port)
{
    objCloseInputPort(regRead(port));
}

void closeInputPort_if(Register result, Register operands)
{
    checkArgsEQ("close-input-port", "i", operands);
    regCloseInputPort(regArgs[0]);
    regMakeSymbol(result, "ok");
}

unsigned int objUnrefInputPort(Object obj)
{
    Glue glue = obj.u.port;
    int refCount = glueDecRefCount(glue);
#ifdef DEBUG_INPUT_PORT_REFS
    Port* port = (Port*)glueGetValue(glue);
    printf("Unref [input port %s], Refcount %d\n", portGetFilename(port), refCount);
#endif
    if (refCount == 0) {
	objDeleteInputPort(obj);
    }
    return refCount;
}

unsigned int objRefInputPort(Object obj)
{
    Glue glue = obj.u.port;
    int refCount = glueIncRefCount(glue);
#ifdef DEBUG_INPUT_PORT_REFS
    Port* port = (Port*)glueGetValue(glue);
    printf("Ref [input port %s], Refcount %d\n", portGetFilename(port), refCount);
#endif
    return refCount;
}

bool objIsEqInputPort(Object o1, Object o2)
{
    return o1.u.port == o2.u.port;
}

bool regIsEqInputPort(Register r1, Register r2)
{
    return objIsEqInputPort(regRead(r1), regRead(r2));
}

bool objIsEqualInputPort(Object o1, Object o2)
{
    return objIsEqInputPort(o1, o2);
}

void objDisplayInputPort(Object obj, FILE* file)
{
    fprintf(file, "[input port %s]", objGetInputPortFilename(obj));
}

void objWriteInputPort(Object obj, FILE* file)
{
    objDisplayInputPort(obj, file);
}



Object objMakeOutputPort(char* fileName, FILE* file)
{
    Object obj;
    Port* port = makePort(fileName, file, NULL);
    obj.type = OBJTYPE_OUTPUT_PORT;
    obj.u.port = glueCreate((void*)port);
    return obj;
}

void regMakeOutputPort(Register reg, char* fileName, FILE* file)
{
    regWrite(reg, objMakeOutputPort(fileName, file));
}

void objDeleteOutputPort(Object obj)
{
    Glue glue = obj.u.port;
    Port* port = (Port*)glueGetValue(glue);

    if (portIsOpen(port))
	objCloseOutputPort(obj);
    portDelete(port);
    glueDelete(glue);
}

char* objGetOutputPortFilename(Object obj)
{
    Port* port;
    assert(objIsOutputPort(obj));
    port = (Port*)glueGetValue(obj.u.port);
    return portGetFilename(port);
}

char* regGetOutputPortFilename(Register reg)
{
    return objGetOutputPortFilename(regRead(reg));
}

FILE* objGetOutputPortFile(Object obj)
{
    Port* port;
    assert(objIsOutputPort(obj));
    port = (Port*)glueGetValue(obj.u.port);
    return portGetFile(port);
}

FILE* regGetOutputPortFile(Register reg)
{
    return objGetOutputPortFile(regRead(reg));
}

void objCloseOutputPort(Object obj)
{
    Glue glue = obj.u.port;
    Port* port = (Port*)glueGetValue(glue);

    /* Do not close the stdout */
    if (strcmp(portGetFilename(port), "stdout"))
	fclose(portGetFile(port));

    portSetState(port, PORT_STATE_CLOSED);
}

void regCloseOutputPort(Register port)
{
    objCloseOutputPort(regRead(port));
}

void closeOutputPort_if(Register result, Register operands)
{
    checkArgsEQ("close-output-port", "o", operands);
    regCloseOutputPort(regArgs[0]);
    regMakeSymbol(result, "ok");
}

unsigned int objUnrefOutputPort(Object obj)
{
    Glue glue = obj.u.port;
    int refCount = glueDecRefCount(glue);
#ifdef DEBUG_OUTPUT_PORT_REFS
    Port* port = (Port*)glueGetValue(glue);
    printf("Unref [output port %s], Refcount %d\n", portGetFilename(port), refCount);
#endif
    if (refCount <= 0) {
	objDeleteOutputPort(obj);
    }
    return refCount;
}

unsigned int objRefOutputPort(Object obj)
{
    Glue glue = obj.u.port;
    int refCount = glueIncRefCount(glue);
#ifdef DEBUG_OUTPUT_PORT_REFS
    Port* port = (Port*)glueGetValue(glue);
    printf("Ref [output port %s], Refcount %d\n", portGetFilename(port), refCount);
#endif
    return refCount;
}

bool objIsEqOutputPort(Object o1, Object o2)
{
    return o1.u.port == o2.u.port;
}

bool regIsEqOutputPort(Register r1, Register r2)
{
    return objIsEqOutputPort(regRead(r1), regRead(r2));
}

bool objIsEqualOutputPort(Object o1, Object o2)
{
    return objIsEqOutputPort(o1, o2);
}

void objDisplayOutputPort(Object obj, FILE* file)
{
    fprintf(file, "[output port %s]", objGetOutputPortFilename(obj));
}

void objWriteOutputPort(Object obj, FILE* file)
{
    objDisplayOutputPort(obj, file);
}

void currentInputPort(Register result)
{
    regCar(result, regInputPorts);
}

void currentInputPort_if(Register result, Register operands)
{
    checkArgsEQ("current-input-port", "", operands);
    currentInputPort(result);
}

void currentOutputPort(Register result)
{
    regCar(result, regOutputPorts);
}

void currentOutputPort_if(Register result, Register operands)
{
    checkArgsEQ("current-output-port", "", operands);
    currentOutputPort(result);
}

void openOutputFile(Register result, Register name)
{
    char* fileName = regGetString(name);
    FILE* outputFile;

    if ((outputFile = fopen(fileName, "w")) == NULL)
	esprint("*** Can't open file %s for writing\n", fileName);
    regMakeOutputPort(result, fileName, outputFile);
}

void openOutputFile_if(Register result, Register operands)
{
    checkArgsEQ("open-output-file", "s", operands);
    openOutputFile(result, regArgs[0]);
}

void openInputFile(Register result, Register name)
{
    char* fileName = regGetString(name);
    FILE* inputFile;
    void* yyBuffer;

    if ((inputFile = fopen(fileName, "r")) == NULL)
	esprint("*** Can't open file %s for reading\n", fileName);
    yyBuffer = scCreateYYBuffer(inputFile);
    regMakeInputPort(result, fileName, inputFile, yyBuffer);
}

void openInputFile_if(Register result, Register operands)
{
    checkArgsEQ("open-input-file", "s", operands);
    openInputFile(result, regArgs[0]);
}

void pushInputPort(Register reg)
{
#ifdef DEBUG_INPUT_PORT_STACK
    printf("pushInputPort: stack before: ");
    regPrint(regInputPorts);
#endif

    cons(regInputPorts, reg, regInputPorts);

    currentInputPort(reg0);
    scSetCurrentYYBuffer(regGetInputPortYYBuffer(reg0));

#ifdef DEBUG_INPUT_PORT_STACK
    printf("pushInputPort: stack after: ");
    regPrint(regInputPorts);
#endif
}

void pushInputPort_if(Register result, Register operands)
{
    checkArgsEQ("push-input-port", "i", operands);
    pushInputPort(regArgs[0]);
    regMakeSymbol(result, "ok");
}

void popInputPort(void)
{
#ifdef DEBUG_INPUT_PORT_STACK
    printf("popInputPort: stack before: ");
    regPrint(regInputPorts);
#endif

    regCdr(regInputPorts, regInputPorts);

    currentInputPort(reg0);
    scSetCurrentYYBuffer(regGetInputPortYYBuffer(reg0));

#ifdef DEBUG_INPUT_PORT_STACK
    printf("popInputPort: stack after: ");
    regPrint(regInputPorts);
#endif
}

void popInputPort_if(Register result, Register operands)
{
    checkArgsEQ("pop-input-port", "", operands);
    popInputPort();
    regMakeSymbol(result, "ok");
}

void pushOutputPort(Register reg)
{
#ifdef DEBUG_OUTPUT_PORT_STACK
    printf("pushOutputPort: stack before: ");
    regPrint(regOutputPorts);
#endif

    cons(regOutputPorts, reg, regOutputPorts);

#ifdef DEBUG_OUTPUT_PORT_STACK
    printf("pushOutputPort: stack after: ");
    regPrint(regOutputPorts);
#endif
}

void popOutputPort(void)
{
#ifdef DEBUG_OUTPUT_PORT_STACK
    printf("popOutputPort: stack before: ");
    regPrint(regOutputPorts);
#endif

    regCdr(regOutputPorts, regOutputPorts);

#ifdef DEBUG_OUTPUT_PORT_STACK
    printf("popOutputPort: stack after: ");
    regPrint(regOutputPorts);
#endif
}

void readCurrentPort(Register result)
{
    int scparse(); /* bison-generated parsing function */
    scparse();
    regCopy(result, regSimple);
}

void readPort(Register result, Register regPort)
{
    currentInputPort(reg0);
    if (!regIsEqInputPort(regPort, reg0)) {
	pushInputPort(regPort);
	readCurrentPort(result);
	popInputPort();
    } else {
	readCurrentPort(result);
    }
}

void read_if(Register result, Register operands)
{
    /* if no port is specified, use the current input port
     * (read), (read port)
     */
    if (checkArgs("read", 0, "i", operands) < 1)
	currentInputPort(regArgs[0]);
    readPort(result, regArgs[0]);
}

unsigned int maxDepthToPrint(void)
{
    return cyclicMaxDepth;
}

void objDisplayToCurrentPort(Object obj)
{
    currentOutputPort(reg0);
    objDisplay(obj, regGetOutputPortFile(reg0), 0, maxDepthToPrint());
}

void regDisplayToCurrentPort(Register reg)
{
    objDisplayToCurrentPort(regRead(reg));
}

void regDisplayObject(Register reg, Register outputPort)
{
    currentOutputPort(reg0);
    if (!regIsEqOutputPort(outputPort, reg0)) {
	pushOutputPort(outputPort);
	regDisplayToCurrentPort(reg);
	popOutputPort();
    } else {
	regDisplayToCurrentPort(reg);
    }
}

void display_if(Register result, Register operands)
{
    /* If no port is specified, use the current output port
     * (display "foo"), (display "foo" port)
     */
    if (checkArgs("display", 1, "*o", operands) < 2)
	currentOutputPort(regArgs[1]);
    regDisplayObject(regArgs[0], regArgs[1]);
    regMakeSymbol(result, "ok");
}

void objWriteToCurrentPort(Object obj)
{
    currentOutputPort(reg0);
    objWrite(obj, regGetOutputPortFile(reg0), 0, maxDepthToPrint());
}

void regWriteToCurrentPort(Register reg)
{
    objWriteToCurrentPort(regRead(reg));
}

void regWriteObject(Register reg, Register outputPort)
{
    currentOutputPort(reg0);
    if (!regIsEqOutputPort(outputPort, reg0)) {
	pushOutputPort(outputPort);
	regWriteToCurrentPort(reg);
	popOutputPort();
    } else {
	regWriteToCurrentPort(reg);
    }
}

void write_if(Register result, Register operands)
{
    /* If no port is specified, use the current output port
     * (display "foo"), (display "foo" port)
     */
    if (checkArgs("write", 1, "*o", operands) < 2)
	currentOutputPort(regArgs[1]);
    regWriteObject(regArgs[0], regArgs[1]);
    regMakeSymbol(result, "ok");
}

void newline(void)
{
    Register regPort = regGetTemp();
    Register regNewline = regGetTemp();
    
    currentOutputPort(regPort);
    regMakeCharacter(regNewline, '\n');
    regDisplayObject(regNewline, regPort);

    regFreeTemp(regPort);
    regFreeTemp(regNewline);
}

void newline_if(Register result, Register operands)
{
    /* If no port is specified, use the current output port
     * (newline), (newline port)
     */
    if (checkArgs("newline", 0, "o", operands) == 0)
	currentOutputPort(regArgs[0]);
    regMakeCharacter(result, '\n');
    regDisplayObject(result, regArgs[0]);
}
