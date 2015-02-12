#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "hash.h"
#include "util.h"


struct binding {
    char *name;
    void *value;
};


enum { MULTIPLIER = 31 };

/* Hashtable is an array of lists
 * The index returned by the hash-function is an index into this array.
 */
struct hashtable {
    List table[NHASH];
};

/* hash: compute hash value of string */
unsigned int hash(char* str)
{
    unsigned int h;
    unsigned char* p;

    h = 0;
    for (p = (unsigned char*) str; *p != '\0'; p++)
	h = MULTIPLIER * h + *p;
    return h % NHASH;
}



static Binding bindCreate(char* name, void* value)
{
    Binding binding;

    binding = (Binding)emalloc(sizeof(struct binding));
    binding->name = estrdup(name);
    binding->value = value;

    return binding;
}

char* bindGetName(Binding binding)
{
    return binding->name;
}

void* bindGetValue(Binding binding)
{
    return binding->value;
}

static bool bindCompare(void* o1, void* o2)
{
    char* name = (char*)o1;
    Binding binding = (Binding)o2;

    return (strcmp(bindGetName(binding), name) == 0);
}

static void bindPrint(void* bind)
{
    Binding binding = (Binding)bind;
    printf("%s ", bindGetName(binding));
}

static void bindDelete(void* bind)
{
    Binding binding = (Binding)bind;
    free(binding->name); 
    free(binding);
}


/* htLookup: find name in hashtable, with optional create */
Binding htLookup(Hashtable ht, char* name, HashOp operation, void* value)
{
    int h = hash(name);
    Binding binding = NULL;
    ListIterator li;
    void* val;

    li = lstFind(ht->table[h], bindCompare, (void*)name);
    if (liIsNull(li)) {
	if (operation == HASHOP_CREATE) {
	    binding = bindCreate(name, value);
	    lstAddFirst(ht->table[h], (void*)binding);
	}
    }
    else {
	if (liGetValue(li, &val))
	    binding = (Binding)val;
	else
	    printf("Cannot get value\n");
    }
    liDelete(li);
    return binding;
}

bool htRemove(Hashtable ht, char* name)
{
    int h = hash(name);
    ListIterator li;
    bool retval;

    li = lstFind(ht->table[h], bindCompare, (void*)name);

    if (liIsNull(li)) 
	retval = FALSE;
    else {
	liRemove(li, bindDelete);
	retval = TRUE;
    }
    liDelete(li);
    return retval;
}

void htPrint(Hashtable ht)
{
    int i;
    for (i = 0; i < NHASH; i++) {
	if (lstSize(ht->table[i]) > 0) {
	    printf("%d: ", i);
	    lstPrint(ht->table[i], bindPrint);
	    printf("\n");
	}
    }
}

Hashtable htCreate(void)
{
    int i;
    Hashtable ht = (Hashtable)emalloc(sizeof(struct hashtable));
    for (i = 0; i < NHASH; i++)
	ht->table[i] = lstMake();
    return ht;
}

void htDelete(Hashtable ht)
{
    int i;
    for (i = 0; i < NHASH; i++)
	lstDelete(ht->table[i], bindDelete);
    free(ht);
}
