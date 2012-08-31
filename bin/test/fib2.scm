; Test is the computation speeds up if we make
; a new environment with a small number of bindings

(define (fib2 n)
  (define (fib n)
    (if (< n 2)
	n
	(+ (fib (- n 2))
	   (fib (- n 1)))))
  (fib n))


