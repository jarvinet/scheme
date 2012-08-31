#include <stdarg.h>

#include "hash.h"
#include "object.h"
#include "memory.h"
#include "util.h"
#include "obarray.h"
#include "eval.h"

static Object lastPair(Object obj)
{
    Object last;

    for (last = obj; isPair(cdr(last)); last = cdr(last))
	;

    return last;
}

/* append! */
Object appendBang(Object first, Object second)
{
    if (!isPair(first))
	eprintf("object is not a pair");
    setCdr(lastPair(first), second);
    return first;
}

/* append */
Object append(Object first, Object second)
{
    if (isNull(first))
	return second;
    else
	return cons(car(first), append(cdr(first), second));
}

Object caar(Object obj) { return car(car(obj)); }
Object cadr(Object obj) { return car(cdr(obj)); }
Object cdar(Object obj) { return cdr(car(obj)); }
Object cddr(Object obj) { return cdr(cdr(obj)); }

Object caaar(Object obj) { return car(caar(obj)); }
Object caadr(Object obj) { return car(cadr(obj)); }
Object cadar(Object obj) { return car(cdar(obj)); }
Object caddr(Object obj) { return car(cddr(obj)); }
Object cdaar(Object obj) { return cdr(caar(obj)); }
Object cdadr(Object obj) { return cdr(cadr(obj)); }
Object cddar(Object obj) { return cdr(cdar(obj)); }
Object cdddr(Object obj) { return cdr(cddr(obj)); }

Object cadddr(Object obj) { return car(cdddr(obj)); }





Object list(int n, ...)
{
    Object result;
    Object obj;
    va_list args;
    int i;

    result = makeNull();

    va_start(args, n);

    for (i = 0; i < n; i++) {
	obj = va_arg(args, Object);
	result = cons(obj, result);
    }

    va_end(args);

    return reverse(result);
}

static Object reverseIter(Object list, Object answer)
{
    if (isNull(list))
	return answer;
    else
	return reverseIter(cdr(list), cons(car(list), answer));
}

Object reverse(Object list)
{
    return reverseIter(list, makeNull());
}

#if 0
Object map(Object procedure, Object list)
{
    if (isNull(list))
	return makeNull();
    else
	return cons(apply(procedure, car(list)),
		    map(procedure, cdr(list)));
}
#endif

Object listRef(Object list, unsigned int n)
{
#if 1
    if (n == 0)
	return car(list);
    else
	return listRef(cdr(list), n-1);
#else
    Object obj;
    int i;

    for (obj = list; i > 0; obj = cdr(list), i--)
	;

    return car(obj);
#endif
}

Object assoc(Object key, Object records)
{
    if (isNull(records))
	return makeNull();
    else if (isEqual(key, caar(records)))
	return car(records);
    else
	return assoc(key, cdr(records));
}

