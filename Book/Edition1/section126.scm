; Structure and Interpretation of Computer Programs, First edition

;-------------------------------------------------------------

; section 1.2.6

; Searching for Divisors

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

;-------------------------------------------------------------

; exercise 1.17

(define (timed-prime-test n)
  (define start-time (runtime))
  (define found-prime? (prime? n))
  (define elapsed-time (- (runtime) start-time))
  (display n)
  (cond (found-prime?
	 (display " *** ")          ; the book uses "print" in place of "display"
	 (display elapsed-time)))
  (display  "\n"))

(define (search-for-primes start end)
  (cond ((>= start end))
	((even? start) (search-for-primes (+ start 1) end))
	(else
	 (timed-prime-test start)
	 (search-for-primes (+ start 2) end))))
