(define (b a c) (+ a c))
(define (a)
  (map (lambda (a c) (b a c)) '(1 2 3) '(4 5 6)))
