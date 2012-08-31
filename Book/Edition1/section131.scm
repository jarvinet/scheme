; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 1.3.1

(define (cube x)
  (* x x x))

(define (sum term a next b)
  (if (> a b)
      0
      (+ (term a)
	 (sum term (next a) next b))))

(define (sum-cubes a b)
  (sum cube a 1+ b))

(define (pi-sum a b)
  (define (pi-term x)
    (/ 1 (* x (+ x 2))))
  (define (pi-next x)
    (+ x 4))
  (sum pi-term a pi-next b))

(define (integral f a b dx)
  (define (add-dx x) (+ x dx))
  (* (sum f (+ a (/ dx 2)) add-dx b)
     dx))


;-------------------------------------------------------------------------------

; exercise 1.24

(define (sum-iter term a next b)
  (define (iter a result)
    (if ( > a b)
	result
	(iter (next a)
	      (+ result (term a)))))
  (iter a 0))

;-------------------------------------------------------------------------------

; exercise 1.25

; recursive:
(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
	 (product term (next a) next b))))

; iterative:
(define (product-iter term a next b)
  (define (iter a result)
    (if (> a b)
	result
	(iter (next a)
	      (* result (term a)))))
  (iter a 1))

; factorial
(define (factorial n)
  (define (identity a) a)
  (product identity 1 1+ n))

; pi approximation
(define (pi-product a b)
  (define (pi-term x)
    (/ (* x (+ x 2)) (square (+ x 1))))
  (define (pi-next x)
    (+ x 2))
  (product pi-term a pi-next b))

(define (pi-approx)
  (* 4 (pi-product 2 10000)))



;-------------------------------------------------------------------------------

; exercise 1.26

; recursive
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
		(accumulate combiner null-value term (next a) next b))))

; iterative
(define (accumulate-iter combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
	result
	(iter (next a)
	      (combiner result (term a)))))
  (iter a null-value))

; sum
(define (sum2 term a next b)
  (accumulate + 0 term a next b))

; product
(define (product2 term a next b)
  (accumulate * 1 term a next b))

(define (factorial2 n)
  (define (identity a) a)
  (product2 identity 1 1+ n))


;-------------------------------------------------------------------------------


;
; exercise 1.27
;

(define (filtered-accumulate combiner null-value predicate term a next b)
  (if (> a b)
      null-value
      (combiner (if (predicate a)
		    (term a)
		    null-value)
		(filtered-accumulate combiner null-value predicate term (next a) next b))))


; sum of the squares of the prime numbers in the interval a to b
(define (prime-square-sum a b)
  (filtered-accumulate + 0 prime? square a 1+ b))


; the product of all the positive integers i < n such that GCD(i, n) = 1
(define (gcd-product n)
  (define (gcd-eq-one i) (= (gcd i n) 1))
  (define (identity a) a)
  (filtered-accumulate * 1 gcd-eq-one identity 1 1+ n))
