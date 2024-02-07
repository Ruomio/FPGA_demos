CC = iverilog
FLAG = -o
SRC = $(wildcard src/*.v sim/*.v)
OBJ = wave
TAR = wave.vcd

all : $(TAR)
$(TAR) : $(OBJ)
	vvp -n sim/$^ -lxt2 -o src

$(OBJ) : $(SRC)
	$(CC) $(FLAG) sim/$@ $^

run : $(TAR)
	gtkwave sim/$^

.PHONY : clean
clean :
	rm sim/wave*