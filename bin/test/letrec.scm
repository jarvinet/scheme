(letrec ((even?
	  (lambda (n)
	    (if (zero? n)
		#t
		(odd? (- n 1)))))
	 (odd?
	  (lambda (n)
	    (if (zero? n)
		#f
		(even? (- n 1))))))
  (even? 88))

; When the above letrec is converted into a let,
; it looks like this:
; (let ((even? (quote *unassigned*))
;       (odd? (quote *unassigned*)))
;   (set! odd?
; 	(lambda (n)
; 	  (if (zero? n)
; 	      false
; 	      (even? (- n 1)))))
;   (set! even?
; 	(lambda (n)
; 	  (if (zero? n)
; 	      true
; 	      (odd? (- n 1)))))
;   (even? 88))
