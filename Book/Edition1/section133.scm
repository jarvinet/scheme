; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; Section 1.3.3

; Finding roots of equations by the half-interval method

(define (search f neg-point pos-point)
  (let ((midpoint (average neg-point pos-point)))
    (if (close-enough? neg-point pos-point)
	midpoint
	(let ((test-value (f midpoint)))
	  (cond ((positive? test-value)
		 (search f neg-point midpoint))
		((negative? test-value)
		 (search f midpoint pos-point))
		(else midpoint))))))

(define (average x y)
  (/ (+ x y) 2))

(define (close-enough? x y)
  (< (abs (- x y)) .001))

(define (half-interval-method f a b)
  (let ((a-value (f a))
	(b-value (f b)))
    (cond ((and (negative? a-value) (positive? b-value))
	   (search f a b))
	  ((and (negative? b-value) (positive? a-value))
	   (search f b a))
	  (else
	   (error "Values are not of opposite sign" a b)))))


; Finding the maximum of a unimodal function

(define (reduce f a x y b fx fy)
  (cond ((close-enough? a b) x)
	((> fx fy)
	 (let ((new (x-point a y)))
	   (reduce f a new x y (f new)fx)))
	(else
	 (let ((new (y-point x b)))
	   (reduce f x y new b fy (f new))))))

(define (x-point a b)
  (+ a (* golden-ratio-squared (- b a))))

(define (y-point a b)
  (+ a (* golden-ratio (- b a))))
  
(define golden-ratio
  (/ (- (sqrt 5) 1) 2))

(define golden-ratio-squared (square golden-ratio))

(define (golden f a b)
  (let ((x (x-point a b))
	(y (y-point a b)))
    (reduce f a x y b (f x) (f y))))

(* 2 (golden sin 0 3))

;-------------------------------------------------------------

; exercise 1.29

; Notice that this calculates the fx (the maximum value) the function has
; in the interval. The golden method calculates the point x where the function
; has its maximum value in the interval

(define (brute-force f a b)
  (accumulate max
	      (f a)
	      f
	      a
	      (lambda (x) (+ x (/ (abs (- a b)) 999)))
	      b))



; exercise 1.31

(define (fixed-point f guess)
  (define (close-enough? a b)
    (< (abs (- a b)) .001))
  (let ((improved-guess (f guess)))
    (if (close-enough? improved-guess guess)
	guess
	(fixed-point f improved-guess))))

 