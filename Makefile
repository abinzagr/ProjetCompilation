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

	make compC3A

compC3A: compC3A.c bilquad.o environ.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

compC3A.c: CompC3A.l
	$(LEX) $@ $<

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
	



