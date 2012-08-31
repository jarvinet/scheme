/* dlload: load the dynamic libraries
 * This module is probably very Linux-specific.
 */


#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include "dlload.h"



typedef struct dynlib DynamicLibrary;
struct dynlib {
    char *baseName;
    void *libHandle;
};


static DynamicLibrary dynlibs[10];
static unsigned int dynlibCount = 0;


void dlAdd(char *filename)
{
    dynlibs[dynlibCount++].baseName = filename;
}

void dlLoad(void)
{
    void (*initFunction)(void);
    char libName[128];
    char* error;
    unsigned int i;

    for (i = 0; i < dynlibCount; i++) {
	sprintf(libName, "lib%s.so", dynlibs[i].baseName);

	if ((dynlibs[i].libHandle = dlopen(libName, RTLD_LAZY)) == NULL) {
	    printf("Cannot open dynamic library: %s\n", libName);
	    printf("Make sure you have set LD_LIBRARY_PATH\n");
	    printf("dlerror: %s\n", dlerror());
	    exit(2);
	}

	initFunction = dlsym(dynlibs[i].libHandle, "initFunc");
	if ((error = dlerror()) != NULL) {
	    printf("dlerror: %s\n", error);
	} 

	(*initFunction)();
    }
}


void dlUnload(void)
{
    void (*exitFunction)(void);
    char* error;
    unsigned int i;

    for (i = 0; i < dynlibCount; i++) {
#if 0
    /* close the file in the opposite order in which they were opened */
    for (i = dynlibCount-1; i >= 0; i--) {
	exitFunction = dlsym(dynlibs[i].libHandle, "regsimExit");
	if ((error = dlerror()) != NULL) {
	    printf("dlerror: %s\n", error);
	} 
	(*exitFunction)();
#endif
	dlclose(dynlibs[i].libHandle);
    }
}
