; Structure and Interpretation of Computer Programs, 2nd edition

;-------------------------------------------------------------

; section 2.2.2


;-------------------------------------------------------------

; Exercise 2.32

(define (subsets s)
  (if (null? s)
      (list nil)
      (let ((rest (subsets (cdr s))))
	(append rest
		(map
		 (lambda (x) (cons (car s) x))
		 rest)))))

; (1 2 3)
; (() (3) (2) (2 3) (1) (1 3) (1 2) (1 2 3))

; (2 3)
; (() (3) (2) (2 3))

; (3)
; (() (3))

; ()
; (())




Let x be an element of S

The subsets of S is

1) A set containing an empty set, if S is empty
2) Let S' be the subsets of S-x
   Add x to each element of S'
