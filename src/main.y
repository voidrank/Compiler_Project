%{
#include "main.h"
#define YYERROR_VERBOSE 1
%}

%defines
%locations

%union {
    int ival; // INT
    float fval; // FLOAT
    char *sval; // STRING
}

/*type*/
%token <ival> INTEGER
%token <fval> REAL
%token <sval> STRING

/*keyword*/
%token <sval> AND ARRAY BeGiN BY DO ELSE ELSIF END EXIT FOR IF IS LOOP MOD NOT OF OR PROCEDURE PROGRAM READ RECORD RETURN THEN TO TYPE VAR WHILE WRITE

/*operator*/
/*define operator precedence DO NOT change the order*/
%left PLUS MINUS
%left ASTERISK SLASH DIV
%left NOT
%left LT LE GT GE
%left EQ NE
%left ASSIGN

/*delimiter*/
%token <sval> COLON SEMICOLON COMMA STOP LP RP LSB RSB LB RB LA RA BACKSLASH

%token <sval> ID

%start program

%%
program: PROGRAM IS body SEMICOLON {cout << "program" << endl;}
       ;
body: declarartions BeGiN statements END {cout << "body" << endl;}
    ;
declarartions: declarartions declarartion {cout << "declarartions" << endl;}
             | {cout << "void declarartions" << endl;}
             ;
declarartion: TYPE typeDecls {cout << "type-declaration" << endl;}
            | VAR varDecls {cout << "var-declaration" << endl;}
            | PROCEDURE procedureDecls {cout << "procedure-declaration" << endl;}
            ;
varDecls: varDecls varDecl {cout << "var-decls" << endl;}
        | {cout << "void var-decls" << endl;}
        ;
typeDecls: typeDecls typeDecl {cout << "type-decls" << endl;}
         | {cout << "void type-decls" << endl;}
         ;
procedureDecls: procedureDecls procedureDecl {cout << "procedureDecls" << endl;}
              | {cout << "void procedureDecls" << endl;}
              ;
varDecl: IDs maybeType ASSIGN expression SEMICOLON {cout << "var-decl" << endl;}
       ;
typeDecl: ID IS type SEMICOLON {cout << "type-decl" << endl;}
        ;
procedureDecl: ID formalParams maybeType IS body SEMICOLON {cout << "procedure-decl" << endl;}
             ;
IDs: IDs COMMA ID {cout << "IDs" << endl;}
   | ID {cout << "first ID" << endl;}
   ;
maybeType: COLON type {cout << "Just type" << endl;}
         | {cout << "Nothing :: Maybe Type" << endl;}
         ;
type: ARRAY OF type {cout << "array of type" << endl;}
    | RECORD components END {cout << "recoard" << endl;}
    | ID {cout << "ID" << endl;}
    ;
components: components component {cout << "components" << endl;}
          | component {cout << "first component" << endl;}
          ;
component: ID COLON type SEMICOLON {cout << "component" << endl;}
         ;
formalParams: LP fpSections RP {cout << "formalParams" << endl;}
            | LP RP {cout << "empty formalParams" << endl;}
            ;
fpSections: fpSections SEMICOLON fpSection {cout << "fp-sections" << endl;}
          | fpSection {cout << "first fp-section" << endl;}
          ;
fpSection: IDs COLON type {cout << "fp-section" << endl;}
         ;
statement: lvalue ASSIGN expression SEMICOLON {cout << "assign statement" << endl;}
         | ID actualParams SEMICOLON {cout << "actual-params statement" << endl;}
         | READ LP lvalues RP SEMICOLON {cout << "read statement" << endl;}
         | WRITE writeParams SEMICOLON {cout << "write statement" << endl;}
         | IF expression THEN statements ELSIFs maybeELSE END SEMICOLON {cout << "if statement" << endl;}
         | WHILE expression DO statements END SEMICOLON {cout << "while statement" << endl;}
         | LOOP statements END SEMICOLON {cout << "loop statement" << endl;}
         | FOR ID ASSIGN expression TO expression maybeByExpression DO statements END SEMICOLON {cout << "for statement" << endl;}
         | EXIT SEMICOLON {cout << "exit statement" << endl;}
         | RETURN maybeExpression SEMICOLON {cout << "return statement" << endl;}
         ;
lvalues: lvalues COMMA lvalue {cout << "l-values" << endl;}
      | lvalue {cout << "first l-value" << endl;}
      ;
ELSIFs: ELSIFs ELSIF expression THEN statements {cout << "ELSIFs" << endl;}
      | {cout << "void ELSIFs" << endl;}
      ;
maybeELSE: ELSE statements {cout << "Just ELSE statement" << endl;}
         | {cout << "Nothing :: Maybe ELSE statement" << endl;}
         ;
statements: statements statement {cout << "statements" << endl;}
          | {cout << "void statement" << endl;}
          ;
maybeByExpression: BY expression {cout << "Just BY expression" << endl;}
                 | {cout << "Nothing :: Maybe BY expression" << endl;}
                 ;
maybeExpression: expression {cout << "Just expression" << endl;}
               | {cout << "Nothing :: Maybe expression" << endl;}
               ;
writeParams: LP writeExprs RP {cout << "write-params" << endl;}
           | LP RP {cout << "empty write-params" << endl;}
           ;
writeExpr: STRING {cout << "STRING write-expr" << endl;}
         | expression {cout << "expression write-expr" << endl;}
         ;
writeExprs: writeExprs COMMA writeExpr {cout << "write-exprs" << endl;}
          | writeExpr {cout << "first write-exprs" << endl;}
          ;
expression: number {cout << "number expression" << endl;}
          | lvalue {cout << "l-value expression" << endl;}
          | LP expression RP {cout << "(expression)" << endl;}
          | unaryOP expression {cout << "unaryOP expression" << endl;}
          | expression binaryOP expression {cout << "expression binaryOP expression" << endl;}
          | ID actualParams {cout << "ID actual-params expression" << endl;}
          | ID compValues {cout << "ID comp-values expression" << endl;}
          | ID arrayValues {cout << "ID array-values expression" << endl;}
          ;
lvalue: ID {cout << "ID l-value" << endl;}
      | lvalue LSB expression RSB {cout << "[expression] l-value" << endl;}
      | lvalue STOP ID {cout << "lvalue . ID lvalue" << endl;}
      ;
actualParams: LP expressions RP {cout << "actual-params" << endl;}
            | LP RP {cout << "empty actual-params" << endl;}
            ;
expressions: expressions COMMA expression {cout << "expressions" << endl;}
           | expression {cout << "first expression" << endl;}
           ;
compValues: LB assignIDs RB {cout << "comp-values" << endl;}
          ;
assignIDs: assignIDs SEMICOLON assignID {cout << "assignIDs" << endl;}
         | assignID {cout << "first assignID" << endl;}
         ;
assignID: ID ASSIGN expression {cout << "assignID" << endl;}
        ;
arrayValues: LA arrayValuess RA {cout << "array-values" << endl;}
           ;
arrayValuess: arrayValuess COMMA arrayvalue {cout << "array-valuess" << endl;}
            | arrayvalue {cout << "first array-value" << endl;}
            ;
arrayvalue: expression OF expression {cout << "expressions" << endl;}
          | expression {cout << "first expression" << endl;}
          ;
number: INTEGER {cout << "INTEGER" << endl;}
      | REAL {cout << "REAL" << endl;}
      ;
unaryOP: PLUS {cout << "PLUS" << endl;}
       | MINUS {cout << "MINUS" << endl;}
       | NOT {cout << "NOT" << endl;}
       ;
binaryOP: PLUS {cout << "PLUS" << endl;}
        | MINUS {cout << "MINUS" << endl;}
        | ASTERISK {cout << "ASTERISK" << endl;}
        | SLASH {cout << "SLASH" << endl;}
        | DIV {cout << "DIV" << endl;}
        | MOD {cout << "MOD" << endl;}
        | OR {cout << "OR" << endl;}
        | AND {cout << "AND" << endl;}
        | GT {cout << "GT" << endl;}
        | LT {cout << "LT" << endl;}
        | EQ {cout << "EQ" << endl;}
        | GE {cout << "GE" << endl;}
        | LE {cout << "LE" << endl;}
        | NE {cout << "NE" << endl;}
        ;

%%

void yyerror(const char *s) {
    PrintError(s);
    // might as well halt now:
    exit(-1);
}
