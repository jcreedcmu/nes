array zeropage thread0_loc 2
array zeropage thread1_loc 2
array zeropage thread2_loc 2
array zeropage thread3_loc 2
array zeropage thread4_loc 2
array zeropage thread5_loc 2
array zeropage thread6_loc 2
array zeropage thread7_loc 2

array zeropage thread0_counter 1
array zeropage thread1_counter 1
array zeropage thread2_counter 1
array zeropage thread3_counter 1
array zeropage thread4_counter 1
array zeropage thread5_counter 1
array zeropage thread6_counter 1
array zeropage thread7_counter 1

array zeropage soundreg 2
array zeropage jmpdest 2
array zeropage loc 2
array zeropage counter 1
array zeropage continue 1
array zeropage thread_mask 1

asm

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