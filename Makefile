# YACC = bison -d
BISON = bison -d
LEX = flex -o 
CC = gcc
CFLAGS=-std=c99 -Wall -g
LDFLAGS:= -lfl

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<

affIMP:iimp.tab.o bilquad.o environ.o  iimpl.o interIMP.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

iimp.tab.o: iimp.tab.c interIMP.c 
	$(CC) $(CFLAGS) -c $^

iimp.tab.c : iimp.y
	$(BISON)  $^
	
iimpl.o: iimpl.c 
	$(CC) $(CFLAGS) -c $^

iimpl.c : iimp.l
	$(LEX) iimpl.c $^

	
clean:
	-rm -f *.o src/*.o  *.tab.* iimpl.c 
	



