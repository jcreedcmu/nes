;;;;;;;;;;;;;;;;;;;;;;
;;; function table ;;;
;;;;;;;;;;;;;;;;;;;;;;

mft:
	mft_entry del
	mft_entry rest
	mft_entry specialx
	mft_entry specialy
	mft_entry specialw
	mft_entry noted
	mft_entry crazy

;;;;;;;;;;;
;;; del ;;;
;;;;;;;;;;;

	mf_handler del, 1
	delay_header 1
	delay_footer

;;;;;;;;;;;;
;;; rest ;;;
;;;;;;;;;;;;

	mf_handler rest, 1
	delay_header 1
	lda #$10
	ldy #0
	sta [soundreg],y
	iny
	lda #0
	sta [soundreg],y
	iny
	sta [soundreg],y
	iny
	sta [soundreg],y
	delay_footer

;;;;;;;;;;;;;;;;
;;; specialx ;;;
;;;;;;;;;;;;;;;;

	mf_handler specialx, 1
	delay_header 1
	mov #1, $400c
	mov #0, $400d
	mov #1, $400e
	mov #0, $400f
	delay_footer
	next

;;;;;;;;;;;;;;;;
;;; specialy ;;;
;;;;;;;;;;;;;;;;

	mf_handler specialy, 1
	delay_header 1
	mov #1, $400c
	mov #0, $400d
	mov #7, $400e
	mov #$f8, $400f
	delay_footer
	next

;;;;;;;;;;;;;;;;
;;; specialw ;;;
;;;;;;;;;;;;;;;;

	mf_handler specialw, 1
	delay_header 1
	mov #$03, $400c
	mov #$00, $400d
	mov #$0f, $400e
	mov #$78, $400f
	delay_footer
	next

;;;;;;;;;;;;;
;;; noted ;;;
;;;;;;;;;;;;;

	mf_handler noted, 2
	delay_header 2
	lda #%10010111
	ldy #0
	sta [soundreg],y
	lda #0
	iny
	sta [soundreg],y
	ldarg
	iny
	sta [soundreg],y
	lda #0
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
