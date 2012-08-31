(define gc-msgs (gc-messages?))
(if gc-msgs (set-gc-messages #f))

(define pass 0)
(define fail 0)

(define (test section exp expected-outcome)
  (let ((outcome (eval exp (interaction-environment))))
    (write exp)
    (display ": ")
    (if (equal? outcome expected-outcome)
	(begin
	  (display "PASS") (newline)
	  (set! pass (+ pass 1)))
	(begin
	  (display "FAIL") (newline)
	  (display "    Expected result: ")
	  (write expected-outcome) (newline)
	  (display "    Result:          ")
	  (write outcome) (newline)
	  (set! fail (+ fail 1))
	  (newline)))))


(load "testsuite/r5rs.scm")

(newline)

(display "*** Total passes: ")
(display pass)
(newline)

(display "*** Total fails: ")
(display fail)
(newline)

(set-gc-messages gc-msgs)
