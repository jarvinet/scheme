; From the Scheme FAQ:
; 4.8. 
; Is there a way to define curried functions?
;
; Here is a definition of curry that takes a function and
; number of parameters as an argument and returns a curried
; function that can be invoked with any number of arguments
; up to the specified number of parameters: 

(define (curry f n)
  (if (zero? n)
      (f)
      (lambda args
        (curry (lambda rest
                 (apply f (append args rest)))
               (- n (length args))))))
; (define foo (curry + 4))
; ((((foo 1) 2) 3) 4)     ;=> 10
; ((foo 1 2 3) 4)         ;=> 10
; (foo 1 2 3 4)           ;=> 10
