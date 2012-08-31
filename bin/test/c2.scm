(define (c2 n)
  (display n)
  (display " ")
  (if (< n 1)
      n
      (c1 (- n 1))))
