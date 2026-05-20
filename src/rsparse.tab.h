/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

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

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_RS_RSPARSE_TAB_H_INCLUDED
# define YY_RS_RSPARSE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int rsdebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    OTHER = 258,                   /* OTHER  */
    DOT = 259,                     /* DOT  */
    STRING = 260,                  /* STRING  */
    IDENTIFIER = 261,              /* IDENTIFIER  */
    NUMBER = 262,                  /* NUMBER  */
    OPENPAR = 263,                 /* OPENPAR  */
    CLOSEPAR = 264,                /* CLOSEPAR  */
    ASSIGN = 265,                  /* ASSIGN  */
    PERFORM = 266,                 /* PERFORM  */
    TEST = 267,                    /* TEST  */
    BRANCH = 268,                  /* BRANCH  */
    GOTO = 269,                    /* GOTO  */
    SAVE = 270,                    /* SAVE  */
    RESTORE = 271,                 /* RESTORE  */
    REG = 272,                     /* REG  */
    CONST = 273,                   /* CONST  */
    LABEL = 274,                   /* LABEL  */
    OP = 275,                      /* OP  */
    COMMENT = 276                  /* COMMENT  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
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


};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE rslval;


int rsparse (void);


#endif /* !YY_RS_RSPARSE_TAB_H_INCLUDED  */
