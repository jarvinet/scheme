; Usage: time sci.sh testfib.scm

(load "fib.scm")
(display (fib 10))
(exit)

; Results with the old-style (linear search) environment:
; real    0m21.370s
; user    0m14.330s
; sys     0m0.080s
:
; Results with the new (hashtable) environment
; 
;
;
