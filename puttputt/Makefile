MAPS = map/hole1.mn map/hole2.mn
SOURCES = title/title.nas code/*.mac code/*.nas mustard/* $(MAPS)

puttputt.nes: gfx/gfx.chr puttputt.nas $(SOURCES)
	nesasm -s  puttputt.nas

gfx/gfx.chr: gfx/gfx.pgm
	pgm2chr.pl gfx/gfx.pgm > gfx/gfx.chr

%.mn: $(@:.mn=.map)
	perl map/mapcompile.pl $(@:.mn=.map) > $@

clean:
	rm -f puttputt.nes puttputt.lst


a: $(@:.nas=.map)