#ifndef _HASH_H
#define _HASH_H


#define NHASH 512
enum { MULTIPLIER = 31 };

#if 1
typedef void* ValueType;
#else
typedef int ValueType;
#endif

typedef struct Binding Binding;

struct Binding {
    char        *name;
    ValueType   value;
    Binding     *next; /* in chain */
};


Binding* bindCreate(char* name, ValueType val, Binding* next);


typedef struct Hashtable Hashtable;

struct Hashtable {
    Binding* table[NHASH];
};

/* htLookup: find name in hashtable, with optional create */
Binding*
htLookup(Hashtable* ht, char* name, int create, ValueType value);


void htPrint(Hashtable* ht);

/* htCreate: create a new hashtable */
Hashtable* htCreate(void);

/* htFree: free the resources allocated for the hashtable */
void htFree(Hashtable* ht);

#endif /* _HASH_H */
