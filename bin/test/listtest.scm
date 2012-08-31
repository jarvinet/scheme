(define q (make-deque))

(define a (cons 'a 1))
(define b (cons 'b 1))
(define c (cons 'c 1))
(define d (cons 'd 1))

(front-insert-deque! q a)
(front-insert-deque! q b)
(front-insert-deque! q c)
(front-insert-deque! q d)

(print-deque q)

(define (f value)
  (lambda (v)
    (eq? (car v) value)))

(define n (find-deque q (f 'b)))
(delete-deque! q n)
(print-deque q)

(define n (find-deque q (f 'd)))
(delete-deque! q n)
(print-deque q)

(define n (find-deque q (f 'a)))
(delete-deque! q n)
(print-deque q)

(define n (find-deque q (f 'c)))
(delete-deque! q n)
(print-deque q)

(define n (find-deque q (f 'c)))
(delete-deque! q n)
(print-deque q)


;(define ht (make-hashtable))
;(display "foo") (newline)
;(lookup-hashtable ht 'a #t 1)
;(lookup-hashtable ht 'b #t 2)
;(lookup-hashtable ht 'c #t 3)
;(lookup-hashtable ht 'd #t 4)
;(lookup-hashtable ht 'e #t 5)
;(display "bar") (newline)
;(define z (lookup-hashtable ht 'c #f 0))
;(display "baz") (newline)
;(remove-hashtable ht 'c)
;(display "foobar") (newline)
