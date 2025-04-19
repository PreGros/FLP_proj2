SWIPL = swipl

MAIN = spanningTree.pl
MAIN2 = test.pl

EXECUTABLE = flp24-log

all: build

build:
	$(SWIPL) -q -g main -o $(EXECUTABLE) -c $(MAIN2)

clean:
	rm -f $(EXECUTABLE) *.qlf