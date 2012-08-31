; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.2.1

(define (nth n x)
  (if (= n 0)
      (car x)
      (nth (- n 1) (cdr x))))


;-------------------------------------------------------------

; exercise 2.16

(define (last x)
  (cond ((= (length x) 0)
	 nil)
	((= (length x) 1)
	 (car x))
	(else
	 (last (cdr x)))))

; alternative, relying on "nth":

(define (last2 x)
  (let ((l (length x)))
    (if (= l 0)
	nil
	(nth (- l 1) x))))


;-------------------------------------------------------------

; exercise 2.17

(define (reverse x)
  (define (iter list answer)
    (if (null? list)
	answer
	(iter (cdr list)
	      (cons (car list) answer))))
  (iter x nil))

; iterative version seems to be much easier to do that the recursive

    
;-------------------------------------------------------------

; exercise 2.18
      
(define (square-list x)
  (if (null? x)
      nil
      (cons (square (car x))
	    (square-list (cdr x)))))


;-------------------------------------------------------------

; exercise 2.19

(define (square-list2 x)
  (define (iter list answer)
    (if (null? list)
	answer
	(iter (cdr list)
	      (cons (square (car list))
		    answer))))
  (iter x nil))

; answer is initially empty, list items are cons'ed to the answer one by one
; cons'ing always puts new items on the head of the list so the first
; item to be cons'ed becomes the last item in the answer-list

(define (square-list3 x)
  (define (iter list answer)
    (if (null? list)
	answer
	(iter (cdr list)
	      (cons answer
		    (square (car list))))))
  (iter x nil))

; I think, if we have a primitive to append new items to the head of the list
; (cons) bu no to the tail of the list, it is easier to reverse a list using
; an iterative process.
; Doing an operation that preserves the order of the items in the list is
; easier with a recursive process.


;-------------------------------------------------------------

; exercise 2.20

(define (mapcar p list)
  (if (null? list)
      nil
      (cons (p (car list))
	    (mapcar p (cdr list)))))

