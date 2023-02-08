#include "nbasic.h"
#include "nbasic.tab.h"
#include "nbasic.yy.h"

#define EIGHT_BIT 255
#define SIXTEEN_BIT 65535
#define NBASIC_SCRATCH_VAR "nbasic_scratch"
#define NBAS_MEM_SIZE 2048
#define NBAS_MEM_PAGESIZE 256

#define identify(n) ;//printf("line %d "n"\n",nbasic_line);

SymTab symTbl;
int nbasic_line;
char nbasic_infilename[40];
CodeTree program;
list<string> infilenames;
string outfilename;

#define STR(n) #n
static char opcode_table[][4]={
  STR(ADC), STR(AND), STR(ASL), STR(BCC), STR(BCS), STR(BEQ), STR(BIT),
  STR(BMI), STR(BNE), STR(BPL), STR(BRK), STR(BVC), STR(BVS), STR(CLC),
  STR(CLD), STR(CLI), STR(CLV), STR(CMP), STR(CPX), STR(CPY), STR(DEC),
  STR(DEX), STR(DEY), STR(EOR), STR(INC), STR(INX), STR(INY), STR(JMP),
  STR(JSR), STR(LDA), STR(LDX), STR(LDY), STR(LSR), STR(NOP), STR(ORA),
  STR(PHA), STR(PHP), STR(PLA), STR(PLP), STR(ROL), STR(ROR), STR(RTI),
  STR(RTS), STR(SBC), STR(SEC), STR(SED), STR(SEI), STR(STA), STR(STX),
  STR(STY), STR(TAX), STR(TAY), STR(TSX), STR(TXA), STR(TXS), STR(TYA)
};
#undef STR

string instr(opcode_6502 op, string arg="", addrmode_6502 mode=ABS_6502) {
  string result="\t";
  string eol = "\n";
  string cmt = ";//";
  if (mode==INDX_6502 || 
      mode==INDY_6502) yyerror("unsupported addressing mode");

  switch(op) {
  case LABEL_6502:
    result=arg+":";
    break;
  case COMMENT_6502: 
    result=cmt+arg;
    break;
  default:
    result +=opcode_table[op];
    result +=" ";
    if(mode==IMM_6502)  result+="#";
    result +=arg;
    if(mode==ZPX_6502 ||
       mode==ABSX_6502) result+=",X";
    if(mode==ABSY_6502) result+=",Y";
    break;
  }

  result+=eol;
  return result;
}
void dumpCodeBlock(FILE *f, CodeTree *c) {
  list<CodeTree*>::const_iterator itr;
  for(itr=c->kids.begin(); itr!=c->kids.end(); itr++) {
    if (*itr==NULL) {
      yyerror("\n\nFound a NULL CodeTree.  contact mrl@andrew.cmu.edu");
    } else if ((*itr)->type==IF) {
      dumpCodeBlock(f,*itr);
    } else {
      fprintf(f,(*itr)->text.c_str());
    }
  }
  
}

void generateSysVars() {
  CodeTree *ad, *id, *c;
 
  id = new CodeTree;
  id->text = NBASIC_SCRATCH_VAR;
  c = new CodeTree;
  c->text = "$1";
  handleArrayDecl(id,c);

  ad = new CodeTree;
  ad->text = "$100";
  id = new CodeTree;
  id->text = "nbasic_stack";
  c = new CodeTree;
  c->text = "$100";
  handleArrayDeclAb(ad,id,c);
}

void allocateVars() {
  bool memory[NBAS_MEM_SIZE];
  SymInfo *sym;
  bool addr_ok;
  int i;
  for(i=0;i<NBAS_MEM_SIZE; i++) memory[i]=false;

  //warn about unlocated labels
  while(sym = symTbl.listEach()) {
    if (sym->isLabel)     continue;
    if (sym->assignable)  continue;
    if (sym->declared)    continue;

    printf("warning: insufficiently defined symbol %s\n", sym->name.c_str());
    sym->isLabel=true;
  }  

  //allocate absolute variables
  while(sym = symTbl.listEach()) {
    if (sym->isLabel)     continue;
    if (!sym->assignable) continue;
    if (sym->address==-1) continue;
    if (sym->size==0)     continue;

    for(i=0; i<sym->size;i++) {
      if(memory[sym->address+i]) {
	printf("address conflict for absolute var %s\n",sym->name.c_str());
	exit(1);
      }
      memory[sym->address+i]=true;
    }
  }

  //allocate zeropage variables
  while(sym = symTbl.listEach()) {
    if (sym->isLabel)     continue;
    if (!sym->assignable) continue;
    if (sym->address!=-1) continue;
    if (!sym->zeropage)   continue;
    if (sym->size==0)     continue;

    for(sym->address=0; sym->address<NBAS_MEM_PAGESIZE-sym->size+1; sym->address++) {
      addr_ok=true;
      for(i=0; i<sym->size;i++) {
	if(memory[sym->address+i]) addr_ok=false;
      }
      if(addr_ok) break;
    }
    if(!addr_ok) {
      printf("failed to allocate zeropage var %s\n",sym->name.c_str());
      exit(1);
    }
    for(i=0; i<sym->size;i++) {
      memory[sym->address+i]=true;
    }
  }

  //allocate sized variables
  while(sym = symTbl.listEach()) {
    if (sym->isLabel)     continue;
    if (!sym->assignable) continue;
    if (sym->address!=-1) continue;
    if (sym->size==1)     continue;
    if (sym->size==0)     continue;

    for(sym->address=0; sym->address<NBAS_MEM_SIZE; sym->address++) {
      addr_ok=true;
      for(i=0; i<sym->size;i++) {
	if(memory[sym->address+i]) addr_ok=false;
	if(sym->address/NBAS_MEM_PAGESIZE!=(sym->address+i)/NBAS_MEM_PAGESIZE)
	  addr_ok=false;
      }
      if(addr_ok) break;
    }
    if(!addr_ok) {
      printf("failed to allocate sized var %s\n",sym->name.c_str());
      exit(1);
    }
    for(i=0; i<sym->size;i++) {
      memory[sym->address+i]=true;
    }
  }

  //allocate remaining variables
  while(sym = symTbl.listEach()) {
    if (sym->isLabel)     continue;
    if (!sym->assignable) continue;
    if (sym->address!=-1) continue;
    if (sym->size==0)     continue;

    for(sym->address=0; sym->address<NBAS_MEM_SIZE; sym->address++) {
      addr_ok=true;
      for(i=0; i<sym->size;i++) {
	if(memory[sym->address+i]) addr_ok=false;
      }
      if(addr_ok) break;
    }
    if(!addr_ok) {
      printf("failed to allocate var %s\n",sym->name.c_str());
      exit(1);
    }
    for(i=0; i<sym->size;i++) {
      memory[sym->address+i]=true;
    }
  }
}

void asmMessage(FILE* f,string msg) {
  string border="////////////////////////////////////////////";
  fprintf(f,"%s%s%s",
	 instr(COMMENT_6502,border).c_str(),
	 instr(COMMENT_6502,msg).c_str(),
	 instr(COMMENT_6502,border).c_str()
	 );
}

void dumpVars(FILE* f) {
  SymInfo *sym;
  while(sym = symTbl.listEach()) {
    if(sym->isLabel) continue;
    fprintf(f,"%s%s\t= %d\t;//size = %d\n",
	   sym->address==-1 ? ";" : "",
	   sym->name.c_str(),
	   sym->address,
	   sym->size);
  }  
  fprintf(f,"\n\n\n");
}

void nbasic_output() {
  FILE *outfile;

  if(outfilename.length()!=0) {
    outfile = fopen(outfilename.c_str(),"w+");
  } else {
    outfile = stdout;
  }    
  if(!outfile)
    yyerror("failed to open output file"); 

  asmMessage(outfile,"Nbasic identifiers");  
  dumpVars(outfile);
  asmMessage(outfile,"Nbasic generated code");
  dumpCodeBlock(outfile,&program);

}

int main(int argn, char* argv[]) {

  //process arguments
  for(int i=1;i < argn;) {
      if (!strcmp(argv[i],"-o")) {
	  outfilename = argv[i+1];
	  i+=2;
      } else if (!strcmp(argv[i],"-stdout")) {
	  outfilename = "";
	  i++;
      } else if (!strcmp(argv[i],"-verbose") || (!strcmp(argv[i],"-quiet"))) {
	i++; //ignore these commands here
      } else {
	infilenames.push_back(argv[i]);
	i++;
      }
    }
  
  if(infilenames.empty()) {
    yyerror("no input files specified");
  }
  generateSysVars();

  printf("beginning compilation\n");
  nbasic_wrap();
  yyparse();
  allocateVars();
  printf("dumping output\n");
  nbasic_output();

}

int nbasic_wrap() {
  if(yyin!=stdin&&yyin!=NULL) 
    fclose(yyin);
  if (infilenames.empty()) 
    return 1;

  strcpy(nbasic_infilename,infilenames.front().c_str());
  if(!(yyin=fopen(nbasic_infilename,"r"))) {
    string msg = "failed to open next input file " + infilenames.front();
    yyerror(msg.c_str());
  }

  nbasic_line=1;
  printf("parsing input file %s\n", nbasic_infilename);
  infilenames.pop_front();
  return 0;
}

int dval(const char *c) {
  int radix=10, result=0;
  if(c==NULL) printf("The dval function is about to crash\n");
  if(*c=='$') {radix=16; c++;}
  if(*c=='%') {radix=2; c++;}

  for(;*c!=0; c++) {
    result=result*radix;
    if(*c<='9' && *c>='0') result+=     *c - '0';
    if(*c<='f' && *c>='a') result+=10 + *c - 'a';
    if(*c<='F' && *c>='A') result+=10 + *c - 'A';
  }
  return result;
}

char* sval(int val, int bitmask) {
  static char buf[16];
  sprintf(buf, "$%X",val&bitmask);
  return buf;
}

void evalConstant(CodeTree *constant,int bitmask) {
  if(constant->type==CONSTANT) {
    constant->text  = bitmask==EIGHT_BIT? "#" : "";
    constant->text += sval(constant->kids.front()->type,bitmask);
    delete constant->kids.front();
    constant->kids.pop_back();
  }
}

string evalArrayIndex(CodeTree *array, addrmode_6502 &mode) {
  string result = array->kids.front()->text;
  mode = (addrmode_6502)array->kids.front()->type;

  delete array->kids.front();
  array->kids.pop_back();
  return result;
}

CodeTree* handleAddrExp(CodeTree* ae) {
  identify("handleAddrExp");
  if(ae->type==IDENTIFIER) {
    SymInfo s;
    s.name=ae->text;
    s.assignable=true;
    s.isLabel=false;
    s.declared=false;
    s.size=1;
    s.address=-1;
    s.zeropage=false;

    const SymInfo* err=symTbl.add(s);
    if(err)  yyerror("conflicting defintions of assignable variable");
  }

  return ae;
}

CodeTree* handleArrayAccess(CodeTree* c) {
  identify("handleArrayAccessUnary");

  c->type='[';
  c->text = sval(c->kids.front()->type,SIXTEEN_BIT);
  c->kids.front()->type=(int)ABS_6502;
  c->kids.front()->text="";//instr(LDX_6502,"$0",IMM_6502);

  return c;
}

//$$->type gets '['
//$$->text is the base addr (either a constant or an identifier)
//$$->kids gets a CodeTree whose text sets X to the array index 
CodeTree* handleArrayAccess(CodeTree* id, CodeTree* aexp) {
  identify("handleArrayAccessBinary");

  //we'll return the CodeTree* id.  So, make its
  //text indicate the base off the array access
  switch(id->type) {
  case IDENTIFIER:
    handleLvalue(id);
    break;
  case CONSTANT:
    evalConstant(id, SIXTEEN_BIT);
    break;
  default:
    yyerror("error in nbasic array base handling.  contact mrl@andrew.cmu.edu");
    break;
  }
  id->type='[';

  
  //aexp will be the child of id.  Thus, aexp->text must be the assembly
  // to load the array index into X
  //aexp is currently __ (whose result is in __)
  // register       register
  // identifier     absolute
  // constant       immediate
  // array access   absolute,X
  // expression     A
  if(aexp==NULL) {
    printf("got a null index for an array access");
    return NULL;
  }

  int tmpType=aexp->type;
  aexp->type=(int)ABSX_6502;

  switch(tmpType) {
  case REGISTER:
    if      (aexp->text=="X" || aexp->text=="x") 
      aexp->text="";
    else if (aexp->text=="Y" || aexp->text=="y") {
      aexp->text="";
      aexp->type=(int)ABSY_6502;
    } else if (aexp->text=="A" || aexp->text=="a") aexp->text=instr(TAX_6502);
    break;
  case CONSTANT:
    evalConstant(aexp,EIGHT_BIT);
    //fall through to identifier
  case IDENTIFIER:
    aexp->text=instr(LDX_6502,aexp->text);
    break;
  case '[':
    aexp->text  = 
      aexp->kids.front()->text
      + instr(LDA_6502,aexp->text,(addrmode_6502)aexp->kids.front()->type);
    aexp->text += instr(TAX_6502);
    delete aexp->kids.front();
    aexp->kids.pop_back();
    break;
  case ASM:
    aexp->text += instr(TAX_6502);
    break;
  default:
    yyerror("error in nbasic array index handling.  contact mrl@andrew.cmu.edu");
    break;
  }
  id->kids.push_back(aexp);

  return id;
}

CodeTree* handleArrayDecl  (CodeTree* id, CodeTree* c) {
  identify("handleArrayDecl");
  SymInfo array;
  array.name=id->text;
  array.assignable=true;
  array.isLabel=false;
  array.declared=true;
  array.size=dval(c->text.c_str());
  array.address=-1;
  array.zeropage=false;

  const SymInfo* err=symTbl.add(array);
  if(err) yyerror("conflicting defintions of identifier/array");

  id->type=ARRAY;
  id->text="";
  delete c;
  return id;
}

CodeTree* handleArrayDeclAb(CodeTree* ad, CodeTree* id, CodeTree* c) {
  identify("handleArrayDeclAb");
  SymInfo array;
  array.name=id->text;
  array.assignable=true;
  array.isLabel=false;
  array.declared=true;
  array.size=dval(c->text.c_str());
  array.address=dval(ad->text.c_str());
  array.zeropage=(array.address<256); 

  const SymInfo* err=symTbl.add(array);
  if(err) yyerror("conflicting defintions of identifier/array");

  id->type=ARRAY;
  id->text="";
  delete ad;
  delete c;
  return id;
}

CodeTree* handleArrayDeclZp(CodeTree* id, CodeTree* c) {
  identify("handleArrayDeclZp");
  SymInfo array;
  array.name=id->text;
  array.assignable=true;
  array.isLabel=false;
  array.declared=true;
  array.size=dval(c->text.c_str());
  array.address=-1;
  array.zeropage=false;

  const SymInfo* err=symTbl.add(array);
  if(err) yyerror("conflicting defintions of identifier/array");

  id->type=ARRAY;
  id->text="";
  delete c;
  return id;
}

CodeTree* handleArithSt    (int type, CodeTree* lhs) {
  identify("handleArithStUnary");
  CodeTree *result = new CodeTree;
  result->type=ASM;

  evalConstant(lhs,SIXTEEN_BIT);
  addrmode_6502 arrayMode;

  switch(type) {

  case INC:
    switch (lhs->type) {
    case '[':
      result->text = evalArrayIndex(lhs, arrayMode);
      result->text += instr(INC_6502,lhs->text,arrayMode);
      break;
    case REGISTER:
      if      (lhs->text=="X" || lhs->text=="x") result->text=instr(INX_6502);
      else if (lhs->text=="Y" || lhs->text=="y") result->text=instr(INY_6502);
      else result->text=instr(CLC_6502)+instr(ADC_6502, "$01",IMM_6502);
      break;
    case CONSTANT:  //fall through to IDENTIFIER
    case IDENTIFIER:
      result->text= instr(INC_6502, lhs->text);
      break;
    default:
      yyerror("error in nbasic unary arithmetic statement handling.  contact mrl@andrew.cmu.edu");
      break;
    }
    break;

  case DEC:
    switch (lhs->type) {
    case '[':
      result->text = evalArrayIndex(lhs,arrayMode);
      result->text += instr(DEC_6502,lhs->text,arrayMode);
      break;
    case REGISTER:
      if      (lhs->text=="X" || lhs->text=="x") result->text=instr(DEX_6502);
      else if (lhs->text=="Y" || lhs->text=="y") result->text=instr(DEY_6502);
      else result->text=instr(SEC_6502)+instr(SBC_6502,"$01",IMM_6502);
      break;
    case CONSTANT:  //fall through to IDENTIFIER
    case IDENTIFIER:
      result->text= instr(DEC_6502, lhs->text);
      break;
    default:
      yyerror("error in nbasic unary arithmetic statement handling.  contact mrl@andrew.cmu.edu");
      break;
    }
    break;

  case PUSH:
    switch (lhs->type) {
    case '[':
      result->text = evalArrayIndex(lhs,arrayMode);
      result->text += instr(LDA_6502,lhs->text,arrayMode) + instr(PHA_6502);
      break;
    case REGISTER:
      if      (lhs->text=="X" || lhs->text=="x") result->text=instr(TXA_6502);
      else if (lhs->text=="Y" || lhs->text=="y") result->text=instr(TYA_6502);
      else result->text="";
      result->text+=instr(PHA_6502);
      break;
    case CONSTANT:  //fall through to IDENTIFIER
    case IDENTIFIER:
      result->text=instr(LDA_6502,lhs->text)+instr(PHA_6502);
      break;
    default:
      yyerror("error in nbasic unary arithmetic statement handling.  contact mrl@andrew.cmu.edu");
      break;
    }
    break;

  case POP:
    switch (lhs->type) {
    case '[':
      result->text = evalArrayIndex(lhs,arrayMode);
      result->text += instr(PLA_6502) + instr(STA_6502,lhs->text,arrayMode);
      break;
    case REGISTER:
      if      (lhs->text=="X" || lhs->text=="x") result->text=instr(TAX_6502);
      else if (lhs->text=="Y" || lhs->text=="y") result->text=instr(TAY_6502);
      else result->text="";
      result->text=instr(PLA_6502)+lhs->text;
      break;
    case CONSTANT:  //fall through to IDENTIFIER
    case IDENTIFIER: 
      result->text=instr(PLA_6502)+instr(STA_6502,lhs->text);
      break;
    default:
      yyerror("error in nbasic unary arithmetic statement handling.  contact mrl@andrew.cmu.edu");
      break;
    }
    break;
    
  default:
    yyerror("error in nbasic arithmetic statement handling.  contact mrl@andrew.cmu.edu");
    break;
  }
 
  delete lhs;
  return result;
}

CodeTree* handleArithSt    (int type, CodeTree* lhs, CodeTree* rhs) {
  identify("handleArithStBinary");
  CodeTree* result = new CodeTree;
  result->type = ASM;
  addrmode_6502 arrayMode;

  //even if these aren't constants, it's ok to call evalConstant
  evalConstant(lhs,SIXTEEN_BIT);
  
  if(type!=SET || lhs==NULL || rhs==NULL) {
    yyerror("error in nbasic arithmetic statement handling.  contact mrl@andrew.cmu.edu");
  }
  result->text = "unimplemented set instruction feature";
  
  // SET A STUFF
  if (lhs->type==REGISTER && (lhs->text=="a" || lhs->text=="A")) {
    identify("set A stuff");
    CodeTree *tmp =doLoadA(rhs,"error in nbasic arithmetic statement handling.  contact mrl@andrew.cmu.edu");
    result->text=tmp->text;
    delete tmp;
  }

  // SET X STUFF
  else if (lhs->type==REGISTER && (lhs->text=="x" || lhs->text=="X")) {
    identify ("set X stuff");
    switch (rhs->type) {
    case CONSTANT:
      evalConstant(rhs,EIGHT_BIT);
      yyerror("can't handle 'set x constant'");
      break;
    case REGISTER:
      if      (rhs->text=="a" || rhs->text=="a") result->text = instr(TAX_6502);
      else if (rhs->text=="y" || rhs->text=="Y") result->text = instr(TYA_6502)+instr(TAX_6502);
      else /*empty*/;
      break;
    case IDENTIFIER:
      result->text = instr(LDX_6502,rhs->text);
      break;
    case '[':
      result->text = evalArrayIndex(rhs,arrayMode);
      result->text += instr(LDA_6502,rhs->text,arrayMode);
      result->text += instr(TAX_6502);
      break;
    default:
      result->text = rhs->text;
      result->text += instr(TAX_6502);
      break;
    }
  }
  
  // SET Y STUFF
  else if (lhs->type==REGISTER && (lhs->text=="y" || lhs->text=="Y")) {
    identify("set y stuff");
    switch (rhs->type) {
    case CONSTANT:
      evalConstant(rhs,EIGHT_BIT);
      yyerror("can't handle 'set y constant'");
      break;
    case REGISTER:
      if      (rhs->text=="a" || rhs->text=="a") result->text = instr(TAY_6502);
      else if (rhs->text=="x" || rhs->text=="X") result->text = instr(TXA_6502)+instr(TAY_6502);
      else /*empty*/;
      break;
    case IDENTIFIER:
      result->text = instr(LDY_6502,rhs->text);
      break;
    case '[':
      result->text = evalArrayIndex(rhs,arrayMode);
      result->text += instr(LDY_6502,rhs->text,arrayMode);
      break;
    default:
      result->text = rhs->text;
      result->text += instr(TAY_6502);
      break;
    }
  }

  // SET VAR STUFF or SET CONSTANT STUFF
  else if (lhs->type==IDENTIFIER || lhs->type==CONSTANT) {
    identify("set var stuff or set constant stuff");
    CodeTree *tmp =doLoadA(rhs,"error in nbasic arithmetic statement handling.  contact mrl@andrew.cmu.edu");
    result->text=tmp->text;
    delete tmp;

    result->text+=instr(STA_6502,lhs->text);
  }
  
  // SET ARRAY STUFF
  else if(lhs->type=='[') {
    identify("set array stuff");
    CodeTree *tmp =doLoadA(rhs,"error in nbasic arithmetic statement handling.  contact mrl@andrew.cmu.edu");
    result->text=tmp->text;
    delete tmp;

    result->text += evalArrayIndex(lhs,arrayMode);
    result->text +=instr(STA_6502,lhs->text,arrayMode);
  }
  
  delete rhs;
  delete lhs;
  return result;
}

CodeTree* handleAsmBlock   (CodeTree* bl) {
  identify("handleAsmBlock");
  if (bl==NULL) bl = new CodeTree;
  bl->type=ASM;
  bl->text=
    instr(COMMENT_6502,"asm")
    + bl->text
    + instr(COMMENT_6502,"endasm");
  return bl;
}

CodeTree* handleAsmLines   (CodeTree* bl, CodeTree* ch) {
  identify("handleAsmLines");
  bl->text+=ch->text;
  delete ch;
  return bl;
}

CodeTree* handleCodeBlock  (CodeTree* cb, CodeTree* st) {
  identify("handleCodeBlock");
  if(cb==NULL) cb=&program;
  cb->type = ASM;
  if(st!=0) cb->kids.push_back(st);
  return cb;
}

CodeTree* handleConstExp   (CodeTree* c) {
  identify("handleConstExp");
  CodeTree* result= new CodeTree;
  result->type=CONSTANT;

  c->type=dval(c->text.c_str());
  result->kids.push_back(c);
  return result;
}

CodeTree* handleConstExp   (CodeTree* op, CodeTree* lhs, CodeTree* rhs){
  identify("handleConstExp");
  int val;

  printf("reduced constant expression (%c %d %d)", op->type, lhs->kids.front()->type,rhs->kids.front()->type);

  switch(op->type) {
  case '+': val = lhs->kids.front()->type +  rhs->kids.front()->type; break;
  case '-': val = lhs->kids.front()->type -  rhs->kids.front()->type; break;
  case LSH: val = lhs->kids.front()->type << rhs->kids.front()->type; break;
  case RSH: val = lhs->kids.front()->type >> rhs->kids.front()->type; break;
  case '&': val = lhs->kids.front()->type &  rhs->kids.front()->type; break;
  case '|': val = lhs->kids.front()->type |  rhs->kids.front()->type; break;
  default:
    yyerror("error in nbasic constant expression handling.  contact mrl@andrew.cmu.edu");
    break;
  }
  
  lhs->kids.front()->type=val;

  printf(" to %d\n", lhs->kids.front()->type);

  delete op;
  delete rhs;
  return lhs;
}

CodeTree* handleEnd        (){
  identify("handleEnd");
  //stubbed
  return NULL;
}

std::string NumString(int i){
  char buf[16];
  sprintf(buf,"%i",i);        
  return std::string(buf);
}

CodeTree* handleIf         (CodeTree* re, CodeTree* bl){
  static unsigned label_no;
  identify("handleIf");

  //if this was a short if, convert nstatement into code_block format
  if(bl->kids.size()==0) {
    CodeTree *tmp = new CodeTree;
    tmp->type=ASM;
    tmp->kids.push_back(bl);
    bl=tmp;
  }

  string ifLabel="nbasic_iflabel_";
  string branchString;
  CodeTree* labelNode = new CodeTree;
  labelNode->type = LABEL;

  ifLabel+=NumString(label_no++);
  
  switch(re->type) {
  case '<': branchString=instr(BCS_6502,ifLabel); break;
  case '=': branchString=instr(BNE_6502,ifLabel); break;
  case '>':
    branchString =instr(BCC_6502,ifLabel);
    branchString+=instr(BEQ_6502,ifLabel);
    break;
  case NEQ: branchString=instr(BEQ_6502,ifLabel); break;
  case LEQ:
    branchString =instr(BEQ_6502,ifLabel+"alt");
    branchString+=instr(BCS_6502,ifLabel);
    labelNode->text = ifLabel+"alt";
    handleLabel(labelNode);
    branchString+=labelNode->text; 
    break;
  case GEQ: branchString=instr(BCC_6502,ifLabel); break;
  default: 
    yyerror("error in nbasic IF statement handling.  contact mrl@andrew.cmu.edu");
    break;
  }
  
  re->text += branchString;
  bl->type  = IF;
  bl->kids.push_front(re);

  labelNode->text = ifLabel;
  bl->kids.push_back(handleLabel(labelNode));

  return bl;
}

CodeTree* handleJump       (int type, CodeTree* dest){
  identify("handleJump");
  CodeTree *result=new CodeTree;
  result->type=type;
  switch (type) {
  case RETURN:
    result->text=instr(RTS_6502);
    break;
  case RESUME:
    result->text=instr(RTI_6502);
    break;
  case GOTO: //fall through to GOSUB
  case GOSUB:
    if (dest->type==IDENTIFIER) handleLvalue(dest);
    result->text = instr( (type==GOTO ? JMP_6502 : JSR_6502), dest->text); 
    break;
  default:
    yyerror("error in nbasic jump handling.  contact mrl@andrew.cmu.edu");
    break;
  }
  if(dest!=NULL) delete dest;
  return result;
}

CodeTree* handleLabel      (CodeTree* l){
  identify("handleLabel");
  SymInfo label;
  label.name=l->text;
  label.assignable=false;
  label.isLabel=true;
  label.declared=true;
  label.size=0;
  label.address=-1;
  label.zeropage=false;

  const SymInfo* err=symTbl.add(label);
  if(err) yyerror("conflicting defintions of identifier/label");

  l->text=instr(LABEL_6502, l->text);
  return l;
}

CodeTree* handleLvalue     (CodeTree* c){
  identify("handleLvalue");
  if(c->type=IDENTIFIER) {
    SymInfo s;
    s.name=c->text;
    s.assignable=false;
    s.isLabel=false;
    s.declared=false;
    s.size=0;
    s.address=-1;
    s.zeropage=false;

    const SymInfo* err=symTbl.add(s);
    if(err) yyerror("conflicting defintions of identifier");
  }

  return c;
}

CodeTree* handleOp         (int type){
  identify("handleOp");
  CodeTree* result=new CodeTree;
  result->type=type;
  return result;
}

int reverseRelOp(int op) {
    switch(op) {
    case '=': return '='; break;
    case NEQ: return NEQ; break;
    case '<': return '>'; break;
    case '>': return '<'; break;
    case LEQ: return GEQ; break;
    case GEQ: return LEQ; break;
    default:  return -1; break;
    }    
    return -1;
}

CodeTree* handleRelExp     (CodeTree* op, CodeTree* lhs, CodeTree* rhs){
  CodeTree *result=op;
  result->text = "unsupported relational expression feature.";
  addrmode_6502 arrayMode;

  //make some simple transformations to reduce assembly code
  if(rhs->type==ASM || lhs->type==IDENTIFIER) {
    CodeTree* tmp;
    tmp = rhs;
    rhs = lhs;
    lhs = tmp;
    op->type = reverseRelOp(op->type);
  }

  evalConstant(rhs,EIGHT_BIT);

  CodeTree *tmp =doLoadA(lhs,"error in nbasic arithmetic expressions.  contact mrl@andrew.cmu.edu");
  result->text=tmp->text;
  delete tmp;

  //compare with rhs value
  switch(rhs->type) {
  case REGISTER:
    if      (lhs->text=="A" || lhs->text=="a")
      result->text = instr(STA_6502,NBASIC_SCRATCH_VAR) + result->text;
    else if (lhs->text=="X" || lhs->text=="x")
      result->text = instr(STX_6502,NBASIC_SCRATCH_VAR) + result->text;
    else if (lhs->text=="Y" || lhs->text=="y")
      result->text = instr(STY_6502,NBASIC_SCRATCH_VAR) + result->text;
    result->text += instr(CMP_6502,NBASIC_SCRATCH_VAR);
    break;    
  case ASM:
    op->type = reverseRelOp(op->type);
    result->text += instr(STA_6502,NBASIC_SCRATCH_VAR);
    result->text += rhs->text;
    result->text += instr(CMP_6502,NBASIC_SCRATCH_VAR);
    break;
  case CONSTANT:
    op->type = reverseRelOp(op->type);
    result->text += instr(STA_6502,NBASIC_SCRATCH_VAR);
    result->text += instr(LDA_6502,rhs->text);
    result->text += instr(CMP_6502,NBASIC_SCRATCH_VAR);
    break;
  case IDENTIFIER:
    result->text += instr(CMP_6502,rhs->text);
    break;
  case '[':
    result->text += evalArrayIndex(rhs,arrayMode);
    if(arrayMode==ABSX_6502) {
      result->text += instr(CPX_6502,rhs->text);
    } else {
      result->text += instr(CPY_6502,rhs->text);
    }
    break;
  default:
    yyerror("error in nbasic relational expressions (rhs).  contact mrl@andrew.cmu.edu");
    break;
  } 

  return result;
}

CodeTree *doLoadA(CodeTree* arg, char *errmsg) {
  CodeTree *result = new CodeTree;
  result->type = ASM;
  addrmode_6502 arrayMode;

  switch(arg->type) {
  case ASM:
    result->text = arg->text;
    break;
  case REGISTER:
    if      (arg->text=="x" || arg->text=="X") result->text = instr(TXA_6502);
    else if (arg->text=="y" || arg->text=="Y") result->text = instr(TYA_6502);
    else /*empty*/;
    break;    
  case CONSTANT:
    evalConstant(arg,EIGHT_BIT);
    //fall through to IDENTIFIER
  case IDENTIFIER:
    result->text = instr(LDA_6502,arg->text);
    break;
  case '[':
    result->text = evalArrayIndex(arg,arrayMode);
    result->text += instr(LDA_6502,arg->text,arrayMode);
    break;
  default:
    yyerror(errmsg);
    break;
  }

  return result;
}

CodeTree* doArith(CodeTree* op, CodeTree* lhs, CodeTree* rhs){
  CodeTree * result = new CodeTree;
  result->type = ASM;
  opcode_6502 opcode;
  addrmode_6502 arrayMode;
  
  evalConstant(rhs,EIGHT_BIT);

  switch(op->type) {
  case '&': op->text=""; opcode = AND_6502; break;
  case '|': op->text=""; opcode = ORA_6502; break;
  case '+': 
    op->text=instr(CLC_6502); 
    opcode = ADC_6502; 
    break;
  case '-':    
    op->text=instr(SEC_6502); 
    opcode = SBC_6502; break;
  default:
    yyerror("error in nbasic arithmetic support");
    break;
  }

  CodeTree *tmp =doLoadA(lhs,"error in nbasic arithmetic expressions.  contact mrl@andrew.cmu.edu");
  result->text=tmp->text;
  delete tmp;

  //combine with the second argument
  switch(rhs->type) {
  case ASM:
    result->text += instr(PHA_6502);
    result->text += rhs->text + instr(STA_6502,NBASIC_SCRATCH_VAR);
    result->text += instr(PLA_6502)+ op->text + instr(opcode,NBASIC_SCRATCH_VAR);
    break;
  case REGISTER:
    if      (rhs->text=="x" || rhs->text=="X")
      result->text = instr(STX_6502,NBASIC_SCRATCH_VAR) + result->text;
    else if (rhs->text=="y" || rhs->text=="Y") 
      result->text = instr(STY_6502,NBASIC_SCRATCH_VAR) + result->text;
    else 
      result->text = instr(STA_6502,NBASIC_SCRATCH_VAR) + result->text;
    result->text += op->text+ instr(opcode,NBASIC_SCRATCH_VAR);
    break;    
  case CONSTANT: /*empty, fall through to IDENTIFIER*/
  case IDENTIFIER:
    result->text += op->text + instr(opcode,rhs->text);
    break;
  case '[':
    result->text += evalArrayIndex(rhs,arrayMode);
    result->text += op->text+ instr(opcode,rhs->text,arrayMode);
  default:
    yyerror("error in nbasic arithmetic expressions.  contact mrl@andrew.cmu.edu");
    break;
  }
  
  return result;
}

CodeTree* doShift (CodeTree* op, CodeTree* lhs, CodeTree* rhs) {
  identify("doShift");
  static unsigned label_no;
  string labelString = "nbasic_shiftlabel_"+NumString(label_no++);
  addrmode_6502 arrayMode;

  CodeTree* result=new CodeTree;
  result->type = ASM;
  result->text = "";
  
  switch(op->type) {
  case LSH: op->text = instr(ASL_6502,"A"); break;
  case RSH: op->text = instr(LSR_6502,"A"); break;
  default:
    yyerror("error in nbasic shift operation support");
    break;
  }
  
  //unless rhs is CONSTANT, get value into nbas_scratch_var
  switch(rhs->type) {
  case CONSTANT: break;
  case REGISTER:
    if      (rhs->text=="a" || rhs->text=="A")
      result->text += instr(STA_6502,NBASIC_SCRATCH_VAR);
    else if (rhs->text=="x" || rhs->text=="X")
      result->text += instr(STX_6502,NBASIC_SCRATCH_VAR);
    else
      result->text += instr(STY_6502,NBASIC_SCRATCH_VAR);
    break;
  case IDENTIFIER:
    result->text += instr(LDA_6502, rhs->text);
    result->text += instr(STA_6502, NBASIC_SCRATCH_VAR);
    break;
  case '[':
    result->text += evalArrayIndex(rhs,arrayMode);
    result->text += instr(LDA_6502,rhs->text,arrayMode);
    result->text += instr(STA_6502,NBASIC_SCRATCH_VAR);
    break;
  case ASM:
    result->text += rhs->text;
    result->text += instr(STA_6502,NBASIC_SCRATCH_VAR);
    break;
  default:
    yyerror("error in nbasic shift operation support");
    break;
  }

  //get lhs into A
  CodeTree *tmp =doLoadA(lhs,"error in nbasic shift operation support.  contact mrl@andrew.cmu.edu");
  result->text=tmp->text;
  delete tmp;

  if(rhs->type!=CONSTANT) {
    CodeTree *labelNode=new CodeTree;
    labelNode->text=labelString;
    result->text += handleLabel(labelNode)->text;
    result->text += op->text;
    result->text += instr(DEC_6502,NBASIC_SCRATCH_VAR);
    result->text += instr(BNE_6502,labelString);
  } else {
    unsigned i=rhs->kids.front()->type;
    i= i<9 ? i : 9;
    for(; i!=0; i--) result->text += op->text;
  }

  return result;
}

CodeTree* handleVarExp     (CodeTree* op, CodeTree* lhs, CodeTree* rhs){
  identify("handleVarExp");
  CodeTree* result;
  //result will be code leaving value of expression in A

  //lhs and rhs types could be (and value is)
  // CONSTANT    (immediate)
  // REGISTER    (register)
  // IDENTIFIER  (absolute)
  // '['         (indexed)
  // ASM         (in A)

  switch (op->type) {
  case '&':
  case '|':
  case '+':

    if(rhs->type==ASM || rhs->type==IDENTIFIER) {
      CodeTree* tmp;
      tmp = rhs;
      rhs = lhs;
      lhs = tmp;
    }
    /*intentional fall through*/
  case '-': 
    result = doArith(op,lhs,rhs);
    break;
  case LSH: 
  case RSH: 
    result = doShift(op,lhs,rhs);
    break;
  default:
    yyerror("error in nbasic arithmetic expressions.  contact mrl@andrew.cmu.edu");
    break;
  }

  delete op;
  delete lhs;
  delete rhs;
  return result;
}
