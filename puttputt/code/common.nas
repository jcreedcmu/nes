	.zp

; used in a couple of places,
; tiles.nas and thread.nas

jmpdest		.ds	2

joy1a		.ds	1
joy1b		.ds	1
joy1select	.ds	1
joy1start	.ds	1
joy1up		.ds	1
joy1down	.ds	1
joy1left	.ds	1
joy1right	.ds	1

	.code

; wait until screen refresh
vwait:
	lda $2002
	bpl vwait ; wait for start of retrace
	; set scroll and PPU base address
	mov #0, $2005
	mov #0, $2005
	mov #0, $2006
	mov #0, $2006
	rts

joystick1:
	mov #1, $4016
	mov #0, $4016
	get_button joy1a
	get_button joy1b
	get_button joy1select
	get_button joy1start
	get_button joy1up
	get_button joy1down
	get_button joy1left
	get_button joy1right
	rts

edge_detect_on	.macro
        mov joy1\1, \1_pressed
        lda \1_down
	beq .\1_not_down
	mov #0, \1_pressed
.\1_not_down:
        mov joy1\1, \1_down 
	.endm

edge_detect:
	edge_detect_on a
	edge_detect_on b
	rts

; signed division by 8
div8:
	bpl .pos
	eor #$ff
	lsr a
	lsr a
	lsr a
	eor #$ff
	rts
.pos:
	lsr a
	lsr a
	lsr a
	rts

; absolute value
abs:
	bmi .neg
	rts
.neg:
	clc
	eor #$ff
	adc #1
	rts