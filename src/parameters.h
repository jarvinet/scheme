#ifndef _PARAMETERS_H
#define _PARAMETERS_H

/* This file contains the program parameters related mainly to debugging
 */


#if 0
/* when NDEBUG is defined, assert has no effect */
#define NDEBUG
#endif

#include <assert.h>

#if 0
/* If this is defined, you can get statistics on
 * the stack usage */
#define STACK_INSTRUMENTED
#endif

#if 1
/* If this is defined, the restores from the stack are
 * guarded. This means that an error is signalled if we
 * try to restore a register that is not on top of the
 * stack. The check is based on register names.
 */
#define STACK_GUARDED
#endif

#if 0
#define DEBUG_INPUT_PORT_STACK
#endif

#if 0
#define DEBUG_OUTPUT_PORT_STACK
#endif

#if 0
#define DEBUG_INPUT_PORT_REFS
#endif

#if 0
#define DEBUG_OUTPUT_PORT_REFS
#endif

#if 0
#define DEBUG_STRING_REFS
#endif

#if 0
#define DEBUG_VECTOR_REFS
#endif

#if 0
#define DEBUG_CONTINUATION_REFS
#endif

#endif /* _PARAMETERS_H */
