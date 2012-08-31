; Structure and Interpretation of Computer Programs, 2nd edition


;;;Code from SECTION 4.3.3, modified as needed to run it

(define (amb? exp) (tagged-list? exp 'amb))
(define (amb-choices exp) (cdr exp))

;; analyze from 4.1.6, with clause from 4.3.3 added
;; and also support for Let
(define (analyze exp)
  (cond ((self-evaluating? exp) 
         (analyze-self-evaluating exp))
        ((quoted? exp) (analyze-quoted exp))
        ((variable? exp) (analyze-variable exp))
        ((assignment? exp) (analyze-assignment exp))
        ((definition? exp) (analyze-definition exp))
        ((if? exp) (analyze-if exp))
        ((lambda? exp) (analyze-lambda exp))
        ((sequence? exp) (analyze-sequence (begin-actions exp)))
        ((cond? exp) (analyze (cond->if exp)))
        ((let? exp) (analyze (let->combination exp)))
        ((amb? exp) (analyze-amb exp))
        ((application? exp) (analyze-application exp))
        (else
         (error "Unknown expression type -- ANALYZE" exp))))

(define (ambeval exp env succeed fail)
  ((analyze exp) env succeed fail))


(define (analyze-self-evaluating exp)
  (lambda (env succeed fail)
    (succeed exp fail)))

(define (analyze-quoted exp)
  (let ((qtext (quote-text exp)))
    (lambda (env succeed fail)
      (succeed qtext fail))))

(define (analyze-variable exp)
  (lambda (env succeed fail)
    (succeed (env-lookup-variable-value exp env)
	     fail)))

(define (analyze-lambda exp)
  (let ((pars (lambda-parameters exp))
	(proc (analyze-sequence (lambda-body exp))))
    (lambda (env succeed fail)
      (succeed (procedure-make pars proc env)
	       fail))))

(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
	(cproc (analyze (if-consequent exp)))
	(aproc (analyze (if-alternative exp))))
    (lambda (env succeed fail)
      (pproc env
	     (lambda (pred-value fail2)
	       (if (true? pred-value)
		   (cproc env succeed fail2)
		   (aproc env succeed fail2)))
	     fail))))

(define (analyze-definition exp)
  (let ((var (definition-variable exp))
	(vproc (analyze (definition-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (env-define-variable! var val env)
	       (succeed 'ok fail2))
	     fail))))


(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
	(vproc (analyze (assignment-value exp))))
    (lambda (env succeed fail)
      (vproc env
	     (lambda (val fail2)
	       (let ((old-value (env-lookup-variable-value var env)))
		 (env-set-variable-value! var val env)
		 (succeed 'ok
			  (lambda ()
			    (env-set-variable-value! var old-value env)
			    (fail2)))))
	     fail))))


(define (analyze-sequence exp)
  (define (sequentially proc1 proc2)
    (lambda (env succeed fail)
      (proc1 env
	     (lambda (value fail2)
	       (proc2 env succeed fail2))
	     fail)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
	first-proc
	(loop (sequentially first-proc (car rest-procs))
	      (cdr rest-procs))))
  (let ((procs (map analyze exp)))
    (if (null? procs)
	(error "empty sequence -- ANALYZE-SEQUENCE"))
    (loop (car procs) (cdr procs))))



(define (analyze-application exp)
  (let ((pproc (analyze (operator exp)))
	(aprocs (map analyze (operands exp))))
    (lambda (env succeed fail)
      (pproc env
	     (lambda (proc fail2)
	       (get-args aprocs
			 env
			 (lambda (args fail3)
			   (execute-application
			    proc args succeed fail3))
			 fail2))
	     fail))))


(define (get-args aprocs env succeed fail)
  (if (null? aprocs)
      (succeed '() fail)
      ((car aprocs) env
		  (lambda (arg fail2)
		    (get-args (cdr aprocs)
			      env
			      (lambda (args fail3)
				(succeed (cons arg args)
					 fail3))
			      fail2))
		  fail)))


(define (execute-application proc args succeed fail)
  (cond ((primitive-procedure? proc)
	 (succeed (apply-primitive-procedure proc args)
		  fail))
	((compound-procedure? proc)
	 ((procedure-body proc)
	  (env-extend (procedure-parameters proc)
		      args
		      (procedure-env proc))
	  succeed
	  fail))
	(else
	 (error "Unknown procedure type -- EXECUTE-APPLICATION"
		proc))))


(define (analyze-amb exp)
  (let ((procs (map analyze (amb-choices exp))))
    (lambda (env succeed fail)
      (define (try-next choices)
	(if (null? choices)
	    (fail)
	    ((car choices) env
			   succeed
			   (lambda ()
			     (try-next (cdr choices))))))
      (try-next procs))))


(define input-prompt ";;; AmbEval input:")
(define output-prompt ";;; AmbEval value:")

(define (driver-loop)
  (define (internal-loop try-again)
    (prompt-for-input input-prompt)
    (let ((input (read)))
      (if (eq? input 'try-again)
	  (try-again)
	  (begin
	    (newline)
	    (display ";;; Starting a new problem ")
	    (ambeval input
		     the-global-environment
		     ;; ambeval success
		     (lambda (val next-alternative)
		       (announce-output output-prompt)
		       (user-print val)
		       (internal-loop next-alternative))
		     ;; ambeval failure
		     (lambda ()
		       (announce-output
			";;; There are no more values of")
		       (user-print input)
		       (driver-loop)))))))
  (internal-loop
   (lambda ()
     (newline)
     (display ";;; There is no current problem")
     (driver-loop))))


;;

(define primitive-procedures
  (list (list 'car car)
        (list 'cadr cadr)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list 'list list)
        (list 'memq memq)
        (list 'member member)
        (list 'not not)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '= =)
        (list '> >)
        (list '>= >=)
        (list 'abs abs)
        (list 'remainder remainder)
        (list 'integer? integer?)
        (list 'sqrt sqrt)
        (list 'eq? eq?)
	(list 'even? even?)
;;      more primitives
        ))


; load aneval.scm before loading this file
; (define the-global-environment (setup-environment))
; (driver-loop)
