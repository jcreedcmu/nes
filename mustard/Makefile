demo.nes: *.inc *.nas *.mac *.abc
	abc2notes.pl yourturntowin.abc | notes2asm.pl > yourturntowin.mac
	nesasm -m -l 3 -s demo.nas

clean:
	rm -f *~ demo.nes demo.asm *.lst
