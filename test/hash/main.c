#include <stdio.h>

#include "bool.h"
#include "hash.h"
#include "list.h"

static void print(void* item)
{
    printf("%d ", (int)item);
}

static void delete(void* item)
{
    printf("Delete %d\n", (int)item);
}

static bool compare(void* o1, void* o2)
{
    int n1 = (int)o1;
    int n2 = (int)o2;

    return n1 == n2;
}

/*
List: ()
AddFirst: 0
Result: (0)
*/
static void case1(void)
{
    List list;

    list = lstMake();

    lstAddFirst(list, 0);
    printf("case1: (0) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: ()
AddLast: 0
Result: (0)
*/
static void case2(void)
{
    List list;

    list = lstMake();

    lstAddLast(list, 0);
    printf("case2: (0) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0)
AddFirst: 1
Result: (1 0)
*/
static void case3(void)
{
    List list;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, 0);
    /* preamble */

    lstAddFirst(list, (void*)1);
    printf("case3: (1 0) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0)
AddLast: 1
Result: (0 1)
 */
static void case4(void)
{
    List list;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, 0);
    /* preamble */

    lstAddLast(list, (void*)1);
    printf("case4: (0 1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
AddFirst: 2
Result: (2 0 1)
*/
static void case5(void)
{
    List list;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    lstAddFirst(list, (void*)2);
    printf("case5: (2 0 1) ");
    lstPrint(list, print);
    printf("\n");
    lstDelete(list, FALSE);
}

/*
List: (0 1)
AddLast: 2
Result: (0 1 2)
*/
static void case6(void)
{
    List list;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    lstAddLast(list, (void*)2);
    printf("case6: (0 1 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
AddFirst: 9
Result: (9 0 1 2)
*/
static void case7(void)
{
    List list;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    lstAddFirst(list, (void*)9);
    printf("case7: (9 0 1 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
AddLast: 9
Result: (0 1 2 9)
*/
static void case8(void)
{
    List list;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    lstAddLast(list, (void*)9);
    printf("case8: (0 1 2 9) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/* INSERTION */
static void insertion(void)
{
    case1();
    case2();
    case3();
    case4();
    case5();
    case6();
    case7();
    case8();
}


/*
List: ()
Iterator: lstGetIteratorHead
liInsertBefore 0
Result: fail
*/
static void case9(void)
{
    List list;
    ListIterator li;

    list = lstMake();
    li = lstGetIteratorHead(list);
    printf("case9: ");
    if (liInsertBefore(li, (void*) 0))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");
    lstDelete(list, FALSE);
}

/*
List: ()
Iterator: lstGetIteratorHead
liInsertAfter 0
Result: fail
*/
static void case10(void)
{
    List list;
    ListIterator li;

    list = lstMake();
    li = lstGetIteratorHead(list);
    printf("case10: ");
    if (liInsertAfter(li, (void*) 0))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");
    lstDelete(list, FALSE);
}

/*
List: ()
Iterator: lstGetIteratorTail
liInsertBefore 0
Result: fail
*/
static void case11(void)
{
    List list;
    ListIterator li;

    list = lstMake();
    li = lstGetIteratorTail(list);
    printf("case11: ");
    if (liInsertBefore(li, (void*) 0))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");
    lstDelete(list, FALSE);
}

/*
List: ()
Iterator: lstGetIteratorTail
liInsertAfter 0
Result: fail
*/
static void case12(void)
{
    List list;
    ListIterator li;

    list = lstMake();
    li = lstGetIteratorHead(list);
    printf("case12: ");
    if (liInsertAfter(li, (void*) 0))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");
    lstDelete(list, FALSE);
}

/*
List: (1)
Iterator: 1
liInsertBefore 0
Result: (0 1)
*/
static void case13(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    /* preamble */

    li = lstGetIteratorHead(list);
    liInsertBefore(li, (void*) 0);

    printf("case13: (0 1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (1)
Iterator: 1
liInsertAfter 0
Result: (1 0)
*/
static void case14(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    /* preamble */

    li = lstGetIteratorHead(list);
    liInsertAfter(li, (void*) 0);

    printf("case14: (1 0) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: 0
liInsertBefore 9
Result: (9 0 1)
*/
static void case15(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liInsertBefore(li, (void*) 9);

    printf("case15: (9 0 1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: 1
liInsertBefore 9
Result: (0 9 1)
*/
static void case16(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorTail(list);
    liInsertBefore(li, (void*) 9);

    printf("case16: (0 9 1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: 0
liInsertAfter 9
Result: (0 9 1)
*/
static void case17(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liInsertAfter(li, (void*) 9);

    printf("case17: (0 9 1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: 1
liInsertAfter 9
Result: (0 1 9)
*/
static void case18(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorTail(list);
    liInsertAfter(li, (void*) 9);

    printf("case18: (0 1 9) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: 0
liInsertAfter 9
Result: (0 9 1 2)
*/
static void case19(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liInsertAfter(li, (void*) 9);

    printf("case19: (0 9 1 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: 0
liInsertBefore 9
Result: (9 0 1 2)
 */
static void case20(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liInsertBefore(li, (void*) 9);

    printf("case20: (9 0 1 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: 1
liInsertAfter 9
Result: (0 1 9 2)
*/
static void case21(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liNext(li);
    liInsertAfter(li, (void*) 9);

    printf("case21: (0 1 9 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: 1
liInsertBefore 9
Result: (0 9 1 2)
*/
static void case22(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liNext(li);
    liInsertBefore(li, (void*) 9);

    printf("case22: (0 9 1 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: 2
liInsertAfter 9
Result: (0 1 2 9)
*/
static void case23(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liNext(li);
    liNext(li);
    liInsertAfter(li, (void*) 9);

    printf("case23: (0 1 2 9) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: 2
liInsertBefore 9
Result: (0 1 9 2)
*/
static void case24(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liNext(li);
    liNext(li);
    liInsertBefore(li, (void*) 9);

    printf("case24: (0 1 9 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/* INSERTION THROUGH ITERATOR */
static void insertIter(void)
{
    case9();
    case10();
    case11();
    case12();
    case13();
    case14();
    case15();
    case16();
    case17();
    case18();
    case19();
    case20();
    case21();
    case22();
    case23();
    case24();
}

/*
List: ()
Iterator: lstGetIteratorHead
liRemove
Result: fail
*/

/*
REMOVE:
*/
static void case25(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    /* preamble */

    li = lstGetIteratorHead(list);

    printf("case25: ");
    if (liRemove(li, FALSE))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: ()
Iterator: lstGetIteratorTail
liRemove
Result: fail
*/
static void case26(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    /* preamble */

    li = lstGetIteratorTail(list);

    printf("case26: ");
    if (liRemove(li, FALSE))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0)
Iterator: lstGetIteratorHead
liRemove
Result: ()
*/
static void case27(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liRemove(li, FALSE);

    printf("case27: () ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0)
Iterator: lstGetIteratorTail
liRemove
Result: ()
*/
static void case28(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorTail(list);
    liRemove(li, FALSE);

    printf("case28: () ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: lstGetIteratorHead
liRemove
Result: (1)
*/
static void case29(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liRemove(li, FALSE);

    printf("case29: (1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: lstGetIteratorTail
liRemove
Result: (0)
*/
static void case30(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorTail(list);
    liRemove(li, FALSE);

    printf("case30: (0) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: lstGetIteratorHead
liRemove
Result: (1 2)
*/
static void case31(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liRemove(li, FALSE);

    printf("case31: (1 2) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: lstGetIteratorTail
liRemove
Result: (0 1)
 */
static void case32(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorTail(list);
    liRemove(li, FALSE);

    printf("case32: (0 1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: lstGetIteratorTail
liNext
liRemove
Result: fail
*/
static void case33(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorTail(list);
    liNext(li);
    printf("case33: ");
    if (liRemove(li, FALSE))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: lstGetIteratorHead
liPrev
liRemove
Result: fail
 */
static void case34(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liPrev(li);
    printf("case34: ");
    if (liRemove(li, FALSE))
      printf("FAIL");
    else
      printf("PASS");
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: lstGetIteratorTail
liPrev
liRemove
Result: (1)
*/
static void case35(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorTail(list);
    liPrev(li);
    liRemove(li, FALSE);

    printf("case35: (1) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1)
Iterator: lstGetIteratorHead
liNext
liRemove
Result: (0)
*/
static void case36(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstGetIteratorHead(list);
    liNext(li);
    liRemove(li, FALSE);

    printf("case36: (0) ");
    lstPrint(list, print);
    printf("\n");

    lstDelete(list, FALSE);
}

static void listRemove(void)
{
    case25();
    case26();
    case27();
    case28();
    case29();
    case30();
    case31();
    case32();
    case33();
    case34();
    case35();
    case36();
}

/*
List: (0 1 2)
Iterator: lstFind(, 1)
Result: 1
*/
static void case37(void)
{
    List list;
    ListIterator li;
    void* value;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstFind(list, compare, (void*)1);

    printf("case37: 1 ");
    if (!liGetValue(li, &value))
	printf("Cannot get value\n");
    printf("%d", (int)value);
    printf("\n");

    lstDelete(list, FALSE);
}

/*
List: (0 1 2)
Iterator: lstFind(, 3)
Result: fail
 */
static void case38(void)
{
    List list;
    ListIterator li;

    list = lstMake();

    /* preamble */
    lstAddFirst(list, (void*)2);
    lstAddFirst(list, (void*)1);
    lstAddFirst(list, (void*)0);
    /* preamble */

    li = lstFind(list, compare, (void*)3);

    printf("case38: ");
    if (liIsNull(li))
      printf("PASS");
    else
      printf("FAIL");
    printf("\n");

    lstDelete(list, FALSE);
}

/* FIND */
static void listFind(void)
{
    case37();
    case38();
}


static void listTest(void)
{
    insertion();
    insertIter();
    listRemove();
    listFind();
}

static void hashTest(void)
{
    Hashtable ht = htCreate();

    htLookup(ht, "foo", HASHOP_CREATE, (void*)1);
    htLookup(ht, "bar", HASHOP_CREATE, (void*)2);
    htPrint(ht);

    if (htRemove(ht, "bar"))
	printf("Delete successful\n");
    else
	printf("Delete unsuccessful\n");

    htPrint(ht);

    htDelete(ht);
}

void main(void)
{
#if 0
    List l1;
    List l2;

    l1 = lstMake();
    l2 = lstMake();

    lstAddFirst(l1, (void*)1);
    lstAddFirst(l2, (void*)3);

    lstPrint(l1, print);
    lstPrint(l2, print);

    lstDelete(l1, delete);
    lstDelete(l2, delete);
#else
    hashTest();
#endif
}
