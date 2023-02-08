/* A Bison parser, made by GNU Bison 1.875a.  */

/* Skeleton parser for Yacc-like parsing with Bison,
   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003 Free Software Foundation, Inc.

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
   Foundation, Inc., 59 Temple Place - Suite 330,
   Boston, MA 02111-1307, USA.  */

/* As a special exception, when this file is copied by Bison into a
   Bison output file, you may use that output file without restriction.
   This special exception was added by the Free Software Foundation
   in version 1.24 of Bison.  */

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     ABSOLUTE = 258,
     END = 259,
     COMMENT = 260,
     LSH = 261,
     RSH = 262,
     LEQ = 263,
     GEQ = 264,
     NEQ = 265,
     ASM = 266,
     ENDASM = 267,
     IF = 268,
     THEN = 269,
     ENDIF = 270,
     SET = 271,
     INC = 272,
     DEC = 273,
     GOTO = 274,
     GOSUB = 275,
     RESUME = 276,
     RETURN = 277,
     ARRAY = 278,
     ZEROPAGE = 279,
     PUSH = 280,
     POP = 281,
     LABEL = 282,
     REGISTER = 283,
     IDENTIFIER = 284,
     CONSTANT = 285,
     ASMCHAR = 286
   };
#endif
#define ABSOLUTE 258
#define END 259
#define COMMENT 260
#define LSH 261
#define RSH 262
#define LEQ 263
#define GEQ 264
#define NEQ 265
#define ASM 266
#define ENDASM 267
#define IF 268
#define THEN 269
#define ENDIF 270
#define SET 271
#define INC 272
#define DEC 273
#define GOTO 274
#define GOSUB 275
#define RESUME 276
#define RETURN 277
#define ARRAY 278
#define ZEROPAGE 279
#define PUSH 280
#define POP 281
#define LABEL 282
#define REGISTER 283
#define IDENTIFIER 284
#define CONSTANT 285
#define ASMCHAR 286




#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 24 "nbasic.y"
typedef union YYSTYPE {
  struct CodeTree_s *val;
} YYSTYPE;
/* Line 1240 of yacc.c.  */
#line 103 "nbasic.tab.h"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;



