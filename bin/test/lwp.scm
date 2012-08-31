; Lightweight Processes implemented with call/cc

; From the book
; The Scheme Programming Language, Second Edition
; by R. Kent Dybvig



(define lwp-list '())

(define lwp
  (lambda (thunk)
    (set! lwp-list (append lwp-list (list thunk)))))

(define start
  (lambda ()
    (let ((next (car lwp-list)))
      (set! lwp-list (cdr lwp-list))
      (next))))

(define pause
  (lambda ()
    (call/cc
      (lambda (k)
        (lwp (lambda () (k #f)))
        (start))))) 

; The following light-weight processes cooperate to print an indefinite sequence 
; of the string "hey!". 
(lwp (lambda () (define (f) (pause) (display "h") (f)) (f)))
(lwp (lambda () (define (f) (pause) (display "e") (f)) (f)))
(lwp (lambda () (define (f) (pause) (display "y") (f)) (f)))
(lwp (lambda () (define (f) (pause) (display "!") (f)) (f)))
(lwp (lambda () (define (f) (pause) (newline)     (f)) (f)))
(start) 
