# YACC = bison -d
BISON = bison -d
LEX = flex -o 
CC = gcc
CFLAGS=-std=c99 -Wall -g
LDFLAGS:= -lfl

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<

affIMP: iimp.tab.o environ.o iimpl.o noeud_struct.c interIMP.o
	$(CC) $(CFLAGS) -o $@ $^ 

	make compIMP
compIMP: noeud_struct.o bilquad.o iimp.tab.o iimpl.o environ.o compIMP.o
	$(CC) $(CFLAGS) -o $@ $^

iimp.tab.c : iimp.y
	$(BISON)  $^
	
iimpl.o: iimpl.c 
	$(CC) $(CFLAGS) -c $^ $(LDFLAGS)

iimpl.c : iimp.l
	$(LEX) iimpl.c $^ 

	
clean:
	-rm -f *.o src/*.o  *.tab.* iimpl.c 
	



