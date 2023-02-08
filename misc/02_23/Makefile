
INCDIRS = .

SRCS = nbasic.cpp SymTab.cpp nbasic.yy.cpp nbasic.tab.c
OBJS = nbasic.o SymTab.o nbasic.yy.o nbasic.tab.o

default: nbasic

nbasic.yy.cpp:  nbasic.l
	flex -v -o nbasic.yy.cpp --header-file=nbasic.yy.h nbasic.l
nbasic.yy.o: nbasic.yy.cpp
	g++ -x c++ -c -o nbasic.yy.o nbasic.yy.cpp
nbasic.tab.c: nbasic.y
	bison -v -d nbasic.y
nbasic.tab.o: nbasic.tab.c
	g++ -x c++ -c -o nbasic.tab.o nbasic.tab.c


nbasic : $(SRCS) $(OBJS)
	g++ -O2 -I $(INCDIRS) -o nbasic.exe $(OBJS)


clean :
	rm -rf *.o *.yy.* *.tab.* *~ *.exe