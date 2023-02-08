# MAGICKIT LINUX MAKEFILE
#

RM       = rm
CC       = gcc

CFLAGS   = -O2 -Wall

OBJS     = main.o input.o assemble.o expr.o code.o command.o\
         macro.o func.o proc.o symbol.o pcx.o output.o crc.o\
         pce.o map.o mml.o nes.o

EXEDIR   = .

TARGPCE  = $(EXEDIR)/pceas
TARGNES  = $(EXEDIR)/nesasm
TARGETS  = $(TARGNES)

#
#

all: $(TARGETS)

# CLEAN
#

clean:
	$(RM) *.o
	$(RM) ..\..\bin\pceas
	$(RM) ..\..\bin\nesasm

# ASSEMBLER
#

$(OBJS)  : defs.h externs.h protos.h
main.o   : inst.h vars.h
expr.o   : expr.h
pce.o    : pce.h
nes.o    : nes.h
%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $<

# EXE
#

$(TARGPCE) : $(OBJS)
	$(CC) $(OBJS) -o $(TARGPCE)
$(TARGNES) : $(OBJS)
	$(CC) $(OBJS) -o $(TARGNES)

