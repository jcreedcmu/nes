nbasic_stack = 256
map_pos = 0
map_start = 2
map_end = 4
msg_loc = 6
line_buf = 8
not_done = 41
counter = 42
twokay = 43
msg_start_h = 44
msg_start_l = 45
scroll = 46
empty = 47
rsc = 48
add_h = 49
add_l = 50
delay = 51

 .inesprg 1 ;//one PRG bank
 .ineschr 1 ;//one CHR bank
 .inesmir 1 ;//mirroring type 0
 .inesmap 0 ;//memory mapper 0

 .org $8000
 .bank 0

mapdata_loc:
 .dw mapdata_start, mapdata_end
 mapdata_start:
 .incbin "fire.dat"
 mapdata_end:

msg1:
 .db 66,111,98,32,115,97,105,100,44,32
 .db 105,116,32,119,97,115,32,97,32,98
 .db 97,100
 .db 32,105,100,101,97,46,0

msg2:
 .db 66,111,98,32,115,97,105,100,44,32
 .db 110,111,98,111,100,121,32,105,110,32
 .db 116,104
 .db 101,105,114,32,32,32,32,32,32,32
 .db 114,105,103,104,116,32,109,105,110,100
 .db 32,119
 .db 111,117,108,100,32,100,111,32,105,116
 .db 46,0

msg3:
 .db 87,101,108,108,46,46,46,0

msg4:
 .db 46,46,46,66,111,98,32,115,97,121
 .db 115,32,97,32,108,111,116,32,111,102
 .db 32,116,104,105,110,103,115,46,0

msg5:
 .db 78,111,119,32,112,114,101,115,101,110
 .db 116,105,110,103,46,46,46,0

msg6:
 .db 84,104,101,32,78,69,83,32,113,117
 .db 105,110,101,33,33,33,0
 jmp start

start:
 lda #1
 sta not_done
 lda #0
 sta counter
 lda #0
 sta twokay
 jsr vwait
 jsr load_palette
 jsr hide
 lda #33
 sta msg_start_h
 lda #33
 sta msg_start_l

 lda #low(msg1)
 sta msg_loc
 lda #high(msg1)
 sta msg_loc+1
 jsr do_msg
 jsr show
 jsr hide
 lda #33
 sta msg_start_h
 lda #33
 sta msg_start_l

 lda #low(msg2)
 sta msg_loc
 lda #high(msg2)
 sta msg_loc+1
 jsr do_msg
 jsr show
 jsr hide
 jsr do_clear
 lda #33
 sta msg_start_h
 lda #33
 sta msg_start_l

 lda #low(msg3)
 sta msg_loc
 lda #high(msg3)
 sta msg_loc+1
 jsr do_msg
 jsr show
 jsr hide
 jsr do_fire
 jsr show
 jsr hide
 jsr do_clear
 lda #33
 sta msg_start_h
 lda #33
 sta msg_start_l

 lda #low(msg4)
 sta msg_loc
 lda #high(msg4)
 sta msg_loc+1
 jsr do_msg
 jsr show
 jsr hide
 jsr do_clear
 lda #33
 sta msg_start_h
 lda #33
 sta msg_start_l

 lda #low(msg5)
 sta msg_loc
 lda #high(msg5)
 sta msg_loc+1
 jsr do_msg
 jsr show
 jsr hide
 jsr do_clear
 lda #33
 sta msg_start_h
 lda #33
 sta msg_start_l

 lda #low(msg6)
 sta msg_loc
 lda #high(msg6)
 sta msg_loc+1
 jsr do_msg
 jsr show
 jsr hide
 lda #63
 sta 8198
 lda #3
 sta 8198
 lda #42
 sta 8199
 jsr do_clear
 jsr show
 lda #0
 sta scroll
 lda #1
 sta empty

 lda #low(q)
 sta msg_loc
 lda #high(q)
 sta msg_loc+1

mainloop:
 lda scroll
 clc
 lsr a
 lsr a
 lsr a
 sta rsc
 lda rsc
 clc
 lsr a
 lsr a
 lsr a
 sta add_h
 lda add_h
 clc
 adc #32
 sta add_h
 lda #7
 and rsc
 clc
 asl a
 asl a
 asl a
 asl a
 asl a
 sta add_l
 lda #1
 cmp empty
 bne nbasic_autolabel_1
 lda #0
 sta empty
 ldy #0

main_putloop:
 lda [msg_loc],y
 bne local_label
 lda #0
 sta not_done
 jmp done_buffering
local_label:
 sta line_buf,y
 iny
 cmp #10 ; nl
 bne main_putloop
 clc
 dey
 lda #0
 sta line_buf,y
 iny
 tya
 adc msg_loc
 sta msg_loc
 lda msg_loc+1
 adc #0
 sta msg_loc+1

nbasic_autolabel_1:

done_buffering:
 jsr vwait
 lda #7
 and scroll
 cmp #0
 bne nbasic_autolabel_2
 lda add_h
 sta 8198
 lda add_l
 sta 8198
 ldx #0

 lda #0
main_clearloop:
 sta $2007
 inx
 cpx #32
 bne main_clearloop
 lda #1
 cmp not_done
 bne nbasic_autolabel_3
 lda #1
 sta empty
 lda add_h
 sta 8198
 lda add_l
 sta 8198
 ldx #0

main_printloop:
 lda line_buf, x
 inx
 sta $2007
 cmp #0
 bne main_printloop

nbasic_autolabel_3:

nbasic_autolabel_2:
 lda #0
 sta 8197
 lda scroll
 sta 8197
 lda scroll
 clc
 adc #1
 sta scroll
 lda #240
 cmp scroll
 bne nbasic_autolabel_4
 lda #0
 sta scroll

nbasic_autolabel_4:
 jmp mainloop

done_loop:
 lda #1
 sta 8200
 jsr vwait
 lda #0
 sta 8197
 lda scroll
 sta 8197
 lda scroll
 clc
 adc #1
 sta scroll
 lda #240
 cmp scroll
 bne nbasic_autolabel_5
 lda #0
 sta scroll

nbasic_autolabel_5:
 jmp done_loop

load_palette:
 lda #63
 sta 8198
 lda #0
 sta 8198
 lda #14
 sta 8199
 lda #39
 sta 8199
 lda #56
 sta 8199
 lda #48
 sta 8199
 rts

vwait:

 lda $2002
 bpl vwait
 vwait_1:
 lda $2002
 bmi vwait_1
 lda #0
 sta 8197
 lda #0
 sta 8197
 lda #0
 sta 8198
 lda #0
 sta 8198
 rts

do_fire:
 lda #0
 sta twokay
 lda #32
 sta 8198
 lda #32
 sta 8198

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
 rts

do_clear:
 lda #32
 sta 8198
 lda #32
 sta 8198

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
clear_loop:
 lda #0
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
 bne clear_loop
 lda map_pos+1
 cmp map_end+1
 bne clear_loop
 rts

waitasecond:
 lda #0
 sta counter

waitloop:
 lda delay
 cmp counter
 beq nbasic_autolabel_6
 jsr vwait
 lda counter
 clc
 adc #1
 sta counter
 jmp waitloop

nbasic_autolabel_6:
 rts

hide:
 jsr vwait
 lda #0
 sta 8192
 lda #0
 sta 8193
 lda #50
 sta delay
 jsr waitasecond
 rts

show:
 jsr vwait
 lda twokay
 sta 8192
 lda #30
 sta 8193
 lda #150
 sta delay
 jsr waitasecond
 rts

do_msg:
 lda #16
 sta twokay
 lda msg_start_h
 sta 8198
 lda msg_start_l
 sta 8198
 ldy #0

do_msg_1:

 lda [msg_loc],y
 cmp #0
 beq do_msg_ret
 sta $2007 
 iny
 jmp do_msg_1

do_msg_ret:
 rts

q:

 .incbin "quine.bas"
 .db 0

vretrace:

  rti

;//jump table points to NMI, Reset, and IRQ start points
	.bank 1
	.org $fffa
	.dw vretrace, start, start
;//include CHR ROM
	.bank 2
	.org $0000
	.incbin "fire.chr"
	.incbin "text.chr"

