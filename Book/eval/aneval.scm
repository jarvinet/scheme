; Structure and Interpretation of Computer Programs, 2nd edition


; analyzing evaluator


;-----------------------------------
; Misc

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

(define (list-of-values operands env)
  (if (null? operands)
      '()
      (cons (eval (car operands) env)
	    (list-of-values (cdr operands) env))))

(define (true? x) (not (eq? x false)))
(define (false? x) (eq? x false))

; I think it is better not to rename this apply
; and use name "myapply" for the apply defined in this evaluator
; so multiple loadings of this file does not lose the original apply
; (define apply-in-underlying-scheme apply)

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (filter predicate stream)
  (cond ((null? stream)
	 '())
	((predicate (car stream))
	 (cons (car stream) (filter predicate (cdr stream))))
	(else (filter predicate (cdr stream)))))

;-----------------------------------
; Binding is a name-value pair:
;
;        +-+-+
;        | | |
;        +-+-+
;         | | 
;         V V 
;      name value

(define (binding-make name value) (cons name value))
(define (binding-name binding)    (car binding))
(define (binding-value binding)   (cdr binding))

(define (binding-set-value! binding new-value)
  (set-cdr! binding new-value))


;-----------------------------------
; Frame is a list of bindings, with a "head node" whose car is *frame*:
;
;    +-+-+       +-+-+       +-+-+
;    | | +------>| | |------>| |/|
;    +-+-+       +-+-+       +-+-+
;     |           |           |
;     V           V           V
;  *frame*      +-+-+       +-+-+
;               | | |       | | |
;               +-+-+       +-+-+
;                | |         | |
;                V V         V V
;             name value  name value
 
(define (frame-make)
  (cons '*frame* '()))

(define (frame-add-binding! binding frame)
  (let ((pair (cons binding (cdr frame))))
    (set-cdr! frame pair)))

(define (frame-lookup-binding frame name)
  (define (iter bindings)
    (if (null? bindings)
	'()
	(let ((binding (car bindings)))
	  (if (eq? (binding-name binding) name)
	      binding
	      (iter (cdr bindings))))))
  (iter (cdr frame)))


;-----------------------------------
; Environment is a list of frames

(define (first-frame env) (car env))

(define (env-enclosing-environment env) (cdr env))

(define (env-lookup-binding env name)
  (define (env-loop env)
    (if (eq? env the-empty-environment)
	'()
	(let ((frame (first-frame env)))
	  (let ((binding (frame-lookup-binding frame name)))
	    (if (null? binding)
		(env-loop (env-enclosing-environment env))
		binding)))))
  (env-loop env))

(define (env-extend vars vals base-env)
  (if (= (length vars) (length vals))
      (let ((frame (frame-make)))
	(define (loop frame vars vals)
	  (if (null? vars)
	      frame
	      (begin (frame-add-binding!
		      (binding-make (car vars) (car vals))
		      frame)
		     (loop frame (cdr vars) (cdr vals)))))
	(loop frame vars vals)
	(cons frame base-env))
      (if (< (length vars) (length vals))
	  (error "Too many arguments supplied" vars vals)
	  (error "Too few arguments supplied" vars vals))))

(define (env-lookup-variable-value var env)
  (let ((binding (env-lookup-binding env var)))
    (if (null? binding)
	(error "Unbound variable" var)
	(let ((value (binding-value binding)))
	  (if (eq? value '*unassigned*)
	      (error "Unassigned variable" var)
	      value)))))

(define (env-set-variable-value! var val env)
  (let ((binding (env-lookup-binding env var)))
    (if (null? binding)
	(error "Unbound variable -- SET!" var)
	(binding-set-value! binding val))))

(define (env-define-variable! var val env)
  (let ((frame (first-frame env)))
    (let ((binding (frame-lookup-binding frame var)))
      (if (null? binding)
	  (frame-add-binding! (binding-make var val) frame)
	  (binding-set-value! binding val)))))


;-----------------------------------
; Procedure application
; (foo 1 2)

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

; A compound procedure is applied as follows:
; 1) Create a new frame (extend environment) where the operands
;    of the application are bound to the parameters of the procedure.
;    The enclosing environment of the new frame is the environment
;    packaged with the procedure to be applied.
; 2) The body of the procedure is evaluated in the new environment.
(define (myapply procedure arguments)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure procedure arguments))
	((compound-procedure? procedure)
	 (sequence-eval (procedure-body procedure)
			(env-extend
			 (procedure-parameters procedure)
			 arguments
			 (procedure-env procedure))))
	(else
	 (error "Unknown procedure type - myapply"
		procedure))))


;-----------------------------------
; Self-evaluating expressions

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))


;-----------------------------------
; Variables

(define (variable? exp) (symbol? exp))


;-----------------------------------
; Quotation
; Special form
; 'foo

(define (quoted? exp) (tagged-list? exp 'quote))
(define (quote-text exp) (cadr exp))


;-----------------------------------
; Assignment
; Special form
; (set! foo 1)

(define (assignment? exp) (tagged-list? exp 'set!))
(define (assignment-variable exp) (cadr exp))
(define (assignment-value exp) (caddr exp))

(define (assignment-make variable value)
  (list 'set! variable value))

(define (assignment-eval exp env)
  (let ((var (assignment-variable exp))
	(value (eval (assignment-value exp) env)))
    (env-set-variable-value! var value env)
    var))

;-----------------------------------
; Definition
;   (define foo 1)          ; case 1 (Special form)
;   (define (foo bar) body) ; case 2 (Derived expression)
; case 2 can be converted to an equivalent case 1 form:
;   (define foo (lambda (bar) body))

(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)     ; case 1
      (caadr exp)))  ; case 2

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)      ; case 1
      (lambda-make     ; case 2
       (cdadr exp)
       (cddr exp))))

(define (definition-eval exp env)
  (let ((var (definition-variable exp))
	(val (eval (definition-value exp) env)))
    (env-define-variable! var val env)
    var))
      

;-----------------------------------
; If
; Special form
; (if condition consequent alternative)

(define (if? exp) (tagged-list? exp 'if))
(define (if-predicate exp)   (cadr exp))
(define (if-consequent exp)  (caddr exp))

; return false if there is no alternative
(define (if-alternative exp)
  (if (null? (cdddr exp))
      'false 
      (cadddr exp)))

(define (if-make predicate consequent alternative)
  (list 'if predicate consequent alternative))

(define (if-eval exp env)
    (if (true? (eval (if-predicate exp) env))
	(eval (if-consequent exp) env)
	(eval (if-alternative exp) env)))


;-----------------------------------
; lambda expression
; Special form
; (lambda (par1 par2) body-foo)

(define (lambda-make parameters body)
  (cons 'lambda (cons parameters body)))

(define (lambda? exp) (tagged-list? exp 'lambda))
(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))


;-----------------------------------
; Procedures

(define (compound-procedure? procedure)
  (tagged-list? procedure 'procedure))

(define (procedure-make parameters body env)
  (list 'procedure parameters body env))

(define (procedure-parameters procedure) (cadr procedure))
(define (procedure-body procedure) (caddr procedure))
(define (procedure-env procedure) (cadddr procedure))


;-----------------------------------
; Primitives from the underlying implementation 
; (primitive impl)

(define primitive-procedures
  (list (list 'car car)
	(list 'cdr cdr)
	(list 'cons cons)
	(list 'null? null?)
	(list '+ +)
	(list '- -)
	(list '* *)
	(list '= =)
	(list '< <)
	(list '> >)
	;; list more primitives here
	))

(define (primitive-procedure? procedure)
  (tagged-list? procedure 'primitive))

(define (primitive-implementation primitive)
  (cadr primitive))

(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (primitive-implementation proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply (primitive-implementation proc) args))


;-----------------------------------
; A sequence of expressions
; Special form
; (begin expr1 expr2 ...)

(define (sequence? exp) (tagged-list? exp 'begin))
(define (sequence-actions exp) (cdr exp))

(define (sequence-make seq) (cons 'begin seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (sequence-make seq))))

(define (sequence-eval exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (sequence-eval (rest-exps exps) env))))


;-----------------------------------
; A conditional expression
; special form derived expression
;
;   (cond (predicate1 consequent1)
;         (predicate2 consequent2)
;         (else       alternative))
;
; is equivalent to
;
;   (if (predicate1)
;       consequent1
;       (if (predicate2)
;           consequent2
;           alternative))

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
      'false
      (let ((first (car clauses))
	    (rest (cdr clauses)))
	(if (cond-else-clause? first)
	    (if (null? rest)
		(sequence->exp (cond-actions first))
		(error "else not last clause -- cond->if" clauses))
	    (if-make (cond-predicate first)
		     (sequence->exp (cond-actions first))
		     (expand-clauses rest))))))



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
		     (list (assignmenô-make name (lambda-make variables body))
			   (cons name expressions))))
	  (else
	   (cons (lambda-make variables body) expressions)))))

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

; Exercise 4.7
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
	 (bindings (map (lambda (var) (list var ''*unassigned*)) variables))
	 (assignments (map (lambda (var val) (assignment-make var val))
			   variables values)))
    (let-make bindings
	      (append assignments (let-body exp)))))
 


;-----------------------------------
; Driver

(define the-empty-environment (frame-make))

(define input-prompt ";;; aneval input: ")
(define output-prompt ";;; aneval value: ")

(define (driver-loop)
  (prompt-for-input input-prompt)
  (let ((input (read)))
    (let ((output (eval input the-global-environment)))
      (announce-output output-prompt)
      (user-print output)))
  (driver-loop))

(define (prompt-for-input string)
  (newline) (newline) (display string) (newline))

(define (announce-output string)
  (newline) (display string))

(define (user-print object)
  (if (compound-procedure? object)
      (display (list 'compound-procedure
                     (procedure-parameters object)
                     (procedure-body object)
                     '<procedure-env>))
      (display object)))
	     
(define (setup-environment)
  (let ((initial-env
         (env-extend (primitive-procedure-names)
		     (primitive-procedure-objects)
		     the-empty-environment)))
    (env-define-variable! 'true true initial-env)
    (env-define-variable! 'false false initial-env)
    initial-env))



;-----------------------------------
;;; The analyzing evaluator starts here


(define (eval exp env)
  ((analyze exp) env))


(define (analyze exp)
  (cond ((self-evaluating? exp) (analyze-self-evaluating exp))
	((variable? exp) (analyze-variable exp))
	((quoted? exp) (analyze-quote exp))
	((assignment? exp) (analyze-assignment exp))
	((definition? exp) (analyze-definition exp))
	((if? exp) (analyze-if exp))
	((lambda? exp) (analyze-lambda exp))
	((sequence? exp)
	 (sequence-eval (analyze-sequence exp)))
        ((cond? exp) (analyze (cond->if exp)))
	((application? exp) (analyze-application exp))
	(else
	 (error "Unknown expression type -- eval" exp))))



; Return an execution procedure that just returns the
; expression with no regard to the environment
(define (analyze-self-evaluating exp)
  (lambda (env) exp))


(define (analyze-variable exp)
  (lambda (env)
    (env-lookup-variable-value exp env))) 


(define (analyze-quote exp)
  (let ((qval (quote-text exp)))
    (lambda (env) exp)))


(define (analyze-assignment exp)
  (let ((var (assignment-variable exp))
	(vproc (analyze (assignment-value exp))))
    (lambda (env)
      (env-set-variable-value! var (vproc env) env))))


(define (analyze-definition exp)
  (let ((var (definition-variable exp))
	(vproc (analyze (definition-value exp))))
    (lambda (env)
      (env-define-variable! var (vproc env) env))))


(define (analyze-if exp)
  (let ((pproc (analyze (if-predicate exp)))
	(cproc (analyze (if-consequent exp)))
	(aproc (analyze (if-alternative exp))))
    (lambda (env)
      (if (true? (pproc env))
	  (cproc env)
	  (aproc env)))))


(define (analyze-lambda exp)
  (let ((parameters (lambda-parameters exp))
	(body (analyze-sequence (lambda-body exp))))
    (lambda (env)
      (procedure-make parameters body env))))


(define (analyze-sequence exp)
  (define (sequentially p1 p2)
    (lambda (env) (p1 env) (p2 env)))
  (define (loop first-proc rest-procs)
    (if (null? rest-procs)
	first-proc
	(loop (sequentially first-proc (car rest-procs))
	      (cdr rest-procs))))
  (let ((procs (map analyze exp)))
    (if (null? procs)
	(error "empty sequence -- ANALYZE")
	(loop (car procs) (cdr procs)))))


(define (analyze-application exp)
  (let ((operator (analyze (operator exp)))
	(operands (map analyze (operands exp))))
    (lambda (env)
      (execute-application (operator env)
			   (map (lambda (proc) (proc env))
				operands)))))


(define (execute-application procedure arguments)
  (cond ((primitive-procedure? procedure)
	 (apply-primitive-procedure procedure arguments))
	((compound-procedure? procedure)
	 ((procedure-body procedure)
	  (env-extend (procedure-parameters procedure)
		      arguments
		      (procedure-env procedure))))
	(else
	 (error "Unknown procedure type -- EXECUTE-APPLICATION"
		procedure))))


;--------------------------------------------

;;;Following are commented out so as not to be evaluated when
;;; the file is loaded.

; (define the-global-environment (setup-environment))
; (driver-loop)

