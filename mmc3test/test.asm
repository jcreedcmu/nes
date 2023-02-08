nbasic_stack = 256
sprite_dma = 16404
sprites = 512
count = 0
nmi_hit = 1
cond = 2

	.inesprg 4
	.ineschr 1
	.inesmir 0
	.inesmap 4 ;//memory mapper 4 (MMC3)

	.bank 7
	.org $e000

start:
 lda #0
 sta 8192
 sta 8193

		sei ;//disable interrupts
	 jsr vwait
 jsr vwait
 lda #63
 sta 8198
 lda #0
 sta 8198
 lda #14
 sta 8199
 lda #0
 sta 8199
 lda #0
 sta 8199
 lda #48
 sta 8199
 jsr vwait
 lda #33
 sta 8198
 lda #33
 sta 8198
 ldx #0

smile_loop:
 lda #0
 sta 8199
 lda #64
 sta 8199
 inx
 cpx #14
 bne smile_loop

		ldx #$ff
		txs ;//reset the stack
	 jsr vwait
 lda #144
 sta 8192
 lda #30
 sta 8193

mainloop:
 lda count
 clc
 adc #1
 sta count
 lda #0
 sta nmi_hit
 jsr nmi_wait
 lda #3
 sta 32768
 lda #16
 and count
 sta cond
 lda #0
 cmp cond
 bne nbasic_autolabel_1
 lda #1
 sta 32769

nbasic_autolabel_1:
 lda #0
 cmp cond
 beq nbasic_autolabel_2
 lda #6
 sta 32769

nbasic_autolabel_2:
 jsr vwait_end
 jmp mainloop

nmi_wait:
 lda #0
 cmp nmi_hit
 beq nmi_wait
 rts

nmi:
 lda #1
 sta nmi_hit
 rti

irq:
 rti

vwait:
 jsr vwait_start
 jsr vwait_end
 rts

vwait_start:

		lda $2002
		bpl vwait_start
	 rts

vwait_end:

		lda $2002
		bmi vwait_end
	 lda #0
 sta 8197
 sta 8197
 sta 8198
 sta 8198
 rts

draw:
 rts

debug:
 lda #0
 sta 8201
 lda 32768
 sta 8200
 lda 40960
 sta 8200
 lda 49152
 sta 8200
 lda 65530
 sta 8200
 lda #0
 sta 8201
 rts

        .bank 0
        .db $00
        .bank 1
        .db $10
        .bank 2
        .db $20
        .bank 3
        .db $30
        .bank 4
        .db $40
        .bank 5
        .db $50
        .bank 6
        .db $60

        .bank 7
;//jump table points to NMI, Reset, and IRQ start points
	.org $fffa
	.dw nmi, start, irq

        .bank 8
        .org $0000
        .incbin "stuff2.chr"
        .incbin "stuff.chr"



