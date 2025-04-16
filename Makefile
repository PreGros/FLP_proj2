SWIPL = swipl

MAIN = spanningTree.pl

EXECUTABLE = flp24-log

all: build

build:
	$(SWIPL) -q -g main -o $(EXECUTABLE) -c $(MAIN)

clean:
	rm -f $(EXECUTABLE) *.qlf