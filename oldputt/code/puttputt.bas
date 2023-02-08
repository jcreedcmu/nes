array absolute $4014 sprite_dma 0
array absolute $200 sprites 256
array absolute $300 jmp_dest 2
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
	.incbin "music/cal.dat"
	musicdata_end:

mapdata_loc:
	.dw mapdata_start, mapdata_end
	mapdata_start:
	.incbin "map/basic.dat"
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
       .dw tile_brick
endasm

//the program starts here on NES boot (see footer)
goto start


start:
        set whichsong 0
        gosub load_music

        set strokes 0

        set a_down 0
        set b_down 0
        set a_pressed 0
        set b_pressed 0

        set iindex 0
        set addend_l 0
        set addend_h 0
        set cursor_x 16
        set cursor_y 0
        set hbounce 0
        set vbounce 0
        set tile_local 0
        set x_local 0
        set y_local 0
        set hole_x 170
        set hole_y 170
        set ball_x_h 20
        set ball_y_h 30
        set ball_x_l 0
        set ball_y_l 0
        set speed 0
        set speedcount 0
        set fspeed 0
        gosub titlescreen_mode
	gosub vwait
	set $2000 %00000000
	set $2001 %00000000 
        gosub init_background
	gosub vwait
	set $2000 %10000000
	set $2001 %00011110 
	gosub vwait
	gosub load_palette

//the main program loop
mainloop:
        if fspeed < 32 goto stop_mode
        gosub hide_cursor
        set fspeed - fspeed 1
asm
        lda fspeed
        lsr a
        lsr a
        lsr a
        lsr a
        lsr a
        sta speed
endasm
        set speedcount 0

ball_loop:
        if speedcount > speed goto draw_sprites
        set speedcount + speedcount 1
        gosub handle_pos
        if vbounce = 1 gosub flip_vertical
        if hbounce = 1 gosub flip_horizontal
        if restore = 1 then
          set ball_x_h ox
          set ball_y_h oy
          set restore 0
        endif

        if ball_x_h > - hole_x 5 then
         if ball_x_h <= + hole_x 5 then
         if ball_y_h > - hole_y 5 then
         if ball_y_h <= + hole_y 5 then
          set strokes 0
          set fspeed 0
          set ball_x_h 20
          set ball_y_h 30
          goto draw_sprites
         endif
         endif
         endif
        endif

        set ox ball_x_h
        set oy ball_y_h
asm
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

endasm
        goto ball_loop

stop_mode:
        if joy1left = 1 set iindex + 2 iindex
        if joy1right = 1 set iindex - iindex 2
        gosub show_cursor
        if a_pressed = 1 then
          set strokes + 1 strokes
          set fspeed 254
        endif
        if b_pressed = 1 then
          set strokes + 1 strokes 
          set fspeed 64
        endif
draw_sprites:
        set [sprites 0] - ball_y_h 2
        set [sprites 1] 1
        set [sprites 2] 0
        set [sprites 3] - ball_x_h 2
        set [sprites 4] - cursor_y 2
        set [sprites 5] 2
        set [sprites 6] 0
        set [sprites 7] - cursor_x 2
        set [sprites 8] hole_y
        set [sprites 9] 1
        set [sprites 10] 1
        set [sprites 11] hole_x

        gosub music_loop
	gosub vwait
	goto mainloop

//load the colors
load_palette:
	//set the PPU start address (background color 0)
	set $2006 $3f
	set $2006 $00
	set $2007 $1a //set base color green
	set $2007 $08 //bg color 1 brown
	set $2007 $2a //bg color 2 green
	set $2007 $28 //bg color 3 yellow
	set $2006 $3f
	set $2006 $11
	set $2007 $0a //fg color 1 black
	set $2007 $10 //fg color 2 gray
	set $2007 $20 //fg color 3 white
	set $2007 $00
	set $2007 $0a //fg color 5 black
	set $2007 $0a //fg color 6 black
	set $2007 $0a //fg color 7 black


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

flip_vertical:
        set iindex - 128 iindex
        set vbounce 0
        return

flip_horizontal:
        set iindex - 0 iindex
        set hbounce 0
        return

joystick1:
	set $4016 1 //first strobe byte
	set $4016 0 //second strobe byte
	set joy1a		& [$4016] 1
	set joy1b		& [$4016] 1
	set joy1select	& [$4016] 1
	set joy1start	& [$4016] 1
	set joy1up		& [$4016] 1
	set joy1down	& [$4016] 1
	set joy1left	& [$4016] 1
	set joy1right	& [$4016] 1
	return


edge_detect:
	//handle A button
        set a_pressed joy1a
        if a_down = 1 set a_pressed 0
        set a_down joy1a
        set b_pressed joy1b
        if b_down = 1 set b_pressed 0
        set b_down joy1b
        return


// signed division by 8
div8:
   if & div8_arg $80 <> 0 then
asm
     lda div8_arg
     eor #$ff
     lsr a
     lsr a
     lsr a
     eor #$ff
     sta div8_arg
     rts
endasm
   endif
   set div8_arg >> div8_arg 3
   return


show_cursor:
        set div8_arg [sin_tab + iindex 128]
        gosub div8
        set cursor_x + ball_x_h div8_arg
        set div8_arg [sin_tab + iindex 192]
        gosub div8
        set cursor_y + ball_y_h div8_arg
        return
hide_cursor:
        set cursor_x 2
        set cursor_y 242
        return


init_background:
	set $2006 $20 //name table 0
	set $2006 $00
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
        return

handle_pos:
   set argx 0
   set argy 0
   array zeropage madd 2
   set argh 0
   set argl 0
   // GAH horrible bit twiddling ahead
asm
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
endasm     

tile_wall:
   if & 1 tile_local <> 0 then
    if y_local = 7 then set vbounce 1 set restore 1 endif
//    if y_local = 6 then set vbounce 1 set restore 1 endif
   endif
   if & 4 tile_local <> 0 then
    if y_local = 0 then set vbounce 1 set restore 1 endif
//    if y_local = 1 then set vbounce 1 set restore 1 endif
   endif
   if & 2 tile_local <> 0 then
    if x_local = 7 then set hbounce 1 set restore 1 endif
//    if x_local = 6 then set hbounce 1 set restore 1 endif
   endif
   if & 8 tile_local <> 0 then
    if x_local = 0 then set hbounce 1 set restore 1 endif
//    if x_local = 1 then set hbounce 1 set restore 1 endif
   endif
   return

tile_grass:
      if fspeed > 128 set fspeed >> fspeed 2
      set speed >> fspeed 5
      set iindex + 1 iindex
      return

tile_brick:
      if y_local = 6 then
       set vbounce 1
       set restore 1
       return
      endif
      if x_local = 0 then
       set hbounce 1
       set restore 1
      endif
      if x_local = 7 then
       set hbounce 1
       set restore 1
      endif
      if y_local < 6 then
       set ball_y_h + ball_y_h - 7 y_local
       return
      endif

      return

tile_do_nothing:
   return

draw_strokes:
      set $2006 $23
      set $2006 $61
      set $2007 + 16 strokes
      return
