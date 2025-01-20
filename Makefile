fizzbuzz.o: fizzbuzz.asm
	as fizzbuzz.asm --64 -o fizzbuzz.o

fizzbuzz: fizzbuzz.o 
	gcc -o fizzbuzz -m64 fizzbuzz.o

run: fizzbuzz 
	./fizzbuzz
