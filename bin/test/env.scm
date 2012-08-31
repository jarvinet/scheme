(define (make-binding var val) (cons var val))
(define (binding-var b) (car b))
(define (binding-val b) (cdr b))
(define (binding-set-value! b val) (set-cdr! b val))


(define (make-frame)
  (make-vector 512 '()))

(define (frame-add-binding frame binding)
  (let ((hash (symbol-hash (binding-var binding))))
    (let ((new (cons binding (vector-ref frame hash))))
      (vector-set! frame hash new))))


(define (frame-lookup-binding frame var)
  (define (loop looper variable)
    (if (null? looper)
	'()
	(let ((binding (car looper)))
	  (let ((var (binding-var binding)))
	    (if (eq? var variable)
		binding
		(loop (cdr looper) variable))))))
  (let ((looper (vector-ref frame (symbol-hash var))))
    (loop looper var)
))


(define frame22 (make-frame))
(frame-add-binding frame22 (make-binding 'a 1))
(frame-add-binding frame22 (make-binding 'b 2))
(frame-add-binding frame22 (make-binding 'c 3))
(display frame22)
(newline)
(define binding (frame-lookup-binding frame22 'a))
(display "binding: ")
(display binding)
(newline)

(if (null? binding)
    (begin
      (display "Not found")
      (newline))
    (begin
      (display "Found")
      (newline)))

(define a (binding-val binding))
(display a)
(newline)
(display frame22)
(newline)
(display frame22)
(newline)
(define b (binding-val (frame-lookup-binding frame22 'b)))
(display b)
(newline)
(display frame22)
(newline)
(define c (binding-val (frame-lookup-binding frame22 'c)))
(display c)
(newline)
