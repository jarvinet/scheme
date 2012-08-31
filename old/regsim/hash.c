#include <stdlib.h>

#include "hash.h"


/* hash: compute hash value of string */
static unsigned int
hash(char* str)
{
    unsigned int h;
    unsigned char* p;

    h = 0;
    for (p = (unsigned char*) str; *p != '\0'; p++)
	h = MULTIPLIER * h + *p;
    return h % NHASH;
}

Binding*
bindCreate(char* name, ValueType value, Binding* next)
{
    Binding* binding;

    binding = (Binding*)emalloc(sizeof(Binding));
    binding->name = name; /* assumed allocated elsewhere */
    binding->value = value;
    binding->next = next;

    return binding;
}

static void bindPrint(Binding* bind)
{
    if (bind == NULL)
	return;
    printf("%s: %d\n", bind->name, bind->value);
    bindPrint(bind->next);
}

/* htLookup: find name in hashtable, with optional create */
Binding*
htLookup(Hashtable* ht, char* name, int create, ValueType value)
{
    int h;
    Binding* sym;

    h = hash(name);
    for (sym = ht->table[h]; sym != NULL; sym = sym->next)
	if (strcmp(name, sym->name) == 0)
	    return sym;
    if (create) {
	sym = bindCreate(name, value, ht->table[h]);
	ht->table[h] = sym;
    }
    return sym;
}

void htPrint(Hashtable* ht)
{
    int i;
    for (i = 0; i < NHASH; i++)
	bindPrint(ht->table[i]);
}

/* htCreate: create a new hashtable */
Hashtable* htCreate(void)
{
    Hashtable* ht = (Hashtable*)emalloc(sizeof(Hashtable));
    return ht;
}

/* htFree: free the resources allocated for the hashtable */
void htFree(Hashtable* ht)
{
    free (ht);
}
