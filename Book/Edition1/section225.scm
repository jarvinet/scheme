; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.2.5

; Sets as unordered lists

(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else
	 (element-of-set? x (cdr set)))))

(define (adjoin-set x set)
  (if (element-of-set? x set)
      set
      (cons x set)))

(define (intersection-set set1 set2)
  (cond ((or (null? set1) (null? set2)) '())
	((element-of-set? (car set1) set2)
	 (cons (car set1)
	       (intersection-set (cdr set1) set2)))
	(else
	 (intersection-set (cdr set1) set2))))


;-------------------------------------------------------------

; exercise 2.33

(define (union-set set1 set2)
  (cond ((and (null? set1) (null? set2)) '())
	((null? set1)
	 (adjoin-set (car set2)
		     (union-set set1 (cdr set2))))
	(else
	 (adjoin-set (car set1)
		     (union-set (cdr set1) set2)))))

;-------------------------------------------------------------

; Sets as ordered lists

(define (element-of-set? x set)
  (cond ((null? set) false)
	((= x (car set)) true)
	((< x (car set)) false)
	(else (element-of-set x (cdr set)))))

;-------------------------------------------------------------

; exercise 2.35

(define (adjoin-set x set)
  (cond ((null? set) (list x))
	((= x (car set)) set)
	((< x (car set))
	 (cons x set))
	(else
	 (cons (car set)
	       (adjoin-set x (cdr set))))))

;-------------------------------------------------------------

(define (intersection-set set1 set2)
  (if (or (null? set1) (null? set2))
      '()
      (let ((x1 (car set1)) (x2 (car set2)))
	(cond ((= x1 x2)
	       (cons x1
		     (intersection-set (cdr set1)
				       (cdr set2))))
	      ((< x1 x2)
	       (intersection-set (cdr set1) set2))
	      ((< x2 x1)
	       (intersection-set set1
				 (cdr set2)))))))

	      
;-------------------------------------------------------------

; exercise 2.36

(define (union-set set1 set2)
  (cond ((null? set1) set2)
	((null? set2) set1)
	(else
	 (let ((x1 (car set1)) (x2 (car set2)))
	   (cond ((= x1 x2)
		  (cons x1
			(union-set (cdr set1)
				   (cdr set2))))
		 ((< x1 x2)
		  (cons x1
			(union-set (cdr set1) set2)))
		 ((< x2 x1)
		  (cons x2
			(union-set set1
				   (cdr set2)))))))))

;-------------------------------------------------------------

; Sets as binary trees

(define (entry tree) (car tree))

(define (left-branch tree) (cadr tree))

(define (right-branch tree) (caddr tree))

(define (make-tree entry left right)
  (list entry left right))

(define (element-of-set? x set)
  (cond ((null? set) false)
	((= x (entry set)) true)
	((< x (entry set))
	 (element-of-set x (left-branch set)))
	((> x (entry set))
	 (element-of-set x (right-branch set)))))

(define (adjoin-set x set)
  (cond ((null? set) (make-tree x '() '()))
	((= x (entry set)) set)
	((< x (entry set))
	 (make-tree (entry set)
		    (adjoin-set x
				(left-branch set))
		    (right-branch set)))
	((> x (entry set))
	 (make-tree (entry set)
		    (left-branch set)
		    (adjoin-set x
				(right-branch set))))))

