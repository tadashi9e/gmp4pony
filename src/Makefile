
all: libgmp4pony.so
clean:
	rm -f mpz.o mpf.o

libgmp4pony.so: mpz.o mpf.o
	clang -shared -Wl mpf.o mpz.o -o libgmp4pony.so
mpz.o: mpz.c
	clang -fPIC -Wall -c mpz.c -o mpz.o
mpf.o: mpf.c
	clang -fPIC -Wall -c mpf.c -o mpf.o
