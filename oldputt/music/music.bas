;// Usage:
;// Music data is in the format created by the nesmus tool.
;// You may have multiple songs in your ROM, and define each start and stop with an array.
;//
;// The romstart address should point to an array of your song addresses.
;// Romstart is currently defined below as $c000.
;// The Start Address is the first memory byte of your song data.
;// The End Address is the first memory byte after your song data.
;//
;// Each entry is 4 bytes, in this format:
;//		Song Start Address (high byte)
;//		Song Start Address (low byte)
;//		Song End Address (high byte)
;//		Song End Address (low byte)
;// To load a song, set the whichsong variable (first song is 0), then gosub load_music
;// At each frame, you should gosub music_loop
;//

array nbasic_temp 1
array zeropage music_pos 2
array absolute $c000 romstart 0
array music_start 2
array music_end 2
array music_stack 2 ;//hold position for repeats

;//requires whichsong
load_music:
	set music_repeat 0
	set music_wait 0
	set $4015 %00011111 ;//turn on the music channels
	set music_id 0
	set x_base << whichsong 2
	;//now set the start, current, and end addresses
	asm
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
	endasm
	return

music_loop_startloop:
	asm
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
	endasm
	goto music_loop

music_loop_endloop:
	asm
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
	endasm
	goto music_loop

music_loop:
	if music_wait <> 0 then
		dec music_wait
		return
		endif
	asm
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
		endasm

	music_loop_c0:
		if & music_id %11 = 0 goto music_loop_c1
		if & music_id %11 = %11 goto music_loop_c0_full
		asm
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
		endasm


	music_loop_c1:
		if & music_id %1100 = 0 goto music_loop_c2
		if & music_id %1100 = %1100 goto music_loop_c1_full
		asm
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
		endasm


	music_loop_c2:
		if & music_id %110000 = 0 goto music_loop_c3
		if & music_id %110000 = %110000 goto music_loop_c2_full
		asm
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
		endasm


	music_loop_c3:
		if & music_id %11000000 = 0 goto music_loop_increment
		if & music_id %11000000 = %11000000 goto music_loop_c3_full
		asm
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
	endasm
	return

