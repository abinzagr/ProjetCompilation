BISON = bison -d
LEX = flex -o 
CC = gcc
CFLAGS =-std=c99 -Wall -g
LDFLAGS = -lfl
EXE = interIMP interC3A compIMP compC3A iimp

all:$(EXE)

%.o : %.c %.h 
	$(CC) $(CFLAGS) -c -o $@ $<

iimp.tab.c iimp.tab.h: iimp.y
	$(BISON)  $^ -o $@

iimp.c: iimp.l iimp.tab.h
	$(LEX) $@ $<

interIMP:iimp.tab.o bilquad.o environ.o iimp.o noeud_struct.o interIMP.c
	$(CC) $(CFLAGS) -o $@ $^

interC3A.c: interC3A.l
	$(LEX) $@ $< 

compIMP: noeud_struct.o bilquad.o iimp.tab.o iimp.o environ.o compIMP.c
	$(CC) $(CFLAGS) -o $@ $^

compC3A.c: compC3A.l
	$(LEX) $@ $<

compC3A: compC3A.c bilquad.o environc3a.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

interC3A: interC3A.c bilquad.o environ.o
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

iimp: compIMP compC3A iimp.c
	$(CC) $(CFLAGS) -o $@ iimp.c

clean:
	-rm -f *.o  *.tab.* *.output iimp.c compC3A.c interC3A.c
	



