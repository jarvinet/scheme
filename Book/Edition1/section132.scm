; Structure and Interpretation of Computer Programs, 1st edition

; Section 1.3.2

;-------------------------------------------------------------

; exercise 1.28

(define (f g)
  (g 2))

; (f f)
; ((lambda (g) (g 2)) f)
; (f 2)
; ((lambda (g) (g 2)) 2)
; (2 2)
;The object 2 is not applicable.
