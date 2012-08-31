; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; Section 1.1.7

(define (square x)
  (* x x))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
		 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) .001))

(define (sqrt x)
  (sqrt-iter 1 x))

;-------------------------------------------------------------

; exercise 1.4

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
	(else else-clause)))
