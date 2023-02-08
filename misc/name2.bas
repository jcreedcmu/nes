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
myname:
	data 16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31

start:
        set posl $01
        set posh $21
        set outb_val 0
        set outb_digit_l 0
        set outb_digit_h 0
        set input_a 0
        set input_b 5
        set output_h 99
        set output_l 99
	gosub vwait
	set $2000 %00000000
	set $2001 %00011110 
	gosub vwait
	gosub load_palette
        gosub compute_results
	gosub vwait
	gosub show_results

//the main program loop
mainloop:
	gosub vwait
	goto mainloop

//load the colors
load_palette:
	//set the PPU start address (background color 0)
	set $2006 $3f
	set $2006 $00
	set $2007 $30 //set base color white
	set $2007 $0e // bg color 1 black
	return	

//write your name into the background

outb:
asm
        lda outb_val
        and #15
        adc #16
        sta outb_digit_l

        lda outb_val
        lsr a
        lsr a
        lsr a
        lsr a
        clc
        and #15
        adc #16
        sta outb_digit_h
endasm
        set $2006 posh
        set $2006 posl
        set $2007 outb_digit_h
        set $2007 outb_digit_l
asm
        clc          ; increment
        lda posl
        adc #4
        sta posl
        lda posh
        adc #0
        sta posh
endasm
        return

compute_results:
        return

show_results:
        set outb_val input_a
        gosub outb

        set outb_val input_b
        gosub outb

        set outb_val output_h
        gosub outb
        set outb_val output_l
        gosub outb
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

//file footer
asm
;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw start, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "hex.chr"
	.incbin "hex.chr"
endasm
