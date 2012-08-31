(define product
  (lambda (ls)
    (call-with-current-continuation
      (lambda (break)
         (let f ((ls ls))
           (cond
             ((null? ls) 1)
             ((= (car ls) 0) (break 0))
             (else (* (car ls) (f (cdr ls))))))))))
 


;(test '(product '(1 2 3 4 5))  120)
;(test '(product '(7 3 8 0 1 9 5))  0)
