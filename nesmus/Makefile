default:
	make hills
	make forest
	make plains
	make space

nesmus: nesmus.cpp
	g++ nesmus.cpp -o nesmus

clean:
	rm *.nes *.o *.dat

hills: sofhills.mus
	nesmus sofhills.mus music.dat
	nesasm music.asm
	mv music.nes sof_hills_music.nes
	rm music.dat

forest: sofforest.mus
	nesmus sofforest.mus music.dat
	nesasm music.asm
	mv music.nes sof_forest_music.nes
	rm music.dat

plains: sofplains.mus
	nesmus sofplains.mus music.dat
	nesasm music.asm
	mv music.nes sof_plains_music.nes
	rm music.dat

space: sofspace.mus
	nesmus sofspace.mus music.dat
	nesasm music.asm
	mv music.nes sof_space_music.nes
	rm music.dat

mario: mario.mus
	nesmus mario.mus music.dat
	nesasm music.asm
	mv music.nes mario_music.nes
	rm music.dat


