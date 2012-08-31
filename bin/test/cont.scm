(define a
  (call-with-current-continuation
   (lambda (exit)
     (for-each (lambda (x)
		 (if (< x 0)
		     (exit x)))
	       '(54 0 37 -3 245 19))
     #t)))

;(define list-length
;  (lambda (obj)
;    (call-with-current-continuation
;     (lambda (return)
;       (letrec ((r
;		 (lambda (obj)
;		   (cond ((null? obj) 0)
;			 ((pair? obj)
;			  (+ (r (cdr obj)) 1))
;			 (else (return #f))))))
;	 (r obj))))))

(define list-length
  (lambda (obj)
    (call-with-current-continuation
     (lambda (return)
       (define (r obj)
	 (cond ((null? obj) 0)
	       ((pair? obj)
		(+ (r (cdr obj)) 1))
	       (else (return #f))))
       (r obj)))))
