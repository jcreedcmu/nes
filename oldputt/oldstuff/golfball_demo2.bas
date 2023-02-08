array absolute $4014 sprite_dma 0
array absolute $200 sprites 256

//header for nesasm
asm
	.inesprg 1 ;//one PRG bank
	.ineschr 1 ;//one CHR bank
	.inesmir 0 ;//mirroring type 0
	.inesmap 0 ;//memory mapper 0 (none)
	.org 32768
	.bank 0
endasm

//the program starts here on NES boot (see footer)
goto start


start:
        set a_down 0
        set b_down 0
        set a_pressed 0
        set b_pressed 0

        set iindex 0
        set jindex 0
        set addend_l 0
        set addend_h 0
        set ball_x_h 100
        set ball_y_h 100
        set ball_x_l 0
        set ball_y_l 0
        set result_l 0
        set result_h 0
        set mult_counter 0
        set speed 0
        set fspeed 0

	gosub vwait
	set $2000 %10000000
	set $2001 %00011110 
	gosub vwait
	gosub load_palette

//the main program loop
mainloop:
        if joy1a = 1 set fspeed + 3 fspeed
        if joy1a = 0 set fspeed - fspeed 1
        if fspeed > 128 set fspeed 0
        if fspeed > 24 set fspeed 24

asm
        lda fspeed
        sta speed 
        lsr speed
        lsr speed
        lsr speed
endasm
        if joy1left = 1 set iindex + 2 iindex
        if joy1right = 1 set iindex - iindex 2
        if ball_x_h = 0 gosub flip_horizontal
        if ball_x_h = 255 gosub flip_horizontal
        if ball_y_h = 8 gosub flip_vertical
        if ball_y_h = 224 gosub flip_vertical
        set jindex + 64 iindex
        set result_l 0
        set result_h 0

asm
        ldx iindex
        lda sin_tab,x
        sta addend_l
        asl a
        lda #0
        adc #255
        eor #255
        sta addend_h
        lda ball_x_l
        sta result_l
        lda ball_x_h
        sta result_h
        lda speed
        sta mult_counter
        jsr mult
        lda result_l
        sta ball_x_l
        lda result_h
        sta ball_x_h
endasm
        set result_l 0
        set result_h 0
asm
        ldx jindex
        lda sin_tab,x
        sta addend_l
        asl a
        lda #0
        adc #255
        eor #255
        sta addend_h
        lda ball_y_l
        sta result_l
        lda ball_y_h
        sta result_h
        lda speed
        sta mult_counter
        jsr mult
        lda result_l
        sta ball_y_l
        lda result_h
        sta ball_y_h

endasm
        set [sprites 0] ball_y_h
        set [sprites 1] 1
        set [sprites 2] 0
        set [sprites 3] ball_x_h

	gosub vwait
	goto mainloop

//load the colors
load_palette:
	//set the PPU start address (background color 0)
	set $2006 $3f
	set $2006 $00
	set $2007 $1a //set base color green
	set $2006 $3f
	set $2006 $11
	set $2007 $0a // fg color 1 black
	set $2007 $10 // fg color 2 gray
	set $2007 $20 //fg color 3 white

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

// multiplication
asm
mult_loop:
        asl addend_l
        rol addend_h
mult: 
        lda mult_counter
        and #1
        beq mult_next
        clc
        lda result_l
        adc addend_l
        sta result_l
        lda result_h
        adc addend_h
        sta result_h
mult_next:
        lsr mult_counter
        bne mult_loop

        rts
endasm

edge_detect:
	//handle A button
        set a_pressed joy1a
        if a_down = 1 set a_pressed 0
        set a_down joy1a
        set b_pressed joy1b
        if b_down = 1 set b_pressed 0
        set b_down joy1b
        return

//file footer

vretrace:
        gosub joystick1
        gosub edge_detect
        set sprite_dma 2
asm
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
endasm


