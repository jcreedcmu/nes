%{
#include "nbasic.h"
#include "nbasic.tab.h"

using namespace std;

#undef yywrap
#define YY_SKIP_YYWRAP
int yywrap() {
  return nbasic_wrap();
}

%}

eol (\r|\n|(\r\n))

%x ASMBLOCK

%%

"<<"       {return LSH;}
">>"       {return RSH;}
"<="       {return LEQ;}
">="       {return GEQ;}
"<>"       {return NEQ;}
absolute   {return ABSOLUTE;}
array      {return ARRAY;}
^[ \t]*asm {BEGIN ASMBLOCK; return ASM;}
dec        {return DEC;}
end        {return END;}
endif      {return ENDIF;}
gosub      {return GOSUB;}
goto       {return GOTO;}
if         {return IF;}
inc        {return INC;}
pop        {return POP;}
push       {return PUSH;}
resume     {return RESUME;}
return     {return RETURN;}
set        {return SET;}
then       {return THEN;}
var        {return VAR;}
zeropage   {return ZEROPAGE;}

$[0-9a-fA-F]+ {
    yylval.val=new CodeTree;
    yylval.val->type = CONSTANT;
    yylval.val->text = yytext;
    return CONSTANT;
  }

[0-9]+ {
    yylval.val=new CodeTree;
    yylval.val->type = CONSTANT;
    yylval.val->text = yytext;
    return CONSTANT;
  }

%[01]+ {
    yylval.val=new CodeTree;
    yylval.val->type = CONSTANT;
    yylval.val->text = yytext;
    return CONSTANT;
  }

("//"|;|#).*{eol} {nbasic_line++; return COMMENT;}

[a-zA-Z][a-zA-Z_0-9]*/: {
    yylval.val=new CodeTree;
    yylval.val->type = LABEL;
    yylval.val->text = yytext;
    return LABEL;
  }

[axyAXY] {
    yylval.val=new CodeTree;
    yylval.val->type = REGISTER;
    yylval.val->text = yytext;
    return REGISTER;
  }

[b-wzB-WZ]|([a-zA-Z][a-zA-Z_0-9]+) {
    yylval.val=new CodeTree;
    yylval.val->type = IDENTIFIER;
    yylval.val->text = yytext;
    return IDENTIFIER;
  }

[ \t] {}               /*(ignore whitespace */
{eol} {nbasic_line++;} /*(ignore whitespace */

[^ \t\r\n] {return yytext[0];}

<ASMBLOCK>[^\r\n]         {
    yylval.val=new CodeTree;
    yylval.val->type = ASMCHAR;
    yylval.val->text = yytext;
    return ASMCHAR;
  }
<ASMBLOCK>{eol} {
    nbasic_line++;
    yylval.val=new CodeTree;
    yylval.val->type = ASMCHAR;
    yylval.val->text = yytext;
    return ASMCHAR;
  }

<ASMBLOCK>^[ \t]*endasm{eol} {BEGIN INITIAL; nbasic_line++; return ENDASM;}

%%