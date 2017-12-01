#define MAX_INT "2147483647"
#define INT_OVERFLOW 1

#define STR_OVER_LONG 1
#define UNEXPECTED_WORD 2
#include <iostream>
#include <cstring>
#include <cstdlib>
#include <cstdarg>
#include "main.tab.h"

using namespace std;

extern int check_integer(char *int_str);

extern int check_string(char *str);

extern "C" int yylex(void);
extern int yyparse(void);
extern void yyerror(const char*);

extern void DumpRow(void); 
extern int GetNextChar(char *b, int maxBuffer);
extern void BeginToken(char*);
extern void PrintError(const char *s, ...);
