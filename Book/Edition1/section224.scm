; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.2.4


; The differentiation program with abstract data

; (define (deriv exp var)
;   (cond ((constant? exp) 0)
; 	((variable? exp)
; 	 (if (same-variable? exp var) 1 0))
; 	((sum? exp)
; 	 (make-sum (deriv (addend exp) var)
; 		   (deriv (augend exp) var)))
; 	((product? exp)
; 	 (make-sum
; 	  (make-product (multiplier exp)
; 			(deriv (multiplicand exp) var))
; 	  (make-product (deriv (multiplier exp) var)
; 			(multiplicand exp))))))

; Representing algebraic expressions

; The constants are numbers
(define (constant? x) (number? x))

; The variables are symbols
(define (variable? x) (symbol? x))

; Two variables are the same if the symbols representing them are eq?
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))

; (define (make-sum a1 a2) (list '+ a1 a2))

; (define (make-product m1 m2) (list '* m1 m2))

(define (sum? x)
  (and (pair? x) (eq? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (product? x)
  (and (pair? x) (eq? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))


; Simplify answers

(define (make-sum a1 a2)
  (cond ((and (number? a1) (number? a2)) (+ a1 a2))
	((number? a1) (if (= a1 0) a2 (list '+ a1 a2)))
	((number? a2) (if (= a2 0) a1 (list '+ a1 a2)))
	(else (list '+ a1 a2))))

(define (make-product m1 m2)
  (cond ((and (number? m1) (number? m2)) (* m1 m2))
	((number? m1)
	 (cond ((= m1 0) 0)
	       ((= m1 1) m2)
	       (else (list '* m1 m2))))
	((number? m2)
	 (cond ((= m2 0) 0)
	       ((= m2 1) m1)
	       (else (list '* m1 m2))))
	(else (list '* m1 m2))))

;-------------------------------------------------------------

; exercise 2.31


(define (make-exponentiation b e)
  (cond ((= e 0) 1)
	((= e 1) b)
	(else (list '** b e))))

(define (exponentiation? x)
  (and (pair? x) (eq? (car x) '**)))

(define (base e) (cadr e))

(define (exponent e) (caddr e))

(define (deriv exp var)
  (cond ((constant? exp) 0)
	((variable? exp)
	 (if (same-variable? exp var) 1 0))
	((sum? exp)
	 (make-sum (deriv (addend exp) var)
		   (deriv (augend exp) var)))
	((product? exp)
	 (make-sum
	  (make-product (multiplier exp)
			(deriv (multiplicand exp) var))
	  (make-product (deriv (multiplier exp) var)
			(multiplicand exp))))
	((exponentiation? exp)
	 (make-product
	  (make-product (exponent exp)
			(make-exponentiation (base exp)
					     (- (exponent exp) 1)))
	  (deriv (base exp) var)))
	(else (error "unknown expresssion type -- DERIV" exp))))
		       
