This is a rudimentary Scheme implementation inspired
by the excellent book "Structure and Interpretation of 
Computer Programs" by Abelson and Sussman.

Some features 
-------------
* Implements a subset of the Scheme standard (R5RS) (Revised5 Report on the Algorithmic Language Scheme)
* Automatic memory management (stop-and-copy garbage colletion)
* Proper tail recursion
* Continuations

Tools used
----------
* Implemented in C. 
* Gnu tools: emacs, make, gcc, gdb
* scanner and parser generators: Gnu versions of lex and yacc (flex, bison)

Tail recursion requires the interpreter to be implemented as
a register machine simulator so that we have total control
of the execution of the interpreter. Otherwise the interpreter
would inherit the control structure of the undelying inplementation
(C-language) and could not be tail recursive.

The program contains a scanner and parser for two different
languages: for the register machine language and for Scheme.
The Scheme interpreter is implemented as a register machine
program that is interpreted by the register machine simulator.
The Scheme interpreter, in turn, interprets Scheme programs.

Directory old contains old drafts of the interpreter.
