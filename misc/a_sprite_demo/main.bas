array absolute $4014 sprite_dma 0
array absolute $200 sprite_mem 256

//the program starts here on NES boot (see footer)
start:
	gosub vwait
	set $2000 %00010000
	set $2001 %00011110 //sprites and bg visible, no sprite clipping
	gosub init_vars
	gosub vwait
	gosub load_palette
//the main program loop
mainloop:
	gosub joy_handler
	gosub vwait
        set sprite_dma 2
	gosub drawstuff
	goto mainloop

//set default sprite location
init_vars:
	set a_pressed 0
	set b_pressed 0
	set a_inc 0
	set b_inc 0
	set spritenum 65
	set spritex 128
	set spritey 120
	return

//routine to draw a sprite
drawstuff:

	set [sprite_mem 0] spritey //y
	set [sprite_mem 1] 69 //tile number
	set [sprite_mem 2] blink //attrib
	set [sprite_mem 3] 128 //x

	set [sprite_mem 4] spritey //y
	set [sprite_mem 5] 65 //tile number
	set [sprite_mem 6] 0 //attrib
	set [sprite_mem 7] spritex //x

	set [sprite_mem 8] spritey //y
	set [sprite_mem 9] 67 //tile number
	set [sprite_mem 10] 0 //attrib
	set [sprite_mem 11] - spritex 16 //x

	set [sprite_mem 12] spritey //y
	set [sprite_mem 13] 67 //tile number
	set [sprite_mem 14] %11000000 //attrib
	set [sprite_mem 15] - spritex 32 //x

	set [sprite_mem 16] spritey //y
	set [sprite_mem 17] 68 //tile number
	set [sprite_mem 18] %11000000 //attrib
	set [sprite_mem 19] - spritex 48 //x

	set [sprite_mem 20] spritey //y
	set [sprite_mem 21] 68 //tile number
	set [sprite_mem 22] %00000000 //attrib
	set [sprite_mem 23] - spritex 64 //x

	set [sprite_mem 24] spritey //y
	set [sprite_mem 25] 66 //tile number
	set [sprite_mem 26] %00000000 //attrib
	set [sprite_mem 27] - spritex 80 //x

	return

//move sprite based on joystick input
joy_handler:
	gosub joystick1
	gosub incrementer
	set spritex + spritex 1
//	set spritex - spritex joy1left
//	set spritey + spritey joy1down
//	set spritey - spritey joy1up
//	set spritenum + spritenum a_inc
        set blink joy1a 

//	set spritenum - spritenum b_inc
//	if joy1start = 1 then
//		set spritex 128
//		set spritey 120
//		endif
	return

//handle press and release of A/B buttons
incrementer:
	//handle A button
	set a_inc 0
	if joy1a = 0 set a_pressed 0
	if joy1a = 1 if a_pressed = 0 then
		set a_pressed 1
		if spritenum < 89  set a_inc 1
		endif
	//handle B button
	set b_inc 0
	if joy1b = 0 set b_pressed 0
	if joy1b = 1 if b_pressed = 0 then
		set b_pressed 1
		if spritenum > 64  set b_inc 1
		endif
	return

//load the colors

load_palette:
    set $2006 $3f
    set $2006 $00
thing1:
    set $2007 [ palette x ]
    inc x
    if x <> 32 branchto thing1
    return

asm
palette:

       .db $08,$16,$16,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
       .db $08,$16,$3d,$30,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
endasm