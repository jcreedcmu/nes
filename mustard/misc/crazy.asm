	.list
	.inesprg 1
	.ineschr 0
	.inesmir 0
	.inesmap 0

blah	.equ 0


mov16	.macro
	.if \?1 = ARG_IMMED
	lda #high(\1)
	.else
	lda \1
	sta \2
	lda \1+1
	sta \2+1
	.endif
	.endm

	.bank 0
	.org $8000
self:
	mov16 #self, blah
	