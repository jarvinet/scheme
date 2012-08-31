; Structure and Interpretation of Computer Programs, 2nd edition

; Exercise 4.21


; Factorial:

((lambda (n)
   ((lambda (fact)
      (fact fact n))
    (lambda (ft k)
      (if (= k 1)
	  1
	  (* k (ft ft (- k 1)))))))
 10)


; Fibonacci

(define (fib n)
  (if (< n 2)
      1
      (+ (fib (- n 1)) (fib (- n 2)))))


((lambda (n)
   ((lambda (fib)
      (fib fib n))
    (lambda (fb k)
      (if (< k 2)
	  1
	  (+ (fb fb (- k 1)) (fb fb (- k 2)))))))
 10)


; Even

(define (f x)
  (define (even? n)
    (if (= n 0)
	true
	(odd? (- n 1))))
  (define (odd? n)
    (if (= n 0)
	false
	(even? (- n 1))))
  (even? x))

(define (f x)
  ((lambda (even? odd?)
     (even? even? odd? x))
   (lambda (ev? od? n)
     (if (= n 0) true (od? ev? od? (- n 1))))
   (lambda (ev? od? n)
     (if (= n 0) false (ev? ev? od? (- n 1))))))


   
