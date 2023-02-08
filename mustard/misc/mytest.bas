asm
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
	do_threads
	jsr vwait
	jmp     main_loop

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

	//set scroll and PPU base address
	mov #0, $2005
	mov #0, $2005
	mov #0, $2006
	mov #0, $2006
	rts
endasm