; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------


; Section 3.1.1

(define (make-withdraw balance)
  (lambda (amount)
    (if (>= balance amount)
	(sequence (set! balance (- balance amount))
		  balance)
	"Insufficient funds")))

(define (make-account balance)
  (define (withdraw amount)
    (if (>= balance amount)
	(sequence (set! balance (- balance amount))
		  balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch m)
    (cond ((eq? m 'withdraw) withdraw)
	  ((eq? m 'deposit)  deposit)
	  (else (error "Unknown request -- MAKE-ACCOUNT" m))))
  dispatch)


;-------------------------------------------------------------

; exercise 3.1

(define (make-accumulator sum)
  (lambda (increment)
    (set! sum (+ sum increment))
    sum))

(define a (make-accumulator 5))
;Value: "a --> #[compound-procedure 6]"

(a 10)
;Value: 15

(a 10)
;Value: 25


;-------------------------------------------------------------

; exercise 3.2

(define (make-monitored f)
  (let ((calls 0))
    (define (dispatch m)
      (cond ((eq? m 'how-many-calls?)
	     calls)
	    ((eq? m 'reset-count) 
	     (set! calls 0)
	     calls)
	    (else
	     (set! calls (1+ calls))
	     (f m))))
    dispatch))


;-------------------------------------------------------------

; exercise 3.3

(define (make-account balance password)
  (define (withdraw amount)
    (if (>= balance amount)
	(sequence (set! balance (- balance amount))
		  balance)
	"Insufficient funds"))
  (define (deposit amount)
    (set! balance (+ balance amount))
    balance)
  (define (dispatch pw m)
    (if (eq? pw password)
	(cond ((eq? m 'withdraw) withdraw)
	      ((eq? m 'deposit)  deposit)
	      (else (error "Unknown request -- MAKE-ACCOUNT" m)))
	(display "Incorrect password")))
  dispatch)


;-------------------------------------------------------------

; exercise 3.4

(define (make-account balance password)
  (let ((incorrect-password 0))
    (define (withdraw amount)
      (if (>= balance amount)
	  (sequence (set! balance (- balance amount))
		    balance)
	  "Insufficient funds"))
    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)
    (define (dispatch pw m)
      (if (eq? pw password)
	  (sequence (set! incorrect-password 0)
		    (cond ((eq? m 'withdraw) withdraw)
			  ((eq? m 'deposit)  deposit)
			  (else (error "Unknown request -- MAKE-ACCOUNT" m))))
	  (sequence (display "Incorrect password")
		    (set! incorrect-password (1+ incorrect-password))
		    (if (> incorrect-password 7)
			(display "Cops called")))))
    dispatch))


;-------------------------------------------------------------

; exercise 3.5

; First we modify make-account to accept command to add new passwords
; that enable the use of this account

(define (make-account balance password)
  (let ((incorrect-password 0)
	(passwords (list password)))
    (define (withdraw amount)
      (if (>= balance amount)
	  (sequence (set! balance (- balance amount))
		    balance)
	  "Insufficient funds"))
    (define (deposit amount)
      (set! balance (+ balance amount))
      balance)
    (define (add-password pw)
      (set! passwords (cons pw passwords)))
    (define (dispatch pw m)
      (if (memq pw passwords)
	  (sequence (set! incorrect-password 0)
		    (cond ((eq? m 'withdraw) withdraw)
			  ((eq? m 'deposit)  deposit)
			  ((eq? m 'add-password) add-password)
			  (else (error "Unknown request -- MAKE-ACCOUNT" m))))
	  (sequence (display "Incorrect password ")
		    (set! incorrect-password (1+ incorrect-password))
		    (if (> incorrect-password 7)
			(display "Cops called")))))
    dispatch))


(define (make-joint account password additional-password)
  ((account password 'add-password) additional-password)
  account)


;-------------------------------------------------------------

; exercise 3.6

; In the following state machine the transitions are labeled
; with x/y where x is the triggering input and y is the output.
; State 0 is the start state.
;
;           +-----+        0/0          +-----+
;           |     |-------------------->|     |
;           |     |        1/1          |     |
;           |state|-------------------->|state|
;           |  0  |       0,1/0         |  1  |
;           |     |<--------------------|     |
;           +-----+                     +-----+
 
(define f
  (let ((state 0))
    (lambda (arg)
      (cond ((= state 0)
	     (set! state 1)
	     arg)
	    ((= state 1)
	     (set! state 0)
	     0)))))


