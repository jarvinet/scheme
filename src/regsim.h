#ifndef _REGSIM_H
#define _REGSIM_H


/* the instruction sequence */
typedef struct instseq InstSeq;

typedef struct regsim RegSim;

extern RegSim* theRegSim;

void makeRegSim();
void deleteRegSim(void);
void rsReadInstSeq(char* fileName);
void rsExpandInstSeq(void);

int  rsAddInst(Inst newInst);

void rsAddLabel(char* label);
unsigned int rsLookupLabel(char* labelName);

void rsAddPrimitive(char* primName, Primitive prim);
Primitive rsLookupPrimitive(char* primName);

void rsPrintInstSeq(void);
void rsExecInstSeq(void);
void rsStart(void);
unsigned int rsGetPc(void);
void rsSetPc(unsigned int index);
void rsAdvancePc();
bool isFlagSet(void);

void exit_if(Register result, Register operands);

#endif /* _REGSIM_H */
