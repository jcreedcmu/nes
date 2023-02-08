	.include "code/arg.mac"
	.include "code/common.mac"
	.include "mustard/thread.mac"

	.include "code/header.nas"

	.bank 0
	.org $8000

	.include "map/hole1.mn"
	.include "map/hole2.mn"
	.include "map/hole3.mn"
	.include "map/hole4.mn"

	.bank 2
	.org $8000

	.include "map/hole5.mn"
	.include "map/hole6.mn"
	.include "map/hole7.mn"
	.include "map/hole8.mn"
	.include "map/hole9.mn"

	.bank 1
	.org $a000

	.include "mustard/wis.mac"
	.include "mustard/music.nas"

        .bank 6
	.org $c000

	.include "code/common.nas"
	.include "code/tiles.nas"
	.include "code/background.nas"
	.include "code/main.nas"
	.include "title/title.nas"

	.include "mustard/mf.nas"
	.include "mustard/thread.nas"

	.bank 7
	.org $e000
        .include "sin/sin.tab"
	.include "code/footer.nas"

	.org $fffa
	.dw nmi, start, start


	.bank 8
	.incbin "title/title.chr"
	.incbin "gfx/gfx.chr"
