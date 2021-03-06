#include <iostream>
#include <stdio.h>
using namespace std;

int yyparse();
extern "C" FILE* yyin;

int main(int argc, char* args[]) {
  if (argc > 1) {
    FILE *file = fopen("test.txt", "r");
    if (!file) {
      cerr << "Can't open file" << endl;
      return 1;
    } else {
      yyin = file;
    }
  }

  yyparse();
  return 0;
}
