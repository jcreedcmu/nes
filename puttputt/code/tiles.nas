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

	.zp
arg	.ds	2
argx	.ds	1
argy	.ds	1
madd	.ds	2
	.code

handle_pos:
	lda #0
	sta argx
	sta argy
	sta arg
	sta arg+1
; horrible bit-swizzling ahead!

	lda ball_x+1
	and #%00000111
	sta x_local
	lda ball_y+1
	and #%00000111
	sta y_local
 
	lda ball_x+1
	lsr a  
	lsr a  
	lsr a
	sta argx
	lda ball_y+1
	lsr a
	lsr a
	lsr a
	sta argy
	lsr a
	lsr a
	lsr a
	sta madd+1 ; high byte
	lda ball_y+1
	and #%00111000
	asl a
	asl a 
	ora argx 
	sta madd ; low byte

	add16 madd, mapdata_start
	ldy #0
	lda [madd],y
	sec
	sbc #32
	bpl .good	; ignore 0-31, and, 
			; I guess, some
			; large ones too.
	rts
.good:
	sta tile_local
	asl a
	tax 
	mov16sx tile_table, jmpdest
	jmp [jmpdest]

wall_check	.macro
	lda tile_local
	and #\1
	beq .no\@
	lda \2
	cmp #\3
	bne .no\@
	lda #1
	sta \4
	sta restore
.no\@:
	.endm

tile_wall:
	wall_check %0001, y_local, 7, vbounce
	wall_check %0010, x_local, 7, hbounce
	wall_check %0100, y_local, 0, vbounce
	wall_check %1000, x_local, 0, hbounce
	rts

tile_grass:
	lda #128
	cmp fspeed
	bge .nofast
	lda fspeed
	lsr a
	lsr a
	sta fspeed
.nofast:
	lda fspeed
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	sta speed
	inc iindex
 	rts

tile_brick:
;      if y_local = 6 then
;       set vbounce 1
;       set restore 1
;       return
;      endif
;      if x_local = 0 then
;       set hbounce 1
;       set restore 1
;      endif
;      if x_local = 7 then
;       set hbounce 1
;       set restore 1
;      endif
;      if y_local < 6 then
;       set ball_y_h + ball_y_h - 7 y_local
;       return
;      endif
	rts

tile_do_nothing:
	rts
