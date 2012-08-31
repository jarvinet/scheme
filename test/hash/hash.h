#ifndef _HASH_H
#define _HASH_H

#include "list.h"

typedef struct binding *Binding;
char* bindGetName(Binding binding);
void* bindGetValue(Binding binding);


typedef struct hashtable *Hashtable;


/* Synopsis:
 *     htCreate: create a new hashtable
 * Parameters:
 *     -
 * Return value:
 *     The new hashtable
 * Note:
 */
Hashtable htCreate(void);


/* Synopsis:
 *     htDelete: free the resources allocated for the hashtable
 * Parameters:
 *     ht - the hashtable to free
 * Return value:
 *     -
 * Note:
 */
void htDelete(Hashtable ht);


/* Synopsis:
 *     htLookup: find name in hashtable, with optional create
 * Parameters:
 *     ht        - the hashtable where the item is to be looked up or added
 *     name      - the name under which the item is stored
 *     operation - LOOKUP or CREATE
 *     value     - the value to be looked up or added
 * Return value:
 *     A binding of the name and value. May be NULL if the operation is LOOKUP
 *     and the value is not found.
 * Usage:
 *     This function is used for both looking up an existing value and
 *     adding a new value to the hashtable. The desired operation is determined
 *     by the third argument <operation> whose type is HashOp and possible values
 *     are HASHOP_LOOKUP amd HASHOP_CREATE.
 *     LOOKUP performs the lookup only. The <value> parameter may be null
 *     in this case.
 *     CREATE adds a new <value> to the hashtable under <name>. If a value
 *     is already installed under <name>, the binding of that value is returned.
 * Note:
 */
typedef enum {
    HASHOP_CREATE,
    HASHOP_LOOKUP
} HashOp;
Binding htLookup(Hashtable ht, char* name, HashOp operation, void* value);


/* Synopsis:
 *     htRemove: remove a value from a hashtable
 * Parameters:
 *     ht   - the hashtable
 *     name - the name whose associated value is to be deleted
 * Return value:
 *     Return TRUE if the value is deleted successfully
 *     Return FALSE if the value is not found
 * Note:
 */
bool htRemove(Hashtable ht, char* name);


/* Synopsis:
 *     htRemove: remove a value from a hashtable
 * Parameters:
 *     ht   - the hashtable
 *     name - the name whose associated value is to be deleted
 * Return value:
 *     Return TRUE if the value is deleted successfully
 *     Return FALSE if the value is not found
 * Note:
 */
void htPrint(Hashtable ht);


/* Synopsis:
 *     hash: compute hash value of string
 * Parameters:
 *     str - the string
 * Return value:
 *     the hash value of the string
 * Note:
 */
unsigned int hash(char* str);

#endif /* _HASH_H */
