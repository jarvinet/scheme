#ifndef _LIST_H
#define _LIST_H

#include "bool.h"


typedef struct list *List;
typedef struct listiterator *ListIterator;

/* Synopsis:
 *     lstMake: Create a new empty list.
 * Parameters:
 *    -
 * Return value:
 *     The new list
 * Note:
 *     The list should be deallocated by lstDelete
 */
typedef void (*ListFunc)(void*);
List lstMake(void);

/* Synopsis:
 *    lstSize: count the number of items in a list
 * Parameters:
 *    list - the list whose items are to be counted
 * Return value:
 *    The number of items in the list
 * Note:
 *    -
 */
unsigned int lstSize(List list);

/* Synopsis:
 *    lstAddFirst: Add a new item to the head of the list
 * Parameters:
 *    list  - the list where the item is to be added
 *    value - the value to be added
 * Return value:
 *    The list
 * Note:
 */
List lstAddFirst(List list, void* value);

/* Synopsis:
 *    lstAddLast: Add a new item to the tail of the list
 * Parameters:
 *    list  - the list where the item is to be added
 *    value - the value to be added
 * Return value:
 *    The list
 * Note:
 */
List lstAddLast(List list, void* value);

/* Synopsis:
 *    lstDelete: delete the list and deallocate the resources reserved for this list
 * Parameters:
 *    list       - the list to be deleted
 *    deleteFunc - if this is non-NULL, this function is called for every item in list
 * Return value:
 *    -
 * Note:
 *    -
 */
void lstDelete(List list, ListFunc deleteFunc);

/* Synopsis:
 *    lstPrint: print all the items in this list
 * Parameters:
 *    list      - the list to be deleted
 *    printFunc - this function is called for every item in list to print the item
 * Return value:
 *    -
 * Note:
 *    -
 */
void lstPrint(List list, ListFunc printFunc);

/* Synopsis:
 *     lstFind: find an element from a list 
 * Parameters:
 *    list       - the list where the item is to be searched for
 *    comparator - a comparator function
 *    compareTo  - the list items are compared against this
 * Return value:
 *     An iterator to the found item.
 *     The returned iterator is null (as per the liIsNull-operation)
 *     if the element was not found.
 * Usage:
 *     The <compareTo> is passed to the comparator along with the
 *     list item. The compare function should return true if the 
 *     elements are considered equal and thus the element is found.
 * Note:
 *     The returned iterator must be deallocated with liDelete
 */
typedef bool (*ListCompareFunc)(void* compareTo, void* listItem);
ListIterator lstFind(List list, ListCompareFunc comparator, void* compareTo);

/* Synopsis:
 *     lstGetIteratorHead: Return an iterator to the head of the list.
 * Parameters:
 *     list - the list where the iterator should point to
 * Return value:
 *     A new list iterator
 *     The returned iterator is null (liIsNull) if the list contains no items.
 * Note:
 *     The returned iterator must be deallocated with liDelete.
 */
ListIterator lstGetIteratorHead(List list);

/* Synopsis:
 *     lstGetIteratorTail: Return an iterator to the tail of the list.
 * Parameters:
 *     list - the list where the iterator should point to
 * Return value:
 *     A new list iterator
 *     The returned iterator is null (liIsNull) if the list contains no items.
 * Note:
 *     The returned iterator must be deallocated with liDelete.
 */
ListIterator lstGetIteratorTail(List list);

/* Synopsis:
 *     liDelete: deallocate the resources allocated for the iterator
 * Parameters:
 *     li - the iterator to deallocate
 * Return value:
 *     -
 * Note:
 *     -
 */
void liDelete(ListIterator li);

/* Synopsis:
 *     liGetValue: get the value pointed to by the iterator.
 * Parameters:
 *     li    - the iterator
 *     value - where the value is to be placed
 * Return value:
 *     If the iterator points to a valid value, return TRUE
 *     otherwise return FALSE.
 * Note:
 *     value is unchanged if the return value is FALSE
 */
bool liGetValue(ListIterator li, void** value);

/* Synopsis:
 *     liNext: move the iterator to the next item in list
 * Parameters:
 *     li    - the iterator
 * Return value:
 *     If the original iterator is null (liIsNull) the iterator
 *     is not changed and FALSE is returned, otherwise TRUE is returned
 * Note:
 *     Calling liNext on an interator pointing to the last item in list
 *     makes the iterator null (liIsNull)
 */
bool liNext(ListIterator li);

/* Synopsis:
 *     liPrev: move the iterator to the previous item in list
 * Parameters:
 *     li    - the iterator
 * Return value:
 *     If the original iterator is null (liIsNull) the iterator
 *     is not changed and FALSE is returned, otherwise TRUE is returned
 * Note:
 *     Calling liPrev on an interator pointing to the first item in list
 *     makes the iterator null (liIsNull)
 */
bool liPrev(ListIterator li);

/* Synopsis:
 *     liIsNull: test whether the iterator points to a valid item
 * Parameters:
 *     li    - the iterator
 * Return value:
 *     Return TRUE if the iterator points to a valid item, FALSE otherwise
 * Note:
 */
bool liIsNull(ListIterator li);

/* Synopsis:
 *     liRemove: Remove the element this iterator points to.
 * Parameters:
 *     li         - the iterator
 *     deleteFunc - a function to be called for the item to be deleted
 * Return value:
 *     Return TRUE if the iterator initially points to a valid item in list,
 *     FALSE otherwise
 * Usage:
 *     If deleteFunc is non-NULL, it is called with the deleted item to free
 *     the resources allocated for the item.
 * Note:
 *     The iterator <li> becomes invalid upon return this function.
 *     That is, liIsNull(li) returns true.
 */
bool liRemove(ListIterator li, ListFunc deleteFunc);

/* Synopsis:
 *     liInsertBefore: insert a new item just before
 *     the item pointed to by the iterator
 * Parameters:
 *     li    - the iterator
 *     value - the value to be inserted
 * Return value:
 *     Return TRUE if the iterator points to a valid item.
 *     Return FALSE otherwise, in this case the value is not inserted.
 * Note:
 *     The iterator is not changed.
 */
bool liInsertBefore(ListIterator li, void* value);

/* Synopsis:
 *     liInsertAfter: insert a new item just after
 *     the item pointed to by the iterator
 * Parameters:
 *     li    - the iterator
 *     value - the value to be inserted
 * Return value:
 *     Return TRUE if the iterator points to a valid item.
 *     Return FALSE otherwise, in this case the value is not inserted.
 * Note:
 *     The iterator is not changed.
 */
bool liInsertAfter(ListIterator li, void* value);


#endif /* _LIST_H */
