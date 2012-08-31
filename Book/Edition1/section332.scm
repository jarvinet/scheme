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
	(sequence (display " ")
		  (iter (next-node start) stop))))
  (display "(")
  (if (not (empty-deque? deque))
      (iter (front-ptr deque) (rear-ptr deque)))
  (display ")")
  (newline))
