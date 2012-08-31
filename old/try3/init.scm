; This file is read on startup of my scheme implementation


(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 2))
	 (fib (- n 1)))))


