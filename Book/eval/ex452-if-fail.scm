; Structure and Intepretation of Computer Programs, 2nd edition

; Solution to the exercise 4.52

; The actual solution to the exercise is the procedure analyze-if-fail.
; Everything else is just support so this file can be loaded into the
; Scheme evaluator.


(load "aneval.scm")
(load "ambeval.scm")

; Override the analyze from ambeval.scm to recognize the if-fail special form
(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((if-fail? exp) (analyze-if-fail exp)) ; exercise 4.52
        ((lambda? exp) (analyze-lambda exp))
        ((sequence? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((let? exp) (analyze (let->combination exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))


; Syntax procedure of the if-fail special form
(define (if-fail? exp) (tagged-list? exp 'if-fail))
(define (if-fail-expression exp) (cadr exp))
(define (if-fail-exception exp) (caddr exp))

; Analyze the expression and the exception.
; The execution procedure returned by analyze-if-fail calls the expression
; execution procedure and gives it a failure continuation that call the
; exception execution procedure.
(define (analyze-if-fail exp)
  (let ((expression-proc (analyze (if-fail-expression exp)))
	(exception-proc (analyze (if-fail-exception exp))))
    (lambda (env succeed fail)
      (expression-proc env
		       succeed
		       (lambda ()
			 (exception-proc env
					 succeed
					 fail))))))


(define the-global-environment (setup-environment))

(driver-loop)

(define (require a)
  (if (not a) (amb)))

(define (an-element-of items)
  (require (not (null? items)))
  (amb (car items) (an-element-of (cdr items))))

(if-fail (let ((x (an-element-of '(1 3 5))))
	   (require (even? x))
	   x)
	 'all-odd)

(if-fail (let ((x (an-element-of '(1 3 5 8))))
	   (require (even? x))
	   x)
	 'all-odd)
