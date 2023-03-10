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

/* Written by Richard Stallman by simplifying the original so called
   ``semantic'' parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0



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
     VAR = 279,
     ZEROPAGE = 280,
     PUSH = 281,
     POP = 282,
     LABEL = 283,
     REGISTER = 284,
     IDENTIFIER = 285,
     CONSTANT = 286,
     ASMCHAR = 287
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
#define VAR 279
#define ZEROPAGE 280
#define PUSH 281
#define POP 282
#define LABEL 283
#define REGISTER 284
#define IDENTIFIER 285
#define CONSTANT 286
#define ASMCHAR 287




/* Copy the first part of user declarations.  */
#line 1 "nbasic.y"


#include <string>
#include <list>
#include <stdio.h>
#include <stdlib.h>

using namespace std;

#include "nbasic.yy.h"
#include "nbasic.h"

int yyerror(const char *msg) {
    printf("%s line %d: %s\n", nbasic_infilename, nbasic_line, msg);
    exit(1);
}

 int yywrap() {
   return 1;
 }



/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

#if ! defined (YYSTYPE) && ! defined (YYSTYPE_IS_DECLARED)
#line 24 "nbasic.y"
typedef union YYSTYPE {
  struct CodeTree_s *val;
} YYSTYPE;
/* Line 191 of yacc.c.  */
#line 167 "nbasic.tab.c"
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 214 of yacc.c.  */
#line 179 "nbasic.tab.c"

#if ! defined (yyoverflow) || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# if YYSTACK_USE_ALLOCA
#  define YYSTACK_ALLOC alloca
# else
#  ifndef YYSTACK_USE_ALLOCA
#   if defined (alloca) || defined (_ALLOCA_H)
#    define YYSTACK_ALLOC alloca
#   else
#    ifdef __GNUC__
#     define YYSTACK_ALLOC __builtin_alloca
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning. */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (0)
# else
#  if defined (__STDC__) || defined (__cplusplus)
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   define YYSIZE_T size_t
#  endif
#  define YYSTACK_ALLOC malloc
#  define YYSTACK_FREE free
# endif
#endif /* ! defined (yyoverflow) || YYERROR_VERBOSE */


#if (! defined (yyoverflow) \
     && (! defined (__cplusplus) \
	 || (YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  short yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (short) + sizeof (YYSTYPE))				\
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  register YYSIZE_T yyi;		\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (0)
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (0)

#endif

#if defined (__STDC__) || defined (__cplusplus)
   typedef signed char yysigned_char;
#else
   typedef short yysigned_char;
#endif

/* YYFINAL -- State number of the termination state. */
#define YYFINAL  65
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   209

/* YYNTOKENS -- Number of terminals. */
#define YYNTOKENS  43
/* YYNNTS -- Number of nonterminals. */
#define YYNNTS  23
/* YYNRULES -- Number of rules. */
#define YYNRULES  67
/* YYNRULES -- Number of states. */
#define YYNSTATES  104

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   287

#define YYTRANSLATE(YYX) 						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const unsigned char yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    38,     2,
       2,     2,     2,    36,     2,    37,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,    33,     2,
      41,    40,    42,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,    34,     2,    35,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,    39,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const unsigned char yyprhs[] =
{
       0,     0,     3,     5,     8,    10,    13,    15,    17,    19,
      21,    23,    25,    27,    29,    31,    34,    38,    43,    49,
      52,    55,    59,    61,    64,    70,    74,    78,    80,    82,
      84,    88,    92,    96,    98,   102,   104,   106,   108,   112,
     117,   122,   124,   126,   128,   130,   132,   134,   136,   138,
     140,   142,   144,   146,   148,   150,   152,   154,   157,   160,
     163,   166,   170,   173,   176,   179,   182,   184
};

/* YYRHS -- A `-1'-separated list of the rules' RHS. */
static const yysigned_char yyrhs[] =
{
      44,     0,    -1,    46,    -1,    44,    46,    -1,    46,    -1,
      45,    46,    -1,    47,    -1,    50,    -1,    52,    -1,    61,
      -1,    64,    -1,     4,    -1,     5,    -1,    48,    -1,    49,
      -1,    24,    30,    -1,    23,    30,    31,    -1,    23,    25,
      30,    31,    -1,    23,     3,    31,    30,    31,    -1,    28,
      33,    -1,    11,    12,    -1,    11,    51,    12,    -1,    32,
      -1,    51,    32,    -1,    13,    53,    14,    45,    15,    -1,
      13,    53,    46,    -1,    54,    60,    54,    -1,    55,    -1,
      56,    -1,    57,    -1,    59,    55,    55,    -1,    59,    55,
      56,    -1,    59,    56,    55,    -1,    31,    -1,    59,    56,
      56,    -1,    29,    -1,    30,    -1,    58,    -1,    34,    56,
      35,    -1,    34,    56,    54,    35,    -1,    34,    30,    54,
      35,    -1,    36,    -1,    37,    -1,     6,    -1,     7,    -1,
      38,    -1,    39,    -1,    40,    -1,    41,    -1,    42,    -1,
       8,    -1,     9,    -1,    10,    -1,    62,    -1,    63,    -1,
      22,    -1,    21,    -1,    19,    31,    -1,    19,    30,    -1,
      20,    31,    -1,    20,    30,    -1,    16,    65,    54,    -1,
      17,    65,    -1,    18,    65,    -1,    26,    65,    -1,    27,
      65,    -1,    57,    -1,    56,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const unsigned char yyrline[] =
{
       0,    40,    40,    41,    48,    49,    57,    58,    59,    60,
      61,    62,    63,    69,    70,    76,    77,    78,    79,    85,
      91,    92,    98,    99,   106,   107,   113,   120,   121,   131,
     132,   133,   134,   141,   142,   149,   150,   151,   158,   159,
     160,   166,   167,   168,   169,   170,   171,   177,   178,   179,
     180,   181,   182,   188,   189,   190,   191,   196,   197,   203,
     204,   210,   211,   212,   213,   214,   221,   222
};
#endif

#if YYDEBUG || YYERROR_VERBOSE
/* YYTNME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals. */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "ABSOLUTE", "END", "COMMENT", "LSH", "RSH", 
  "LEQ", "GEQ", "NEQ", "ASM", "ENDASM", "IF", "THEN", "ENDIF", "SET", 
  "INC", "DEC", "GOTO", "GOSUB", "RESUME", "RETURN", "ARRAY", "VAR", 
  "ZEROPAGE", "PUSH", "POP", "LABEL", "REGISTER", "IDENTIFIER", 
  "CONSTANT", "ASMCHAR", "':'", "'['", "']'", "'+'", "'-'", "'&'", "'|'", 
  "'='", "'<'", "'>'", "$accept", "top_block", "code_block", "nstatement", 
  "declaration", "array_decl", "label_decl", "asm_block", "asm_lines", 
  "if_block", "rel_exp", "arith_exp", "var_exp", "const_exp", "lvalue", 
  "array_access", "arith_op", "rel_op", "jump_statement", 
  "goto_statement", "gosub_statement", "arith_statement", "addr_exp", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const unsigned short yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,    58,    91,    93,    43,    45,    38,   124,
      61,    60,    62
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const unsigned char yyr1[] =
{
       0,    43,    44,    44,    45,    45,    46,    46,    46,    46,
      46,    46,    46,    47,    47,    48,    48,    48,    48,    49,
      50,    50,    51,    51,    52,    52,    53,    54,    54,    55,
      55,    55,    55,    56,    56,    57,    57,    57,    58,    58,
      58,    59,    59,    59,    59,    59,    59,    60,    60,    60,
      60,    60,    60,    61,    61,    61,    61,    62,    62,    63,
      63,    64,    64,    64,    64,    64,    65,    65
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const unsigned char yyr2[] =
{
       0,     2,     1,     2,     1,     2,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     2,     3,     4,     5,     2,
       2,     3,     1,     2,     5,     3,     3,     1,     1,     1,
       3,     3,     3,     1,     3,     1,     1,     1,     3,     4,
       4,     1,     1,     1,     1,     1,     1,     1,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     2,     2,     2,
       2,     3,     2,     2,     2,     2,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const unsigned char yydefact[] =
{
       0,    11,    12,     0,     0,     0,     0,     0,     0,     0,
      56,    55,     0,     0,     0,     0,     0,     0,     2,     6,
      13,    14,     7,     8,     9,    53,    54,    10,    20,    22,
       0,    43,    44,    35,    36,    33,     0,    41,    42,    45,
      46,     0,     0,    27,    28,    29,    37,     0,    67,    66,
       0,     0,    62,    63,    58,    57,    60,    59,     0,     0,
       0,    15,    64,    65,    19,     1,     3,    21,    23,     0,
       0,     0,    25,    50,    51,    52,    47,    48,    49,     0,
       0,     0,     0,    61,     0,     0,    16,     0,    38,     0,
       0,     4,    26,    30,    31,    32,    34,     0,    17,    40,
      39,    24,     5,    18
};

/* YYDEFGOTO[NTERM-NUM]. */
static const yysigned_char yydefgoto[] =
{
      -1,    17,    90,    18,    19,    20,    21,    22,    30,    23,
      41,    42,    43,    44,    45,    46,    47,    79,    24,    25,
      26,    27,    51
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -44
static const short yypact[] =
{
     170,   -44,   -44,     3,    52,    52,    52,    52,     2,    26,
     -44,   -44,    62,   -19,    52,    52,   -17,    95,   -44,   -44,
     -44,   -44,   -44,   -44,   -44,   -44,   -44,   -44,   -44,   -44,
      12,   -44,   -44,   -44,   -44,   -44,    16,   -44,   -44,   -44,
     -44,   120,     9,   -44,   -44,   -44,   -44,    52,   -44,   -44,
      66,    52,   -44,   -44,   -44,   -44,   -44,   -44,    -6,   -16,
       6,   -44,   -44,   -44,   -44,   -44,   -44,   -44,   -44,    52,
      32,   170,   -44,   -44,   -44,   -44,   -44,   -44,   -44,    52,
      52,    52,    66,   -44,    13,    33,   -44,    39,   -44,    43,
     145,   -44,   -44,   -44,   -44,   -44,   -44,    53,   -44,   -44,
     -44,   -44,   -44,   -44
};

/* YYPGOTO[NTERM-NUM].  */
static const short yypgoto[] =
{
     -44,   -44,   -44,   -11,   -44,   -44,   -44,   -44,   -44,   -44,
     -44,   -43,   -40,    -5,   194,   -44,    -2,   -44,   -44,   -44,
     -44,   -44,    14
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const unsigned char yytable[] =
{
      48,    48,    48,    50,    50,    50,    66,    80,    83,    48,
      48,    61,    50,    50,    85,    28,    64,    73,    74,    75,
      52,    53,    31,    32,    67,    84,    87,    89,    62,    63,
      72,    70,    54,    55,    50,    29,    92,    86,    31,    32,
      93,    95,    81,    97,    68,    82,    69,    35,    50,    76,
      77,    78,    37,    38,    39,    40,    56,    57,    31,    32,
      91,    33,    34,    35,    98,    58,    36,    88,    37,    38,
      39,    40,    31,    32,    99,    94,    96,    96,   100,   102,
      50,    33,    34,    35,   103,     0,    36,    59,    37,    38,
      39,    40,    60,     0,     0,    65,     0,    35,     0,     1,
       2,     0,    37,    38,    39,    40,     3,     0,     4,     0,
       0,     5,     6,     7,     8,     9,    10,    11,    12,    13,
       0,    14,    15,    16,     1,     2,     0,     0,     0,     0,
       0,     3,     0,     4,    71,     0,     5,     6,     7,     8,
       9,    10,    11,    12,    13,     0,    14,    15,    16,     1,
       2,     0,     0,     0,     0,     0,     3,     0,     4,     0,
     101,     5,     6,     7,     8,     9,    10,    11,    12,    13,
       0,    14,    15,    16,     1,     2,     0,     0,     0,     0,
       0,     3,     0,     4,     0,     0,     5,     6,     7,     8,
       9,    10,    11,    12,    13,     0,    14,    15,    16,    49,
      49,    49,     0,     0,     0,     0,     0,     0,    49,    49
};

static const yysigned_char yycheck[] =
{
       5,     6,     7,     5,     6,     7,    17,    47,    51,    14,
      15,    30,    14,    15,    30,    12,    33,     8,     9,    10,
       6,     7,     6,     7,    12,    31,    69,    70,    14,    15,
      41,    36,    30,    31,    36,    32,    79,    31,     6,     7,
      80,    81,    47,    30,    32,    50,    30,    31,    50,    40,
      41,    42,    36,    37,    38,    39,    30,    31,     6,     7,
      71,    29,    30,    31,    31,     3,    34,    35,    36,    37,
      38,    39,     6,     7,    35,    80,    81,    82,    35,    90,
      82,    29,    30,    31,    31,    -1,    34,    25,    36,    37,
      38,    39,    30,    -1,    -1,     0,    -1,    31,    -1,     4,
       5,    -1,    36,    37,    38,    39,    11,    -1,    13,    -1,
      -1,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      -1,    26,    27,    28,     4,     5,    -1,    -1,    -1,    -1,
      -1,    11,    -1,    13,    14,    -1,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    -1,    26,    27,    28,     4,
       5,    -1,    -1,    -1,    -1,    -1,    11,    -1,    13,    -1,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      -1,    26,    27,    28,     4,     5,    -1,    -1,    -1,    -1,
      -1,    11,    -1,    13,    -1,    -1,    16,    17,    18,    19,
      20,    21,    22,    23,    24,    -1,    26,    27,    28,     5,
       6,     7,    -1,    -1,    -1,    -1,    -1,    -1,    14,    15
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const unsigned char yystos[] =
{
       0,     4,     5,    11,    13,    16,    17,    18,    19,    20,
      21,    22,    23,    24,    26,    27,    28,    44,    46,    47,
      48,    49,    50,    52,    61,    62,    63,    64,    12,    32,
      51,     6,     7,    29,    30,    31,    34,    36,    37,    38,
      39,    53,    54,    55,    56,    57,    58,    59,    56,    57,
      59,    65,    65,    65,    30,    31,    30,    31,     3,    25,
      30,    30,    65,    65,    33,     0,    46,    12,    32,    30,
      56,    14,    46,     8,     9,    10,    40,    41,    42,    60,
      55,    56,    56,    54,    31,    30,    31,    54,    35,    54,
      45,    46,    54,    55,    56,    55,    56,    30,    31,    35,
      35,    15,    46,    31
};

#if ! defined (YYSIZE_T) && defined (__SIZE_TYPE__)
# define YYSIZE_T __SIZE_TYPE__
#endif
#if ! defined (YYSIZE_T) && defined (size_t)
# define YYSIZE_T size_t
#endif
#if ! defined (YYSIZE_T)
# if defined (__STDC__) || defined (__cplusplus)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# endif
#endif
#if ! defined (YYSIZE_T)
# define YYSIZE_T unsigned int
#endif

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrlab1


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { 								\
      yyerror ("syntax error: cannot back up");\
      YYERROR;							\
    }								\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

/* YYLLOC_DEFAULT -- Compute the default location (before the actions
   are run).  */

#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)         \
  Current.first_line   = Rhs[1].first_line;      \
  Current.first_column = Rhs[1].first_column;    \
  Current.last_line    = Rhs[N].last_line;       \
  Current.last_column  = Rhs[N].last_column;
#endif

/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (0)

# define YYDSYMPRINT(Args)			\
do {						\
  if (yydebug)					\
    yysymprint Args;				\
} while (0)

# define YYDSYMPRINTF(Title, Token, Value, Location)		\
do {								\
  if (yydebug)							\
    {								\
      YYFPRINTF (stderr, "%s ", Title);				\
      yysymprint (stderr, 					\
                  Token, Value);	\
      YYFPRINTF (stderr, "\n");					\
    }								\
} while (0)

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (cinluded).                                                   |
`------------------------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_stack_print (short *bottom, short *top)
#else
static void
yy_stack_print (bottom, top)
    short *bottom;
    short *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (/* Nothing. */; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (0)


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yy_reduce_print (int yyrule)
#else
static void
yy_reduce_print (yyrule)
    int yyrule;
#endif
{
  int yyi;
  unsigned int yylineno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %u), ",
             yyrule - 1, yylineno);
  /* Print the symbols being reduced, and their result.  */
  for (yyi = yyprhs[yyrule]; 0 <= yyrhs[yyi]; yyi++)
    YYFPRINTF (stderr, "%s ", yytname [yyrhs[yyi]]);
  YYFPRINTF (stderr, "-> %s\n", yytname [yyr1[yyrule]]);
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (Rule);		\
} while (0)

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YYDSYMPRINT(Args)
# define YYDSYMPRINTF(Title, Token, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   SIZE_MAX < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#if YYMAXDEPTH == 0
# undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined (__GLIBC__) && defined (_STRING_H)
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
static YYSIZE_T
#   if defined (__STDC__) || defined (__cplusplus)
yystrlen (const char *yystr)
#   else
yystrlen (yystr)
     const char *yystr;
#   endif
{
  register const char *yys = yystr;

  while (*yys++ != '\0')
    continue;

  return yys - yystr - 1;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined (__GLIBC__) && defined (_STRING_H) && defined (_GNU_SOURCE)
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
static char *
#   if defined (__STDC__) || defined (__cplusplus)
yystpcpy (char *yydest, const char *yysrc)
#   else
yystpcpy (yydest, yysrc)
     char *yydest;
     const char *yysrc;
#   endif
{
  register char *yyd = yydest;
  register const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

#endif /* !YYERROR_VERBOSE */



#if YYDEBUG
/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yysymprint (FILE *yyoutput, int yytype, YYSTYPE *yyvaluep)
#else
static void
yysymprint (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  if (yytype < YYNTOKENS)
    {
      YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
# ifdef YYPRINT
      YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# endif
    }
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  switch (yytype)
    {
      default:
        break;
    }
  YYFPRINTF (yyoutput, ")");
}

#endif /* ! YYDEBUG */
/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

#if defined (__STDC__) || defined (__cplusplus)
static void
yydestruct (int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yytype, yyvaluep)
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  /* Pacify ``unused variable'' warnings.  */
  (void) yyvaluep;

  switch (yytype)
    {

      default:
        break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM);
# else
int yyparse ();
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The lookahead symbol.  */
int yychar;

/* The semantic value of the lookahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
# if defined (__STDC__) || defined (__cplusplus)
int yyparse (void *YYPARSE_PARAM)
# else
int yyparse (YYPARSE_PARAM)
  void *YYPARSE_PARAM;
# endif
#else /* ! YYPARSE_PARAM */
#if defined (__STDC__) || defined (__cplusplus)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  register int yystate;
  register int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Lookahead token as an internal (translated) token number.  */
  int yytoken = 0;

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  short	yyssa[YYINITDEPTH];
  short *yyss = yyssa;
  register short *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  register YYSTYPE *yyvsp;



#define YYPOPSTACK   (yyvsp--, yyssp--)

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* When reducing, the number of symbols on the RHS of the reduced
     rule.  */
  int yylen;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed. so pushing a state here evens the stacks.
     */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack. Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	short *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow ("parser stack overflow",
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyoverflowlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyoverflowlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	short *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyoverflowlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid lookahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YYDSYMPRINTF ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */
  YYDPRINTF ((stderr, "Shifting token %s, ", yytname[yytoken]));

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;


  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  yystate = yyn;
  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 40 "nbasic.y"
    {yyval.val=handleCodeBlock(NULL, yyvsp[0].val);;}
    break;

  case 3:
#line 41 "nbasic.y"
    {yyval.val=handleCodeBlock(yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 4:
#line 48 "nbasic.y"
    {yyval.val=handleCodeBlock(new CodeTree, yyvsp[0].val);;}
    break;

  case 5:
#line 49 "nbasic.y"
    {yyval.val=handleCodeBlock(yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 6:
#line 57 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 7:
#line 58 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 8:
#line 59 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 9:
#line 60 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 10:
#line 61 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 11:
#line 62 "nbasic.y"
    {yyval.val=handleEnd();;}
    break;

  case 12:
#line 63 "nbasic.y"
    {yyval.val=handleOp(COMMENT);;}
    break;

  case 13:
#line 69 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 14:
#line 70 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 15:
#line 76 "nbasic.y"
    {yyval.val=handleArrayDecl(yyvsp[0].val);;}
    break;

  case 16:
#line 77 "nbasic.y"
    {yyval.val=handleArrayDecl(yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 17:
#line 78 "nbasic.y"
    {yyval.val=handleArrayDeclZp(yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 18:
#line 79 "nbasic.y"
    {yyval.val=handleArrayDeclAb(yyvsp[-2].val, yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 19:
#line 85 "nbasic.y"
    {yyval.val=handleLabel(yyvsp[-1].val);;}
    break;

  case 20:
#line 91 "nbasic.y"
    {yyval.val=handleAsmBlock(NULL);;}
    break;

  case 21:
#line 92 "nbasic.y"
    {yyval.val=handleAsmBlock(yyvsp[-1].val);;}
    break;

  case 22:
#line 98 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 23:
#line 99 "nbasic.y"
    {yyval.val=handleAsmLines(yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 24:
#line 106 "nbasic.y"
    {yyval.val=handleIf(yyvsp[-3].val,yyvsp[-1].val);;}
    break;

  case 25:
#line 107 "nbasic.y"
    {yyval.val=handleIf(yyvsp[-1].val,yyvsp[0].val);;}
    break;

  case 26:
#line 113 "nbasic.y"
    {yyval.val=handleRelExp(yyvsp[-1].val, yyvsp[-2].val, yyvsp[0].val);;}
    break;

  case 27:
#line 120 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 28:
#line 121 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 29:
#line 131 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 30:
#line 132 "nbasic.y"
    {yyval.val=handleVarExp(yyvsp[-2].val, yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 31:
#line 133 "nbasic.y"
    {yyval.val=handleVarExp(yyvsp[-2].val, yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 32:
#line 134 "nbasic.y"
    {yyval.val=handleVarExp(yyvsp[-2].val, yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 33:
#line 141 "nbasic.y"
    {yyval.val=handleConstExp(yyvsp[0].val);;}
    break;

  case 34:
#line 142 "nbasic.y"
    {yyval.val=handleConstExp(yyvsp[-2].val, yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 35:
#line 149 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 36:
#line 150 "nbasic.y"
    {yyval.val=handleLvalue(yyvsp[0].val);;}
    break;

  case 37:
#line 151 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 38:
#line 158 "nbasic.y"
    {yyval.val=handleArrayAccess(yyvsp[-1].val);;}
    break;

  case 39:
#line 159 "nbasic.y"
    {yyval.val=handleArrayAccess(yyvsp[-2].val,yyvsp[-1].val);;}
    break;

  case 40:
#line 160 "nbasic.y"
    {yyval.val=handleArrayAccess(yyvsp[-2].val,yyvsp[-1].val);;}
    break;

  case 41:
#line 166 "nbasic.y"
    {yyval.val=handleOp('+');;}
    break;

  case 42:
#line 167 "nbasic.y"
    {yyval.val=handleOp('-');;}
    break;

  case 43:
#line 168 "nbasic.y"
    {yyval.val=handleOp(LSH);;}
    break;

  case 44:
#line 169 "nbasic.y"
    {yyval.val=handleOp(RSH);;}
    break;

  case 45:
#line 170 "nbasic.y"
    {yyval.val=handleOp('&');;}
    break;

  case 46:
#line 171 "nbasic.y"
    {yyval.val=handleOp('|');;}
    break;

  case 47:
#line 177 "nbasic.y"
    {yyval.val=handleOp('=');;}
    break;

  case 48:
#line 178 "nbasic.y"
    {yyval.val=handleOp('<');;}
    break;

  case 49:
#line 179 "nbasic.y"
    {yyval.val=handleOp('>');;}
    break;

  case 50:
#line 180 "nbasic.y"
    {yyval.val=handleOp(LEQ);;}
    break;

  case 51:
#line 181 "nbasic.y"
    {yyval.val=handleOp(GEQ);;}
    break;

  case 52:
#line 182 "nbasic.y"
    {yyval.val=handleOp(NEQ);;}
    break;

  case 53:
#line 188 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 54:
#line 189 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;

  case 55:
#line 190 "nbasic.y"
    {yyval.val=handleJump(RETURN);;}
    break;

  case 56:
#line 191 "nbasic.y"
    {yyval.val=handleJump(RESUME);;}
    break;

  case 57:
#line 196 "nbasic.y"
    {yyval.val=handleJump(GOTO, yyvsp[0].val);;}
    break;

  case 58:
#line 197 "nbasic.y"
    {yyval.val=handleJump(GOTO, yyvsp[0].val);;}
    break;

  case 59:
#line 203 "nbasic.y"
    {yyval.val=handleJump(GOSUB, yyvsp[0].val);;}
    break;

  case 60:
#line 204 "nbasic.y"
    {yyval.val=handleJump(GOSUB, yyvsp[0].val);;}
    break;

  case 61:
#line 210 "nbasic.y"
    {yyval.val=handleArithSt(SET,  yyvsp[-1].val, yyvsp[0].val);;}
    break;

  case 62:
#line 211 "nbasic.y"
    {yyval.val=handleArithSt(INC,  yyvsp[0].val);;}
    break;

  case 63:
#line 212 "nbasic.y"
    {yyval.val=handleArithSt(DEC,  yyvsp[0].val);;}
    break;

  case 64:
#line 213 "nbasic.y"
    {yyval.val=handleArithSt(PUSH, yyvsp[0].val);;}
    break;

  case 65:
#line 214 "nbasic.y"
    {yyval.val=handleArithSt(POP,  yyvsp[0].val);;}
    break;

  case 66:
#line 221 "nbasic.y"
    {yyval.val=handleAddrExp(yyvsp[0].val);;}
    break;

  case 67:
#line 222 "nbasic.y"
    {yyval.val=yyvsp[0].val;;}
    break;


    }

/* Line 999 of yacc.c.  */
#line 1501 "nbasic.tab.c"

  yyvsp -= yylen;
  yyssp -= yylen;


  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (YYPACT_NINF < yyn && yyn < YYLAST)
	{
	  YYSIZE_T yysize = 0;
	  int yytype = YYTRANSLATE (yychar);
	  char *yymsg;
	  int yyx, yycount;

	  yycount = 0;
	  /* Start YYX at -YYN if negative to avoid negative indexes in
	     YYCHECK.  */
	  for (yyx = yyn < 0 ? -yyn : 0;
	       yyx < (int) (sizeof (yytname) / sizeof (char *)); yyx++)
	    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	      yysize += yystrlen (yytname[yyx]) + 15, yycount++;
	  yysize += yystrlen ("syntax error, unexpected ") + 1;
	  yysize += yystrlen (yytname[yytype]);
	  yymsg = (char *) YYSTACK_ALLOC (yysize);
	  if (yymsg != 0)
	    {
	      char *yyp = yystpcpy (yymsg, "syntax error, unexpected ");
	      yyp = yystpcpy (yyp, yytname[yytype]);

	      if (yycount < 5)
		{
		  yycount = 0;
		  for (yyx = yyn < 0 ? -yyn : 0;
		       yyx < (int) (sizeof (yytname) / sizeof (char *));
		       yyx++)
		    if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
		      {
			const char *yyq = ! yycount ? ", expecting " : " or ";
			yyp = yystpcpy (yyp, yyq);
			yyp = yystpcpy (yyp, yytname[yyx]);
			yycount++;
		      }
		}
	      yyerror (yymsg);
	      YYSTACK_FREE (yymsg);
	    }
	  else
	    yyerror ("syntax error; also virtual memory exhausted");
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror ("syntax error");
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse lookahead token after an
	 error, discard it.  */

      /* Return failure if at end of input.  */
      if (yychar == YYEOF)
        {
	  /* Pop the error token.  */
          YYPOPSTACK;
	  /* Pop the rest of the stack.  */
	  while (yyss < yyssp)
	    {
	      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
	      yydestruct (yystos[*yyssp], yyvsp);
	      YYPOPSTACK;
	    }
	  YYABORT;
        }

      YYDSYMPRINTF ("Error: discarding", yytoken, &yylval, &yylloc);
      yydestruct (yytoken, &yylval);
      yychar = YYEMPTY;

    }

  /* Else will try to reuse lookahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*----------------------------------------------------.
| yyerrlab1 -- error raised explicitly by an action.  |
`----------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;

      YYDSYMPRINTF ("Error: popping", yystos[*yyssp], yyvsp, yylsp);
      yydestruct (yystos[yystate], yyvsp);
      yyvsp--;
      yystate = *--yyssp;

      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  YYDPRINTF ((stderr, "Shifting error token, "));

  *++yyvsp = yylval;


  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*----------------------------------------------.
| yyoverflowlab -- parser overflow comes here.  |
`----------------------------------------------*/
yyoverflowlab:
  yyerror ("parser stack overflow");
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
  return yyresult;
}


#line 225 "nbasic.y"



