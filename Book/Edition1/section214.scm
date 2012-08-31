; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.1.4

(define (intadd x y)
  (make-interval (+ (lower-bound x) (lower-bound y))
		 (+ (upper-bound x) (upper-bound y))))

(define (intmul x y)
  (let ((p1 (* (lower-bound x) (lower-bound y)))
	(p2 (* (lower-bound x) (upper-bound y)))
	(p3 (* (upper-bound x) (lower-bound y)))
	(p4 (* (upper-bound x) (upper-bound y))))
    (make-interval (min p1 p2 p3 p4)
		   (max p1 p2 p3 p4))))

(define (intdiv x y)
  (intmul x
	  (make-interval (/ 1 (upper-bound y))
			 (/ 1 (lower-bound y)))))


;-------------------------------------------------------------

; exercise 2.6

(define (make-interval a b) (cons a b))

(define (lower-bound x) (car x))

(define (upper-bound x) (cdr x))


;-------------------------------------------------------------

; exercise 2.7

(define (intsub x y)
  (make-interval (- (lower-bound x) (lower-bound y))
		 (- (upper-bound x) (upper-bound y))))
  


;-------------------------------------------------------------

; exercise 2.9

(define (intdiv x y)
  (if (= (upper-bound y) (lower-bound y))
      (error "intdiv: Zero interval divisor")
      (intmul x
	      (make-interval (/ 1 (upper-bound y))
			     (/ 1 (lower-bound y))))))

;-------------------------------------------------------------

; exercise 2.10

; One hell of a mess, I wouldn't want to have to maintain this.
; This probalby could be simplified by using symmetry.
  
; (define (intmul x y)
;   (cond ((and (< (upper-bound x) 0)
; 	      (< (upper-bound y) 0))
; 	 (make-interval (* (upper-bound x) (upper-bound y))
; 			(* (lower-bound x) (lower-bound y))))
; 	((and (< (upper-bound x) 0)
; 	      (and (< (lower-bound y) 0)
; 		   (> (upper-bound y) 0)))
; 	 (make-interval (* (lower-bound x) (upper-bound y))
; 			(* (lower-bound x) (lower-bound y))))
; 	((and (< (upper-bound x) 0)
; 	      (> (lower-bound y 0)))
; 	 (make-interval (* (lower-bound x) (upper-bound y))
; 			(* (upper-bound x) (lower-bound y))))
; 	((and (and (< (lower-bound x) 0)
; 		   (> (upper-bound x) 0))
; 	      (< (upper-bound y) 0))
; 	 (make-interval (* (upper-bound x) (lower-bound y))
; 			(* (lower-bound x) (lower-bound y))))
; 	((and (and (< (lower-bound x) 0)
; 		   (> (upper-bound x) 0))
; 	      (and (< (lower-bound y) 0)
; 		   (> (upper-bound y) 0)))
; 	 (let ((p1 (* (lower-bound x) (lower-bound y)))
; 	       (p2 (* (lower-bound x) (upper-bound y)))
; 	       (p3 (* (upper-bound x) (lower-bound y)))
; 	       (p4 (* (upper-bound x) (upper-bound y))))
; 	   (make-interval (min p1 p2 p3 p4)
; 			  (max p1 p2 p3 p4))))
; 	((and (and (< (lower-bound x) 0)
; 		   (> (upper-bound x) 0))
; 	      (> (lower-bound y) 0))
; 	 (make-interval (* (lower-bound x) (upper-bound y))
; 			(* (upper-bound x) (upper-bound y))))
; 	((and (> (lower-bound x) 0)
; 	      (< (upper-bound y) 0))
; 	 (make-interval (* (upper-bound x) (lower-bound y))
; 			(* (lower-bound x) (upper-bound y))))
; 	((and (> (lower-bound x) 0)
; 	      (and (< (lower-bound y) 0)
; 		   (> (upper-bound y) 0)))
; 	 (make-interval (* (upper-bound x) (lower-bound y))
; 			(* (upper-bound x) (upper-bound y))))
; 	((and (> (lower-bound x) 0)
; 	      (> (lower-bound y) 0))
; 	 (make-interval (* (lower-bound x) (lower-bound y))
; 			(* (upper-bound x) (upper-bound y))))))
; 

;-------------------------------------------------------------

(define (center-width c w)
  (make-interval (- c w) (+ c w)))

(define (center i)
  (/ (+ (lower-bound i) (upper-bound i)) 2))

(define (width i)
  (/ (- (upper-bound i) (lower-bound i)) 2))

;-------------------------------------------------------------

; exercise 2.11

(define (make-center-percent c p)
  (let ((w (* c p)))
    (center-width c w)))

(define (percent i)
  (let ((c (center i))
	(w (width i)))
    (/ w c)))


;-------------------------------------------------------------


(define (par1 r1 r2)
  (intdiv (intmul r1 r2)
	  (intadd r1 r2)))

(define (par2 r1 r2)
  (let ((one (make-interval 1 1)))
    (intdiv one
	    (intadd (intdiv one r1)
		    (intdiv one r2)))))
