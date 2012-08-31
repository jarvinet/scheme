#include <string.h>
#include <stdlib.h>


#define OBARRAYSIZE 1024

static char* obarray[OBARRAYSIZE];
static unsigned int nextFree = 0;

/* return the index of symbol in obarray, -1 if not found */
static unsigned int
search(char* symbol)
{
    unsigned int i;

    for (i = 0; i < nextFree; i++) {
	if (!strcmp(symbol, obarray[i]))
	    return i;
    }
    return -1;
}


/* insert a symbol to the obarray, return the index
 * makes a copy of the string
 */
unsigned int
insert(char* symbol)
{
    unsigned int index = -1;

    if ((index = search(symbol)) == -1) {
	if (nextFree == OBARRAYSIZE) {
	    printf("Obarray is full, cannot insert %s\n", symbol);
	    exit(1);
	} else {
	    index = nextFree;
	    obarray[index] = malloc(strlen(symbol+1));
	    strcpy(obarray[index], symbol);
	    nextFree++;
	}
    }
    return index;
}


char*
lookup(unsigned int index)
{
    if ((index < 0) || (index >= OBARRAYSIZE)) {
	printf("lookup by out of range index: %d\n", index);
	exit(1);
    }
    return obarray[index];
}
