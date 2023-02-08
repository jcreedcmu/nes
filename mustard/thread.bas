asm

	.zp	

thread0_loc	.ds 2
thread1_loc	.ds 2
thread2_loc	.ds 2
thread3_loc	.ds 2
thread4_loc	.ds 2
thread5_loc	.ds 2
thread6_loc	.ds 2
thread7_loc	.ds 2

thread0_counter	.ds 1
thread1_counter	.ds 1
thread2_counter	.ds 1
thread3_counter	.ds 1
thread4_counter	.ds 1
thread5_counter	.ds 1
thread6_counter	.ds 1
thread7_counter	.ds 1

soundreg	.ds 2
jmpdest		.ds 2
loc		.ds 2
counter		.ds 1
continue	.ds 1
thread_mask	.ds 1

	.code

do_thread_handler:
	ldy #0
	sty continue
	lda [loc],y
	tay
	and #3
	cmp #3
	bne do_thread_code
;;; special op 
;;; xxxxxx11
	tya
	lsr a
	tax
	mov16sx mft-1, jmpdest
	jmp [jmpdest]
;;; ordinary 6502 code
;;; xxxxxx00, xxxxxx01, xxxxxx10
do_thread_code:
	jmp [loc]

yield_handler:
	clc
	pla
	adc #1 
	sta loc
	pla
	adc #0
	sta loc+1
	rts

endasm