; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; Section 1.3.4

(define (deriv f dx)
  (lambda (x)
    (/ (- (f (+ x dx)) (f x))
       dx)))


; Newton's method for arbitrary functions

(define (newton f guess)
  (if (good-enough? guess f)
      guess
      (newton f (improve guess f))))

(define (improve guess f)
  (- guess (/ (f guess)
	      ((deriv f .001) guess))))

(define (good-enough? guess f)
  (< (abs (f guess)) .001))


;-------------------------------------------------------------

; exercise 1.32

; Return a function that performs n repeated applications of the function f
; This works OK alone, but combined with e.g. smooth (see below), does not.
; For example, the following two expression should yield the same value, but do not
; when this version of repeated is used.
; ((smooth (smooth square .001) .001) 2)
; ((smooth-n square .001 2) 2)
;
(define (repeated-iter f n)
  (lambda (x)
    (define (iter f count times value)
      (if (> count times)
	  value
	  (iter f (1+ count) times (f value))))
    (iter f 1 n x)))

; 2nd try

; Return a procedure that applies f twice
(define (double f)
  (lambda (x)
    (f (f x))))

; Return a procedure that is a compound of f1 and f2, i.e. calculates f1(f2(x))
(define (compose f1 f2)
  (lambda (x)
    (f1 (f2 x))))

; This does not seem to be any better in combination with "smooth" than "repeated-iter"
(define (repeated f n)
  (if (= n 0)
      (lambda (x) x) ; Identity function; returns the parameter
      (compose f (repeated f (- n 1)))))


;-------------------------------------------------------------

; exercise 1.33

(define (smooth f dx)
  (lambda (x)
    (/ (+ (f (- x dx))
	  (f x)
	  (f (+ x dx)))
       3)))

; n-fold smoothed function of any given function using "smooth" and "repeated"
; DOES NOT WORK
(define (smooth-n f dx n)
  (repeated (smooth f dx) n))


;-------------------------------------------------------------

; exercise 1.35

(define (iterative-improve good-enough? improve-guess)
  (lambda (x)
    (define (iter guess)
      (if (good-enough? guess)
	  guess
	  (iter (improve-guess guess))))
    (iter x)))

(define (newton2 f guess)
  (define (improve guess)
    (- guess (/ (f guess)
		((deriv f .001) guess))))
  (define (good-enough? guess)
    (< (abs (f guess)) .001))
  ((iterative-improve good-enough? improve) guess))

(define (fixed-point2 f guess)
  (define (good-enough? guess)
    (< (abs (- guess (f guess))) .001))
  ((iterative-improve good-enough? f) 1))
