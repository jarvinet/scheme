; The factorial function with no definitions or assigments

((lambda (x)
  ((lambda (ft)
    (ft ft x))
   (lambda (ft n)
     (if (< n 2)
	 1
	 (* n (ft ft (- n 1)))))))
  10)

