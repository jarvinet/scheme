(define (- first . rest)
  (if (null? rest)
      (integer-minus 0 first)
      (fold-left integer-minus first rest)))
