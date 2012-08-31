; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------


; Section 3.3.3

; Representing Tables

;     table
;       |
;       v
;     +-+-+    +-+-+    +-+-+    +-+-+
;     | | +--->| | +--->| | +--->| |/|
;     +++-+    +++-+    +++-+    +++-+
;      |        |        |        |
;      |        v        v        v
;      v       +-+-+    +-+-+    +-+-+
;   *table*    | | |    | | |    | | |
;              +++++    +++++    +++++
;               | |      | |      | |
;               v v      v v      v v
;               a 1      b 2      c 3

(define (lookup key table)
  (let ((record (assq key (cdr table))))
    (if (null? record)
	nil
	(cdr record))))

(define (assq key records)
  (cond ((null? records) nil)
	((eq? key (caar records)) (car records))
	(else (assq key (cdr records)))))

(define (insert! key value table)
  (let ((record (assq key (cdr table))))
    (if (null? record)
	(set-cdr! table
		  (cons (cons key value) (cdr table)))
	(set-cdr! record value)))
  'ok)

(define (make-table)
  (list '*table*))


; Two-dimensional tables
;
; The following table stores key/value (A B) => 2
;
;     table
;       |
;       v
;     +-+-+    +-+-+
;     | | +--->| |/|
;     +++-+    +++-+
;      |        |
;      |        V
;      V       +-+-+    +-+-+
;   *table*    | | +--->| |/|
;              +++-+    +++++
;               |        |
;               V        V
;               A       +-+-+
;			| | |
;                       +++++
;                        | |
;			 V V
;			 B 2
;



(define (lookup key-1 key-2 table)
  (let ((subtable (assq key-1 (cdr table))))
    (if (null? subtable)
	nil
	(let ((record (assq key-2 (cdr subtable))))
	  (if (null? record)
	      nil
	      (cdr record))))))

(define (insert! key-1 key-2 value table)
  (let ((subtable (assq key-1 (cdr table))))
    (if (null? subtable)
	(set-cdr! table
		  (cons (list key-1
			      (cons key-2 value))
			(cdr table)))
	(let ((record (assq key-2 (cdr subtable))))
	  (if (null? record)
	      (set-cdr! subtable
			(cons (cons key-2 value)
			      (cdr subtable)))
	      (set-cdr! record-value)))))
  'ok)






;-------------------------------------------------------------

; exercise 3.25

; Multidimensional tables
;
; Apparently it is not possible to store value 1 under key (A)
; and value 2 under key (A B). Just like in Huffman coding,
; no key may the prefix of any other key, as here key (A) is a prefix
; of key (A B).
;
; When the following keys/values are stored into a multidimensional table:
;
;  (A B)   => 2
;  (C)     => 3
;  (A C D) => 4
;
; the data structure should look like this:
;
;     table
;       |
;       V
;     +-+-+    +-+-+                                   +-+-+
;     | | +--->| | +---------------------------------->| |/|
;     +++-+    +++-+                                   +++-+
;      |        |					|
;      |        V					V
;      V       +-+-+    +-+-+     +-+-+	               +-+-+
;   *table*    | | +--->| | +---->| |/|		       | | |
;              +++-+    +++++     +++-+		       +++++
;               |        |   	   |			| |
;               V        V   	   V			V V
;               A       +-+-+  	  +-+-+	    +-+-+	C 3
;                       | | |     | | +---->| |/|
;			+++++     +++++     +++++
;			 | | 	   |	     |
;			 V V 	   V	     V
;			 B 2 	   C	    +-+-+
;			                    | | |
;                                           +++++
;                                            | |
;                                            V V
;                                            D 4
;
;
; Whether a thing stored under a key is a value or a subtable can be
; determined by looking at the cdr of the record: 
; (if (pair? (cdr record))
;     (it-is-a-subtable)
;     (it-is-a-value)
;
; When inserting, note that new values for the key simply overwrites all
; the old values whose key begins with the new key, i.e. for which the new
; key is a prefix of the old key.
; For example, if you do the following insert!'s
;
;   (insert! '(A B A) 1 t)
;   (insert! '(A B B) 2 t)
;   (insert! '(A B C) 3 t)
;
; and then do this:
;
;   (insert! '(A) 4 t)
;
; then you lose all the old values whose key begins with 'A, i.e.
; the values of the previous three insert!'s are lost!
;
; The lookup-procedure probably should issue a warning if it finds a value
; and there is unused keys in the 'keys' list.
;


(define (lookup keys table)
  (if (null? keys)
      nil
      (let ((record (assq (car keys) (cdr table))))
	(cond ((null? record) nil)  ; not found
	      ((pair? (cdr record)) ; it is a subtable
	       (lookup (cdr keys) record))
	      (else (cdr record))))))

(define (insert! keys value table)
  (if (null? keys)
      (set-cdr! table value)
      (let ((record (assq (car keys) (cdr table))))
	(if (null? record)
	    (let ((new-record (cons (car keys) nil)))
	      (insert! (cdr keys) value new-record)
	      (set-cdr! table
			(cons new-record (cdr table))))
	    (insert! (cdr keys) value record))))
  'ok)

				       
