

; Exercise 4.20

(define (f x)
  (letrec ((even?
	    (lambda (n)
	      (if (= n 0)
		  true
		  (odd? (- n 1)))))
	   (odd?
	    (lambda (n)
	      (if (= n 0)
		  false
		  (even? (- n 1))))))
    (even? x)))


(define (f2 x)
  (define even?
    (lambda (n)
      (if (= n 0)
	  true
	  (odd? (- n 1)))))
  (define odd?
    (lambda (n)
      (if (= n 0)
	  false
	  (even? (- n 1)))))
  (even? x))

(define (f3 x)
  (let ((even? '*unassigned*)
	(odd? '*unassigned*))
    (set! even?
	  (lambda (n)
	    (if (= n 0)
		true
		(odd? (- n 1)))))
    (set! odd?
	  (lambda (n)
	    (if (= n 0)
		false
		(even? (- n 1)))))
    (even? x)))

(define (f4 x)
  ((lambda (even? odd?)
     (set! even?
	   (lambda (n)
	     (if (= n 0)
		 true
		 (odd? (- n 1)))))
     (set! odd?
	   (lambda (n)
	     (if (= n 0)
		 false
		 (even? (- n 1)))))
     (even? x))
   '*unassigned* '*unassigned*))



; let in place of letrec

(define (f5 x)
  (let ((even?
	 (lambda (n)
	   (if (= n 0)
	       true
	       (odd? (- n 1)))))
	(odd?
	 (lambda (n)
	   (if (= n 0)
	       false
	       (even? (- n 1))))))
    (even? x)))

(define (f6 x)
  ((lambda (even? odd?)
     (even? x))
   (lambda (n)
     (if (= n 0)
	 true
	 (odd? (- n 1))))
   (lambda (n)
     (if (= n 0)
	 false
	 (even? (- n 1))))))


(define f7
  (lambda (x)
    ((lambda (even? odd?)
       (even? x))
     (lambda (n)
       (fi (= n 0)
	   true
	   (odd? (- n 1))))
     (lambda (n)
       (if (= n 0)
	   false
	   (even? (- n 1)))))))


(define (foo)
  (define (plus a b)
    (display "plus ")
    (+ a b))
  (display "foo ")
  plus)

(define (bar)
  (display "bar ")
  1)

(define (baz)
  (display "baz ")
  2)

((foo) (bar) (baz))


To evaluate a combination:

1) Evaluate the subexpressions of the combination.
2) Apply the value of the operator subexpression to the values
   of the operand subexpressions.

To apply a procedure object:

1) Create a new frame whose enclosing frame is the frame of the
   procedure object being applied.
2) Bind the formal parameters of the procedure to the arguments
   of the call. The binding is in the new frame.
3) Evaluate the body of the procedure in the context of the new
   environment constructed.

A procedure is created by evaluating a lambda expression relative
to a given environment. The resulting procedure object is a pair
consisting of the text of the expression and a pointer to the
environment in which the procedure was created.
--


Evaluate (f6 2)
  Evaluate f6 -> procedure object P0, environment = Global env
  Evaluate 2 -> integer 2
  Apply P0 to 2
    Create environment E1, enclosing = Global env
    Bind (x 2) in E1
    Evaluate P0, context E1
      Evaluate (lambda (even? odd?)...) -> procedure object P1, environment = E1
      Evaluate (lambda (n) ...) -> procedure object P2, environment = E1
      Evaluate (lambda (n) ...) -> procedure object P3, environment = E1
      Apply P1 to (P2 P3) in E1
        Create environment E2, enclosing = E1
    	Bind (even? P2) (odd? P3) in E2
        Evaluate (even? x), context E2
          Evaluate even? -> procedure object P2, environment = E1
          Evaluate x -> integer 2
          Apply (P2 2), environment = E1
            Create environment E3, enclosing = E1
            Bind (n 2) in E3
            Evaluate (if (= n 0) true (odd? (- n 1))), context E3
              Evaluate (odd? (- n 1)), context E3
                Evaluate odd? -> procedure object P3, found from E2
                Evaluate (- n 1) -> 1		        	
                Apply P3 to 1                                                   
		  Create environment E4, **enclosing = E1**	 
                  Bind (n 1)
                  Evaluate (if (= n 0) false (even? (- n 1))), context E4
                    Evaluate (even? (- n 1)), context E4
                      Evaluate even? -> NOT FOUND
			     

This pic is flawed, E1 is really the enclosing environment of E3!!!

			     
       +------------------------------+
       |       Global environment     |
       |   f6         	              |
       +---+--------------------------+
           |   ^      	   ^
           |   |           |
           |   |           |
           V   |           |
         +-+-+ |     +-----+---------------------------------------------+
     P0->| | +-+ E1->|x:2                                                |
         +++-+       +---------------------------------------------------+
           |            ^         ^         ^           ^            ^
           |		|         |         |           |            |
           V		|         |         |           |            |
parameters: x	        |         |         |           |            |
body: ((lambda (...))   |         |         |           |            |
                     +-+++     +-+++     +-+++     +----+----+     +-+-+
                 P1->| | | P2->| | | P3->| | | E2->|even?: P2| E4->|n:1|
                     +++-+     +++-+     +++-+     |odd? : P3|     +---+
                      |         |         |        +---------+ 
                      |         |         |	        ^
                      V         |         |		|
     parameters: even? odd?     |         |		|
     body: (even? x)            |         | 	        |
                                V         |           +-+-+
            parameters: n                 |       E3->|n:2|
            body: (if (= n 0) true...)    |           +---+
                                          V
                           parameters:n
                           body: (if (= n 0) false...)
