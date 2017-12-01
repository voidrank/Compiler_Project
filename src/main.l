%{
#include "main.h"

#define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if (  result <= 0  ) \
      result = YY_NULL; \
    }

%}

keyword	AND|ELSIF|LOOP|PROGRAM|VAR|ARRAY|END|MOD|READ|WHILE|BEGIN|EXIT|NOT|RECORD|WRITE|BY|FOR|OF|RETURN|IF|OR|THEN|DO|IN|OUT|TO|ELSE|IS|PROCEDURE|TYPE
letter	[A-Za-z]
digit	[0-9]
operator	:=|\+|\-|\*|\/|<|<=|>|>=|=|<>|DIV
delimiter	:|;|,|\.|\(|\)|\[|\]|\{|\}|\[<|>\]|\\

%%
[ \t\r\n]+  {
    BeginToken(yytext);
    /* eat up whitespace */
}
{keyword} {
    BeginToken(yytext);
    yylval.sval = yytext;
    if (strcmp(yytext, "AND") == 0) return AND;
    if (strcmp(yytext, "ARRAY") == 0) return ARRAY;
    if (strcmp(yytext, "BEGIN") == 0) return BeGiN;
    if (strcmp(yytext, "BY") == 0) return BY;
    if (strcmp(yytext, "DO") == 0) return DO;
    if (strcmp(yytext, "ELSE") == 0) return ELSE;
    if (strcmp(yytext, "ELSIF") == 0) return ELSIF;
    if (strcmp(yytext, "END") == 0) return END;
    if (strcmp(yytext, "EXIT") == 0) return EXIT;
    if (strcmp(yytext, "FOR") == 0) return FOR;
    if (strcmp(yytext, "IF") == 0) return IF;
    if (strcmp(yytext, "IS") == 0) return IS;
    if (strcmp(yytext, "LOOP") == 0) return LOOP;
    if (strcmp(yytext, "MOD") == 0) return MOD;
    if (strcmp(yytext, "NOT") == 0) return NOT;
    if (strcmp(yytext, "OF") == 0) return OF;
    if (strcmp(yytext, "OR") == 0) return OR;
    if (strcmp(yytext, "PROCEDURE") == 0) return PROCEDURE;
    if (strcmp(yytext, "PROGRAM") == 0) return PROGRAM;
    if (strcmp(yytext, "READ") == 0) return READ;
    if (strcmp(yytext, "RECORD") == 0) return RECORD;
    if (strcmp(yytext, "RETURN") == 0) return RETURN;
    if (strcmp(yytext, "THEN") == 0) return THEN;
    if (strcmp(yytext, "TO") == 0) return TO;
    if (strcmp(yytext, "TYPE") == 0) return TYPE;
    if (strcmp(yytext, "VAR") == 0) return VAR;
    if (strcmp(yytext, "WHILE") == 0) return WHILE;
    if (strcmp(yytext, "WRITE") == 0) return WRITE;
}
{digit}+ {
    BeginToken(yytext);
    if (check_integer(yytext) == INT_OVERFLOW)
        cout << "INT INT_OVERFLOW";
    yylval.ival = atoi(yytext);
    return INTEGER;
}
{digit}+\.{digit}* {
    BeginToken(yytext);
    yylval.fval = atof(yytext);
    return REAL;
}
\"[^\"]*\" {
    BeginToken(yytext);
    int err = check_string(yytext);
    if (err == STR_OVER_LONG)
        cout << "STRING OVER LONG";
    else if (err == UNEXPECTED_WORD)
        cout << "UNEXPECTED WORD";
    yylval.sval = yytext;
    return STRING;
}
{operator} {
    BeginToken(yytext);
    if (strcmp(yytext, ":=") == 0) return ASSIGN;
    if (strcmp(yytext, "+") == 0) return PLUS;
    if (strcmp(yytext, "-") == 0) return MINUS;
    if (strcmp(yytext, "*") == 0) return ASTERISK;
    if (strcmp(yytext, "/") == 0) return SLASH;
    if (strcmp(yytext, "<") == 0) return LT;
    if (strcmp(yytext, "<=") == 0) return LE;
    if (strcmp(yytext, ">") == 0) return GT;
    if (strcmp(yytext, ">=") == 0) return GE;
    if (strcmp(yytext, "=") == 0) return EQ;
    if (strcmp(yytext, "<>") == 0) return NE;
    if (strcmp(yytext, "DIV") == 0) return DIV;
}
{delimiter} {
    BeginToken(yytext);
    if (strcmp(yytext, ":") == 0) return COLON;
    if (strcmp(yytext, ";") == 0) return SEMICOLON;
    if (strcmp(yytext, ",") == 0) return COMMA;
    if (strcmp(yytext, ".") == 0) return STOP;
    if (strcmp(yytext, "(") == 0) return LP;
    if (strcmp(yytext, ")") == 0) return RP;
    if (strcmp(yytext, "[") == 0) return LSB;
    if (strcmp(yytext, "]") == 0) return RSB;
    if (strcmp(yytext, "{") == 0) return LB;
    if (strcmp(yytext, "}") == 0) return RB;
    if (strcmp(yytext, "[<") == 0) return LA;
    if (strcmp(yytext, ">]") == 0) return RA;
    if (strcmp(yytext, "\\") == 0) return BACKSLASH;
}
{letter}({letter}|{digit})* {
    BeginToken(yytext);
    yylval.sval = yytext;
    return ID;
}
\(*.*\*\) {
    BeginToken(yytext);
    cerr << "Ignore Comment:" << yytext << endl;
}

%%

int check_string(char *str) {
    if (strlen(str) > 255)
        return STR_OVER_LONG;
    else {
        for (int i = 0; i < strlen(str); ++i)
            if (str[i] < 32)
                return UNEXPECTED_WORD;
        return 0;
    }
}


int check_integer(char* int_str) {
    if (strlen(int_str) > strlen(MAX_INT))
        return INT_OVERFLOW;
    else if (strlen(int_str) == strlen(MAX_INT)) {
        for (int i = 0; i < strlen(int_str); ++i)
            if (int_str[i] > MAX_INT[i])
                return INT_OVERFLOW;
            else if (int_str[i] < MAX_INT[i])
                return 0;
    }
    return 0;
}
