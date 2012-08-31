(define t-branch (make-instruction-sequence '(a1) '(b1) '(c1)))
(define c-code (make-instruction-sequence '(a2) '(b2) '(c2)))
(define f-branch (make-instruction-sequence '(a3) '(b3) '(c3)))
(define a-code (make-instruction-sequence '(a4) '(b4) '(c4)))
(define p-code (make-instruction-sequence '(a5) '(b5) '(c5)))
(define after-if (make-label 'after-if))


(preserving '(a1 b1)
 p-code
 (append-instruction-sequences
  (make-instruction-sequence '(val) '()
			     `((test (op false?) (reg val))
			       (branch (label ,f-branch))))
  (parallel-instruction-sequences
   (append-instruction-sequences t-branch c-code)
   (append-instruction-sequences f-branch a-code))
  after-if))
 
  

