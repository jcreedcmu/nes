	.zp

bgptr 	.ds 2
tmp 	.ds 1

joy1a		.ds 1
joy1b		.ds 1
joy1select	.ds 1
joy1start	.ds 1
joy1up		.ds 1
joy1down	.ds 1
joy1left	.ds 1
joy1right	.ds 1

	.code

start:	
	threads_init

	start_thread 0, your_turn_to_win_0_c
	start_thread 1, your_turn_to_win_1
	start_thread 3, your_turn_to_win_3a



	mov16 #dance, thread4_loc


	mov #$0F, $4015

	jsr vwait
	jsr vwait
	mov #0, $2000
	mov #0, $2001
palette:
	ppua #bgpal
	ppuw #$30
	ppuw #$20
	ppuw #$10
	ppuw #$0e

init_background:
	mov16 #bgnam, bgptr
	add16 bgptr, #(2 + 3 * $20)
	jsr draw_guy
	mov16 #bgnam, bgptr
	add16 bgptr, #(10 + 9 * $20)
	jsr draw_guy
	mov16 #bgnam, bgptr
	add16 bgptr, #(18 + 5 * $20)
	jsr draw_guy


	jsr vwait
	jsr vwait
	mov #%10010000, $2000
	mov #%00001000, $2001

main_loop:
	jsr joystick1
	lda joy1a
	beq .no
;	thread_on 4
	jmp .anyway
.no:
;	thread_off 4
.anyway:
	do_threads
	jsr vwait
	jmp     main_loop


	; import All the Songs
	all_songs

dance:
	here
	mov #2, $8000
	mov #0, $8001
	thread_off 4
	yhere
	mf del, #$03
	mov #2, $8000
	mov #1, $8001
	thread_off 4
	yhere
	mov #2, $8000
	mov #2, $8001
	thread_off 4
	yhere
	mov #2, $8000
	mov #3, $8001
	thread_off 4
	yhere
	jmp dance

vwait:
	lda $2002
	bpl vwait ; wait for start of retrace
.loop:
;	lda $2002
;	bmi .loop ; wait for end of retrace

	; set scroll and PPU base address
	mov #0, $2005
	mov #0, $2005
	mov #0, $2006
	mov #0, $2006
	rts

draw_guy:
	ppua bgptr
	clc
	mov #0, tmp
	ldy #0
	.yl:
	ldx #0
	.xl:
	lda tmp
	ppuw a
	adc #1
	sta tmp
	inx
	cpx #8
	bne .xl
	add16 bgptr, #$20
	ppua bgptr
	iny
	cpy #8
	bne .yl
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
