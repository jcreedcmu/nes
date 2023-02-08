debug_loc	.macro
	lda #\1
	sta $2009
	lda loc+1
	sta $2008
	lda loc
	sta $2008
	.endm

debug_thing	.macro
	lda #\1
	sta $2009
	lda \2
	sta $2008
	.endm
