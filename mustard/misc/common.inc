; mov src, dst
; dst := [src]
mov	.macro
	lda \1
	sta \2
	.endm

; mov16 src16, dst16
; dst16 := [src16]

; mov16 #src16, dst16
; dst16 := src16
mov16	.macro
	.if \?1 = ARG_IMMED
	mov #low(\1), \2
	mov #high(\1), \2+1
	.else
	mov \1, \2
	mov \1+1, \2+1
	.endif
	.endm

; mov16 src16, dst16
; dst16 := [src16 + x]
mov16sx	.macro
	lda \1,x
	sta \2
	lda \1+1,x
	sta \2+1
	.endm


; add16 dst16, src16
; dst16 := [dst16] + [src16]

; add16 dst16, #val16
; dst16 := [dst16] + val16
add16	.macro
	clc
	.if \?2 = ARG_IMMED
	lda \1
	adc #low(\2)
	sta \1
	lda \1+1
	adc #high(\2)
	sta \1+1
	.else
	lda \1
	adc \2
	sta \1
	lda \1+1
	adc \2+1
	sta \1+1
	.endif
	.endm

; inc16 dst16
; dst16 := [dst16] + 1
inc16	.macro
	add16 \1, #1
	.endm
