; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------


; Section 3.3.2

; Representing queues

;-------------------------------------------------------------

; exercise 3.23

; We make a two directional list to support O(1) -operations on both
; front and rear of the deque

; The list nodes are represented by triples (list of three elements)
; containing the data and a pointer to both next and previous nodes.

; f     = front
; r     = rear
; n     = next
; p     = prev
; a,b,c = data
; --|   = null pointer
;
; Empty deque:
;
;                 +-+-+
;          deque->|f|r|
;                 +|+|+
;                  | |
;                  - -
;          
;          
; Deque with one element, (a):
;
;                 +-+-+
;          deque->|f|r|
;                 +|+|+
;                  | |
;                  | |
;                  | |
;                  v v
;                  +-+
;                  |n|--|
;                  +-+
;               |--|p|
;                  +-+
;                  |a|
;                  +-+
;          
;          
; Deque with three elements, (a b c):
;
;                 +-+-+
;          deque->|f|r|
;                 +|+|+
;                  | |
;                  | +------------------+
;                  |                    |
;                  v                    v
;                 +-+        +-+       +-+
;                 |n|------->|n|------>|n|--|
;                 +-+        +-+       +-+
;              |--|p|<-------|p|<------|p|
;                 +-+        +-+       +-+
;                 |a|        |b|       |c|
;                 +-+        +-+       +-+
;          
;          

(define (make-node data) (list data '() '()))

(define (first node) node)        ; select the first pair from list
(define (second node) (cdr node)) ; select the second pair from list
(define (third node) (cddr node)) ; select the third pair from list

(define (data-pair node) (first node))  ; node pair pointing to the data
(define (prev-pair node) (second node)) ; node pair pointing to the previous node
(define (next-pair node) (third node))  ; node pair pointing to the next node

(define (data-node node) (car (data-pair node)))
(define (prev-node node) (car (prev-pair node)))
(define (next-node node) (car (next-pair node)))

(define (set-data-node! node x)
  (set-car! (data-pair node) x))

(define (set-prev-node! node x)
  (set-car! (prev-pair node) x))

(define (set-next-node! node x)
  (set-car! (next-pair node) x))




(define (make-deque) (cons '() '()))

(define (empty-deque? deque)
  (and (null? (front-ptr deque))
       (null? (rear-ptr deque))))

(define (front-ptr deque) (car deque))

(define (rear-ptr deque) (cdr deque))
  
(define (set-front-ptr! deque ptr)
  (set-car! deque ptr))

(define (set-rear-ptr! deque ptr)
  (set-cdr! deque ptr))

(define (front-deque deque)
  (let ((front-node (front-ptr deque)))
    (data-node front-node)))

(define (rear-deque deque)
  (let ((rear-node (rear-ptr deque)))
    (data-node rear-node)))

(define (front-insert-deque! deque data)
  (let ((new-node (make-node data)))
    (cond ((empty-deque? deque) ; add to empty deque
	   (set-car! deque new-node)
	   (set-cdr! deque new-node))
	  (else
	   (let ((front-node (front-ptr deque)))
	     (set-prev-node! front-node new-node)
	     (set-next-node! new-node front-node)
	     (set-car! deque new-node))))))

(define (rear-insert-deque! deque data)
  (let ((new-node (make-node data)))
    (cond ((empty-deque? deque) ; add to emtpy deque
	   (set-car! deque new-node)
	   (set-cdr! deque new-node))
	  (else
	   (let ((rear-node (rear-ptr deque)))
	     (set-next-node! rear-node new-node)
	     (set-prev-node! new-node rear-node)
	     (set-cdr! deque new-node))))))

(define (front-delete-deque! deque)
  (cond ((empty-deque? deque)
	 (error "Delete called with an empty deque"))
	((eq? (front-ptr deque) (rear-ptr deque)) ; delete from deque with one element
	 (set-car! deque nil)
	 (set-cdr! deque nil))
	(else
	 (let ((front-node (front-ptr deque)))
	   (let ((next-node (next-node front-node)))
	     (set-car! deque next-node)
	     (set-prev-node! next-node nil))))))

(define (rear-delete-deque! deque)
  (cond ((empty-deque? deque)
	 (error "Delete called with an empty deque"))
	((eq? (front-ptr deque) (rear-ptr deque)) ; delete from deque with one element
	 (set-car! deque nil)
	 (set-cdr! deque nil))
	(else
	 (let ((rear-node (rear-ptr deque)))
	   (let ((prev-node (prev-node rear-node)))
	     (set-cdr! deque prev-node)
	     (set-next-node! prev-node nil))))))

(define (print-deque deque)
  (define (iter start stop)
    (display (data-node start))
    (if (not (eq? start stop))
	(begin (display " ")
	       (iter (next-node start) stop))))
  (display "(")
  (if (not (empty-deque? deque))
      (iter (front-ptr deque) (rear-ptr deque)))
  (display ")"))

(define (find-deque deque finder)
  (define (iter start stop)
    (cond ((finder (data-node start)) start)
	  ((eq? start stop) '())
	  (else (iter (next-node start) stop))))
  (if (empty-deque? deque)
      '()
      (iter (front-ptr deque) (rear-ptr deque))))

(define (delete-deque! deque node)
  (cond ((and (eq? (front-ptr deque) node) ; one node in list
	      (eq? (rear-ptr deque) node))
	 (set-front-ptr! deque '())
	 (set-rear-ptr! deque '()))
	((eq? (front-ptr deque) node) ; front node
	 (set-front-ptr! deque (next-node node)))
	((eq? (rear-ptr deque) node) ; rear node
	 (set-rear-ptr! deque (prev-node node)))
	(else ; middle node
	 (let ((prev (prev-node node))
	       (next (next-node node)))
	   (set-next-node! prev next)
	   (set-prev-node! next prev)))))


(define (make-hashtable)
  (define (iter vector start stop)
    (vector-set! vector start (make-deque))
    (if (= start stop)
	vector
	(iter vector (+ start 1) stop)))
  (let ((ht (make-vector 512))) ; must be the same number as NHASH in hash.h
    (iter ht 0 511)))

(define (hashtable-compare value)
  (lambda (v)
    (eq? (car v) value)))

; hashtable look up with optional create
(define (lookup-hashtable hashtable name create value)
  (let ((hash (symbol-hash name)))
    (let ((deque (vector-ref hashtable hash)))
      (let ((node (find-deque deque (hashtable-compare name))))
	(if (null? node)
	    (if create
		(front-insert-deque! deque
				     (cons name value))
		'())
	    (if create
		(set-data-node! node (cons name value))
		(data-node node)))))))

(define (remove-hashtable hashtable name)
  (let ((hash (symbol-hash name)))
    (let ((deque (vector-ref hashtable hash)))
      (let ((node (find-deque deque (hashtable-compare name))))
	(if (null? node)
	    #f
	    (delete-deque! deque node))))))

(define properties (make-hashtable))

(define (putprop symbol key value)
  (let ((prop (lookup-hashtable properties symbol #f 0)))
    (if (null? prop)
	(let ((ht (make-hashtable)))
	  (lookup-hashtable ht key #t value)
	  (lookup-hashtable properties symbol #t ht))
	(let ((ht (cdr prop)))
	  (lookup-hashtable ht key #t value)))))

(define (getprop symbol key)
  (let ((prop (lookup-hashtable properties symbol #f 0)))
    (if (null? prop)
	#f
	(let ((val (lookup-hashtable (cdr prop) key #f 0)))
	  (if (null? val)
	      #f
	      (cdr val))))))

(define (remprop symbol key)
  (let ((prop (lookup-hashtable properties symbol #f 0)))
    (if (null? prop)
	#f
	(remove-hashtable (cdr prop) key))))
