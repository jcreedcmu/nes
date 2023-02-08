#include "SymTab.h"

using namespace std;

SymTab::SymTab() {
  recentInList=table.begin();
}

SymTab::~SymTab() {
  SymInfo * s;
  while(!table.empty()) {
    s=*(table.begin());
    table.pop_front();
    delete s;
  }
}

const SymInfo*SymTab::add(const SymInfo &s){
  recentInList=table.begin();
  SymInfo* existing=find(s.name);
  
  //if this is a new symbol, add it to the table as is.
  //assume assignable and label attributes don't clash
  if(existing==NULL) {
    SymInfo* newSym    = new SymInfo;
    newSym->name       = s.name;
    newSym->assignable = s.assignable;
    newSym->isLabel    = s.isLabel;
    newSym->declared   = s.declared;
    newSym->size       = s.size;
    newSym->address    = s.address;
    newSym->zeropage   = s.zeropage;
    
    table.push_back(newSym);
    return NULL;
  } 

  //check for clash in assignable and label attributes
  if(s.assignable)   existing->assignable=true;
  if(s.isLabel)      existing->isLabel=true;
  if(existing->assignable && existing->isLabel)
    return existing;
  
  //if adding a symbol from a declaration,
  // make sure it doesn't squash previous declarations
  if(s.declared)   {
    if(existing->declared) return existing;
    existing->declared=true;
    existing->size=s.size;
    existing->address=s.address;
    existing->zeropage=s.zeropage;
  }

  //watch for assignability's effect on size
  if(!existing->declared && existing->assignable) existing->size=1;

  return NULL;
}

SymInfo* SymTab::find(const string &sym) const {
  list<SymInfo*>::const_iterator itr;
  for(itr=table.begin();itr!=table.end();itr++) {
    if((*itr)->name==sym) return *itr;
  }
  return NULL;
}

SymInfo* SymTab::listEach(){
  if (recentInList==table.end()) {
    recentInList=table.begin();
    return NULL;
  }
  return *(recentInList++);
}
