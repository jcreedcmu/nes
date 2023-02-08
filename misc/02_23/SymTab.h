#ifndef NBASIC_SYMTAB_H
#define NBASIC_SYMTAB_H

#include <string>
#include <list>

using namespace std;

typedef struct{
  string name;
  bool   assignable; //true once used as destination of a store
  bool   isLabel;    //true once declared as a label
  bool   declared;   //true onced declared as array or as label
  int    size;       //0 in general
                     //1 once used as destination of a store
                     //fixed once declared as array
  int    address;    //-1 unless declared as absolute array
  bool   zeropage;   //true once declared as zeropage array
} SymInfo;

class SymTab {
 public:
  SymTab();
  ~SymTab();
  const SymInfo* add(const SymInfo &s);
  SymInfo* find(const string &sym) const;
  SymInfo* listEach();

 private:
  list <SymInfo*> table;

  list<SymInfo*>::iterator recentInList;
};

#endif
