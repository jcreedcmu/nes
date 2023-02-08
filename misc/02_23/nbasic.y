%{

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

%}

%union {
  struct CodeTree_s *val;
}

%token ABSOLUTE END COMMENT LSH RSH LEQ GEQ NEQ ASM ENDASM IF THEN ENDIF SET INC DEC GOTO GOSUB RESUME RETURN ARRAY ZEROPAGE PUSH POP
%token <val> LABEL REGISTER IDENTIFIER CONSTANT ASMCHAR

%type <val> top_block code_block nstatement declaration array_decl label_decl asm_block asm_lines if_block rel_exp arith_exp var_exp const_exp lvalue array_access arith_op rel_op jump_statement goto_statement gosub_statement arith_statement addr_exp 

%start top_block
%%

//$$->text is unused
//$$->type is ASM
//$$->kids gets a list of CodeTrees
top_block
    : nstatement           {$$=handleCodeBlock(NULL, $1);}
    | top_block nstatement {$$=handleCodeBlock($1, $2);}
    ;

//$$->text is unused
//$$->type is ASM
//$$->kids gets a list of CodeTrees
code_block
    : nstatement           {$$=handleCodeBlock(new CodeTree, $1);}
    | code_block nstatement {$$=handleCodeBlock($1, $2);}
    ;

//$$->type gets ARRAY, LABEL, ASM, IF, GOTO, GOSUB, RETURN, RESUME,
// END, or COMMENT
//$$->text gets some (or no) assembly code
//$$->kids gets nothing or some CodeTrees with assembly code
nstatement
    : declaration     {$$=$1;}
    | asm_block       {$$=$1;}
    | if_block        {$$=$1;}
    | jump_statement  {$$=$1;}
    | arith_statement {$$=$1;}
    | END             {$$=handleEnd();}
    | COMMENT         {$$=handleOp(COMMENT);}
    ;

//$$->type gets ARRAY or LABEL
//$$->text gets assembly code (maybe comments)
declaration
    : array_decl {$$=$1;}
    | label_decl {$$=$1;}
    ;

//$$->type gets ARRAY
//$$->type gets assembly code comment describing declaration
array_decl
    : ARRAY IDENTIFIER CONSTANT                   {$$=handleArrayDecl($2, $3);}
    | ARRAY ZEROPAGE IDENTIFIER CONSTANT          {$$=handleArrayDeclZp($3, $4);}
    | ARRAY ABSOLUTE CONSTANT IDENTIFIER CONSTANT {$$=handleArrayDeclAb($3, $5, $5);}
    ;

//$$->type gets LABEL
//$$->text gets the assembly code for the label
label_decl
    : LABEL ':' {$$=handleLabel($1);}
    ;

//$$-type gets ASM
//$$->text gets assembly code text
asm_block
    : ASM ENDASM           {$$=handleAsmBlock(NULL);}
    | ASM asm_lines ENDASM {$$=handleAsmBlock($2);}
    ;

//$$->type gets ASMCHAR
//$$->text gets the assembly code text
asm_lines
    : ASMCHAR           {$$=$1;}
    | asm_lines ASMCHAR {$$=handleAsmLines($1, $2);}
    ;

//$$->type gets IF
//$$->text is unused
//$$->kids gets rel_exp then code_block/nstatement
if_block
    : IF rel_exp THEN code_block ENDIF {$$=handleIf($2,$4);}
    | IF rel_exp nstatement            {$$=handleIf($2,$3);}
    ;

//$$->type gets '=', NEQ, '<', '>', LEQ, or GEQ
//$$->text gets code to evaluate rel_exp.  
rel_exp
    : arith_exp rel_op arith_exp {$$=handleRelExp($2, $1, $3);}
    ;


//$$ passes through with
//$$->type as REGISTER or IDENTIFIER or '[' or ASM or CONSTANT
arith_exp
    : var_exp   {$$=$1;}
    | const_exp {$$=$1;}
    ;

//if lvalue
//  $$ passes through with
//  $$->type as REGISTER or INDENTIFIER or '['
//otherwise
//  $$->type gets ASM
//  $$->text gets code to evaluate expression leaving result in A
var_exp
    : lvalue                        {$$=$1;}
    | arith_op var_exp   var_exp    {$$=handleVarExp($1, $2, $3);}
    | arith_op var_exp   const_exp  {$$=handleVarExp($1, $2, $3);}
    | arith_op const_exp var_exp    {$$=handleVarExp($1, $2, $3);}
    ;

//$$->type gets CONSTANT
//$$->text is unused
//$$->kids gets one CodeTree whose type is the 32bit value of the constant
const_exp
    : CONSTANT                     {$$=handleConstExp($1);}
    | arith_op const_exp const_exp {$$=handleConstExp($1, $2, $3);}
    ;

//$$->type gets REGISTER IDENTIFIER or '['
//$$->text gets register/identifier text or is unused
//$$->kids is unused or unused or see array_access
lvalue
    : REGISTER     {$$=$1;}
    | IDENTIFIER   {$$=handleLvalue($1);}
    | array_access {$$=$1;}
    ;

//$$->type gets '['
//$$->text is the base addr (either a constant or an identifier)
//$$->kids gets a CodeTree whose text sets X to the array index 
array_access
    : '[' const_exp ']'            {$$=handleArrayAccess($2);}
    | '[' const_exp  arith_exp ']' {$$=handleArrayAccess($2,$3);}
    | '[' IDENTIFIER arith_exp ']' {$$=handleArrayAccess($2,$3);}
    ;

//$$->type gets '+', '-', LSH, RSH, '&', or '|'        
//$$->text is unused
arith_op
    : '+' {$$=handleOp('+');}
    | '-' {$$=handleOp('-');}
    | LSH {$$=handleOp(LSH);}
    | RSH {$$=handleOp(RSH);}
    | '&' {$$=handleOp('&');}
    | '|' {$$=handleOp('|');}
    ;

//$$->type gets '=', '<', '>', LEQ, GEQ, or NEQ
//$$->text is unused
rel_op
    : '=' {$$=handleOp('=');}
    | '<' {$$=handleOp('<');}
    | '>' {$$=handleOp('>');}
    | LEQ {$$=handleOp(LEQ);}
    | GEQ {$$=handleOp(GEQ);}
    | NEQ {$$=handleOp(NEQ);}
    ;

//$$->type gets GOSUB, GOTO, RETURN, or RESUME
//$$->text gets assembly code for jump statement
jump_statement
    : goto_statement  {$$=$1;}
    | gosub_statement {$$=$1;}
    | RETURN          {$$=handleJump(RETURN);}
    | RESUME          {$$=handleJump(RESUME);}
    ;
//$$->type gets GOTO
//$$->text gets assembly code for goto statement
goto_statement
    : GOTO CONSTANT   {$$=handleJump(GOTO, $2);}
    | GOTO IDENTIFIER {$$=handleJump(GOTO, $2);}
    ;

//$$->type gets GOSUB
//$$->text gets assembly code for gosub statement
gosub_statement
    : GOSUB CONSTANT   {$$=handleJump(GOSUB, $2);}
    | GOSUB IDENTIFIER {$$=handleJump(GOSUB, $2);}
    ;

//%%-type gets ASM
//$$->text gets assembly code for statement.  result in A
arith_statement
    : SET addr_exp arith_exp {$$=handleArithSt(SET,  $2, $3);}
    | INC addr_exp           {$$=handleArithSt(INC,  $2);}
    | DEC addr_exp           {$$=handleArithSt(DEC,  $2);}
    | PUSH addr_exp          {$$=handleArithSt(PUSH, $2);}
    | POP addr_exp           {$$=handleArithSt(POP,  $2);}
    ;

//$$->type gets IDENTIFIER or '[' or CONSTANT
//$$->text gets identifier text or is unused or is unused
//$$->kids is unused or see array_access or see CONSTANT
addr_exp
    : lvalue    {$$=handleAddrExp($1);}
    | const_exp {$$=$1;}
    ;    

%%

