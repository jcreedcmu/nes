nbasic_stack = 256
sprite_dma = 16404
sprites = 512
jmp_dest = 768
romstart = 49152
map_pos = 0
map_start = 2
map_end = 4
madd = 6
music_pos = 8
nbasic_temp = 10
music_start = 11
music_end = 13
music_stack = 15
whichsong = 17
a_down = 18
b_down = 19
a_pressed = 20
b_pressed = 21
iindex = 22
addend_l = 23
addend_h = 24
cursor_x = 25
cursor_y = 26
hbounce = 27
vbounce = 28
tile_local = 29
x_local = 30
y_local = 31
ball_x_h = 32
ball_y_h = 33
ball_x_l = 34
ball_y_l = 35
speed = 36
speedcount = 37
fspeed = 38
restore = 39
ox = 40
oy = 41
joy1a = 42
joy1b = 43
joy1select = 44
joy1start = 45
joy1up = 46
joy1down = 47
joy1left = 48
joy1right = 49
div8_arg = 50
argx = 51
argy = 52
argh = 53
argl = 54
music_repeat = 55
music_wait = 56
music_id = 57
x_base = 58

	.inesprg 1 ;//one PRG bank
	.ineschr 1 ;//one CHR bank
	.inesmir 0 ;//mirroring type 0
	.inesmap 0 ;//memory mapper 0 (none)

	.org $8000
        .bank 0
	.dw musicdata_start, musicdata_end
	musicdata_start:
	.incbin "wis.dat"
	musicdata_end:

mapdata_loc:
	.dw mapdata_start, mapdata_end
	mapdata_start:
	.incbin "basic.dat"
        mapdata_end:

tile_table:
       .dw tile_do_nothing
       .dw tile_wall
       .dw tile_wall
       .dw tile_wall

       .dw tile_wall
       .dw tile_wall
       .dw tile_wall
       .dw tile_wall

       .dw tile_wall
       .dw tile_wall
       .dw tile_wall
       .dw tile_wall

       .dw tile_wall
       .dw tile_wall
       .dw tile_wall
       .dw tile_wall

       .dw tile_grass
 jmp start

start:
 lda #0
 sta whichsong
 jsr load_music
 lda #0
 sta a_down
 lda #0
 sta b_down
 lda #0
 sta a_pressed
 lda #0
 sta b_pressed
 lda #0
 sta iindex
 lda #0
 sta addend_l
 lda #0
 sta addend_h
 lda #16
 sta cursor_x
 lda #0
 sta cursor_y
 lda #0
 sta hbounce
 lda #0
 sta vbounce
 lda #0
 sta tile_local
 lda #0
 sta x_local
 lda #0
 sta y_local
 lda #20
 sta ball_x_h
 lda #30
 sta ball_y_h
 lda #0
 sta ball_x_l
 lda #0
 sta ball_y_l
 lda #0
 sta speed
 lda #0
 sta speedcount
 lda #0
 sta fspeed
 jsr vwait
 lda #0
 sta 8192
 lda #0
 sta 8193
 jsr init_background
 jsr vwait
 lda #128
 sta 8192
 lda #30
 sta 8193
 jsr vwait
 jsr load_palette

mainloop:
 lda #32
 cmp fspeed
 bcc nbasic_autolabel_1
 jmp stop_mode

nbasic_autolabel_1:
 jsr hide_cursor
 lda fspeed
 sec
 sbc #1
 sta fspeed

        lda fspeed
        lsr a
        lsr a
        lsr a
        lsr a
        lsr a
        sta speed
 lda #0
 sta speedcount

ball_loop:
 lda speed
 cmp speedcount
 bpl nbasic_autolabel_2
 jmp draw_sprites

nbasic_autolabel_2:
 lda #1
 clc
 adc speedcount
 sta speedcount
 jsr handle_pos
 lda #1
 cmp vbounce
 bne nbasic_autolabel_3
 jsr flip_vertical

nbasic_autolabel_3:
 lda #1
 cmp hbounce
 bne nbasic_autolabel_4
 jsr flip_horizontal

nbasic_autolabel_4:
 lda #1
 cmp restore
 bne nbasic_autolabel_5
 lda ox
 sta ball_x_h
 lda oy
 sta ball_y_h
 lda #0
 sta restore

nbasic_autolabel_5:
 lda #145
 cmp ball_x_h
 bpl nbasic_autolabel_6
 lda #155
 cmp ball_x_h
 bmi nbasic_autolabel_7
 lda #35
 cmp ball_y_h
 bpl nbasic_autolabel_8
 lda #45
 cmp ball_y_h
 bmi nbasic_autolabel_9
 lda #0
 sta fspeed
 lda #20
 sta ball_x_h
 lda #30
 sta ball_y_h
 jmp draw_sprites

nbasic_autolabel_9:

nbasic_autolabel_8:

nbasic_autolabel_7:

nbasic_autolabel_6:
 lda ball_x_h
 sta ox
 lda ball_y_h
 sta oy

        ldx iindex
        lda sin_tab,x
        sta addend_l
        asl a
        lda #0
        adc #255
        eor #255
        sta addend_h
        clc
        lda ball_x_l
        adc addend_l
        sta ball_x_l
        lda ball_x_h
        adc addend_h
        sta ball_x_h

        clc
        lda iindex
        adc #64
        tax
        lda sin_tab,x
        sta addend_l
        asl a
        lda #0
        adc #255
        eor #255
        sta addend_h
        clc
        lda ball_y_l
        adc addend_l
        sta ball_y_l
        lda ball_y_h
        adc addend_h
        sta ball_y_h

 jmp ball_loop

stop_mode:
 lda #1
 cmp joy1left
 bne nbasic_autolabel_10
 lda iindex
 clc
 adc #2
 sta iindex

nbasic_autolabel_10:
 lda #1
 cmp joy1right
 bne nbasic_autolabel_11
 lda iindex
 sec
 sbc #2
 sta iindex

nbasic_autolabel_11:
 jsr show_cursor
 lda #1
 cmp a_pressed
 bne nbasic_autolabel_12
 lda #254
 sta fspeed

nbasic_autolabel_12:
 lda #1
 cmp b_pressed
 bne nbasic_autolabel_13
 lda #64
 sta fspeed

nbasic_autolabel_13:

draw_sprites:
 lda ball_y_h
 sec
 sbc #2
 ldx #0
 sta sprites,x
 lda #1
 ldx #1
 sta sprites,x
 lda #0
 ldx #2
 sta sprites,x
 lda ball_x_h
 sec
 sbc #2
 ldx #3
 sta sprites,x
 lda cursor_y
 sec
 sbc #2
 ldx #4
 sta sprites,x
 lda #2
 ldx #5
 sta sprites,x
 lda #0
 ldx #6
 sta sprites,x
 lda cursor_x
 sec
 sbc #2
 ldx #7
 sta sprites,x
 lda #40
 ldx #8
 sta sprites,x
 lda #1
 ldx #9
 sta sprites,x
 lda #1
 ldx #10
 sta sprites,x
 lda #150
 ldx #11
 sta sprites,x
 jsr music_loop
 jsr vwait
 jmp mainloop

load_palette:
 lda #63
 sta 8198
 lda #0
 sta 8198
 lda #26
 sta 8199
 lda #8
 sta 8199
 lda #42
 sta 8199
 lda #63
 sta 8198
 lda #17
 sta 8198
 lda #10
 sta 8199
 lda #16
 sta 8199
 lda #32
 sta 8199
 lda #0
 sta 8199
 lda #10
 sta 8199
 lda #10
 sta 8199
 lda #10
 sta 8199
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

flip_vertical:
 lda #128
 sec
 sbc iindex
 sta iindex
 lda #0
 sta vbounce
 rts

flip_horizontal:
 lda #0
 sec
 sbc iindex
 sta iindex
 lda #0
 sta hbounce
 rts

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

edge_detect:
 lda joy1a
 sta a_pressed
 lda #1
 cmp a_down
 bne nbasic_autolabel_14
 lda #0
 sta a_pressed

nbasic_autolabel_14:
 lda joy1a
 sta a_down
 lda joy1b
 sta b_pressed
 lda #1
 cmp b_down
 bne nbasic_autolabel_15
 lda #0
 sta b_pressed

nbasic_autolabel_15:
 lda joy1b
 sta b_down
 rts

div8:
 lda #128
 and div8_arg
 cmp #0
 beq nbasic_autolabel_16

     lda div8_arg
     eor #$ff
     lsr a
     lsr a
     lsr a
     eor #$ff
     sta div8_arg
     rts

nbasic_autolabel_16:
 lda div8_arg
 clc
 lsr a
 lsr a
 lsr a
 sta div8_arg
 rts

show_cursor:
 lda #128
 clc
 adc iindex
 tax
 lda sin_tab,x
 sta div8_arg
 jsr div8
 lda div8_arg
 clc
 adc ball_x_h
 sta cursor_x
 lda #192
 clc
 adc iindex
 tax
 lda sin_tab,x
 sta div8_arg
 jsr div8
 lda div8_arg
 clc
 adc ball_y_h
 sta cursor_y
 rts

hide_cursor:
 lda #2
 sta cursor_x
 lda #242
 sta cursor_y
 rts

init_background:
 lda #32
 sta 8198
 lda #32
 sta 8198

  lda mapdata_loc
  sta map_pos
  sta map_start
  lda mapdata_loc+1
  sta map_pos+1
  sta map_start+1
  lda mapdata_loc+2
  sta map_end
  lda mapdata_loc+3
  sta map_end+1
  ldy #0 ;wtf??
ib_loop:
  lda [map_pos],y
  sta $2007
  clc
  lda map_pos
  adc #1
  sta map_pos
  lda map_pos+1
  adc #0
  sta map_pos+1
  clc
  lda map_pos
  cmp map_end
  bne ib_loop
  lda map_pos+1
  cmp map_end+1
  bne ib_loop
 rts

handle_pos:
 lda #0
 sta argx
 lda #0
 sta argy
 lda #0
 sta argh
 lda #0
 sta argl

   lda ball_x_h
   and #%00000111
   sta x_local
   lda ball_y_h
   and #%00000111
   sta y_local
 
   lda ball_x_h
   lsr a  
   lsr a  
   lsr a
   sta argx
   clc
   lda ball_y_h
   sec
   sbc #8
   lsr a
   lsr a
   lsr a
   sta argy
   lsr a
   lsr a
   lsr a
   sta madd+1 ; high byte
   clc
   lda ball_y_h
   sec
   sbc #8
   and #%00111000
   asl a
   asl a 
   adc argx ; carry bit should be clear here I think
   sta madd ; low byte

   clc
   lda madd
   adc map_start
   sta madd
   lda madd+1
   adc map_start+1
   sta madd+1
   ldy #0
   lda [madd],y
   sec
   sbc #32
   sta tile_local
   asl a
   tax 
   lda tile_table,x
   sta jmp_dest
   lda tile_table+1,x
   sta jmp_dest+1
   jmp [jmp_dest]

tile_wall:
 lda tile_local
 and #1
 cmp #0
 beq nbasic_autolabel_17
 lda #7
 cmp y_local
 bne nbasic_autolabel_18
 lda #1
 sta vbounce
 lda #1
 sta restore

nbasic_autolabel_18:

nbasic_autolabel_17:
 lda tile_local
 and #4
 cmp #0
 beq nbasic_autolabel_19
 lda #0
 cmp y_local
 bne nbasic_autolabel_20
 lda #1
 sta vbounce
 lda #1
 sta restore

nbasic_autolabel_20:

nbasic_autolabel_19:
 lda tile_local
 and #2
 cmp #0
 beq nbasic_autolabel_21
 lda #7
 cmp x_local
 bne nbasic_autolabel_22
 lda #1
 sta hbounce
 lda #1
 sta restore

nbasic_autolabel_22:

nbasic_autolabel_21:
 lda tile_local
 and #8
 cmp #0
 beq nbasic_autolabel_23
 lda #0
 cmp x_local
 bne nbasic_autolabel_24
 lda #1
 sta hbounce
 lda #1
 sta restore

nbasic_autolabel_24:

nbasic_autolabel_23:
 rts

tile_grass:
 lda #128
 cmp fspeed
 bpl nbasic_autolabel_25
 lda fspeed
 clc
 lsr a
 lsr a
 sta fspeed

nbasic_autolabel_25:
 lda fspeed
 clc
 lsr a
 lsr a
 lsr a
 lsr a
 lsr a
 sta speed
 lda iindex
 clc
 adc #1
 sta iindex
 rts

tile_do_nothing:
 rts

load_music:
 lda #0
 sta music_repeat
 lda #0
 sta music_wait
 lda #31
 sta 16405
 lda #0
 sta music_id
 lda whichsong
 clc
 asl a
 asl a
 sta x_base

		ldx x_base
		lda romstart,x
		sta music_start
		sta music_pos
		inx
		lda romstart,x
		sta music_start+1
		sta music_pos+1
		inx
		lda romstart,x
		sta music_end
		inx
		lda romstart,x
		sta music_end+1	
	 rts

music_loop_startloop:

		iny ;;//y is already 0
		lda [music_pos],y
		sta music_repeat
		;;//inc music counter and put on music stack
		clc
		lda music_pos
		adc #2
		sta music_pos
		sta music_stack
		lda music_pos+1
		adc #0
		sta music_pos+1
		sta music_stack+1
	 jmp music_loop

music_loop_endloop:

		dec music_repeat
		lda music_repeat
		cmp #0
		beq music_loop_endloop_lasttime ;;//last time
		;;//else jump to start of loop
		lda music_stack
		sta music_pos
		lda music_stack+1
		sta music_pos+1
		jmp music_loop
	music_loop_endloop_lasttime:
		clc
		lda music_pos
		adc #1
		sta music_pos
		lda music_pos+1
		adc #0
		sta music_pos+1
	 jmp music_loop

music_loop:
 lda #0
 cmp music_wait
 beq nbasic_autolabel_26
 dec music_wait
 rts

nbasic_autolabel_26:

		;;//set new wait time and ID byte
		ldy #0
		lda [music_pos],y
		;;//check if we're handling a repeat
		cmp #255
		beq music_loop_startloop
		cmp #254
		beq music_loop_endloop
		;;//continue on our merry way
		sta music_wait
		iny
		lda [music_pos],y
		sta music_id
		iny
		
music_loop_c0:
 lda #3
 and music_id
 cmp #0
 bne nbasic_autolabel_27
 jmp music_loop_c1

nbasic_autolabel_27:
 lda #3
 and music_id
 cmp #3
 bne nbasic_autolabel_28
 jmp music_loop_c0_full

nbasic_autolabel_28:

	music_loop_c0_partial:
	music_loop_c0_full:
		lda [music_pos],y
		sta $4000
		iny
		lda [music_pos],y
		sta $4001
		iny
		lda [music_pos],y
		sta $4002
		iny
		lda [music_pos],y
		sta $4003
		iny
		
music_loop_c1:
 lda #12
 and music_id
 cmp #0
 bne nbasic_autolabel_29
 jmp music_loop_c2

nbasic_autolabel_29:
 lda #12
 and music_id
 cmp #12
 bne nbasic_autolabel_30
 jmp music_loop_c1_full

nbasic_autolabel_30:

	music_loop_c1_partial:
	music_loop_c1_full:
		lda [music_pos],y
		sta $4004
		iny
		lda [music_pos],y
		sta $4005
		iny
		lda [music_pos],y
		sta $4006
		iny
		lda [music_pos],y
		sta $4007
		iny
		
music_loop_c2:
 lda #48
 and music_id
 cmp #0
 bne nbasic_autolabel_31
 jmp music_loop_c3

nbasic_autolabel_31:
 lda #48
 and music_id
 cmp #48
 bne nbasic_autolabel_32
 jmp music_loop_c2_full

nbasic_autolabel_32:

	music_loop_c2_partial:
	music_loop_c2_full:
		lda [music_pos],y
		sta $4008
		iny
		lda [music_pos],y
		sta $4009
		iny
		lda [music_pos],y
		sta $400a
		iny
		lda [music_pos],y
		sta $400b
		iny
		
music_loop_c3:
 lda #192
 and music_id
 cmp #0
 bne nbasic_autolabel_33
 jmp music_loop_increment

nbasic_autolabel_33:
 lda #192
 and music_id
 cmp #192
 bne nbasic_autolabel_34
 jmp music_loop_c3_full

nbasic_autolabel_34:

	music_loop_c3_partial:
	music_loop_c3_full:
		lda [music_pos],y
		sta $400c
		iny
		lda [music_pos],y
		sta $400d
		iny
		lda [music_pos],y
		sta $400e
		iny
		lda [music_pos],y
		sta $400f
		iny

	music_loop_increment:
		;;//increment the music counter
		tya
		sta nbasic_temp
		clc
		lda music_pos
		adc nbasic_temp
		sta music_pos
		lda music_pos+1
		adc #0
		sta music_pos+1
	music_loop_increment_2:
		;;//reset counter if music end
		clc
		lda music_pos
		cmp music_end
		bne music_loop_end
		lda music_pos+1
		cmp music_end+1
		bne music_loop_end
		lda music_start
		sta music_pos
		lda music_start+1
		sta music_pos+1
	music_loop_end:
	 rts

vretrace:
 jsr joystick1
 jsr edge_detect
 lda #2
 sta sprite_dma

;  lda draw
;  beq nmi_done
;  clc
;  lda argl
;  adc #$20
;  sta argl
;  lda argh
;  adc #$20
;  sta argh
;  lda argh
;  sta $2006
;  lda argl
;  sta $2006
;  lda #47
;  sta $2007
;  lda #0
;  sta draw
;nmi_done:

  rti

        .include "sin.tab"

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw vretrace, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "hex.chr"
	.incbin "hex.chr"

