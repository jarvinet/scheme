#ifndef _REGSIM_H
#define _REGSIM_H

void rsAddPrimitive(char* primName, Primitive prim);
void exit_if(Register result, Register operands);

void initRegsim(void);
void loadFiles(unsigned int regsimFileCount, char** regsimFilenames);

#endif /* _REGSIM_H */
