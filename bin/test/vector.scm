; load this file with vector.scm fib.scm

(define b (make-vector 2))
(define (a b) b)
(vector-set! b 0 0)
(vector-set! b 1 (a 4))
