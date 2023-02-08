;;;;;;;;;;;;;;;;;;;;;;
;;; function table ;;;
;;;;;;;;;;;;;;;;;;;;;;

mft:
	mft_entry del
	mft_entry note
	mft_entry noted
	mft_entry crazy

;;;;;;;;;;;
;;; del ;;;
;;;;;;;;;;;

	mf_handler del, 1
	lda counter
	bne .decrement
	ldarg
	beq .quit
	sta counter
	yredo
.decrement:
	dec counter
	beq .quit
	yredo
.quit:
	next

;;;;;;;;;;;;
;;; note ;;;
;;;;;;;;;;;;

	mf_handler note, 1
	lda #$f
	ldy #0
	sta [soundreg],y
	lda #0
	iny
	sta [soundreg],y
	ldarg
	iny
	sta [soundreg],y
	lda #9
	iny
	sta [soundreg],y
	next

;;;;;;;;;;;;;
;;; noted ;;;
;;;;;;;;;;;;;

	mf_handler noted, 2
	delay_header 2
	lda #$f
	ldy #0
	sta [soundreg],y
	lda #0
	iny
	sta [soundreg],y
	ldarg
	iny
	sta [soundreg],y
	lda #9
	iny
	sta [soundreg],y
	delay_footer

;;;;;;;;;;;;;
;;; crazy ;;;
;;;;;;;;;;;;;

	mf_handler crazy, 2
	delay_header 1
	lda #%10100000
	ldy #0
	sta [soundreg],y
	lda #%10001111
	iny
	sta [soundreg],y
	ldarg 2
	iny
	sta [soundreg],y
	lda #%00001111
	iny
	sta [soundreg],y
	delay_footer
