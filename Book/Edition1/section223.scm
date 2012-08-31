; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.2.3

(define (memq item x)
  (cond ((null? x) '())
	((eq? item (car x)) x)
	(else (memq item (cdr x)))))

;-------------------------------------------------------------

; exercise 2.28

(list 'a 'b 'c)
;Value: (a b c)

(list (list 'george))
;Value: ((george))

(cdr '((x1 x2) (y1 y2)))
;Value: ((y1 y2))

(cadr '((x1 x2) (y1 y2)))
;Value: (y1 y2)

(memq 'red '((red shoes) (blue socks)))
;Value: #f

(memq 'red '(red shoes blue socks))
;Value: (red shoes blue socks)


;-------------------------------------------------------------

; exercise 2.28

(define (equal? a b)
  (cond ((and (symbol? a) (symbol? b))
	 (eq? a b))
	((and (list? a) (list? b))
	 (cond ((and (null? a) (null? b)) #t) ; both empty lists
	       ((or  (null? a) (null? b)) #f) ; only other is an empty list
	       (else
		(and (equal? (car a) (car b))
		     (equal? (cdr a) (cdr b))))))
	(else #f)))


;-------------------------------------------------------------

; exercise 2.29

(car ''abracadabra)
;Value: quote
(quote (quote abracadabra))
;Value: (quote abracadabra)

(cdddr '(this list contains '(a quote)))
;Value: ((quote (a quote)))
