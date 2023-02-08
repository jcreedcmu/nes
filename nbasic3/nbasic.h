#ifndef NBASIC_H_
#define NBASIC_H_

#include "SymTab.h"
#include <list>

extern int nbasic_line;
extern char nbasic_infilename[40];

extern int yyparse();
extern int yyerror(const char *msg);
//extern int yywrap();
int nbasic_wrap();
typedef struct CodeTree_s CodeTree;
struct CodeTree_s {
  int type;
  string text;
  list<CodeTree*> kids;
};

typedef enum {
 ADC_6502= 0, AND_6502= 1, ASL_6502= 2, BCC_6502= 3, BCS_6502= 4, BEQ_6502= 5, BIT_6502= 6,
 BMI_6502= 7, BNE_6502= 8, BPL_6502= 9, BRK_6502=10, BVC_6502=11, BVS_6502=12, CLC_6502=13,
 CLD_6502=14, CLI_6502=15, CLV_6502=16, CMP_6502=17, CPX_6502=18, CPY_6502=19, DEC_6502=20,
 DEX_6502=21, DEY_6502=22, EOR_6502=23, INC_6502=24, INX_6502=25, INY_6502=26, JMP_6502=27,
 JSR_6502=28, LDA_6502=29, LDX_6502=30, LDY_6502=31, LSR_6502=32, NOP_6502=33, ORA_6502=34,
 PHA_6502=35, PHP_6502=36, PLA_6502=37, PLP_6502=38, ROL_6502=39, ROR_6502=40, RTI_6502=41,
 RTS_6502=42, SBC_6502=43, SEC_6502=44, SED_6502=45, SEI_6502=46, STA_6502=47, STX_6502=48,
 STY_6502=49, TAX_6502=50, TAY_6502=51, TSX_6502=52, TXA_6502=53, TXS_6502=54, TYA_6502=55,
 LABEL_6502=56, COMMENT_6502=57,
} opcode_6502;

typedef enum {
  IMM_6502, ZP_6502, ZPX_6502, ABS_6502, ABSX_6502, ABSY_6502, INDX_6502, INDY_6502
} addrmode_6502;

int dval(char *c);
std::string instr(opcode_6502 op, std::string arg, addrmode_6502 mode);

CodeTree* doLoadA          (CodeTree* arg, char *errmsg);

CodeTree* handleAddrExp    (CodeTree* ae);
CodeTree* handleArrayAccess(CodeTree* c);
CodeTree* handleArrayAccess(CodeTree* id, CodeTree* aexp);
CodeTree* handleArrayDecl  (CodeTree* id, CodeTree* c=NULL);
CodeTree* handleArrayDeclAb(CodeTree* ad, CodeTree* id, CodeTree* c);
CodeTree* handleArrayDeclZp(CodeTree* id, CodeTree* c);
CodeTree* handleArithSt    (int type, CodeTree* lhs);
CodeTree* handleArithSt    (int type, CodeTree* lhs, CodeTree* rhs);
CodeTree* handleAsmBlock   (CodeTree* bl);
CodeTree* handleAsmLines   (CodeTree* bl, CodeTree* ch);
CodeTree* handleCodeBlock  (CodeTree* cb, CodeTree* St);
CodeTree* handleConstExp   (CodeTree* c);
CodeTree* handleConstExp   (CodeTree* op, CodeTree* lhs, CodeTree* rhs);
CodeTree* handleEnd        ();
CodeTree* handleIf         (CodeTree* re, CodeTree* bl);
CodeTree* handleJump       (int type, CodeTree* dest=NULL);
CodeTree* handleLabel      (CodeTree* l);
CodeTree* handleLvalue     (CodeTree* c);
CodeTree* handleOp         (int type);
CodeTree* handleRelExp     (CodeTree* op, CodeTree* lhs, CodeTree* rhs);
CodeTree* handleVarExp     (CodeTree* op, CodeTree* lhs, CodeTree* rhs);

#endif
