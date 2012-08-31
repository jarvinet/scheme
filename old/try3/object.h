#ifndef _OBJECT_H
#define _OBJECT_H

Object append(Object first, Object second);
Object appendBang(Object first, Object second);
Object list(int n, ...);
Object reverse(Object list);
Object map(Object procedure, Object list);
Object listRef(Object list, unsigned int n);
Object assoc(Object key, Object records);

#endif /* _OBJECT_H */
