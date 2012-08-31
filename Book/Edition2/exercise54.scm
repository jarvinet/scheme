; Structure and Interpretation of Computer Programs, 2nd edition

; Exercise 5.4



; a: Recursive exponentiation:

(define (expt b n)
  (if (= n 0)
      1
      (* b (expt b (- n 1)))))




                     /\    /\
                    / 1\  / 0\
                    ----  ----
                      |	   |
		      |	   V
                      |   / \
       +--------------+  | = |
       |              |   \ /
       |	      |	   ^
       |	      |	   |
       V	      |	+---+   sn   +-----+
     +---+ +---+      | |   |------->|     |
     |val| | b |      | | n |<-------|stack|
     +---+ +---+      | +---+	rn   +-----+
      ^	|   |	      |	 | ^	       ^  |
      | V   V	      V	 V |	     rc|  |sc
      | -----        ----- |	       |  V
      | \ * /        \ - / |	     +--------+
      |  ---          ---  |	     |continue|
      |   |	       |   |	     +--------+
      +---+            +---+   	       ^    ^
				       |    |
			       after- /\    /\ expt-
			       expt  /  \  /  \done
				     ----  ----




(controller
 (assign continue (label expt-done))
 expt-loop
 (test (op =) (reg n) (const 0))
 (branch (label base-case))
 ; set up a procedure call
 (save continue)
 (save n)
 (assign n (op -) (reg n) (const 1))
 (assign continue (label after-expt))
 (goto (label expt-loop))
 after-expt
 (restore n)
 (restore continue)
 (assign val (op *) (reg val) (reg b))
 (goto (reg continue)) ; return to caller
 base-case
 (assign val (const 1))
 (goto (reg continue))
 expt-done)



; b. Iterative exponentiation:

(define (expt b n)
  (define (expt-iter counter product)
    (if (= counter 0)
	product
	(expt-iter (- counter 1) (* b product))))
  (expt-iter n 1))



(controller
 (assign product (const 1))
 (assign counter (reg n)
 (assign continue (label expt-done))
 (save continue)
 (goto (label expt-iter))
 expt-iter
 (test (op =) (reg counter) (const 1))
 (branch (label base-case))
 (save continue)
 (assign counter (op -) (reg counter) (const 1))
 (assign product (op *) (reg product) (reg b))
 (assign continue (label after-expt))
 (goto (label expt-iter))
 after-expt
 (restore continue)
 (goto (reg continue))
 base-case
 (goto (reg continue)) ; return to caller
 expt-done)
