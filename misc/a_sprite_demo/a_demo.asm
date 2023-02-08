nbasic_stack = 256
sprite_dma = 16404
sprite_mem = 512
a_pressed = 0
b_pressed = 1
a_inc = 2
b_inc = 3
spritenum = 4
spritex = 5
spritey = 6
blink = 7
joy1a = 8
joy1b = 9
joy1select = 10
joy1start = 11
joy1up = 12
joy1down = 13
joy1left = 14
joy1right = 15

	.inesprg 1 ;//one PRG bank
	.ineschr 1 ;//one CHR bank
	.inesmir 0 ;//mirroring type 0
	.inesmap 0 ;//memory mapper 0 (none)
	.org $8000
	.bank 0

start:
 jsr vwait
 lda #16
 sta 8192
 lda #30
 sta 8193
 jsr init_vars
 jsr vwait
 jsr load_palette

mainloop:
 jsr joy_handler
 jsr vwait
 lda #2
 sta sprite_dma
 jsr drawstuff
 jmp mainloop

init_vars:
 lda #0
 sta a_pressed
 lda #0
 sta b_pressed
 lda #0
 sta a_inc
 lda #0
 sta b_inc
 lda #65
 sta spritenum
 lda #128
 sta spritex
 lda #120
 sta spritey
 rts

drawstuff:
 lda spritey
 ldx #0
 sta sprite_mem,x
 lda #69
 ldx #1
 sta sprite_mem,x
 lda blink
 ldx #2
 sta sprite_mem,x
 lda #128
 ldx #3
 sta sprite_mem,x
 lda spritey
 ldx #4
 sta sprite_mem,x
 lda #65
 ldx #5
 sta sprite_mem,x
 lda #0
 ldx #6
 sta sprite_mem,x
 lda spritex
 ldx #7
 sta sprite_mem,x
 lda spritey
 ldx #8
 sta sprite_mem,x
 lda #67
 ldx #9
 sta sprite_mem,x
 lda #0
 ldx #10
 sta sprite_mem,x
 lda spritex
 sec
 sbc #16
 ldx #11
 sta sprite_mem,x
 lda spritey
 ldx #12
 sta sprite_mem,x
 lda #67
 ldx #13
 sta sprite_mem,x
 lda #192
 ldx #14
 sta sprite_mem,x
 lda spritex
 sec
 sbc #32
 ldx #15
 sta sprite_mem,x
 lda spritey
 ldx #16
 sta sprite_mem,x
 lda #68
 ldx #17
 sta sprite_mem,x
 lda #192
 ldx #18
 sta sprite_mem,x
 lda spritex
 sec
 sbc #48
 ldx #19
 sta sprite_mem,x
 lda spritey
 ldx #20
 sta sprite_mem,x
 lda #68
 ldx #21
 sta sprite_mem,x
 lda #0
 ldx #22
 sta sprite_mem,x
 lda spritex
 sec
 sbc #64
 ldx #23
 sta sprite_mem,x
 lda spritey
 ldx #24
 sta sprite_mem,x
 lda #66
 ldx #25
 sta sprite_mem,x
 lda #0
 ldx #26
 sta sprite_mem,x
 lda spritex
 sec
 sbc #80
 ldx #27
 sta sprite_mem,x
 rts

joy_handler:
 jsr joystick1
 jsr incrementer
 lda #1
 clc
 adc spritex
 sta spritex
 lda joy1a
 sta blink
 rts

incrementer:
 lda #0
 sta a_inc
 lda #0
 cmp joy1a
 bne nbasic_autolabel_1
 lda #0
 sta a_pressed

nbasic_autolabel_1:
 lda #1
 cmp joy1a
 bne nbasic_autolabel_2
 lda #0
 cmp a_pressed
 bne nbasic_autolabel_3
 lda #1
 sta a_pressed
 lda #89
 cmp spritenum
 bcc nbasic_autolabel_4
 lda #1
 sta a_inc

nbasic_autolabel_4:

nbasic_autolabel_3:

nbasic_autolabel_2:
 lda #0
 sta b_inc
 lda #0
 cmp joy1b
 bne nbasic_autolabel_5
 lda #0
 sta b_pressed

nbasic_autolabel_5:
 lda #1
 cmp joy1b
 bne nbasic_autolabel_6
 lda #0
 cmp b_pressed
 bne nbasic_autolabel_7
 lda #1
 sta b_pressed
 lda #64
 cmp spritenum
 bpl nbasic_autolabel_8
 lda #1
 sta b_inc

nbasic_autolabel_8:

nbasic_autolabel_7:

nbasic_autolabel_6:
 rts

load_palette:
 lda #63
 sta 8198
 lda #0
 sta 8198

thing1:
 lda palette,x
 sta 8199
 inx
 cpx #32
 bne thing1
 rts

palette:

       .db $08,$16,$16,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .db $08,$16,$3d,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

joystick1:
 lda #1
 sta 16406
 lda #0
 sta 16406
 lda 16406
 and #1
 sta joy1a
 lda 16406
 and #1
 sta joy1b
 lda 16406
 and #1
 sta joy1select
 lda 16406
 and #1
 sta joy1start
 lda 16406
 and #1
 sta joy1up
 lda 16406
 and #1
 sta joy1down
 lda 16406
 and #1
 sta joy1left
 lda 16406
 and #1
 sta joy1right
 rts

vwait:

		lda $2002
		bpl vwait ;//wait for start of retrace
	vwait_1:
		lda $2002
		bmi vwait_1 ;//wait for end of retrace
	 lda #0
 sta 8197
 lda #0
 sta 8197
 lda #0
 sta 8198
 lda #0
 sta 8198
 rts

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw start, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "ascii.chr"
	.incbin "ascii.chr"

