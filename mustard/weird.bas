array zeropage bgptr 2
array zeropage tmp 1
array zeropage drumpos 1

asm


start:	
	threads_init
	mov16 #music0, thread0_loc
	mov16 #music1, thread1_loc
	mov16 #music3, thread3_loc

	mov16 #dance, thread4_loc
	thread_on 0
	thread_on 1
	thread_on 3
	thread_on 4

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
	thread_on 4
	jmp .anyway
.no:
	thread_off 4
.anyway:
	do_threads
	jsr vwait
	jmp     main_loop

music3:

	mov #0, drumpos

.l:
	inc drumpos
	lda drumpos
	cmp #4
	beq .silence
	pat_wisconsin_course_drums
	jmp .l
.silence
	mov #0, drumpos
	pat_wisconsin_course_silence
	jmp .l

music0:
	pat_wisconsin_course_melody
	jmp music0

music1:
	pat_wisconsin_course_melody2
	jmp music1

dance:
	here
	mf del, #$03
	mov #2, $8000
	mov #0, $8001
	yhere
	mf del, #$03
	mov #2, $8000
	mov #1, $8001
	yhere
	mf del, #$03
	mov #2, $8000
	mov #2, $8001
	yhere
	mf del, #$03
	mov #2, $8000
	mov #3, $8001
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

endasm

joystick1:
	set $4016 1 //first strobe byte
	set $4016 0 //second strobe byte
	set joy1a		& [$4016] 1
	set joy1b		& [$4016] 1
	set joy1select	& [$4016] 1
	set joy1start	& [$4016] 1
	set joy1up		& [$4016] 1
	set joy1down	& [$4016] 1
	set joy1left	& [$4016] 1
	set joy1right	& [$4016] 1
	return
