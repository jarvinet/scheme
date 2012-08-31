;; Stuff required by the macro implementation


;;; The following nonstandard procedures must be provided by the
;;; implementation for this code to run.
;;;
;;; (void)
;;; returns the implementation's cannonical "unspecified value".  The
;;; following usually works:
;;;

(define void (lambda () (if #f #f)))

;;;
;;; (andmap proc list1 list2 ...)
;;; returns true if proc returns true when applied to each element of list1
;;; along with the corresponding elements of list2 ....  The following
;;; definition works but does no error checking:
;;;

(define andmap
  (lambda (f first . rest)
    (or (null? first)
        (if (null? rest)
            (let andmap ((first first))
              (let ((x (car first)) (first (cdr first)))
                (if (null? first)
                    (f x)
                    (and (f x) (andmap first)))))
            (let andmap ((first first) (rest rest))
              (let ((x (car first))
                    (xr (map car rest))
                    (first (cdr first))
                    (rest (map cdr rest)))
                (if (null? first)
                    (apply f (cons x xr))
                    (and (apply f (cons x xr)) (andmap first rest)))))))))

;;;
;;; (ormap proc list1)
;;; returns the first non-false return result of proc applied to
;;; the elements of list1 or false if none.  The following definition
;;; works but does no error checking:
;;;

(define ormap
  (lambda (proc list1)
    (and (not (null? list1))
         (or (proc (car list1)) (ormap proc (cdr list1))))))

;;;
;;; The following nonstandard procedures must also be provided by the
;;; implementation for this code to run using the standard portable
;;; hooks and output constructors.  They are not used by expanded code,
;;; and so need be present only at expansion time.
;;;
;;; (eval x)
;;; where x is always in the form ("noexpand" expr).
;;; returns the value of expr.  the "noexpand" flag is used to tell the
;;; evaluator/expander that no expansion is necessary, since expr has
;;; already been fully expanded to core forms.
;;;
;;; eval will not be invoked during the loading of psyntax.pp.  After
;;; psyntax.pp has been loaded, the expansion of any macro definition,
;;; whether local or global, results in a call to eval.  If, however,
;;; sc-expand has already been registered as the expander to be used
;;; by eval, and eval accepts one argument, nothing special must be done
;;; to support the "noexpand" flag, since it is handled by sc-expand.
;;;
;;; (error who format-string why what)
;;; where who is either a symbol or #f, format-string is always "~a ~s",
;;; why is always a string, and what may be any object.  error should
;;; signal an error with a message something like
;;;
;;;    "error in <who>: <why> <what>"
;;;
;;; (gensym)
;;; returns a unique symbol each time it's called.  In Chez Scheme, gensym
;;; returns a symbol with a "globally" unique name so that gensyms that
;;; end up in the object code of separately compiled files cannot conflict.
;;; This is necessary only if you intend to support compiled files.
;;;

; gensym is a primitive in symbol.c

;;; (putprop symbol key value)
;;; (getprop symbol key)
;;; (remprop symbol key)
;;; key is always a symbol; value may be any object.  putprop should
;;; associate the given value with the given symbol and key in some way
;;; that it can be retrieved later with getprop.  getprop should return
;;; #f if no value is associated with the given symbol and key.  remprop
;;; should remove the association between the given symbol and key.

(load "scm/list.scm")

;;; When porting to a new Scheme implementation, you should define the
;;; procedures listed above, load the expanded version of psyntax.ss
;;; (psyntax.pp, which should be available whereever you found
;;; psyntax.ss), and register sc-expand as the current expander (how
;;; you do this depends upon your implementation of Scheme).  You may
;;; change the hooks and constructors defined toward the beginning of
;;; the code below, but to avoid bootstrapping problems, do so only
;;; after you have a working version of the expander.

(load "scm/macros/psyntax.pp")
