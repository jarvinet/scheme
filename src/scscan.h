#ifndef _SCSCAN_H
#define _SCSCAN_H

void* scCreateYYBuffer(FILE* file);
void scDeleteYYBuffer(void* buffer);
void scSetCurrentYYBuffer(void* buffer);
void* scGetCurrentYYBuffer(void);
void* scScanString(char* string);

#endif /* _SCSCAN_H */
