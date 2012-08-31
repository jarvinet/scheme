(load "ch5-compiler.scm")

(define in2 (open-input-file "exp_com.scm"))
(define expression-to-compile (read in2))
(close-input-port in2)

(define out2 (open-output-file "t.txt"))
(display (compile expression-to-compile 'val 'next) out2)
(newline out2)
(close-output-port out2)
