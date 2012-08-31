#!/usr/bin/guile -s
!#

; Wrapper for the guile scheme interpreter
;
; CURRENTLY NOT FUNCTIONAL FOR WHATEVER REASON


(define false '())
(define true (not false))

(load "myeval.scm")

(define the-global-environment (setup-environment))
(driver-loop)
