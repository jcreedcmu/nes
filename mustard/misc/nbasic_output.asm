nbasic_stack = 256
chan0_loc = 0
chan1_loc = 2
chan2_loc = 4
chan3_loc = 6

	.include macro.inc

	.inesprg 1
	.ineschr 0
	.inesmir 0
	.inesmap 0


        .bank 0
	.org $8000

start:	
	lda #$0F
	sta $4015
	lda #$FF
	sta $4000
	sta $4002
	sta $4003		
	lda #%11111010
	sta $4001
main_loop:
	jmp     main_loop

nmi:
        gosub music_loop
	rti

	.bank 1
	.org $fffa
	.dw nmi,start,nmi

