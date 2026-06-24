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

#ifndef YY_SC_SCPARSE_TAB_H_INCLUDED
# define YY_SC_SCPARSE_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int scdebug;
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
    IDENTIFIER = 259,              /* IDENTIFIER  */
    NUMBER = 260,                  /* NUMBER  */
    CHARACTER = 261,               /* CHARACTER  */
    STRING = 262,                  /* STRING  */
    BEGINVECTOR = 263,             /* BEGINVECTOR  */
    OPENPAR = 264,                 /* OPENPAR  */
    CLOSEPAR = 265,                /* CLOSEPAR  */
    DOT = 266,                     /* DOT  */
    QUOTE = 267,                   /* QUOTE  */
    QUASIQUOTE = 268,              /* QUASIQUOTE  */
    UNQUOTE = 269,                 /* UNQUOTE  */
    UNQUOTESPLICING = 270,         /* UNQUOTESPLICING  */
    TOKEN_TRUE = 271,              /* TOKEN_TRUE  */
    TOKEN_FALSE = 272,             /* TOKEN_FALSE  */
    NEWLINE = 273,                 /* NEWLINE  */
    END_OF_FILE = 274              /* END_OF_FILE  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{

    int   num;
    char* str;
    char  chr;


};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE sclval;


int scparse (void);


#endif /* !YY_SC_SCPARSE_TAB_H_INCLUDED  */
