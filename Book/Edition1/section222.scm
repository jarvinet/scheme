; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.2.2


;-------------------------------------------------------------

; exercise 2.22

(list 1 (list 2 (list 3 4)))

;Value: (1 (2 (3 4)))


; Box-and-pointer:
;
;                 +-+-+              +-+-+
;  (1 (2 (3 4)))->| | |------------->| |/|
;                 +|+-+              +|+-+
;                  |                  |
;                  v                  v
;                 +-+                +-+-+          +-+-+
;                 |1|     (2 (3 4))->| | |--------->| |/|
;                 +-+                +|+-+          +|+-+
;                                     |              |
;                                     v              v
;                                    +-+            +-+-+        +-+-+
;                                    |2|     (3 4)->| | |------->| |/|
;                                    +-+            +|+-+        +|+-+
;                                                    |            |
;                                                    v            v
;                                                   +-+          +-+
;                                                   |3|          |4|
;                                                   +-+          +-+
;

; Interpretation as a tree:
;
;                            |
; 			  +--+--+
; 			  |	|
; 			  1	|
; 			     +--+--+
; 			     |     |
; 			     2	   |
; 				+--+--+
; 				|     |
; 				3     4
; 


;-------------------------------------------------------------

; exercise 2.23

(define a '(1 (2 3 (5 7) 9)))

; (cdr a)
; ((2 3 (5 7) 9))
; (car a)
; (2 3 (5 7) 9)
; (cdr a)
; (3 (5 7) 9)
; (cdr a)
; ((5 7) 9)
; (car a)
; (5 7)
; (cdr a)
; (7)
; (car a)
; 7

(car (cdr (car (cdr (cdr (car (cdr a)))))))

(define a '((7)))

; (car a)
; (7)
; (car a)
; 7

(car (car a))

(define a '(1 (2 (3 (4 (5 (6 7)))))))

; (cdr a)
; ((2 (3 (4 (5 (6 7))))))
; (car a)
; (2 (3 (4 (5 (6 7)))))
; (cdr a)
; ((3 (4 (5 (6 7)))))
; (car a)
; (3 (4 (5 (6 7))))
; (cdr a)
; ((4 (5 (6 7))))
; (car a)
; (4 (5 (6 7)))
; (cdr a)
; ((5 (6 7)))
; (car a)
; (5 (6 7))
; (cdr a)
; ((6 7))
; (car a)
; (6 7)
; (cdr a)
; (7)
; (car a)
; 7

(car (cdr (car (cdr (car (cdr (car (cdr (car (cdr (car (cdr a))))))))))))


;-------------------------------------------------------------

; exercise 2.24


(define x (list 1 2 3))
(define y (list 4 5 6))

(append x y) ;Value: (1 2 3 4 5 6)
(cons x y)   ;Value: ((1 2 3) 4 5 6)
(list x y)   ;Value: ((1 2 3) (4 5 6))

;-------------------------------------------------------------

(define (count-leaves x)
  (cond ((null? x) 0)
	((not (pair? x)) 1)  ; 1st edition uses "atom?" in place of "pair?"
	(else (+ (count-leaves (car x))
		 (count-leaves (cdr x))))))

;-------------------------------------------------------------

; exercise 2.25

(define (deep-reverse list)
  (define (iter x answer)
    (cond ((null? x) answer)
	  ((not (pair? x)) x)
	  (else
	   (let ((sublist-reversed (iter (car x) nil)))
	     (iter (cdr x)
		   (cons sublist-reversed answer))))))
  (iter list nil))


;-------------------------------------------------------------

; exercise 2.26

(define (fringe x)
  (cond ((null? x) nil)
	((not (pair? x)) (list x))
	(else
	 (append (fringe (car x))
		 (fringe (cdr x))))))


;-------------------------------------------------------------

; exercise 2.27

(define (make-mobile left right)
  (list left right))

(define (make-branch length structure)
  (list length structure))

; a

(define (left-branch mobile)
  (car mobile))

(define (right-branch mobile)
  (car (cdr mobile)))

(define (branch-length branch)
  (car branch))

(define (branch-structure branch)
  (car (cdr branch)))

; b

(define (total-weight mobile)
  (if (not (pair? mobile))
      mobile
      (+ (total-weight (branch-structure (left-branch mobile)))
	 (total-weight (branch-structure (right-branch mobile))))))

; c

(define (balanced? mobile)
  (cond ((not (pair? mobile)) #t)
	(else
	 (let ((left-torque (* (branch-length (left-branch mobile))
			       (total-weight (branch-structure (left-branch mobile)))))
	       (right-torque (* (branch-length (right-branch mobile))
				(total-weight (branch-structure (right-branch mobile))))))
	   (and (= left-torque right-torque)
		(balanced? (branch-structure (left-branch mobile)))
		(balanced? (branch-structure (right-branch mobile))))))))

; d
;
; Only a small change: right-branch must be converted to
;	 
;      (define (right-branch mobile)
;       (cdr mobile))
;
; branch-structure must be converted to
;
;      (define (branch-structure branch)
;       (cdr branch))


