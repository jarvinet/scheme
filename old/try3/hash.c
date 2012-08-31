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
bindCreate(char* name, int value, Binding* next)
{
    Binding* binding;

    binding = (Binding*)emalloc(sizeof(Binding));
    binding->name = name; /* assumed allocated elsewhere */
    binding->value = value;
    binding->next = next;

    return binding;
}


/* htLookup: find name in hashtable, with optional create */
Binding*
htLookup(Hashtable* ht, char* name, int create, int value)
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
