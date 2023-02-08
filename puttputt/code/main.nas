	.bss
	.org $200

start_level	.macro
	mov16 #mapdata_hole\1_start, mapdata_start
	mov16 #mapdata_hole\1_end, mapdata_end
	jsr show_level
	.endm

sprites 	.ds	256

	.zp

strokes		.ds	1
a_down		.ds	1
b_down		.ds	1
a_pressed	.ds	1
b_pressed	.ds	1
iindex		.ds	1
addend		.ds	2
cursor_x	.ds	1
cursor_y	.ds	1
hbounce		.ds	1
vbounce		.ds	1
tile_local	.ds	1
x_local		.ds	1
y_local		.ds	1
ox		.ds	1
oy		.ds	1
hole_x		.ds	1
hole_y		.ds	1
ball_x		.ds	2
ball_y		.ds	2
speed		.ds	1
speedcount	.ds	1
fspeed		.ds	1
restore		.ds	1
in_meter_mode	.ds	1

	.code

start:

	threads_init
	mov #$00, $4015

	mov #6, $8000
	mov #0, $8001

	lda #0
	sta strokes
	sta a_down
	sta b_down
	sta a_pressed
	sta b_pressed
	sta iindex
	sta addend
	sta addend+1
	sta hbounce
	sta vbounce
	sta tile_local
	sta x_local
	sta y_local
	sta ox
	sta oy
	sta ball_x+1
	sta ball_y+1
	sta fspeed
	sta speed
	sta restore
	sta in_meter_mode
	init_joy1

	mov #16, cursor_x
	mov #0, cursor_y

	jsr titlescreen_mode
	mov #$0F, $4015
	start_thread 0, wisconsin_course_0
	start_thread 1, wisconsin_course_1
	start_thread 2, wisconsin_course_2
	start_thread 3, wisconsin_course_3a
	start_thread 5, grass
;	start_thread 6, meter
	start_thread 7, holes


; the main program loop

mainloop:
	lda fspeed
	cmp #32
	iflt jmp stop_mode

	jsr hide_cursor
	dec fspeed

	lda fspeed
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta speed

	mov #0, speedcount

ball_loop:
	lda speed
	cmp speedcount
	iflt jmp draw_sprites

	inc speedcount
	jsr handle_pos
	lda vbounce
	ifne jsr flip_vertical
	lda hbounce
	ifne jsr flip_horizontal

	lda restore
	beq .norestore
	mov ox, ball_x+1
	mov oy, ball_y+1
	mov #0, restore
.norestore:

	sec
	lda hole_x
	sbc ball_x+1
	jsr abs
	cmp #5	
	bge .nohole

	sec
	lda hole_y
	sbc ball_y+1
	jsr abs
	cmp #5	
	bge .nohole
	
	mov #0, strokes
	mov #0, fspeed
	thread_on 7
	jmp draw_sprites

.nohole:
	mov ball_x+1, ox
	mov ball_y+1, oy

; funny stuff going on here!
	ldx iindex
	lda sin_tab,x
	sta addend
	asl a
	lda #0
	adc #255
	eor #255
	sta addend+1
	add16 ball_x, addend

	clc
	lda iindex
	adc #64
	tax
	lda sin_tab,x
	sta addend
	asl a
	lda #0
	adc #255
	eor #255
	sta addend+1
	add16 ball_y, addend

	jmp ball_loop

stop_mode:
	jsr check_strokes
	lda in_meter_mode
	ifne jmp meter_mode

	lda joy1left
	beq .noleft
	add iindex, #2
.noleft:
	lda joy1right
	beq .noright
	sub iindex, #2
.noright:
	jsr show_cursor
	lda a_pressed
	beq .noa
	start_thread 6, meter
	mov #1, in_meter_mode
	mov #0, a_pressed
	jmp draw_sprites
.noa
;	lda b_pressed
;	beq .nob
;	inc strokes
;	mov #64, fspeed
;.nob
	jmp draw_sprites

meter_mode:
	lda a_pressed
	beq .noa
	thread_off 6
	clc
	lda meter_x
	adc #32
	inc strokes
	sta fspeed
	mov #0, in_meter_mode
.noa


draw_sprites:
	sec
	lda ball_y+1
	sbc #2
	sta sprites
	mov #1, sprites+1
	mov #0, sprites+2
	sec
	lda ball_x+1
	sbc #2
	sta sprites+3

	sec
	lda cursor_y
	sbc #2
	sta sprites+4
	mov #2, sprites+5
	mov #0, sprites+6
	sec
	lda cursor_x
	sbc #2
	sta sprites+7

	mov hole_y, sprites+8
	mov #1, sprites+9
	mov #1, sprites+10
	mov hole_x, sprites+11

	mov #215, sprites+12 ; ???
	mov #5, sprites+13
	mov #0, sprites+14
	clc
	lda meter_x
	adc #32
	sta sprites+15


	do_threads
	jsr vwait

	jmp mainloop


flip_vertical:
	sec
	lda #128
	sbc iindex
	sta iindex
	mov #0, vbounce
	rts

flip_horizontal:
	sec
	lda #0
	sbc iindex
	sta iindex
	mov #0, hbounce
	rts

show_cursor:
	clc
	lda iindex
	adc #128
	tax
	lda sin_tab, x
	jsr div8
	clc
	adc ball_x+1
	sta cursor_x

	clc
	lda iindex
	adc #192
	tax
	lda sin_tab, x
	jsr div8
	clc
	adc ball_y+1
	sta cursor_y
	rts

hide_cursor:
	mov #2, cursor_x
	mov #242, cursor_y
	rts

draw_strokes:
	mov #$23, $2006 
	mov #$61, $2006
	
	clc
	lda strokes
	adc #$10
	sta $2007
	rts

do_hole	.macro
	start_level \1	
	thread_off 7
	yhere
	.endm

holes:
	do_hole 1
	do_hole 2
	do_hole 3
	do_hole 4

	mov #6, $8000
	mov #2, $8001

	do_hole 5
	do_hole 6
	do_hole 7
	do_hole 8
	do_hole 9

	jmp win

	.zp
meter_x		.ds	1
meter_dir	.ds	1
	.code
meter:
	mov #4, meter_dir
	mov #0, meter_x
.loop
	add meter_x, meter_dir
	cmp #192
	bne .nothigh
	mov #-4, meter_dir
	jmp .done
.nothigh:
	cmp #0
	bne .notlow
	mov #4, meter_dir
.notlow
.done:
	yhere
	jmp .loop

check_strokes:
	lda strokes
	cmp #$9
	bne .okay
	pla
	pla
	lda #$ff
	sta $4000
	lda #$40
	sta $4002
	lda #$f8
	sta $4003
	lda #$f2
	sta $4001
	ldx #160
.loop
	jsr vwait
	inx
	bne .loop
	jmp start
.okay
	rts

grass:
	mov #2, $8000
	mov #4, $8001
	here
	mf del, #$20
	mov #2, $8000
	mov #7, $8001
	here
	mf del, #$20
	jmp grass
	
win:
	lda #$ff
	sta $4000
	sta $4002
	sta $4003
	lda #$fa
	sta $4001
	ldx #160
.loop
	jsr vwait
	inx
	bne .loop
	jmp start
