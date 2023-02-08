nbasic_stack = 256
thread0_loc = 0
thread1_loc = 2
thread2_loc = 4
thread3_loc = 6
thread4_loc = 8
thread5_loc = 10
thread6_loc = 12
thread7_loc = 14
thread0_counter = 16
thread1_counter = 17
thread2_counter = 18
thread3_counter = 19
thread4_counter = 20
thread5_counter = 21
thread6_counter = 22
thread7_counter = 23
soundreg = 24
jmpdest = 26
loc = 28
counter = 30
continue = 31
thread_mask = 32

 .list 
 .include "macro.inc"

	.inesprg 1
	.ineschr 0
	.inesmir 0
	.inesmap 0


        .bank 0
	.org $8000

start:	
	mov16 #music, thread0_loc
	mov16 #music2, thread1_loc
	mov #%00000011, thread_mask

	jsr vwait
	jsr vwait
	mov #%10000000, $2000
	mov #%00000000, $2001

	mov #$0F, $4015


main_loop:
	do_thread 0
	do_thread 1
	do_thread 2
	do_thread 3
	do_thread 4
	do_thread 5
	do_thread 6
	do_thread 7
	jsr vwait
	jmp     main_loop

;;; del;;;

	mf_handler del, 1
	lda counter
	bne .decrement
	ldarg
	beq .quit
	sta counter
	yredo
.decrement:
	dec counter
	beq .quit
	yredo
.quit:
	next

;;; note ;;;

	mf_handler note, 1
	lda #$f
	ldy #0
	sta [soundreg],y
	lda #0
	iny
	sta [soundreg],y
	ldarg
	iny
	sta [soundreg],y
	lda #9
	iny
	sta [soundreg],y
	next

;;; noted ;;;

	mf_handler noted, 2
	delay_header 2
	lda #$f
	ldy #0
	sta [soundreg],y
	lda #0
	iny
	sta [soundreg],y
	ldarg
	iny
	sta [soundreg],y
	lda #9
	iny
	sta [soundreg],y
	delay_footer

;;; crazy ;;;

	mf_handler crazy, 2
	delay_header 1
	lda #%10100000
	ldy #0
	sta [soundreg],y
	lda #%10001111
	iny
	sta [soundreg],y
	ldarg 2
	iny
	sta [soundreg],y
	lda #%00001111
	iny
	sta [soundreg],y
	delay_footer

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

music:
	here
	mf noted, $2f, $10
	mf del, $10
	mf noted, $2f, $10
	mf noted, $2f, $30
	jmp music

music2:
	here
	mf note, $60
	mf del, $06
	mf note, $e0
	mf del, $06
	mf note, $d0
	mf del, $60
	mf note, $c0
	mf del, $06
	jmp music2


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

mft:
	mft_entry del
	mft_entry note
	mft_entry noted
	mft_entry crazy

nmi:
	rti

	.bank 1
	.org $fffa
	.dw nmi,start,start


