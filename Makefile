# YACC = bison -d
BISON = bison -d
LEX = flex -o 
CC = gcc
CFLAGS=-std=c99 -Wall
LDFLAGS:= -lfl

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<

iimp: iimp.tab.o iimpl.o
	$(CC) $(CFLAGS) -o iimp $^
	
	$(MAKE) affC3A	
affC3A: affc3A.c src/bilquad.o src/environ.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

	$(MAKE) affIMP
affIMP: affIMP.c src/bilquad.o src/environ.o	
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

iimp.tab.o: iimp.tab.c 
	$(CC) $(CFLAGS) -c $^

iimp.tab.c : iimp.y
	$(BISON)  $^
	
iimpl.o: iimpl.c 
	$(CC) $(CFLAGS) -c $^

iimpl.c : iimp.l
	$(LEX) iimpl.c $^
	
affc3A.c : AffC3A.l
	$(LEX) $@ $^	
	
affIMP.c : AffIMP.l
	$(LEX) $@ $^
	
	
clean:
	-rm -f *.o src/*.o  *.tab.* iimpl.c 
	



