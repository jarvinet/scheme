;;;;SCHEME SYNTAX FROM SECTION 4.1.2 OF STRUCTURE AND INTERPRETATION OF
;;;  COMPUTER PROGRAMS, TO SUPPORT CHAPTER 5
;;;;Loaded by compiler.scm (for use by compiler), and by eceval-support.scm
;;;; (for simulation of eceval machine operations)

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))


(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))


(define (variable? exp) (symbol? exp))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))


(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))


(define (begin? exp) (tagged-list? exp 'begin))
(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

;;;**following needed only to implement COND as derived expression,
;;; not needed by eceval machine in text.  But used by compiler

;; from 4.1.2
(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))


(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

(define (cond? exp) (tagged-list? exp 'cond))
(define (cond-clauses exp) (cdr exp))
(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))
(define (cond-predicate clause) (car clause))
(define (cond-actions clause) (cdr clause))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false                          ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))
;; end of Cond support


;; Begin(Added by tmj to support compilation of let, let*, letrec)

;-----------------------------------
; Assignment
; Special form
; (set! foo 1)

;(define (assignment? exp) (tagged-list? exp 'set!))
;(define (assignment-variable exp) (cadr exp))
;(define (assignment-value exp) (caddr exp))

(define (assignment-make variable value)
  (list 'set! variable value))


;-----------------------------------
; lambda expression
; Special form
; (lambda (par1 par2) body-foo)

(define (lambda-make parameters body)
  (cons 'lambda (cons parameters body)))

;(define (lambda? exp) (tagged-list? exp 'lambda))
;(define (lambda-parameters exp) (cadr exp))
;(define (lambda-body exp) (cddr exp))


;-----------------------------------
; Let special form
;
; let is of the form
;   (let
;    ((var1 exp1) (var2 exp2))
;    body)
; which is equivalent to 
;   ((lambda (var1 var2) body) exp1 exp2)


(define (let? exp) (tagged-list? exp 'let))
(define (let*? exp) (tagged-list? exp 'let*))
(define (letrec? exp) (tagged-list? exp 'letrec))
(define (named-let? exp) (not (pair? (cadr exp))))

(define (let-name exp)
  (cond ((named-let? exp) (cadr exp))
	(else '())))

(define (let-bindings exp)
  (cond ((named-let? exp) (caddr exp))
	(else (cadr exp))))

(define (let-body exp)
  (cond ((named-let? exp) (cdddr exp))
	(else (cddr exp))))
  
; Extract a list of variables from a let
(define (let-variables exp)
  (let ((bindings (let-bindings exp)))
    (map (lambda (binding) (car binding))
	 bindings)))

; Extract a list of expressions from a let    
(define (let-expressions exp)
  (let ((bindings (let-bindings exp)))
    (map (lambda (binding) (cadr binding))
	 bindings)))

(define (let-make bindings body)
  (cons 'let (cons bindings body)))

; Exercise 4.6
; Exercise 4.8
(define (let->combination exp)
  (let ((variables (let-variables exp))
	(expressions (let-expressions exp))
	(body (let-body exp))
	(name (let-name exp)))
    (cond ((named-let? exp)
	   (let-make (list (list name ''*unassigned*))
		     (list (assignment-make name (lambda-make variables body))
			   (cons name expressions))))
	  (else
	   (cons (lambda-make variables body) expressions)))))

(define (let*->nested-lets exp)
  (car (expand-bindings (let-bindings exp) (let-body exp))))

(define (expand-bindings bindings body)
  (if (null? bindings)
      body
      (list (let-make (list (first-exp bindings))
		      (expand-bindings (rest-exps bindings) body)))))

; Exercise 4.20
(define (letrec->let exp)
  (let* ((variables (let-variables exp))
	 (values (let-expressions exp))
	 (bindings
	  (map (lambda (var) (list var ''*unassigned*))
	       variables))
	 (assignments
	  (map (lambda (var val) (assignment-make var val))
	       variables values)))
    (let-make bindings
	      (append assignments (let-body exp)))))

;; End(Added by tmj to support compilation of let, let*, letrec)


;; Begin(Added by tmj to support compilation of internal defines)

(define (scan-out-defines body)
  (let ((defines (filter definition? body)))
    (if (null? defines)
	body
	(let ((variables
	       (map (lambda (exp) (definition-variable exp))
		    defines))
	      (values
	       (map (lambda (exp) (definition-value exp))
		    defines)))
	  (let ((bindings
		 (map (lambda (var) (list var ''*unassigned*))
		      variables))
		(assignments
		 (map (lambda (var val) (assignment-make var val))
		      variables values))
		(body-without-defines
		 (filter (lambda (exp) (not (definition? exp)))
			 body)))
	    (list (let-make bindings
			    (append assignments body-without-defines))))))))

;; End(Added by tmj to support compilation of internal defines)

