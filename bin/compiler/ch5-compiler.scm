;;;;COMPILER FROM SECTION 5.5 OF
;;;; STRUCTURE AND INTERPRETATION OF COMPUTER PROGRAMS

;;;;Matches code in ch5.scm

;;;;This file can be loaded into Scheme as a whole.
;;;;**NOTE**This file loads the metacircular evaluator's syntax procedures
;;;;  from section 4.1.2
;;;;  You may need to change the (load ...) expression to work in your
;;;;  version of Scheme.

;;;;Then you can compile Scheme programs as shown in section 5.5.5

;;**implementation-dependent loading of syntax procedures


;;;SECTION 5.5.1

(define (compile exp target linkage)
  (cond ((self-evaluating? exp)
         (compile-self-evaluating exp target linkage))
        ((quoted? exp)
	 (compile-quoted exp target linkage))
        ((variable? exp)
         (compile-variable exp target linkage))
        ((assignment? exp)
         (compile-assignment exp target linkage))
        ((definition? exp)
         (compile-definition exp target linkage))
        ((if? exp)
	 (compile-if exp target linkage))
        ((lambda? exp)
	 (compile-lambda exp target linkage))
        ((begin? exp)
         (compile-sequence (begin-actions exp) target linkage))
        ((cond? exp)
	 (compile (cond->if exp) target linkage))
 	((let? exp)
	 (compile (let->combination exp) target linkage))
 	((let*? exp)
	 (compile (let*->nested-lets exp) target linkage))
 	((letrec? exp)
	 (compile (letrec->let exp) target linkage))
	((and? exp)
	 (compile-and (and-expressions exp) target linkage))
	((or? exp)
	 (compile-or (or-expressions exp) target linkage))
        ((application? exp)
         (compile-application exp target linkage))
        (else
         (error "Unknown expression type -- COMPILE" exp))))


(define (make-instruction-sequence needs modifies statements)
  (list needs modifies statements))

(define (empty-instruction-sequence)
  (make-instruction-sequence '() '() '()))


;;;SECTION 5.5.2

;;;linkage code

(define (compile-linkage linkage)
  (cond ((eq? linkage 'return)
         (make-instruction-sequence '(continue) '()
	    '((goto (reg continue)))))
        ((eq? linkage 'next)
         (empty-instruction-sequence))
        (else
         (make-instruction-sequence '() '()
	    (list (list 'goto (list 'label linkage)))))))

(define (end-with-linkage linkage instruction-sequence)
  (preserving '(continue)
   instruction-sequence
   (compile-linkage linkage)))


;;;simple expressions

(define (compile-self-evaluating exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
      (list
       (list 'assign target (list 'const exp))))))

(define (compile-quoted exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '() (list target)
      (list
       (list 'assign target (list 'const (text-of-quotation exp)))))))

(define (compile-variable exp target linkage)
  (end-with-linkage linkage
   (make-instruction-sequence '(env) (list target)
      (list (list 'assign target
		  '(op lookup-variable-value)
		  (list 'const exp)
		  '(reg env))))))

(define (compile-assignment exp target linkage)
  (let ((var (assignment-variable exp))
        (get-value-code
         (compile (assignment-value exp) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
	 (list (list 'perform
		     '(op set-variable-value!)
		     (list 'const var)
		     '(reg val)
		     '(reg env))
	       (list 'assign target '(const ok))))))))

(define (compile-definition exp target linkage)
  (let ((var (definition-variable exp))
        (get-value-code (compile (definition-value exp) 'val 'next)))
    (end-with-linkage linkage
     (preserving '(env)
      get-value-code
      (make-instruction-sequence '(env val) (list target)
	 (list (list 'perform
		     '(op define-variable!)
		     (list 'const var)
		     '(reg val)
		     '(reg env))
	       (list 'assign target '(const ok))))))))


;;;conditional expressions

;;;labels (from footnote)
;(define label-counter 0)

;(define (new-label-number)
;  (set! label-counter (+ 1 label-counter))
;  label-counter)

;(define (make-label name)
;  (string->symbol
;    (string-append (symbol->string name)
;                   (number->string (new-label-number)))))

; Rewrite 26.8.2002 by tmj to make use of the gensym-primitive
(define (make-label name)
  (gensym name))
;; end of footnote

(define (compile-if exp target linkage)
  (let ((t-branch (make-label 'true-branch))
        (f-branch (make-label 'false-branch))                    
        (after-if (make-label 'after-if)))
    (let ((consequent-linkage
           (if (eq? linkage 'next) after-if linkage)))
      (let ((p-code (compile (if-predicate exp) 'val 'next))
            (c-code (compile (if-consequent exp) target consequent-linkage))
            (a-code (compile (if-alternative exp) target linkage)))
        (preserving '(env continue)
         p-code
         (append-instruction-sequences
          (make-instruction-sequence '(val) '()
	     (list (list 'test '(op false?) '(reg val))
		   (list 'branch (list 'label f-branch))))
          (parallel-instruction-sequences
           (append-instruction-sequences t-branch c-code)
           (append-instruction-sequences f-branch a-code))
          after-if))))))

;;; sequences

(define (compile-sequence seq target linkage)
  (if (last-exp? seq)
      (compile (first-exp seq) target linkage)
      (preserving '(env continue)
       (compile (first-exp seq) target 'next)
       (compile-sequence (rest-exps seq) target linkage))))


;;; and 
;
; Compiling (and 1 2) should produce:
;
;  (assign val (const 1))
;  (test (op false?) (reg val))
;  (branch (label false-found))
;
;  (assign val (const 2))
;  (test (op false?) (reg val))
;  (branch (label false-found))
;
; false-found
;  (goto (reg continue))

; Compiling (and) should produce:
;
;  (assign exp (const true))
;  (assign val (op lookup-variable-value) (reg exp) (reg env))
;  (goto (reg continue))

(define (compile-and-sequence seq target linkage label)
  (if (last-exp? seq)
      (append-instruction-sequences
       (compile (first-exp seq) target 'next)
       label)
      (preserving '(env continue)
	  (compile (first-exp seq) target 'next)
	  (append-instruction-sequences
	       (make-instruction-sequence '(val) '()
		  (list '(test (op false?) (reg val))
			(list 'branch (list 'label label))))
	       (compile-and-sequence (rest-exps seq) target linkage label)))))

(define (compile-and seq target linkage)
  (let ((false-found (make-label 'and-false-found)))
    (end-with-linkage linkage
      (if (no-expressions? seq)
	  (make-instruction-sequence '(val) '()
	     (list '(assign exp (const true))
		   '(assign val (op lookup-variable-value) (reg exp) (reg env))))
	  (compile-and-sequence seq target linkage false-found)))))

(define (compile-or-sequence seq target linkage label)
  (if (last-exp? seq)
      (append-instruction-sequences
       (compile (first-exp seq) target 'next)
       label)
      (preserving '(env continue)
	  (compile (first-exp seq) target 'next)
	  (append-instruction-sequences
	       (make-instruction-sequence '(val) '()
		  (list '(test (op true?) (reg val))
			(list 'branch (list 'label label)))))
	  (compile-or-sequence (rest-exps seq) target linkage label))))

(define (compile-or seq target linkage)
  (let ((true-found (make-label 'or-true-found)))
    (if (no-expressions? seq)
	(make-instruction-sequence '(val) '()
	   (list '(assign exp (const false))
		 '(assign val (op lookup-variable-value) (reg exp) (reg env))))
	(compile-or-sequence seq target linkage true-found))))
       
  

;;;lambda expressions

(define (compile-lambda exp target linkage)
  (let ((proc-entry (make-label 'entry))
        (after-lambda (make-label 'after-lambda)))
    (let ((lambda-linkage
           (if (eq? linkage 'next) after-lambda linkage)))
      (append-instruction-sequences
       (tack-on-instruction-sequence
        (end-with-linkage lambda-linkage
         (make-instruction-sequence '(env) (list target)
	    (list (list 'assign
			target
			'(op make-compiled-procedure)
			(list 'label proc-entry)
			'(reg env)))))
        (compile-lambda-body exp proc-entry))
       after-lambda))))

(define (compile-lambda-body exp proc-entry)
  (let ((formals (lambda-parameters exp))
	(body (scan-out-defines (lambda-body exp))))
    (append-instruction-sequences
     (make-instruction-sequence '(env proc argl) '(env)
	(list proc-entry
	      '(assign env (op compiled-procedure-env) (reg proc))
	      (list 'assign 'env
		    '(op extend-environment)
		    (list 'const formals)
		    '(reg argl)
		    '(reg env))))
     (compile-sequence body 'val 'return))))


;;;SECTION 5.5.3

;;;combinations

(define (compile-application exp target linkage)
  (let ((proc-code (compile (operator exp) 'proc 'next))
        (operand-codes
         (map (lambda (operand) (compile operand 'val 'next))
              (operands exp))))
    (preserving '(env continue)
     proc-code
     (preserving '(proc continue)
      (construct-arglist operand-codes)
      (compile-procedure-call target linkage)))))

(define (construct-arglist operand-codes)
  (let ((operand-codes (reverse operand-codes)))
    (if (null? operand-codes)
        (make-instruction-sequence
	 '()
	 '(argl)
	 '((assign argl (const ()))))
        (let ((code-to-get-last-arg
               (append-instruction-sequences
                (car operand-codes)
                (make-instruction-sequence 
		 '(val)
		 '(argl)
		 '((assign argl (op list) (reg val)))))))
          (if (null? (cdr operand-codes))
              code-to-get-last-arg
              (preserving '(env)
               code-to-get-last-arg
               (code-to-get-rest-args
                (cdr operand-codes))))))))

(define (code-to-get-rest-args operand-codes)
  (let ((code-for-next-arg
         (preserving '(argl)
          (car operand-codes)
          (make-instruction-sequence
	   '(val argl) 
	   '(argl)
	   '((assign argl (op cons) (reg val) (reg argl)))))))
    (if (null? (cdr operand-codes))
        code-for-next-arg
        (preserving '(env)
         code-for-next-arg
         (code-to-get-rest-args (cdr operand-codes))))))


;;;applying procedures (compiled, compound, primitives, and continuations)
(define (compile-procedure-call target linkage)
  (let ((primitive-branch (make-label 'primitive-branch))
        (compiled-branch (make-label 'compiled-branch))
	;--------------------Begin added by tmj to support calling of compound procedures from compiled procedures
	(compound-branch (make-label 'compound-branch))
	(continuation-branch (make-label 'continuation-branch))
	;--------------------End   added by tmj to support calling of compound procedures from compiled procedures
        (after-call (make-label 'after-call)))
    (let ((compiled-linkage
	   (if (eq? linkage 'next) after-call linkage)))
      (append-instruction-sequences
       (make-instruction-sequence '(proc) '()
	  (list (list 'test '(op primitive-procedure?) '(reg proc))
		(list 'branch (list 'label primitive-branch))
		(list 'test '(op compiled-procedure?) '(reg proc))
		(list 'branch (list 'label compiled-branch))
		(list 'test '(op continuation?) '(reg proc))
		(list 'branch (list 'label continuation-branch))))
       (parallel-instruction-sequences 
	    (append-instruction-sequences
	         compound-branch
		 (compile-compound-proc-appl target compiled-linkage))
	    (parallel-instruction-sequences 
	         (append-instruction-sequences 
		      compiled-branch
		      (compile-proc-appl target compiled-linkage))
		 (parallel-instruction-sequences
		      (append-instruction-sequences
    		           continuation-branch
			   (compile-continuation-apply target linkage))
		      (append-instruction-sequences
		           primitive-branch
			   (compile-primitive-apply target linkage)))))
       after-call))))

; applying primitives
(define (compile-primitive-apply target linkage)
  (end-with-linkage linkage
    (make-instruction-sequence '(proc argl) (list target)
       (list (list 'assign target
		   '(op apply-primitive-procedure)
		   '(reg proc)
		   '(reg argl))))))

; applying continuations
(define (compile-continuation-apply target linkage)
  (end-with-linkage linkage
    (make-instruction-sequence '(proc argl) (list target)
       (list (list 'assign target
		   '(op apply-continuation)
		   '(reg proc)
		   '(reg argl))))))

;;;applying compiled procedures
(define (compile-proc-appl target linkage)
  (cond ((and (eq? target 'val) (not (eq? linkage 'return)))
         (make-instruction-sequence '(proc) all-regs
	    (list (list 'assign 'continue (list 'label linkage))
		  '(assign val (op compiled-procedure-entry) (reg proc))
		  '(goto (reg val)))))

        ((and (not (eq? target 'val)) (not (eq? linkage 'return)))
         (let ((proc-return (make-label 'proc-return)))
           (make-instruction-sequence '(proc) all-regs
	      (list (list 'assign 'continue (list 'label proc-return))
		    '(assign val (op compiled-procedure-entry) (reg proc))
		    '(goto (reg val))
		    proc-return
		    (list 'assign target '(reg val))
		    (list 'goto (list 'label linkage))))))
	
        ((and (eq? target 'val) (eq? linkage 'return))
         (make-instruction-sequence '(proc continue) all-regs
	    '((assign val (op compiled-procedure-entry) (reg proc))
	      (goto (reg val)))))
	
        ((and (not (eq? target 'val)) (eq? linkage 'return))
         (error "return linkage, target not val -- COMPILE"
                target))))


;--------------------Begin added by tmj to support calling of compound procedures from compiled procedures

(define (compile-compound-proc-appl target linkage)
  (cond ((and      (eq? target 'val)  (not (eq? linkage 'return)))
         (make-instruction-sequence '(proc) all-regs
	    (list 
	     (list 'assign 'continue (list 'label linkage))
	     '(goto (label compound-apply-compiled)))))
	
        ((and (not (eq? target 'val)) (not (eq? linkage 'return)))
         (let ((proc-return (make-label 'proc-return)))
           (make-instruction-sequence '(proc) all-regs
	      (list (list 'assign 'continue (list 'label proc-return))
		    '(goto (label compound-apply))
		    proc-return
		    (list 'assign target '(reg val))
		    (list 'goto (list 'label linkage))))))

        ((and      (eq? target 'val)       (eq? linkage 'return))
         (make-instruction-sequence '(proc continue) all-regs
	    '((goto (label compound-apply-compiled)))))
	
        ((and (not (eq? target 'val))      (eq? linkage 'return))
         (error "return linkage, target not val -- COMPILE" target))))

;--------------------End   added by tmj to support calling of compound procedures from compiled procedures

;; footnote
(define all-regs '(env proc val argl continue))


;;;SECTION 5.5.4

(define (registers-needed s)
  (if (symbol? s) '() (car s)))

(define (registers-modified s)
  (if (symbol? s) '() (cadr s)))

(define (statements s)
  (if (symbol? s) (list s) (caddr s)))

(define (needs-register? seq reg)
  (memq reg (registers-needed seq)))

(define (modifies-register? seq reg)
  (memq reg (registers-modified seq)))


(define (append-instruction-sequences . seqs)
  (define (append-2-sequences seq1 seq2)
    (make-instruction-sequence
     (list-union (registers-needed seq1)
                 (list-difference (registers-needed seq2)
                                  (registers-modified seq1)))
     (list-union (registers-modified seq1)
                 (registers-modified seq2))
     (append (statements seq1) (statements seq2))))
  (define (append-seq-list seqs)
    (if (null? seqs)
        (empty-instruction-sequence)
        (append-2-sequences (car seqs)
                            (append-seq-list (cdr seqs)))))
  (append-seq-list seqs))

(define (list-union s1 s2)
  (cond ((null? s1) s2)
        ((memq (car s1) s2) (list-union (cdr s1) s2))
        (else (cons (car s1) (list-union (cdr s1) s2)))))

(define (list-difference s1 s2)
  (cond ((null? s1) '())
        ((memq (car s1) s2) (list-difference (cdr s1) s2))
        (else (cons (car s1)
                    (list-difference (cdr s1) s2)))))

(define (preserving regs seq1 seq2)
  (if (null? regs)
      (append-instruction-sequences seq1 seq2)
      (let ((first-reg (car regs)))
        (if (and (needs-register? seq2 first-reg)
                 (modifies-register? seq1 first-reg))
            (preserving (cdr regs)
             (make-instruction-sequence
              (list-union (list first-reg)
                          (registers-needed seq1))
              (list-difference (registers-modified seq1)
                               (list first-reg))
	      (append (list (list 'save first-reg))
		      (statements seq1)
		      (list (list 'restore first-reg))))
             seq2)
            (preserving (cdr regs) seq1 seq2)))))

(define (tack-on-instruction-sequence seq body-seq)
  (make-instruction-sequence
   (registers-needed seq)
   (registers-modified seq)
   (append (statements seq) (statements body-seq))))

(define (parallel-instruction-sequences seq1 seq2)
  (make-instruction-sequence
   (list-union (registers-needed seq1)
               (registers-needed seq2))
   (list-union (registers-modified seq1)
               (registers-modified seq2))
   (append (statements seq1) (statements seq2))))

'(COMPILER LOADED)
