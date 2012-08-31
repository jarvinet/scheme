; Ackermann's function
(define (A x y)
  (if (= y 0)
      0
      (if (= x 0)
	  (* 2 y)
	  (if (= y 1)
	      2
	      (A (- x 1)
		 (A x (- y 1)))))))

