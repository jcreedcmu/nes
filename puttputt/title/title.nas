	.zp

titlescreen_pos		.ds	2


	.code

titlescreen_data_start:
	.incbin "title/title.dat"
titlescreen_data_end:

titlescreen_mode:
	mov #0, ox
	jsr vwait
	jsr titlescreen_load_palette
	jsr vwait
	mov #0, $2000
	mov #0, $2001


        jsr titlescreen_init_background
	jsr vwait

	mov #%00000000, $2000 
	mov #%00001110, $2001 

titlescreen_mainloop:

        jsr vwait
        jsr joystick1
        lda joy1start
	ifne rts


        jmp titlescreen_mainloop

titlescreen_load_palette:
	;set the PPU start address (background color 0)
	mov #$3f, $2006 
	mov #$00, $2006 
	mov #$0e, $2007  ;set base color black
	mov #$19, $2007  ;bg color 1 dark green
	mov #$29, $2007  ;bg color 2 light green
	mov #$30, $2007  ;bg color 3 white
	mov #$0e, $2007 
	mov #$27, $2007  ;bg color 5 orange
	mov #$16, $2007  ;bg color 6 red
	rts


titlescreen_init_background:
	mov #$20, $2006  ;name table 0
	mov #$20, $2006 

	mov16 #titlescreen_data_start, titlescreen_pos
	ldy #0
.loop:
	lda [titlescreen_pos],y
	sta $2007
	inc16 titlescreen_pos
	clc
	lda titlescreen_pos
	cmp #low(titlescreen_data_end)
	bne .loop
	lda titlescreen_pos+1
	cmp #high(titlescreen_data_end)
	bne .loop

 	mov #$23, $2006 
	mov #$f7, $2006 
	mov #%00010101, $2007 
	rts



