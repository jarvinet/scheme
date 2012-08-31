; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------


; Section 3.3

(define (last x)
  (if (null? (cdr x))
      x
      (last (cdr x))))



;-------------------------------------------------------------

; exercise 3.13

(define (make-cycle x)
  (set-cdr! (last x) x)
  x)

; (define z (make-cycle '(a b c)))

; endless loop results

;-------------------------------------------------------------

; exercise 3.14

(define (mystery x)
  (define (loop x y)
    (if (null? x)
	y
	(let ((temp (cdr x)))
	  (set-cdr! x y)
	  (loop temp x))))
  (loop x '()))

; initial guess before running this: it is a procedure doing reverse of list

(define v '(a b c d))


;-------------------------------------------------------------

; exercise 3.16

(define (count-pairs x)
  (if (not (pair? x))
      0
      (+ (count-pairs (car x))
	 (count-pairs (cdr x))
	 1)))

; This reports three for the following structure
;
; (define x '(a b c))
; (count-pairs x)
;
;           +-+-+         +-+-+        +-+-+
;      x--->|a| |-------->|b| |------->|c|/|
;           +-+-+         +-+-+        +-+-+
;
; Four for the following structure
;
; (define bc1 (cons 'b 'c))
; (define bc2 (cons bc1 bc1))
; (define y   (cons 'a bc2))
; (count-pairs y)
;
;           +-+-+        +-+-+
;      y--->|a| |------->| | |
;           +-+-+        +|+|+
;                         | |
;                         v v
;                        +-+-+
;                        |b|c|
;                        +-+-+
;
; And seven for the following structure (z)
; (define ab1 (cons 'a 'b))
; (define ab2 (cons ab1 ab1))
; (define z   (cons ab2 ab2))
; (count-pairs z)
;
;
;           +-+-+
;      z--->| | |
;           +|+|+
;            | |
;            v v
;           +-+-+
;           | | |
;           +|+|+
;            | |
;            v v
;           +-+-+
;           |a|b|
;           +-+-+
;
; This would never return
;
; (define x (make-cycle '(a b c)))
;
;            +----------------------------+
;            v                            |
;           +-+-+         +-+-+        +-+-+
;      x--->|a| |-------->|b| |------->|c| |
;           +-+-+         +-+-+        +-+-+
;


;-------------------------------------------------------------

; exercise 3.17

(define (count-pairs x)
  (let ((pair-count 0)
	(visited-pairs '()))
    (define (count x)
      (if (and (pair? x) (not (memq x visited-pairs)))
	  (sequence (set! pair-count (1+ pair-count))
		    (set! visited-pairs (cons x visited-pairs))
		    (count (car x))
		    (count (cdr x)))))
    (count x)
    pair-count))


;-------------------------------------------------------------

; exercise 3.18

(define (has-cycle? x)
  (define (iter head x)
    (cond ((eq? head x) #t)
	  ((null? x) #f)
	  (else (iter head (cdr x)))))
  (iter x (cdr x)))


