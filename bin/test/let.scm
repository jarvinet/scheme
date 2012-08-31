(let ((a 1)
      (b 2))
  (+ a b))

; The above let is converted into this:
; ((lambda (a b) (+ a b)) 1 2)
