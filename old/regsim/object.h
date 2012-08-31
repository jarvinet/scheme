#ifndef _OBJECT_H
#define _OBJECT_H


#define OBJTYPE_NULL        0x00
#define OBJTYPE_PAIRPOINTER 0x01
#define OBJTYPE_SYMBOL      0x02
#define OBJTYPE_STRING      0x03
#define OBJTYPE_NUMBER      0x04
#define OBJTYPE_BROKENHEART 0x05
#define OBJTYPE_BOOLEAN     0x06
#define OBJTYPE_PRIMITIVE   0x07
#define OBJTYPE_LABEL       0x08

typedef struct object Object;

typedef Object (*Primitive)();

struct object {
    unsigned char type;

    union {
	unsigned int pair;      /* pointer to the memory */
	Binding      *symbol;   /* pointer to obarray */
	char         *string;   /* the string */
	int          number;    /* the number */
	char         boolean;   /* boolean true or false */
	Primitive    primitive; /* primitives */
	unsigned int label;     /* index to the instruction sequence */
    } u;
};



Object caar(Object obj);
Object cadr(Object obj);
Object cdar(Object obj);
Object cddr(Object obj);

Object caaar(Object obj);
Object caadr(Object obj);
Object cadar(Object obj);
Object caddr(Object obj);
Object cdaar(Object obj);
Object cdadr(Object obj);
Object cddar(Object obj);
Object cdddr(Object obj);

Object cadddr(Object obj);

unsigned int isPair(Object obj);
unsigned int isSymbol(Object obj);
unsigned int isString(Object obj);
unsigned int isNumber(Object obj);
unsigned int isNull(Object obj);
unsigned int isBoolean(Object obj);
unsigned int isBrokenHeart(Object obj);
unsigned int isPrimitive(Object obj);
unsigned int isTrue(Object obj);

Object makePair(unsigned int value);
Object makeBrokenHeart(void);
Object makeSymbol(char* symbol);
Object makeString(char* string);
Object makeNumber(int value);
Object makeNull(void);
Object makeBoolean(char boolean);
Object makePrimitive(Primitive primitive);
Object makeLabel(unsigned int index);

void printObject(Object obj);
void dumpObject(Object obj);

unsigned int isEq(Object o1, Object o2);
unsigned int isEqual(Object o1, Object o2);

/* arithmetic stuff */
unsigned int equal(Object o1, Object o2);
unsigned int lessThan(Object o1, Object o2);
unsigned int greaterThan(Object o1, Object o2);

unsigned int length(Object obj);

Object append(Object first, Object second);
Object appendBang(Object first, Object second);
Object list(int n, ...);
Object reverse(Object list);
Object map(Object procedure, Object list);
Object listRef(Object list, unsigned int n);
Object assoc(Object key, Object records);

#endif /* _OBJECT_H */
