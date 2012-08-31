(define a-stream
  (letrec ((next
	    (lambda (n)
	      (cons n (delay (next (+ n 1)))))))
    (next 0)))
(define head car)
(define tail
  (lambda (stream) (force (cdr stream))))

; (head (tail (tail a-stream))) => 2
