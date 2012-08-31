(load "ch5-compiler.scm")

(define in2 (open-input-file "exp_com.scm"))
(define expression-to-compile (read in2))
(close-input-port in2)

(define out2 (open-output-file "mit.txt"))
(pp (compile expression-to-compile 'val 'next) out2)
(newline out2)
(close-output-port out2)

;; pretty-print the tmj output
(define in1 (open-input-file "t.txt"))
(define b (read in1))
(define out1 (open-output-file "tmj.txt"))
(pp b out1)
(close-output-port out1)
(close-input-port in1)
