nbasic_stack = 256
romstart = 49152
map_pos = 0
map_start = 2
map_end = 4
music_pos = 6
nbasic_temp = 8
music_start = 9
music_end = 11
music_stack = 13
whichsong = 15
music_repeat = 16
music_wait = 17
music_id = 18
x_base = 19

	.inesprg 1 ;//one PRG bank
	.ineschr 1 ;//one CHR bank
	.inesmir 0 ;//mirroring type 0
	.inesmap 0 ;//memory mapper 0 (none)

	.org $8000
        .bank 0

        .dw musicdata_start, musicdata_end
        musicdata_start:
        .incbin "../music/cal.dat"
        musicdata_end:

mapdata_loc:
	.dw mapdata_start, mapdata_end
	mapdata_start:
	.incbin "title.dat"
        mapdata_end:


 jmp start

start:
 lda #0
 sta whichsong
 jsr load_music
 jsr vwait
 jsr load_palette
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

mainloop:
 jsr music_loop
 jsr vwait
 jmp mainloop

load_palette:
 lda #63
 sta 8198
 lda #0
 sta 8198
 lda #14
 sta 8199
 lda #25
 sta 8199
 lda #41
 sta 8199
 lda #48
 sta 8199
 lda #14
 sta 8199
 lda #39
 sta 8199
 lda #22
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
 lda #35
 sta 8198
 lda #247
 sta 8198
 lda #21
 sta 8199
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
 beq nbasic_autolabel_1
 dec music_wait
 rts

nbasic_autolabel_1:

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
 bne nbasic_autolabel_2
 jmp music_loop_c1

nbasic_autolabel_2:
 lda #3
 and music_id
 cmp #3
 bne nbasic_autolabel_3
 jmp music_loop_c0_full

nbasic_autolabel_3:

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
 bne nbasic_autolabel_4
 jmp music_loop_c2

nbasic_autolabel_4:
 lda #12
 and music_id
 cmp #12
 bne nbasic_autolabel_5
 jmp music_loop_c1_full

nbasic_autolabel_5:

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
 bne nbasic_autolabel_6
 jmp music_loop_c3

nbasic_autolabel_6:
 lda #48
 and music_id
 cmp #48
 bne nbasic_autolabel_7
 jmp music_loop_c2_full

nbasic_autolabel_7:

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
 bne nbasic_autolabel_8
 jmp music_loop_increment

nbasic_autolabel_8:
 lda #192
 and music_id
 cmp #192
 bne nbasic_autolabel_9
 jmp music_loop_c3_full

nbasic_autolabel_9:

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

  rti

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw vretrace, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "title.chr"

