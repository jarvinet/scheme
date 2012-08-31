(define (enumerate a b)
  (if (> a b)
      the-empty-stream
      (cons-stream a
		   (enumerate (+ a 1) b))))

; The following, when evaluated, will result in an infinite loop 
; ((lambda (x) (x x)) (lambda (x) (x x)))
