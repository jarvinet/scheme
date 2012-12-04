This is a Scheme implementation inspired by the excellent book "Structure and Interpretation of Computer Programs" by Abelson and Sussman.

Some features 
-------------
* Implements a subset of the Scheme standard (R5RS) (Revised5 Report on the Algorithmic Language Scheme)
* Automatic memory management (stop-and-copy garbage colletion)
* Proper tail recursion
* Continuations

Tail recursion requires the interpreter to be implemented as a register machine simulator so that we have total control
of the execution of the interpreter. Otherwise the interpreter would inherit the control structure of the undelying inplementation
(C-language) and could not be tail recursive.

The program contains a scanner and parser for two different languages: for the register machine language and for Scheme.
The Scheme interpreter is implemented as a register machine program that is interpreted by the register machine simulator.
The Scheme interpreter, in turn, interprets Scheme programs.

Directory old contains old drafts of the interpreter.

Building
--------

Running
-------
Directory bin contains scripts sci.sh (interpreter) and scc.sh (compiler). These are scripts that invoke the register
machine simulator with appropriate arguments. sci.sh gives you a REPL, and scc.sh compiles a scheme file given on the 
command line.

sci.sh can take both scheme files (*.scm), and register machine simulator files (*.rms) on the command line and run
the programs contained within.

Testing
-------

Tools used
----------
* Implemented in C. 
* Gnu tools: emacs, make, gcc, gdb
* scanner and parser generators: Gnu versions of lex and yacc (flex, bison)
