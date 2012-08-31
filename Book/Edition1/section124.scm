; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; Section 1.2.4

; x^0 = 1
; x^n = x * (x^(n-1))
;

(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))


(define (expt-iter b counter product)
  (if (= counter 0)
      product
      (expt-iter b 
		 (- counter 1) 
		 (* b product))))


; b^n = (b^(n/2))^2   n even
; b^n = b * (b^(n-1)) n odd
;

(define (fast-exp b n)
  (cond ((= n 0) 1)
	((even? n) (square (fast-exp b (/ n 2))))
	(else      (* b (fast-exp b (- n 1))))))


;-------------------------------------------------------------

; exercise 1.11

; (square (fast-exp b (/ n 2))) = (fast-exp (square b) (/ n 2))
; a(b^2)^(n/2) = a(b^2)(b^2)(n/2 - 1)

(define (fast-exp-iter b n a)
  (cond ((= n 0)   a)
	((even? n) (fast-exp-iter (square b)
				  (- (/ n 2) 1)
				  (* a (square b))))
	(else      (fast-exp-iter b
				  (- n 1)
				  (* b a)))))
	
(define (fast-exp2 b n) (fast-exp-iter b n 1))


;-------------------------------------------------------------

; exercise 1.12

(define (mul a b)
  (if (= b 0)
      0
      (+ a (mul a (- b 1)))))

(define (double a) (* 2 a))
(define (halve a) (/ a 2))

; a*b = a+a+a+a (b times)
; 
; a*b = 2a*(b/2)      b even
; a*b = a + (a*(b-1)) b odd
;
(define (fast-mul a b)
  (cond ((= b 0)   0)
	((even? b) (double (fast-mul a (halve b))))
	(else      (+ a (fast-mul a (- b 1))))))


;-------------------------------------------------------------

; exercise 1.13

(define (fast-mul-iter a b sum)
  (cond ((= b 0)   sum)
	((even? b) (fast-mul-iter (double a)
				  (- (halve b) 1)
				  (+ sum (double a))))
	(else      (fast-mul-iter a
				  (- b 1)
				  (+ a sum)))))

(define (fast-mul2 a b) (fast-mul-iter a b 0))



