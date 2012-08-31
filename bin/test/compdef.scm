; Test the compilation of a procedure definition using the dot-notation is arguments

(define (foo . args)
  (display args)
  (newline))

(foo 1 2 3)
