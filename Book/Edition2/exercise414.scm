; Structure and Interpretation of Computer Programs, 2nd edition


Exercise 4.14.

Eva Lu Ator and Louis Reasoner are each experimenting with the
metacircular evaluator. Eva types in the definition of map, and
runs some test programs that use it. They work fine. Louis, in
contrast, has installed the system version of map as a primitive
for the metacircular evaluator. When he tries it, things go terribly
wrong. Explain why Louis's map fails even though Eva's works. 




(define (map proc items)
  (if (null? items)
      '()
      (cons (proc (car items))
	    (map proc (cdr items)))))


;  The problem is that the representation of procedures is totally different
;  in our evaluator and in the underlying Scheme implementation.
;  
;  Now when the map is from the underlying Scheme, the call
;  
;      (map (lambda (n) (+ n n)) '(1 2 3))
;  
;  creates a procedure (from the lambda expression) in our representation
;  and it is passed to the system map-function. The map tries to call the
;  procedure and finds it "not applicable". This is equivalent to evaluating
;  the expression
;  
;      (map 'a '(1 2 3))
;  
;  Here (quote a) is also "not applicable".
;
;  The same holds for any higher-order procedure from the underlying
;  implementation that tries to call a procedure in our representation.
