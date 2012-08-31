(define (f . args)
  (display args)
  (newline)
  (if (null? (car args))
      (begin
	(display "null")
	(newline))
      (begin
	(display (car args))
	(newline)
	(f (cdr args)))))

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 2))
	 (fib (- n 1)))))

(define (fib n)
  (fib-iter 1 0 n))

(define (fib-iter a b count)
  (if (= count 0)
      b
      (fib-iter (+ a b) a (- count 1))))

(define (iter n)
  (if (> n 0)
      (begin
	(display n)
	(newline)
	(iter (- n 1)))))

(define (fact n)
  (if (= n 0)
      1
      (* n (fact (- n 1)))))

(define (make-withdraw balance)
  (lambda (amount)
    (if (> balance amount)
	(begin (set! balance (- balance amount))
	       balance)
	"insufficient funds")))


(define (add-one n) (+ n 1))

(define (list-copy l)
  (if (null? l)
      '()
      (cons (car l)
	    (list-copy (cdr l)))))



; Demonstration that failure to save the env register
; in evaluation of and-special form produces wrong results
(define (f a)
  (lambda () a))

(define q (f 2))

(define a 1)

(and (q) (= a 1))

;--------------------------------------------------
; section 1.2.6

; Searching for Divisors

(define (square n) (* n n))

(define (smallest-divisor n)
  (find-divisor n 2))

; find-divisor: find the smallest integral divisor
; (greater than 1) of a given number n
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
	((divides? test-divisor n) test-divisor)
	(else (find-divisor n (+ test-divisor 1)))))

(define (divides? a b)
  (= (remainder b a) 0))

; number is a prime if its smallest divisor is the number itself
(define (prime? n)
  (= n (smallest-divisor n)))


; The Fermat Test

(define (expmod b e m)
  (cond ((= e 0) 1)
	((even? e)
	 (remainder (square (expmod b (/ e 2) m))
		    m))
	(else
	 (remainder (* b (expmod b (- e 1) m))
		    m))))

(define (fermat-test n)
  (define a (+ 2 (random (- n 2))))
  (= (expmod a n n) a))

(define (fast-prime? n times)
  (cond ((= times 0) #t)      ; the book uses "t" in place of "#t"
	((fermat-test n)
	 (fast-prime? n (- times 1)))
	(else nil)))
