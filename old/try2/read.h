#ifndef _READ_H
#define _READ_H

extern Object parserOutput;

Object read(void);
Object readFile(char* fileName);

Object loadFile(char* fileName);

#endif /* _READ_H */
