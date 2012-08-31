#ifndef _REGSIM_H
#define _REGSIM_H

void initRegSim(void);

void addOperation(char* name, Primitive p);

void execute(Register text);

#endif /* _REGSIM_H */
