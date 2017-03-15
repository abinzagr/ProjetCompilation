# YACC = bison -d
BISON = bison -d
LEX = flex -o 
CC = gcc
CFLAGS=-std=c99 -Wall -g
LDFLAGS:= -lfl

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<

interIMP:iimp.tab.o bilquad.o environ.o  iimpl.o interIMP.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

	make interC3A
interC3A: interC3A.c bilquad.o environ.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

interC3A.c: interC3A.l
	$(LEX) $@ $< 

iimp.tab.o: iimp.tab.c interIMP.c 
	$(CC) $(CFLAGS) -c $^

	make compIMP
compIMP: noeud_struct.o bilquad.o iimp.tab.o iimpl.o environ.o compIMP.o
	$(CC) $(CFLAGS) -o $@ $^

iimp.tab.c : iimp.y
	$(BISON)  $^
	
iimpl.o: iimpl.c 
	$(CC) $(CFLAGS) -c $^ $(LDFLAGS)

iimpl.c : iimp.l
	$(LEX) iimpl.c $^ 

	make compC3A
compC3A.c: compC3A.l
	$(LEX) $@ $<

compC3A: compC3A.c bilquad.o environc3a.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	
clean:
	-rm -f *.o src/*.o  *.tab.* iimpl.c compC3A.c
	



