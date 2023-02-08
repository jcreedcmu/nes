nbasic_stack = 256
posl = 0
posh = 1
outb_val = 2
outb_digit_l = 3
outb_digit_h = 4
input_a = 5
input_b = 6
output_h = 7
output_l = 8

	.inesprg 1 ;//one PRG bank
	.ineschr 1 ;//one CHR bank
	.inesmir 0 ;//mirroring type 0
	.inesmap 0 ;//memory mapper 0 (none)
	.org 32768
	.bank 0
 jmp start

myname:
 .db 16,17,18,19,20,21,22,23,24,25
 .db 26,27,28,29,30,31

start:
 lda #1
 sta posl
 lda #33
 sta posh
 lda #0
 sta outb_val
 lda #0
 sta outb_digit_l
 lda #0
 sta outb_digit_h
 lda #0
 sta input_a
 lda #5
 sta input_b
 lda #99
 sta output_h
 lda #99
 sta output_l
 jsr vwait
 lda #0
 sta 8192
 lda #30
 sta 8193
 jsr vwait
 jsr load_palette
 jsr compute_results
 jsr vwait
 jsr show_results

mainloop:
 jsr vwait
 jmp mainloop

load_palette:
 lda #63
 sta 8198
 lda #0
 sta 8198
 lda #48
 sta 8199
 lda #14
 sta 8199
 rts

outb:

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
 lda posh
 sta 8198
 lda posl
 sta 8198
 lda outb_digit_h
 sta 8199
 lda outb_digit_l
 sta 8199

        clc          ; increment
        lda posl
        adc #4
        sta posl
        lda posh
        adc #0
        sta posh
 rts

compute_results:
 rts

show_results:
 lda input_a
 sta outb_val
 jsr outb
 lda input_b
 sta outb_val
 jsr outb
 lda output_h
 sta outb_val
 jsr outb
 lda output_l
 sta outb_val
 jsr outb
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

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw start, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "hex.chr"
	.incbin "hex.chr"

