music_pos=0
whichsong=2
wait=3
nbasic_temp2=4
nbasic_temp=5
music_start=6
music_end=8
music_stack=10
music_repeat=12
music_wait=13
music_id=14
x_base=15
	.inesprg 2
	.ineschr 0
	.inesmir 1
	.inesmap 0
	
	.org $8000
	.dw musicdata_start, musicdata_end
	musicdata_start:
	.incbin "music.dat"
	musicdata_end:
	.bank 0
start:
 jsr init
 lda #0
 sta whichsong
 jsr load_music
main:
 jsr vwait
 jsr music_loop
 jmp main
timeloop:
 lda #255
 sta wait
timeloop2:
 dec wait
 lda #0
 sta nbasic_temp2
 lda wait
 cmp nbasic_temp2
 beq nbasic_autolabel1
 jmp timeloop2
nbasic_autolabel1:
 rts
vwait:
	lda $2002
	bpl vwait
vwait2:
	lda $2002
	bmi vwait2
 rts
init:
 lda #48
 sta $2000
 lda #28
 sta $2001
 rts
nmi:
 rts
load_music:
 lda #0
 sta music_repeat
 lda #0
 sta music_wait
 lda #31
 sta $4015
 lda #0
 sta music_id
 lda whichsong
 asl a
 asl a
 sta x_base
		ldx x_base
		lda $8000,x
		sta music_start
		sta music_pos
		inx
		lda $8000,x
		sta music_start+1
		sta music_pos+1
		inx
		lda $8000,x
		sta music_end
		inx
		lda $8000,x
		sta music_end+1	
 rts
music_loop_startloop:
		iny ;//y is already 0
		lda [music_pos],y
		sta music_repeat
		;//inc music counter and put on music stack
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
		beq music_loop_endloop_lasttime ;//last time
		;//else jump to start of loop
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
 sta nbasic_temp2
 lda music_wait
 cmp nbasic_temp2
 beq nbasic_autolabel2
 dec music_wait
 rts
nbasic_autolabel2:
		;//set new wait time and ID byte
		ldy #0
		lda [music_pos],y
		;//check if we're handling a repeat
		cmp #255
		beq music_loop_startloop
		cmp #254
		beq music_loop_endloop
		;//continue on our merry way
		sta music_wait
		iny
		lda [music_pos],y
		sta music_id
		iny
music_loop_c0:
 lda #0
 sta nbasic_temp2
 lda music_id
 and #3
 cmp nbasic_temp2
 bne nbasic_autolabel3
 jmp music_loop_c1
nbasic_autolabel3:
 lda #3
 sta nbasic_temp2
 lda music_id
 and #3
 cmp nbasic_temp2
 bne nbasic_autolabel4
 jmp music_loop_c0_full
nbasic_autolabel4:
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
 lda #0
 sta nbasic_temp2
 lda music_id
 and #12
 cmp nbasic_temp2
 bne nbasic_autolabel5
 jmp music_loop_c2
nbasic_autolabel5:
 lda #12
 sta nbasic_temp2
 lda music_id
 and #12
 cmp nbasic_temp2
 bne nbasic_autolabel6
 jmp music_loop_c1_full
nbasic_autolabel6:
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
 lda #0
 sta nbasic_temp2
 lda music_id
 and #48
 cmp nbasic_temp2
 bne nbasic_autolabel7
 jmp music_loop_c3
nbasic_autolabel7:
 lda #48
 sta nbasic_temp2
 lda music_id
 and #48
 cmp nbasic_temp2
 bne nbasic_autolabel8
 jmp music_loop_c2_full
nbasic_autolabel8:
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
 lda #0
 sta nbasic_temp2
 lda music_id
 and #192
 cmp nbasic_temp2
 bne nbasic_autolabel9
 jmp music_loop_increment
nbasic_autolabel9:
 lda #192
 sta nbasic_temp2
 lda music_id
 and #192
 cmp nbasic_temp2
 bne nbasic_autolabel10
 jmp music_loop_c3_full
nbasic_autolabel10:
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
		;//increment the music counter
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
		;//reset counter if music end
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
	.bank 3
	.org $fffa
	.dw nmi		;//NMI
	.dw start	;//Reset
	.dw start	;//BRK
	.bank 4
	.org $0000
	;//end of file
