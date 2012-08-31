#ifndef _COMMON_H
#define _COMMON_H

/* The Register type.
 * You may only use registers returned by regAllocate.
 * You have to be very careful when using registers from C.
 * Beware register aliasing (e.g. by function arguments)
 * that easily leads to register value overwriting.
 * You can always save the register value to stack and
 * restore it later, but determining which registers need
 * to be saved can be hard.
 */
typedef unsigned int Register;

#include "bool.h"
#include "hash.h"

#include "object.h"
#include "register.h"
#include "memory.h"

#endif /* _COMMON_H */
