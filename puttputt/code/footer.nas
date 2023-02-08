sprite_dma	= $4014

nmi:
        jsr joystick1
        jsr edge_detect
        jsr draw_strokes
	mov #2, sprite_dma
	rti

