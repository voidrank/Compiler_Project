GCC = @g++
LEX = @flex
YACC = @bison
MKDIR_P = mkdir -p
BUILD_DIR = build
BIN_DIR = build/bin
MAINCC = build/main.cc
TABCC = build/main.tab.cc
TABH = build/main.tab.h
MAINY = src/main.y
MAINL = src/main.l
TESTCASE=test.pcat
TESTDIR=tests/
MAINBIN = build/bin/main
CFLAG = -I "src"

main: clean $(BUILD_DIR) $(BIN_DIR) $(MAINCC) $(TABCC)
	$(GCC) $(TABCC) $(MAINCC) -lfl -o $(MAINBIN) $(CFLAG)

$(BUILD_DIR): 
	$(MKDIR_P) $(BUILD_DIR)

$(BIN_DIR):
	$(MKDIR_P) $(BIN_DIR)

$(MAINCC): 
	$(LEX) -o $(MAINCC) $(MAINL)

$(TABCC):
	$(YACC) --defines=$(TABH) --output=$(TABCC) $(MAINY)

clean:
				@-rm -rf build

test: main
	$(MAINBIN) $(TESTDIR)$(TESTCASE)

.PHONY: clean
