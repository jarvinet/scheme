; To demonstrate that calling interpreted procedure containing
; internal define from a compiled procedure produces error
; When you compile this file, fib does not work but fib2 does
; compound procedures < + - contain internal defines but
; integer-less-than, integer-add, integer-minus do not

; all the functions here that do not work make no
; recursive calls to themselves at all!


(define (fib1 n)
  (if (< n 2)
      n
      (+ (fib1 (- n 2))
	 (fib1 (- n 1)))))

(define (fib2 n)
  (if (integer-less-than n 2)
      n
      (integer-add (fib2 (integer-minus n 2))
		   (fib2 (integer-minus n 1)))))

(define (fib3 n)
  (if (< n 2)
      n
      (integer-add (fib3 (integer-minus n 2))
		   (fib3 (integer-minus n 1)))))

(define (fib4 n)
  (if (integer-less-than n 2)
      n
      (+ (fib4 (integer-minus n 2))
	 (fib4 (integer-minus n 1)))))

(define (fib5 n)
  (if (integer-less-than n 2)
      n
      (integer-add (fib5 (- n 2))
		   (fib5 (- n 1)))))

(define (fib6 n)
  (if (< n 2)
      n
      (integer-add (fib6 (- n 2))
		   (fib6 (- n 1)))))

(define (fib7 n)
  (if (< n 2)
      n
      (+ (fib7 (integer-minus n 2))
	 (fib7 (integer-minus n 1)))))

(define (fib8 n)
  (if (integer-less-than n 2)
      n
      (+ (fib8 (- n 2))
	 (fib8 (- n 1)))))



;      <   +   -  result        modified compiler
;  ---------------------------------------------------
;  1   <   +   -  #f            restore fails    restore fails
;  2              ok            ok               ok
;  3   <          #f            restore fails    restore fails
;  4       +      ok            ok               ok
;  5           -  wrong result  assertion fails  ok
;  6   <       -  #f            restore fails    restore fails
;  7   <   +      #f            restore fails    restore fails
;  8       +   -  wrong result  assertion fails  ok

