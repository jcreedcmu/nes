array absolute $4014 sprite_dma 0
array absolute $200 sprites 256

//header for nesasm
asm
	.inesprg 4
	.ineschr 1
	.inesmir 0
	.inesmap 4 ;//memory mapper 4 (MMC3)

	.bank 7
	.org $e000
endasm

start:
	set a 0
	set $2000 a
	set $2001 a //turn off the PPU
	asm
		sei ;//disable interrupts
	endasm
	gosub vwait
	gosub vwait //it's good to wait 2 vblanks at the start

// palette bs
	set $2006 $3f
	set $2006 $00
	set $2007 $1a //set base color green
	set $2007 $08 //bg color 1 brown
	set $2007 $2a //bg color 2 green
	set $2007 $28 //bg color 3 yellow

	gosub vwait
	set $2006 $21 //name table 0
	set $2006 $21
	set $2007 $00
	set $2007 $40
	set $2007 $80
	set $2007 $c0
	set $2007 97
	set $2007 $00

	asm
		ldx #$ff
		txs ;//reset the stack
	endasm

	gosub vwait
	set $2000 %10010000 //NMI, bg 1, fg 0
	set $2001 %00011110 //show sprites, bg, clipping



// gosub debug
 //       set $8000 %01000110
// gosub debug
//        set $8001 3
// gosub debug
//        set $8000 %00000110
// gosub debug
 //       set $8001 4
 //gosub debug
//        set $8000 %00000111
// gosub debug
//        set $8001 5
// gosub debug

set count_l 0
set count_h 0
mainloop:
asm
        clc
        lda count_l
        adc #1
        sta count_l
        lda count_h
        adc #0
        sta count_h
endasm        
 
	set nmi_hit 0

     
// mmc3 commands. cross our fingers!
        set $8000 %00000010

        if count_h < 64 then
        set $8001 1
	endif
        if count_h >= 64 then
        set $8001 2
        endif

	gosub vwait_end

	goto mainloop

nmi_wait:
	if nmi_hit = 0 branchto nmi_wait
	return

nmi:
	set nmi_hit 1
	resume

irq:
	resume

//wait full vertical retrace
vwait:
	gosub vwait_start
	gosub vwait_end
	return

//wait until start of vertical retrace
vwait_start:
	asm
		lda $2002
		bpl vwait_start
	endasm
	return

//wait until end of vertical retrace
vwait_end:
	asm
		lda $2002
		bmi vwait_end
	endasm
	//set scroll and PPU base address
	set a 0
	set $2005 a
	set $2005 a
	set $2006 a
	set $2006 a
	return

draw:
	return

debug:
        set $2009 0
        set $2008 [$8000]
        set $2008 [$a000]
        set $2008 [$c000]
        set $2008 [$fffa]
        set $2009 0
        return

//file footer
asm
        .bank 0
        .db $00
        .bank 1
        .db $10
        .bank 2
        .db $20
        .bank 3
        .db $30
        .bank 4
        .db $40
        .bank 5
        .db $50
        .bank 6
        .db $60

        .bank 7
;//jump table points to NMI, Reset, and IRQ start points
	.org $fffa
	.dw nmi, start, irq

        .bank 8
        .org $0000
        .incbin "stuff.chr"
        .incbin "stuff.chr"


endasm

;        set [sprites 0] - ball_y_h 2
;        set [sprites 1] 1
;        set [sprites 2] 0
;        set [sprites 3] - ball_x_h 2
