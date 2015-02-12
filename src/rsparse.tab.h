/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     OTHER = 258,
     DOT = 259,
     STRING = 260,
     IDENTIFIER = 261,
     NUMBER = 262,
     OPENPAR = 263,
     CLOSEPAR = 264,
     ASSIGN = 265,
     PERFORM = 266,
     TEST = 267,
     BRANCH = 268,
     GOTO = 269,
     SAVE = 270,
     RESTORE = 271,
     REG = 272,
     CONST = 273,
     LABEL = 274,
     OP = 275,
     COMMENT = 276
   };
#endif
/* Tokens.  */
#define OTHER 258
#define DOT 259
#define STRING 260
#define IDENTIFIER 261
#define NUMBER 262
#define OPENPAR 263
#define CLOSEPAR 264
#define ASSIGN 265
#define PERFORM 266
#define TEST 267
#define BRANCH 268
#define GOTO 269
#define SAVE 270
#define RESTORE 271
#define REG 272
#define CONST 273
#define LABEL 274
#define OP 275
#define COMMENT 276




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE

{
    char*        str;
    int          num;
    Inst         ins;
    RegisterExp  reg;
    Constant     con;
    OperationExp ope;
    Label        lbl;
    Source       src;
    Target       trg;
    Input        inp;
    List         lst;
}
/* Line 1529 of yacc.c.  */

	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE rslval;

