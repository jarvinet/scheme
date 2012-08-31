#include <stdio.h>
#include <stdlib.h>

#include "util.h"
#include "list.h"


typedef struct listnode *ListNode;
struct listnode {
    ListNode prev;
    ListNode next;
    void *value;
};

struct list {
    ListNode head;
    ListNode tail;
};

struct listiterator {
    List list;
    ListNode node;
};


static ListNode lnMake(void* value)
{
    ListNode ln = emalloc(sizeof(struct listnode));
    ln->prev = NULL;
    ln->next = NULL;
    ln->value = value;
    return ln;
}

static void lnDelete(ListNode ln)
{
    free(ln);
}

static void* lnGetValue(ListNode ln)
{
    return ln->value;
}

static ListNode lnGetNext(ListNode ln)
{
    return ln->next;
}

static ListNode lnGetPrev(ListNode ln)
{
    return ln->prev;
}

static bool lnIsNull(ListNode ln)
{
    return ln == NULL;
}


ListIterator liMake(List list, ListNode node)
{
    ListIterator li = emalloc(sizeof(struct listiterator));
    li->list = list;
    li->node = node;
    return li;
}

void liDelete(ListIterator li)
{
    free(li);
}

List liGetList(ListIterator li)
{
    return li->list;
}

ListNode liGetNode(ListIterator li)
{
    return li->node;
}

bool liGetValue(ListIterator li, void** value)
{
    if (liIsNull(li))
	return FALSE;
    *value = lnGetValue(liGetNode(li));
    return TRUE;
}

bool liNext(ListIterator li)
{
    if (liIsNull(li))
	return FALSE;
    li->node = lnGetNext(liGetNode(li));
    return TRUE;
}

bool liPrev(ListIterator li)
{
    if (liIsNull(li))
	return FALSE;
    li->node = lnGetPrev(liGetNode(li));
    return TRUE;
}

bool liIsNull(ListIterator li)
{
    return lnIsNull(liGetNode(li));
}

void liInvalidate(ListIterator li)
{
    li->node = NULL;
}

bool liRemove(ListIterator li, ListFunc deleteFunc)
{
    ListNode node;
    ListNode prev;
    ListNode next;

    if (liIsNull(li))
        return FALSE;

    node = liGetNode(li);

    if (lnIsNull(prev = lnGetPrev(node))) {
	li->list->head = node->next;
    }
    else {
        prev->next = node->next;
    }

    if (lnIsNull(next = lnGetNext(node))) {
	li->list->tail = node->prev;
    }
    else {
        next->prev = node->prev;
    }

    if (deleteFunc != NULL)
	(*deleteFunc)(lnGetValue(node));

    lnDelete(node);
    liInvalidate(li);

    return TRUE;
}

bool liInsertBefore(ListIterator li, void* value)
{
    ListNode thisNode;
    ListNode newNode;
    ListNode prevNode;

    if (liIsNull(li))
        return FALSE;

    thisNode = liGetNode(li);
    newNode = lnMake(value);
    prevNode = lnGetPrev(thisNode);

    if (lnIsNull(prevNode)) {
	li->list->head = newNode;
    }
    else {
        prevNode->next = newNode;
    }

    newNode->prev = thisNode->prev;
    newNode->next = thisNode;
    thisNode->prev = newNode;

    return TRUE;
}

bool liInsertAfter(ListIterator li, void* value)
{
    ListNode thisNode;
    ListNode newNode;
    ListNode nextNode;

    if (liIsNull(li))
        return FALSE;

    thisNode = liGetNode(li);
    newNode = lnMake(value);
    nextNode = lnGetNext(thisNode);

    if (lnIsNull(nextNode)) {
	li->list->tail = newNode;
    }
    else {
        nextNode->prev = newNode;
    }

    newNode->prev = thisNode;
    newNode->next = thisNode->next;
    thisNode->next = newNode;

    return TRUE;
}

List lstMake(void)
{
    List list = emalloc(sizeof(struct list));
    list->head = NULL;
    list->tail = NULL;
    return list;
}

unsigned int lstSize(List list)
{
    ListIterator li;
    unsigned int count = 0;
    for (li = lstGetIteratorHead(list); !liIsNull(li); liNext(li)) {
	count++;
    }
    liDelete(li);
    return count;
}

List lstAddFirst(List list, void* value)
{
    ListNode newNode = lnMake(value);
    if (list->head == NULL) {
	list->head = newNode;
	list->tail = newNode;
    } else {
	list->head->prev = newNode;
	newNode->next = list->head;
	list->head = newNode;
    }
    return list;
}

List lstAddLast(List list, void* value)
{
    ListNode newNode = lnMake(value);
    if (list->head == NULL) {
	list->head = newNode;
	list->tail = newNode;
    } else {
	list->tail->next = newNode;
	newNode->prev = list->tail;
	list->tail = newNode;
    }
    return list;
}

ListIterator lstGetIteratorHead(List list)
{
    return liMake(list, list->head);
}

ListIterator lstGetIteratorTail(List list)
{
    return liMake(list, list->tail);
}

void lstDelete(List list, ListFunc deleteFunc)
{
    ListNode ln1;
    ListNode ln2;

    ln1 = list->head; 
    while (!lnIsNull(ln1)) {
	ln2 = lnGetNext(ln1);
	if (deleteFunc != NULL)
	  (*deleteFunc)(lnGetValue(ln1));
	lnDelete(ln1);
	ln1 = ln2;
    }
    free(list);
}

void lstPrint(List list, ListFunc printFunc)
{
    ListIterator li;
    void* value;

    for (li = lstGetIteratorHead(list); !liIsNull(li); liNext(li)) {
	liGetValue(li, &value);
	(*printFunc)(value);
    }

    liDelete(li);
}

ListIterator lstFind(List list, ListCompareFunc comparator, void* compareTo)
{
    ListIterator li;
    void* value;

    for (li = lstGetIteratorHead(list); !liIsNull(li); liNext(li)) {
	liGetValue(li, &value);
	if ((*comparator)(compareTo, value))
	    return li;
    }
    liInvalidate(li);
    return li;
}
