; From the book
; The Scheme Programming Language, Second Edition
; by R. Kent Dybvig

(test '(call/cc (lambda (k) (* 5 4)))  20)
(test '(call/cc (lambda (k) (* 5 (k 4))))  4)
(test '(+ 2 (call/cc (lambda (k) (* 5 (k 4)))))  6)
(test '(let ((x (call/cc (lambda (k) k)))) (x (lambda (ignore) "hi")))  "hi")
(test '(((call/cc (lambda (k) k)) (lambda (x) x)) "HEY!")  "HEY!")
