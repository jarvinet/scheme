; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------


; Section 3.4.2

(define the-empty-stream '())

; This is named construct-stream because the MIT-Scheme interpreter has
; cons-stream defined internally and gives this if we try to define
; with the same name:
;SYNTAX: define: redefinition of syntactic keyword cons-stream
(define (construct-stream x stream) (cons x stream))

(define (head stream) (car stream))

(define (tail stream) (cdr stream))

(define (empty-stream? stream) (null? stream))

(define (append-streams stream1 stream2) (append stream1 stream2))


(define (accumulate combiner initial-value stream)
  (if (empty-stream? stream)
      initial-value
      (combiner (head stream)
		(accumulate combiner
			    initial-value
			    (tail stream)))))

(define (map proc stream)
  (if (empty-stream? stream)
      the-empty-stream
      (construct-stream (proc (head stream))
			(map proc (tail stream)))))

(define (filter pred stream)
  (cond ((empty-stream? stream)
	 the-empty-stream)
	((pred (head stream))
	 (construct-stream (head stream)
			   (filter pred (tail stream))))
	(else
	 (filter pred (tail stream)))))

;-------------------------------------------------------------

; exercise 3.39

(define (accumulate-n op init streams)
  (if (empty-stream? (head streams))
      the-empty-stream
      (construct-stream
       (accumulate op init (map car streams))
       (accumulate-n op init (map cdr streams)))))

;-------------------------------------------------------------

; exercise 3.40

; Matrix
; +-       -+
; | 1 2 3 4 |
; | 4 5 6 6 |
; | 6 7 8 9 |
; +-       -+
;
;
; is represented as ((1 2 3 4) (4 5 6 6) (6 7 8 9))


; Dot product of two vectors
;
(define (dot-product v w)
  (accumulate + 0
	      (accumulate-n * 1
			    (construct-stream v
					      (construct-stream w
								the-empty-stream)))))


; Transpose matrix
;
;      +-     -+   
; M =  | 1 2 3 |
;      | 4 5 6 |
;      +-     -+
;
;      +-   -+ 
;  T   | 1 4 |   
; M =  | 2 5 |
;      | 3 6 |
;      +-   -+

(define (transpose mat)
  (accumulate-n cons '() mat))


; Matrix times vector
;                           +- -+
;      +-     -+            | 7 |
; M =  | 1 2 3 |        V = | 8 |
;      | 4 5 6 |            | 9 |
;      +-     -+            +- -+
;
;           +- -+
;   M x V = | a |
;           | b |
;           +- -+
;
; where
;      a = 1*7 + 2*8 + 3*9 = 7+16+27 = 50
;      b = 4*7 + 5*8 + 6*9 = 28+40+54 = 122
;

(define (matrix-times-vector m v)
  (map (lambda (w)
	 (dot-product v w))
       m))


; Matrix times matrix
;
;      +-     -+         +-   -+        +-     -+
;      | 1 2 3 |         | 1 2 |     T  | 1 3 5 |
; M =  | 4 5 6 |     N = | 3 4 |    N = | 2 4 6 |
;      +-     -+         | 5 6 |        +-     -+
;                        +-   -+
;            +-   -+
;   M x N =  | a b |
;            | c d |
;            +-   -+
;
; where
;    a = 1*1 + 2*3 + 3*5 = 1+6+15 = 22
;    b = 1*2 + 2*4 + 3*6 = 2+8+18 = 28
;    c = 4*1 + 5*3 + 6*5 = 4+15+30 = 49
;    d = 4*2 + 5*4 + 6*6 = 8+20+36 = 64


(define (matrix-times-matrix m n)
  (let ((cols (transpose n)))
    (map (lambda (v)
	   (matrix-times-vector cols v))
	 m)))

