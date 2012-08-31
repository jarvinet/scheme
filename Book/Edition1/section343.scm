; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------
; Section 3.4.3

; Implementing streams

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream low
		   (enumerate-interval (1+ low high)))))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-map proc s)
  (if (stream-null? s)
      the-empty-stream
      (cons-stream (proc (stream-car s))
                   (stream-map proc (stream-cdr s)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
      'done
      (begin (proc (stream-car s))
             (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

;-------------------------------------------------------------

; exercise 3.43

(define (show x)
  (newline)
  (display x)
  x)

(define (nth-stream n s)
  (if (= n 0)
      (head s)
      (nth-stream (-1+ n) (tail s))))

(define x (stream-map show (stream-enumerate-interval 0 10)))

; (nth-stream 5 x)
; 
; 1
; 2
; 3
; 4
; 5
; ;Value: 5
; (nth-stream 7 x)
; 
; 6
; 7
; ;Value: 7


;-------------------------------------------------------------

; exercise 3.44

(define sum 0)

(define (accum x)
  (set! sum (+ x sum))
  sum)

(define seq (stream-map accum (stream-enumerate-interval 1 20)))

(define y (stream-filter even? seq))

(define z (stream-filter (lambda (x) (= (remainder x 5) 0)) seq))

(stream-ref y 7)

(display-stream z)
