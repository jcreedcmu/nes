;;;;;;;;;;;;;;;;;;;;;;
;;; function table ;;;
;;;;;;;;;;;;;;;;;;;;;;

mft:
	mft_entry del
	mft_entry rest
	mft_entry zero
	mft_entry specialx
	mft_entry specialy
	mft_entry specialw
	mft_entry note
	mft_entry note_long
	mft_entry note_tri
	mft_entry sthr0
	mft_entry sthr1
	mft_entry sthr2
	mft_entry sthr3

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

;;;;;;;;;;;;
;;; zero ;;;
;;;;;;;;;;;;

	mf_handler zero, 1
	delay_header 1
	lda #$0
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
	mov #2, $400e
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


;;;;;;;;;;;;
;;; note ;;;
;;;;;;;;;;;;

	mf_handler note, 3
	delay_header 1
	starg 2
	starg 3
	ldy #0
	lda #%10010111
	sta [soundreg],y
	iny
	lda #%00001000
	sta [soundreg],y
	iny
	lda arg2
	sta [soundreg],y
	iny
	lda arg3
	sta [soundreg],y
	delay_footer

;;;;;;;;;;;;;;;;;
;;; note_long ;;;
;;;;;;;;;;;;;;;;;

	mf_handler note_long, 3
	delay_header 1
	starg 2
	starg 3
	ldy #0
	lda #%10010010
	sta [soundreg],y
	iny
	lda #%00001000
	sta [soundreg],y
	iny
	lda arg2
	sta [soundreg],y
	iny
	lda arg3
	ora #%00001000
	sta [soundreg],y
	delay_footer

;;;;;;;;;;;;;;;;
;;; note_tri ;;;
;;;;;;;;;;;;;;;;

	mf_handler note_tri, 3
	delay_header 1
	starg 2
	starg 3
	ldy #0
	lda #%00111111
	sta [soundreg],y
	iny
	lda #%00000000
	sta [soundreg],y
	iny
	lda arg2
	sta [soundreg],y
	iny
	lda arg3
	ora #%00000000
	sta [soundreg],y
	delay_footer


;;;;;;;;;;;;
;;; sthr ;;;
;;;;;;;;;;;;

sthr_handler	.macro
	mf_handler sthr\1, 2
	mov #0, thread\1_counter
	ldy #1
	lda [loc],y
	sta thread\1_loc
	iny
	lda [loc],y
	sta thread\1_loc+1
	thread_on \1
	next
	.endm

	sthr_handler 0
	sthr_handler 1
	sthr_handler 2
	sthr_handler 3
