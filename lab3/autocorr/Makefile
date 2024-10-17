CC = g++

CFLAGS = -std=c++20

LIB_AUTOCORR = ./autocorrfunc/autocorr.cpp

LIB_AUTOCORRNORM = ./normalization/normalization.cpp

LIB_TABLEOUT = ./tableoutput/tableoutput.cpp

SRC = main.cpp

TARGER = main

all: clean run

clean:
	rm $(TARGER)
run: 
	$(CC) $(SRC) -o $(TARGER) $(LIB_AUTOCORR) $(LIB_AUTOCORRNORM) $(LIB_TABLEOUT) $(CFLAGS)
	./$(TARGER)
