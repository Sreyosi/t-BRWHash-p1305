INCDRS = -I../include/

SRCFLS = ../source/p1305_spaces.s ../source/p1305_macros.s ../source/p1305_powers.s ../source/p1305_4brwhash.s main_pre-computed.c

OBJFLS = ../source/p1305_spaces.o ../source/p1305_macros.o ../source/p1305_powers.o ../source/p1305_4brwhash.o main_pre-computed.o
EXE    = p1305-pre

CFLAGS = -march=native -mtune=native -m64 -O3 -funroll-loops -fomit-frame-pointer

CC     = gcc-10

LL     = gcc-10

$(EXE): $(OBJFLS)
	$(LL) -o $@ $(OBJFLS) -lm -no-pie

.c.o:
	$(CC) $(INCDRS) $(CFLAGS) -o $@ -c $<

clean:
	-rm $(EXE)
	-rm $(OBJFLS)



 


