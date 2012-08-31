; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.1.1

(define (+rat x y)
  (make-rat (+ (* (numer x) (denom y))
	       (* (denom x) (numer y)))
	    (* (denom x) (denom y))))

(define (-rat x y)
  (make-rat (- (* (numer x) (denom y))
	       (* (denom x) (numer y)))
	    (* (denom x) (denom y))))

(define (*rat x y)
  (make-rat (* (numer x) (numer y))
	    (* (denom x) (denom y))))

(define (/rat x y)
  (make-rat (* (numer x) (denom y))
	    (* (denom x) (numer y))))

(define (=rat x y)
  (= (* (numer x) (denom y))
     (* (numer y) (denom x))))

(define (make-rat n d)
  (let ((g (gcd n d)))
    (cons (/ n g) (/ d g))))

(define (numer x) (car x))

(define (denom x) (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))


;-------------------------------------------------------------

; exercise 2.1

(define (make-rat n d)
  (cond ((and (not (= (abs n) n)) (not (= (abs d) d))) 
	 (make-rat (abs n) (abs d))) ; both are negative, make both positive
	((not (= (abs d) d))
	 (make-rat (- n) (abs d)))
	(else
	 (let ((g (gcd n d)))
	   (cons (/ n g) (/ d g))))))


;-------------------------------------------------------------

; exercise 2.2

(define (make-segment start-point end-point)
  (cons start-point end-point))

(define (start-point segment) (car segment))

(define (end-point segment) (cdr segment))

(define (make-point x y)
  (cons x y))

(define (x-coord point) (car point))

(define (y-coord point) (cdr point))

(define (midpoint segment)
  (let ((p1 (start-point segment))
	(p2 (end-point segment)))
    (make-point (/ (+ (x-coord p1) (x-coord p2))
		   2)
		(/ (+ (y-coord p1) (y-coord p2))
		   2))))


;-------------------------------------------------------------

; exercise 2.3

(define (cons23 x y)
  (lambda (m) (m x y)))

(define (car23 z)
  (z (lambda (p q) p)))

(define (cdr23 z)
  (z (lambda (p q) q)))


;-------------------------------------------------------------

; exercise 2.4

(define (cons24 x y)
  (* (expt 2 x) (expt 3 y)))

(define (car24 z)
  #f) ; factor z to see how many 2's and 3's in contains

(define (cdr24 z)
  #t)

;-------------------------------------------------------------

; exercise 2.4

(define zero (lambda (f) (lambda (x) x)))

(define (1+ n)
  (lambda (f) (lambda (x) (f ((n f) x)))))


(1+ zero)
(lambda (f) (lambda (x) (f (((lambda (f) (lambda (x) x)) f) x))))

