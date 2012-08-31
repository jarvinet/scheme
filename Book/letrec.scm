(define foo
  (lambda ()
    (let ((a (+ b 1))
	  (b (- a 1)))
      (* a b))))

(define bar
  (lambda ()
    (letrec ((a (+ b 1))
	     (b (- a 1)))
      (* a b))))
