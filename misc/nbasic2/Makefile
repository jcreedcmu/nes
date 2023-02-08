OBJECTS = bin/main.o bin/nbasic.o bin/RegEx.o
TARGET = bin/nbasic
CFLAGS = -Wall -fsigned-char

default: $(OBJECTS)
	g++ $(OBJECTS) -o $(TARGET)

bin/main.o: main.cpp nbasic.h
	g++ $(CFLAGS) -c main.cpp -o bin/main.o

bin/nbasic.o: nbasic.cpp nbasic.h RegEx.h
	g++ $(CFLAGS) -c nbasic.cpp -o bin/nbasic.o

bin/RegEx.o: RegEx.cpp RegEx.h
	g++ $(CFLAGS) -c RegEx.cpp -o bin/RegEx.o

clean:
	rm $(TARGET) $(OBJECTS)
