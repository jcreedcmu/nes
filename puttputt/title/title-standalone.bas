array zeropage map_pos 2
array zeropage map_start 2
array zeropage map_end 2

//header for nesasm
asm
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


endasm

//the program starts here on NES boot (see footer)
goto start


start:
        set whichsong 0
        gosub load_music

	gosub vwait
	gosub load_palette
	gosub vwait
	set $2000 %00000000
	set $2001 %00000000 
        gosub init_background
	gosub vwait
	set $2000 %10000000
	set $2001 %00011110 

//the main program loop
mainloop:
        gosub music_loop
        gosub vwait
        goto mainloop

//load the colors
load_palette:
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


//wait until screen refresh
vwait:
	asm
		lda $2002
		bpl vwait ;//wait for start of retrace
	vwait_1:
		lda $2002
		bmi vwait_1 ;//wait for end of retrace
	endasm
	//set scroll and PPU base address
	set $2005 0
	set $2005 0
	set $2006 0
	set $2006 0
	return


init_background:
	set $2006 $20 //name table 0
	set $2006 $20
asm
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
endasm
 	set $2006 $23
	set $2006 $f7
        set $2007 %00010101
        return



