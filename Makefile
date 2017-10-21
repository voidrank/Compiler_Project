GCC = @g++
LEX = @flex
YACC = @bison
MKDIR_P = mkdir -p
BUILD_DIR = build
BIN_DIR = build/bin
MAINCC = build/main.cc
MAINY = src/main.y
MAINBIN = build/bin/main
CFLAG = -I "src"

main: clean $(BUILD_DIR) $(BIN_DIR) $(MAINCC) 
	$(GCC) $(MAINCC) -ll -o $(MAINBIN) $(CFLAG)

$(BUILD_DIR): 
	$(MKDIR_P) $(BUILD_DIR)

$(BIN_DIR):
	$(MKDIR_P) $(BIN_DIR)

$(MAINCC): 
	$(LEX) -o $(MAINCC) $(MAINY)


clean:
				@-rm -rf build
.PHONY: clean
