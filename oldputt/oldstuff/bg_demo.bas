array absolute $4014 sprite_dma 0
array absolute $200 sprites 256

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
	.incbin "wis.dat"
	musicdata_end:

endasm

//the program starts here on NES boot (see footer)
goto start


start:
        set whichsong 0
        gosub load_music

        set a_down 0
        set b_down 0
        set a_pressed 0
        set b_pressed 0

        set iindex 0
        set addend_l 0
        set addend_h 0
        set cursor_x 16
        set cursor_y 0
        set ball_x_h 100
        set ball_y_h 100
        set ball_x_l 0
        set ball_y_l 0
        set speed 0
        set fspeed 0
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
        if a_pressed = 0 set fspeed - fspeed 1
asm
        lda fspeed
        lsr a
        lsr a
        lsr a
        lsr a
        lsr a
        sta speed
endasm

ball_loop:
        if speed = 0 goto draw_sprites
        set speed - speed 1
        if ball_y_h = 8 gosub flip_vertical
        if ball_y_h = 232 gosub flip_vertical
        if ball_x_h = 0 gosub flip_horizontal
        if ball_x_h = 255 gosub flip_horizontal
        if ball_x_h > 145 then
         if ball_x_h < 155 then
         if ball_y_h > 95 then
         if ball_y_h < 105 then
          set fspeed 0
          set ball_x_h 100
          set ball_y_h 100
          goto draw_sprites
         endif
         endif
         endif
        endif
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
        if a_pressed = 1 set fspeed 254
draw_sprites:
        set [sprites 0] - ball_y_h 2
        set [sprites 1] 1
        set [sprites 2] 0
        set [sprites 3] - ball_x_h 2
        set [sprites 4] - cursor_y 2
        set [sprites 5] 2
        set [sprites 6] 0
        set [sprites 7] - cursor_x 2
        set [sprites 8] 100
        set [sprites 9] 1
        set [sprites 10] 1
        set [sprites 11] 150

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
//set $2009 1
//set $2008 iindex
        set iindex - 128 iindex
//set $2008 iindex
        return

flip_horizontal:
        set iindex - 0 iindex
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
	set $2006 $20
        set ib_y 0
ib_out_loop:
        set ib_x 0
ib_in_loop:
         if ib_x = 0 then 
           set $2007 %00101000
           goto ib_done
         endif
         if ib_x = 31 then 
           set $2007 %00100010
           goto ib_done
         endif
         if ib_y = 0 then 
           set $2007 %00100100
           goto ib_done
         endif
         if ib_y = 27 then 
           set $2007 %00100001
           goto ib_done
         endif

         set $2007 0
ib_done:
         set ib_x + 1 ib_x
         if ib_x <> 32 branchto ib_in_loop
        set ib_y + 1 ib_y
        if ib_y <> 28 branchto ib_out_loop

	set $2006 $20
	set $2006 $20
	set $2007 %00101100
	set $2006 $20
	set $2006 $3f
	set $2007 %00100110
	set $2006 $23
	set $2006 $80
	set $2007 %00101001
	set $2006 $23
	set $2006 $9f
	set $2007 %00100011


        return
       
