; Structure and Interpretation of Computer Programs, 1st edition

;-------------------------------------------------------------

; section 2.2.6 Example: Huffman encoding trees

(define (make-leaf symbol weight)
  (list 'leaf symbol weight))

(define (leaf? object)
  (eq? (car object) 'leaf))

(define (symbol-leaf x) (cadr x))

(define (weight-leaf x) (caddr x))

(define (make-code-tree left right)
  (list left
	right
	(append (symbols left) (symbols right))
	(+ (weight left) (weight right))))

(define (left-branch tree) (car tree))

(define (right-branch tree) (cadr tree))

(define (symbols tree)
  (if (leaf? tree)
      (list (symbol-leaf tree))
      (caddr tree)))

(define (weight tree)
  (if (leaf? tree)
      (weight-leaf tree)
      (cadddr tree)))


; The decoding procedure


(define (decode bits tree)
  (decode-1 bits tree tree))

(define (decode-1 bits tree current-branch)
  (if (null? bits)
      '()
      (let ((next-branch
	     (choose-branch (car bits) current-branch)))
	(if (leaf? next-branch)
	    (cons (symbol-leaf next-branch)
		  (decode-1 (cdr bits) tree tree))
	    (decode-1 (cdr bits) tree next-branch)))))

(define (choose-branch bit branch)
  (cond ((= bit 0) (left-branch branch))
	((= bit 1) (right-branch branch))
	(else (error "bad bit -- CHOOSE-BRANCH" bit))))

(define (adjoin-set x set)
  (cond ((null? set) (list x))
	((< (weight x) (weight (car set))) (cons x set))
	(else (cons (car set)
		    (adjoin-set x (cdr set))))))

(define (make-leaf-set pairs)
  (if (null? pairs)
      '()
      (let ((pair (car pairs)))
	(adjoin-set (make-leaf (car pair)   ; symbol
			       (cadr pair)) ; frequency
		    (make-leaf-set (cdr pairs))))))


;-------------------------------------------------------------

; exercise 2.39

(define sample-tree
  (make-code-tree (make-leaf 'A 4)
		  (make-code-tree (make-leaf 'B 2)
				  (make-code-tree
				   (make-leaf 'D 1)
				   (make-leaf 'C 1)))))

(define sample-message '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(decode sample-message sample-tree)
;Value: (a d a b b c a)


;-------------------------------------------------------------

; exercise 2.40

(define (encode message tree)
  (if (null? message)
      '()
      (append (encode-symbol (car message) tree)
	      (encode (cdr message) tree))))

(define (encode-symbol symbol tree)
  (if (leaf? tree)
      '()
      (let ((zero-branch (left-branch tree))
	    (one-branch  (right-branch tree)))
	(cond ((element-of-set? symbol (symbols zero-branch))
	       (cons '0 (encode-symbol symbol zero-branch)))
	      ((element-of-set? symbol (symbols one-branch))
	       (cons '1 (encode-symbol symbol one-branch)))
	      (else 
	       (error "symbol not defined in the tree -- ENCODE-SYMBOL" symbol))))))

(define (element-of-set? x set)
  (cond ((null? set) false)
	((equal? x (car set)) true)
	(else
	 (element-of-set? x (cdr set)))))
	       

;-------------------------------------------------------------

; exercise 2.41

(define (generate-huffman-tree pairs)
  (successive-merge (make-leaf-set pairs)))

(define (successive-merge pairs)
  (if (= (length pairs) 1)
      (car pairs)
      (successive-merge
       (adjoin-set (make-code-tree (car pairs) (cadr pairs))
		   (cddr pairs)))))

(define pairs '((A 4) (B 2) (C 1) (D 1)))

;-------------------------------------------------------------

; exercise 2.42

(define lyrics '((a 2) (boom 1) (Get 2) (job 2) (na 16) (Sha 3) (yip 10) (Wah 1)))

(define rock-song
  '(Get a job
    Sha na na na na na na na na
    Get a job
    Sha na na na na na na na na
    Wah yip yip yip yip yip yip yip yip
    Sha boom))

(encode rock-song rock-tree)
;Value: (1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 0 0 1 1 1 1 0 1 1 1 0 0 0 0 0 0 0 0 0 1 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1 1 1 0 1 1 0 1 1)

			

