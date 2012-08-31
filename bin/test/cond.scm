(cond ((= a 1) 1)
      ((= a 2) 2)
      (else 3))

; The above cond is converted into this:
; (if (= a 1) 1 (if (= a 2) 2 3))
