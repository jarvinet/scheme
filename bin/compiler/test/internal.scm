; Testing the compilation of internal defines

(define (a b) 
  (define (c d)
    d)
  (c b))
(display (a 3))
(newline)

