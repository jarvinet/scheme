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
