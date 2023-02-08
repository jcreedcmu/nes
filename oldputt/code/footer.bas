//file footer

//dont_call_me:
// set draw 0

vretrace:
        gosub joystick1
        gosub edge_detect
        gosub draw_strokes
        set sprite_dma 2        
asm
  rti

        .include "sin/sin.tab"

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw vretrace, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "gfx/gfx.chr"
	.incbin "title/title.chr"
endasm
