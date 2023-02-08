array zeropage map_pos 2
array zeropage map_start 2
array zeropage map_end 2

array zeropage msg_loc 2
array zeropage line_buf 33

//header for nesasm
asm
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
endasm

msg1:
 data "Bob said, it was a bad",
 data " idea.", 0
msg2:
 data "Bob said, nobody in th",
 data "eir       right mind w",
 data "ould do it.", 0
msg3:
 data "Well...", 0
msg4:
 data "...Bob says a lot of",
 data " things.", 0
msg5:
 data "Now presenting...", 0
msg6:
 data "The NES quine!!!", 0

//the program starts here
goto start

start:
 set not_done 1
 set counter 0
 set twokay 0

 gosub vwait
 gosub load_palette

/// Bob said, it was...
 gosub hide
 set msg_start_h $21
 set msg_start_l $21
asm
 lda #low(msg1)
 sta msg_loc
 lda #high(msg1)
 sta msg_loc+1
endasm
 gosub do_msg
 gosub show

/// Bob said, nobody in...
 gosub hide
 set msg_start_h $21
 set msg_start_l $21
asm
 lda #low(msg2)
 sta msg_loc
 lda #high(msg2)
 sta msg_loc+1
endasm
 gosub do_msg
 gosub show

/// Well...
 gosub hide
 gosub do_clear
 set msg_start_h $21
 set msg_start_l $21
asm
 lda #low(msg3)
 sta msg_loc
 lda #high(msg3)
 sta msg_loc+1
endasm
 gosub do_msg
 gosub show

/// Fire
 gosub hide
 gosub do_fire
 gosub show

/// ...Bob says a lot...
 gosub hide
 gosub do_clear
 set msg_start_h $21
 set msg_start_l $21
asm
 lda #low(msg4)
 sta msg_loc
 lda #high(msg4)
 sta msg_loc+1
endasm
 gosub do_msg
 gosub show

/// Now presenting...
 gosub hide
 gosub do_clear
 set msg_start_h $21
 set msg_start_l $21
asm
 lda #low(msg5)
 sta msg_loc
 lda #high(msg5)
 sta msg_loc+1
endasm
 gosub do_msg
 gosub show

/// The NES Quine!!!
 gosub hide
 gosub do_clear
 set msg_start_h $21
 set msg_start_l $21
asm
 lda #low(msg6)
 sta msg_loc
 lda #high(msg6)
 sta msg_loc+1
endasm
 gosub do_msg
 gosub show

 gosub hide
 set $2006 $3f
 set $2006 $03
 set $2007 $2a 
 gosub do_clear
 gosub show
//the main program loop
 set scroll 0
 set empty 1
asm
 lda #low(q)
 sta msg_loc
 lda #high(q)
 sta msg_loc+1
endasm
mainloop:
 set rsc >> scroll 3
 set add_h >> rsc 3
 set add_h + $20 add_h
 set add_l << & rsc 7 5
//put stuff into line_buf
 if empty = 1 then
 set empty 0
 set y 0
asm
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
endasm
 endif
done_buffering:
 gosub vwait
 if & scroll 7 = 0 then
 set $2006 add_h
 set $2006 add_l
// print stuff in line_buf
 set x 0
asm
 lda #0
main_clearloop:
 sta $2007
 inx
 cpx #32
 bne main_clearloop
endasm
 if not_done = 1 then
 set empty 1
 set $2006 add_h
 set $2006 add_l
 set x 0
asm
main_printloop:
 lda line_buf, x
 inx
 sta $2007
 cmp #0
 bne main_printloop
endasm
 endif
 endif
 set $2005 0
 set $2005 scroll
 set scroll + 1 scroll
 if scroll = 240 set scroll 0
 goto mainloop

done_loop:
 set $2008 1
 gosub vwait
 set $2005 0
 set $2005 scroll
 set scroll + 1 scroll
 if scroll = 240 set scroll 0
 goto done_loop

//load the colors
load_palette:
 set $2006 $3f
 set $2006 $00
 set $2007 $0e //bg color 0
 set $2007 $27 //bg color 1
 set $2007 $38 //bg color 2
 set $2007 $30 //bg color 3
 return	

//wait until screen refresh
vwait:
asm
 lda $2002
 bpl vwait
 vwait_1:
 lda $2002
 bmi vwait_1
endasm
 set $2005 0
 set $2005 0
 set $2006 0
 set $2006 0
 return


do_fire:
 set twokay %00000000
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
 return

do_clear:
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
endasm
 return

waitasecond:
 set counter 0
waitloop:
 if counter <> delay then
 gosub vwait
 set counter + 1 counter
 goto waitloop
 endif
 return
hide: 
 gosub vwait
 set $2000 %00000000
 set $2001 %00000000 
 set delay 50
 gosub waitasecond
 return
show: 
 gosub vwait
 set $2000 twokay
 set $2001 %00011110 
 set delay 150
 gosub waitasecond
 return

do_msg:
 set twokay %00010000
 set $2006 msg_start_h
 set $2006 msg_start_l
 set y 0	
do_msg_1:
asm
 lda [msg_loc],y
 cmp #0
 beq do_msg_ret
 sta $2007 
 iny
 jmp do_msg_1
endasm
do_msg_ret:
 return


// at last, the punchline:


q:
asm
 .incbin "quine.bas"
 .db 0
endasm
