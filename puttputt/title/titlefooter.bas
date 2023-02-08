vretrace:           
asm
  rti

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw vretrace, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "title.chr"
endasm
