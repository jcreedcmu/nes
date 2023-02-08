array chan0_loc 2
array chan1_loc 2
array chan2_loc 2
array chan3_loc 2
array loc 2
array counter 1

asm
 .list 
 .include "macro.inc"

	.inesprg 1
	.ineschr 0
	.inesmir 0
	.inesmap 0


        .bank 0
	.org $8000

start:	
	stw music, chan0_loc

	jsr vwait
	jsr vwait
	lda #%10000000
	sta $2000
	lda #%00000000
	sta $2001

	lda #$0F
	sta $4015


main_loop:
	do_chan 0
	jsr vwait
	jmp     main_loop

yield_handler:
	clc
	pla
	adc #1 
	sta loc
	pla
	adc #0
	sta loc+1
	rts

music:
	lda #$FF
	sta $4000
	sta $4002
	sta $4003		
	lda #%11111010
	sta $4001
	lda #$3F
	sta counter
music2:
	ldx counter
	dex
	beq music
	stx counter
	yield
	jmp music2
endasm

vwait:
	asm
		lda $2002
		bpl vwait ;//wait for start of retrace
	vwait_1:
		lda $2002
		bmi vwait_1 ;//wait for end of retrace
	endasm
	//set scroll and PPU base address
	set $2005 0
	set $2005 0
	set $2006 0
	set $2006 0
	return


asm
nmi:
	rti

	.bank 1
	.org $fffa
	.dw nmi,start,start

endasm