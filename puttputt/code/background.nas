	.zp

map_pos		.ds	2
mapdata_start	.ds	2
mapdata_end	.ds	2
map_x		.ds	1
map_y		.ds	1
map_tile	.ds	1

	.code

show_level:
	jsr vwait
	mov #%00000000, $2000 
	mov #%00000000, $2001
	jsr vwait
	jsr load_palette

	mov #$20, $2006
	mov #$0, $2006
	sta map_x
	sta map_y
	mov16 mapdata_start, map_pos
	ldy #0
.loop:
	lda [map_pos],y
	sta map_tile
	lda map_y
	cmp #240
	beq .in_attrib
	lda map_tile
	cmp #0
	bne .noball
	mov #32, map_tile
	mov map_x, ball_x+1
	mov map_y, ball_y+1
	jmp .nospecial
.noball:
	cmp #1
	bne .nohole
	mov #32, map_tile
	mov map_x, hole_x
	mov map_y, hole_y
.nohole:
.nospecial:
	add map_x, #8
	bne .nowrap
	add map_y, #8
.nowrap:
.in_attrib
	lda map_tile
	sta $2007
	inc16 map_pos
	clc
	lda map_pos
	cmp mapdata_end
	bne .goback
	lda map_pos+1
	cmp mapdata_end+1
	bne .goback

	mov #$23, $2006
	mov #$64, $2006
	mov #$3, $2007
	mov #$23, $2006
	mov #$7c, $2006
	mov #$4, $2007

	jsr vwait
	mov #%10011000, $2000
	mov #%00011110, $2001
	rts

.goback:
	jmp .loop

; load the colors
load_palette:
	mov #$3f, $2006 
	mov #$00, $2006 
	mov #$1a, $2007  ;set base color green
	mov #$08, $2007  ;bg color 1 brown
	mov #$2a, $2007  ;bg color 2 green
	mov #$28, $2007  ;bg color 3 yellow
	mov #$3f, $2006 
	mov #$11, $2006 
	mov #$0a, $2007  ;fg color 1 black
	mov #$10, $2007  ;fg color 2 gray
	mov #$20, $2007  ;fg color 3 white
	mov #$00, $2007 
	mov #$0a, $2007  ;fg color 5 black
	mov #$0a, $2007  ;fg color 6 black
	mov #$0a, $2007  ;fg color 7 black
	rts