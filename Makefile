SWIPL = swipl

MAIN = flp24-log.pl
MAIN2 = vypocetKomb.pl

EXECUTABLE = flp24-log

all: build

build:
	$(SWIPL) -q -g main -o $(EXECUTABLE) -c $(MAIN2)

clean:
	rm -f $(EXECUTABLE) *.qlf