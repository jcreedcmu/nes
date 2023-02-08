array zeropage titlescreen_pos 2
array zeropage titlescreen_start 2
array zeropage titlescreen_end 2

//header for nesasm
asm

titlescreen_data_loc:
	.dw titlescreen_data_start, titlescreen_data_end
	titlescreen_data_start:
	.incbin "title/title.dat"
        titlescreen_data_end:
endasm

titlescreen_mode:
	gosub vwait
	gosub titlescreen_load_palette
	gosub vwait
	set $2000 %00000000
	set $2001 %00000000 
        gosub titlescreen_init_background
	gosub vwait
	set $2000 %00010000
	set $2001 %00011110 

//the main program loop
titlescreen_mainloop:
        gosub vwait
        gosub joystick1
        if joy1start = 1 return
        goto titlescreen_mainloop

titlescreen_load_palette:
	//set the PPU start address (background color 0)
	set $2006 $3f
	set $2006 $00
	set $2007 $0e //set base color black
	set $2007 $19 //bg color 1 dark green
	set $2007 $29 //bg color 2 light green
	set $2007 $30 //bg color 3 white
	set $2007 $0e
	set $2007 $27 //bg color 5 orange
	set $2007 $16 //bg color 6 red

	return	

titlescreen_init_background:
	set $2006 $20 //name table 0
	set $2006 $20
asm
  lda titlescreen_data_loc
  sta titlescreen_pos
  sta titlescreen_start
  lda titlescreen_data_loc+1
  sta titlescreen_pos+1
  sta titlescreen_start+1
  lda titlescreen_data_loc+2
  sta titlescreen_end
  lda titlescreen_data_loc+3
  sta titlescreen_end+1
  ldy #0 ;wtf??
titlescreen_ib_loop:
  lda [titlescreen_pos],y
  sta $2007
  clc
  lda titlescreen_pos
  adc #1
  sta titlescreen_pos
  lda titlescreen_pos+1
  adc #0
  sta titlescreen_pos+1
  clc
  lda titlescreen_pos
  cmp titlescreen_end
  bne titlescreen_ib_loop
  lda titlescreen_pos+1
  cmp titlescreen_end+1
  bne titlescreen_ib_loop
endasm
 	set $2006 $23
	set $2006 $f7
        set $2007 %00010101
        return



