(define (b1 n)
  (if (b)
      1
      2))

(define (b2 n)
  (if (integer-less-than n n)
      1
      2))

(define (b3 n)
  (if (b)
      1
      (b)))

(define (b4 n)
  (if (< n 2)
      1
      2))
