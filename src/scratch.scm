(define (simplemap proc seq)
  (if (null? seq)
      '()
      (cons (proc (car seq))
	    (simplemap proc (cdr seq)))))

(define seq '((1 2 3) (4 5 6)))

(define heads (simplemap car seq)) ; (1 4)
(define tails (simplemap cdr seq)) ; ((2 3) (5 6))

(define (mymap proc . seqs)
  (display seqs)
  (newline)
  (let ((heads (simplemap car seqs))
	(tails (simplemap cdr seqs)))
    ((display heads)
     (newline)
     (display tails)
     (newline)
     if (null? seqs)
	'()
	(cons (apply proc heads)
	      (apply mymap (cons proc tails))))))


