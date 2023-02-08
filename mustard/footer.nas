	.bank 1
	.org $e000

nmi:
	rti
irq:
	rti

	.org $fffa
	.dw nmi, start, irq

	.bank 2
	.incbin "guy.chr"
	.incbin "guy.chr"
