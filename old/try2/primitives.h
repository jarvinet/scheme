#ifndef _PRIMITIVES_H
#define _PRIMITIVES_H

/* Scheme interface to the primitives.
 * The naming convention is to suffix the function name with
 * "_si" for "Scheme Interface".
 */

Object cons_si(Object args);
Object car_si(Object args);
Object cdr_si(Object args);
Object setCar_si(Object args);
Object setCdr_si(Object args);

Object caar_si(Object args);
Object cadr_si(Object args);
Object cdar_si(Object args);
Object cddr_si(Object args);

Object isPair_si(Object args);
Object isSymbol_si(Object args);
Object isString_si(Object args);
Object isNumber_si(Object args);
Object isNull_si(Object args);
Object isBoolean_si(Object args);

Object isEq_si(Object args);

Object equal_si(Object args);
Object lessThan_si(Object args);
Object greaterThan_si(Object args);
Object plus_si(Object args);
Object minus_si(Object args);
Object mul_si(Object args);

Object load_si(Object args);

Object isGcMessages_si(Object args);
Object setGcMessages_si(Object args);

#endif /* _PRIMITIVES_H */
