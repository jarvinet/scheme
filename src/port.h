#ifndef _PORT_H
#define _PORT_H

extern Register regSimple;
extern Register regCompound;

void portInit(void);
void initPorts(void);


/* Input ports */
Object objMakeInputPort(char* fileName, FILE* file, void* yyBuffer);
char* objGetInputPortFilename(Object obj);
FILE* objGetInputPortFile(Object obj);
void* objGetInputPortYYBuffer(Object obj);

void objCloseInputPort(Object obj);
unsigned int objUnrefInputPort(Object obj);
unsigned int objRefInputPort(Object obj);
bool objIsEqInputPort(Object p1, Object p2);
bool objIsEqualInputPort(Object p1, Object p2);
void objDisplayInputPort(Object obj, FILE* file);
void objWriteInputPort(Object obj, FILE* file);

void regMakeInputPort(Register reg, char* fileName, FILE* file, void* yyBuffer);
char* regGetInputPortFilename(Register reg);
FILE* regGetInputPortFile(Register reg);
void* regGetInputPortYYBuffer(Register reg);
void regCloseInputPort(Register port);
bool regIsEqInputPort(Register p1, Register p2);
void currentInputPort(Register result);
void readCurrentPort(Register result);
void readPort(Register result, Register regPort);
void openInputFile(Register result, Register name);

void pushInputPort(Register reg);
void popInputPort(void);


/* Output ports */
Object objMakeOutputPort(char* fileName, FILE* file);
char* objGetOutputPortFilename(Object obj);
FILE* objGetOutputPortFile(Object obj);

void objCloseOutputPort(Object obj);
unsigned int objUnrefOutputPort(Object obj);
unsigned int objRefOutputPort(Object obj);
bool objIsEqOutputPort(Object p1, Object p2);
bool objIsEqualOutputPort(Object p1, Object p2);
void objDisplayOutputPort(Object obj, FILE* file);
void objWriteOutputPort(Object obj, FILE* file);
void objDisplayToCurrentPort(Object obj);
void objWriteToCurrentPort(Object obj);

void regMakeOutputPort(Register reg, char* fileName, FILE* file);
char* regGetOutputPortFilename(Register reg);
FILE* regGetOutputPortFile(Register reg);
void regCloseOutputPort(Register port);
bool regIsEqOutputPort(Register p1, Register p2);
void currentOutputPort(Register result);
void openOutputFile(Register result, Register name);
void regDisplayToCurrentPort(Register reg);
void regDisplayObject(Register reg, Register outputPort);
void regWriteToCurrentPort(Register reg);
void regWriteObject(Register reg, Register outputPort);

void pushOutputPort(Register reg);
void popOutputPort(void);

unsigned int maxDepthToPrint(void);

void newline(void);

void closeInputPort_if(Register result, Register operands);
void closeOutputPort_if(Register result, Register operands);
void currentInputPort_if(Register result, Register operands);
void currentOutputPort_if(Register result, Register operands);
void openOutputFile_if(Register result, Register operands);
void openInputFile_if(Register result, Register operands);
void pushInputPort_if(Register result, Register operands);
void popInputPort_if(Register result, Register operands);
void read_if(Register result, Register operands);
void display_if(Register result, Register operands);
void write_if(Register result, Register operands);
void newline_if(Register result, Register operands);

#endif /* _PORT_H */
