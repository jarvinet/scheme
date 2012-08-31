http://www.cs.indiana.edu/chezscheme/syntax-case/

Portable syntax-case
R. Kent Dybvig and Oscar Waddell 

The portable syntax-case macro system is now up-to-date with respect
to The Scheme Programming Language, second edition and the Chez Scheme
User's Guide, as well as the paper Extending the Scope of Syntactic
Abstraction. 

The system consists of one file, psyntax.ss. The file psyntax.pp is
an expanded version of the file that may be used for bootstrapping
the system. See the porting notes in psyntax.ss 

Please let us know if you successfully port this code to a new Scheme
implementation, and also please allow us to include the hooks you
develop in doing the port in this directory for use by others. 

Please also contact us if you have difficulty porting to a new
Scheme implementation or if you discover that the implementation
depends on nonportable features of Chez Scheme in some
undocumented way. 

Release notes
Version 6.9 (psyntax.ss, psyntax.pp) 

(06/04/02) Recoded generate-id so that generated symbols have
a standard print representation and to avoid ASCII dependencies. 

Extended the syntax of syntax-case patterns to allow a fixed
number of items after an ellipsis. Ellipses are therefore no
longer constrained to appear only at the end of a list- or
vector-structured form, but only one ellipsis can appear at
a given level of a list- or vector-structured form. For
example, (a ... b) matches a list of one or more elements,
with b bound to the last element and a ... to all but the
last element. 

(05/31/02) Added a local definition for a one-clause version
of let-values and recoded uses of call-with-values using let-values. 

Fixed two bugs in the portable expander. One resulted in an error
in vector-ref when redefining a variable at top level that was
previously imported from a module. The other caused the wrong
identifier to be exported in certain circumstances, perhaps
resulting in an inappropriate identifier out of context error. 

Version 6.8 (psyntax.ss, psyntax.pp) 

(02/06/02) Added support for visit and revisit procedures,
which are relevant for systems that support compile-file:
visit is like load but loads only compile-time information,
and revisit is like load but loads only run-time information. 

Cleaned up and extended eval-when to handle new situations visit
and revisit. A translation table that clearly shows what happens
with nested eval-when forms is given in the source. 

Added literal-identifier=?. literal-identifier=? is similar to
free-identifier=? except that the former equates top-level
identifiers that come from different modules, even if they
do not necessarily resolve to the same binding. syntax-rules
and syntax-case employ literal-identifier=? to compare
identifiers listed in the literals list against input identifiers.
literal-identifier=? is intended for the comparison of auxiliary
keywords such as else in cond and case, where no actual binding
is involved. 

Fixed a bug in the portable expander that caused an application
of cdr to the empty list in build-sequence for top-level modules
with no exported definitions other than reexports, e.g., 

(module m1 (a) (define a 3))
(module m2 (a) (import m1))
(let () (import m2) a) ;=> 3


Fixed a bug in the portable expander that prevented use of
"hidden" top-level definitions in the output of a macro, e.g.: 

(define-syntax counter
  (syntax-rules ()
    ((_ ref incr e)
     (begin
       (define hidden e)
       (define ref (lambda () hidden))
       (define incr (lambda (n) (set! hidden (+ hidden n))))))))
(counter get bump 17)
(get) ;=> 17
(bump 4)
(get) ;=> 21
hidden ;=> unbound error


An incompatible change to the expander has been made to reduce
the loss of source information when one macro generates another
macro definition: List and vector structure in the subexpression
of a syntax form is no longer guaranteed to be list and vector
structure in the output form except where pattern variables are
contained within that structure. For example, #'(a ...), where
a is a pattern variable, is guaranteed to evaluate to a list,
but the constant structure (a b c d), none of a, b, c, and d
are pattern variables, may not. The practical consequence of
this change is that constant structures must be deconstructed
using syntax-case or syntax-rules rather than car, cdr, and
other list-processing operations. 

Version 6.3 (psyntax.ss, psyntax.pp) 

(08/30/00) The portable syntax-case macro system is now up-to-date
with respect to the Chez Scheme User's Guide as well as The Scheme
Programming Langauge, Second Edition. 

Version numbers refer to the version of Chez Scheme from which
the portable version was extracted. 

-------------------------------------------------------------


http://www.cs.indiana.edu/~dyb/papers/popl99-abstract.html

Oscar Waddell and R. Kent Dybvig, Extending the Scope of Syntactic
Abstraction. Conference Record of POPL'99: The 26th ACM SIGPLAN-SIGACT
Symposium on Principles of Programming Languages. January 1999. 

The benefits of module systems and lexically scoped syntactic abstraction
(macro) facilities are well-established in the literature. This paper
presents a system that seamlessly integrates modules and lexically
scoped macros. The system is fully static, permits mutually recursive
modules, and supports separate compilation. We show that more dynamic
module facilities are easily implemented at the source level in the
extended language supported by the system. 

popl99.ps.gz
