#include <stdarg.h>

#include "hash.h"
#include "object.h"
#include "memory.h"
#include "util.h"
#include "obarray.h"

unsigned int
isPair(Object obj)
{
    return (obj.type == OBJTYPE_PAIRPOINTER);
}

unsigned int
isBrokenHeart(Object obj)
{
    return (obj.type == OBJTYPE_BROKENHEART);
}

unsigned int
isSymbol(Object obj)
{
    return (obj.type == OBJTYPE_SYMBOL);
}

unsigned int
isNumber(Object obj)
{
    return (obj.type == OBJTYPE_NUMBER);
}

unsigned int
isNull(Object obj)
{
    return (obj.type == OBJTYPE_NULL);
}

unsigned int
isString(Object obj)
{
    return (obj.type == OBJTYPE_STRING);
}

unsigned int
isBoolean(Object obj)
{
    return (obj.type == OBJTYPE_BOOLEAN);
}

unsigned int
isPrimitive(Object obj)
{
    return (obj.type == OBJTYPE_PRIMITIVE);
}

unsigned int
isTrue(Object obj)
{
    return obj.u.boolean;
}


Object
makePair(unsigned int value)
{
    Object obj;
    obj.type = OBJTYPE_PAIRPOINTER;
    obj.u.pair = value;
    return obj;
}

Object
makeBrokenHeart(void)
{
    Object obj;
    obj.type = OBJTYPE_BROKENHEART;
    return obj;
}

Object
makeSymbol(char* symbol)
{
    Object obj;
    obj.type = OBJTYPE_SYMBOL;
    obj.u.symbol = htLookup(obarray, symbol, 1, 0);
    return obj;
}

Object
makeString(char* string)
{
    Object obj;
    obj.type = OBJTYPE_STRING;
    obj.u.string = string;
    return obj;
}

Object
makeNumber(int value)
{
    Object obj;
    obj.type = OBJTYPE_NUMBER;
    obj.u.number = value;
    return obj;
}

Object
makeNull(void)
{
    Object obj;
    obj.type = OBJTYPE_NULL;
    return obj;
}

Object
makeBoolean(char boolean)
{
    Object obj;
    obj.type = OBJTYPE_BOOLEAN;
    obj.u.boolean = boolean;
    return obj;
}

Object
makePrimitive(Primitive primitive)
{
    Object obj;
    obj.type = OBJTYPE_PRIMITIVE;
    obj.u.primitive = primitive;
    return obj;
}


static void
printPair(Object obj)
{
    Object cdr1;

    printObject(car(obj));

    cdr1 = cdr(obj);
    if (isPair(cdr1)) {
	printf(" ");
	printPair(cdr1);
    } else if (!isNull(cdr1)) {
	printf(" . ");
	printObject(cdr1);
    }
}

void
printObject(Object obj)
{
    switch (obj.type) {
    case OBJTYPE_PAIRPOINTER:
	printf("(");
	printPair(obj);
	printf(")");
	break;
    case OBJTYPE_BROKENHEART:
	printf("Broken Heart");
	break;
    case OBJTYPE_SYMBOL:
	printf("%s", obj.u.symbol->name);
	break;
    case OBJTYPE_STRING:
	printf("\"%s\"", obj.u.string);
	break;
    case OBJTYPE_NUMBER:
	printf("%d", obj.u.number);
	break;
    case OBJTYPE_NULL:
	printf("()");
	break;
    case OBJTYPE_BOOLEAN:
	printf("%s", obj.u.boolean ? "#t" : "#f");
	break;
    case OBJTYPE_PRIMITIVE:
	printf("primitive");
	break;
    default:
	printf("UNKNOWN OBJECT: %u\n", obj);
	break;
    }
}

void
dumpObject(Object obj)
{
    switch (obj.type) {
    case OBJTYPE_PAIRPOINTER:
	printf(" p%02u", obj.u.pair);
	break;
    case OBJTYPE_BROKENHEART:
	printf("  BH");
	break;
    case OBJTYPE_SYMBOL:
	printf("  sy");
	break; 
    case OBJTYPE_STRING:
	printf("  st");
	break;
   case OBJTYPE_NUMBER:
	printf("  n%u", obj.u.number);
	break;
    case OBJTYPE_NULL:
	printf("  e0");
	break;
    default:
	printf("  UO");
	break;
    }
}

static Object
lastPair(Object obj)
{
    Object last;

    for (last = obj; isPair(cdr(last)); last = cdr(last))
	;

    return last;
}

/* append! */
Object
appendBang(Object first, Object second)
{
    if (!isPair(first))
	eprintf("object is not a pair");
    setCdr(lastPair(first), second);
    return first;
}

/* append */
Object
append(Object first, Object second)
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

unsigned int
length(Object obj)
{
    Object o;
    unsigned int result = 0;

    for (o = obj; !isNull(o); o = cdr(o))
	result++;

    return result;
}


unsigned int
isEq(Object o1, Object o2)
{
    if (o1.type != o2.type)
	return (FALSE);

    switch (o1.type) {
    case OBJTYPE_NULL:
	return (TRUE);
	break;
    case OBJTYPE_PAIRPOINTER:
	return (o1.u.pair == o2.u.pair);
	break;
    case OBJTYPE_SYMBOL:
	return (o1.u.symbol == o2.u.symbol);
	break;
    case OBJTYPE_STRING:
	return (o1.u.string == o2.u.string);
	break;
    case OBJTYPE_NUMBER:
	return (o1.u.number == o2.u.number);
	break;
    case OBJTYPE_BROKENHEART:
	return (TRUE);
	break;
    case OBJTYPE_PRIMITIVE:
	return (o1.u.primitive == o2.u.primitive);
	break;
    }
    return (FALSE);
}

unsigned int
isEqual(Object o1, Object o2)
{
    if (o1.type != o2.type)
	return (FALSE);

    switch (o1.type) {
    case OBJTYPE_NULL:
	return (TRUE);
	break;
    case OBJTYPE_PAIRPOINTER:
	return (isEqual(car(o1), car(o2)) &&
		isEqual(cdr(o1), cdr(o2)));
	break;
    case OBJTYPE_SYMBOL:
	return isEq(o1, o2);
	break;
    case OBJTYPE_STRING:
	return (!strcmp(o1.u.string, o2.u.string));
	break;
    case OBJTYPE_NUMBER:
	return isEq(o1, o2);
	break;
    case OBJTYPE_BROKENHEART:
	return (TRUE);
	break;
    case OBJTYPE_PRIMITIVE:
	return isEq(o1, o2);
	break;
    }
    return (FALSE);
}


/* the arithmetic equal (=) */
unsigned int
equal(Object o1, Object o2)
{
    if (!isNumber(o1))
	eprintf("object is not a number");
    if (!isNumber(o2))
	eprintf("object is not a number");
    return (o1.u.number == o2.u.number);
}

/* the arithmetic less than (<) */
unsigned int
lessThan(Object o1, Object o2)
{
    if (!isNumber(o1))
	eprintf("object is not a number");
    if (!isNumber(o2))
	eprintf("object is not a number");
    return (o1.u.number < o2.u.number);
}

unsigned int
greaterThan(Object o1, Object o2)
{
    if (!isNumber(o1))
	eprintf("object is not a number");
    if (!isNumber(o2))
	eprintf("object is not a number");
    return (o1.u.number > o2.u.number);
}

Object
list(int n, ...)
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

static Object
reverseIter(Object list, Object answer)
{
    if (isNull(list))
	return answer;
    else
	return reverseIter(cdr(list), cons(car(list), answer));
}

Object
reverse(Object list)
{
    return reverseIter(list, makeNull());
}

#if 0
Object
map(Object procedure, Object list)
{
    if (isNull(list))
	return makeNull();
    else
	return cons(apply(procedure, car(list)),
		    map(procedure, cdr(list)));
}
#endif

Object
listRef(Object list, unsigned int n)
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

Object
assoc(Object key, Object records)
{
    if (isNull(records))
	return makeNull();
    else if (isEqual(key, caar(records)))
	return car(records);
    else
	return assoc(key, cdr(records));
}

