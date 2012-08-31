
(define b "foobar")
(define (a b) b)
(string-set! b 1 (a #\k))

