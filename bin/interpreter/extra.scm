;; extra stuff considered useful

(define (filter predicate sequence)
  (cond ((null? sequence) '())
	((predicate (car sequence))
	 (cons (car sequence)
	       (filter predicate (cdr sequence))))
	(else (filter predicate (cdr sequence)))))

(define (fold-right oper initial-value seq)
  (cond ((null? seq) initial-value)
	((pair? seq)
	 (oper (car seq)
	       (fold-right oper initial-value (cdr seq))))
	(else seq)))

(define (fold-left oper initial sequence)
  (define (iter result rest)
    (if (null? rest)
	result
	(iter (oper result (car rest))
	      (cdr rest))))
  (iter initial sequence))

(define (accumulate oper initial-value seq)
  (fold-right oper initial-value seq))

(define (error . args)
  (define (iter args)
    (if (not (null? args))
	(begin
	  (display (car args))
	  (iter (cdr args)))))
  (iter args))
