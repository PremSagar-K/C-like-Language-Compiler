%token TYPE COND_OP IF ELSE FOR WHILE RET PRINT EQ POW

%{
    #include <iostream>
    #include <bits/stdc++.h>
    using namespace std;
    void yyerror(const char *);
	int yylex(void);
    extern char *yytext;
    extern int yylineno;
    char var[100];
    set<string> A0D;
    set<string> A1D;
    set<string> A2D;
%}

%union {
    int ival;           /* For integer values */
    float fval;         /* For floating-point values */
    char sval[100];         /* For string values or identifiers */
    char op;            /* For operators */
}

%token <ival> INT 
%token <sval> STRING VAR

%left '+' '-' 
%left '*' '/'
%right POW

%%

program: lines 
;

lines: Fun lines | stmts lines | 
;

Fun: TYPE VAR '(' ARG ')' '{' stmts '}' 
    | TYPE VAR '(' ')' '{' stmts '}' 
;

ARG: TYPE VAR_ | ARG ',' ARG 
;

stmts: 
    | stmt
    | stmts stmt 
;

stmt: 
    | Decl 
    | Assign ';'
    | Print 
    | Loop 
    | If 
    | Ret 
    | FunCal ';'
;


Decl: TYPE SPLVars ';' 
;

VAR_: VAR 
    | VAR '[' EXP ']'
    | VAR '[' ']'
    | VAR '[' ']' '[' ']'
    | VAR '[' EXP ']' '[' EXP ']'
    | VAR '['  ']' '[' EXP ']'
    | VAR '[' EXP ']' '['  ']'
;

Vars: VAR_ | VAR_ ',' Vars
;

SPLVAR_: VAR { A0D.insert((string)$1); }
    | VAR  '[' EXP ']' { A1D.insert((string)$1); }
    | VAR  '[' ']' { A1D.insert((string)$1); }
    | VAR  '[' ']' '[' ']' { A2D.insert((string)$1); }
    | VAR  '[' EXP ']''[' EXP ']' { A2D.insert((string)$1); }
    | VAR  '['  ']' '[' EXP ']' { A2D.insert((string)$1); }
    | VAR  '[' EXP ']' '['  ']' { A2D.insert((string)$1); }
;

SPLVars: SPLVAR_ | SPLVAR_ ',' SPLVars
;

Assign: VAR_ EQ EXP 
;

Print: PRINT '(' STRING ')' ';' 
    | PRINT '(' STRING ',' Vars ')' ';'
;

Loop: For | While 
;

For: FOR '(' Assign ';' Cond ';' Assign ')' '{' stmts '}' 
    | FOR '(' Assign ';' Cond ';' Assign ')' stmt 
; 

While: WHILE '(' Cond ')' '{' stmts '}'
    | WHILE '(' Cond ')' stmt
;

Cond: SPLEXP COND_OP SPLEXP  
;

If: IF_ 
    | IF_ ELSE stmt 
    | IF_ ELSE '{' stmts '}' 
;

IF_: IF '(' Cond ')' stmt 
    | IF '(' Cond ')' '{' stmts '}' 
;

Ret: RET EXP ';' | RET ';'
;

EXP: INT 
    | VAR_
    | EXP '+' EXP 
    | EXP '-' EXP
    | EXP '*' EXP
    | EXP '/' EXP
    | EXP POW EXP
    | FunCal
;

SPLEXP: INT 
    | VAR  {if(A1D.find($1) != A1D.end() || A2D.find($1) != A2D.end()) {cout << yylineno << endl; exit(1);}}
    | VAR  '[' SPLEXP ']' {if(A2D.find($1) != A2D.end()) {cout << yylineno << endl; exit(1);}}
    | VAR  '[' ']' {if(A2D.find($1) != A2D.end()) {cout << yylineno << endl; exit(1);}}
    | VAR  '[' ']' '[' ']' {if(A1D.find($1) != A1D.end()) {cout << yylineno << endl; exit(1);}}
    | VAR  '[' SPLEXP ']' '[' SPLEXP ']' {if(A1D.find($1) != A1D.end()) {cout << yylineno << endl; exit(1);}}
    | VAR  '['  ']' '[' SPLEXP ']' {if(A1D.find($1) != A1D.end()) {cout << yylineno << endl; exit(1);}}
    | VAR  '[' SPLEXP ']' '['  ']' {if(A1D.find($1) != A1D.end()) {cout << yylineno << endl; exit(1);}}
    | SPLEXP '+' SPLEXP 
    | SPLEXP '-' SPLEXP
    | SPLEXP '*' SPLEXP
    | SPLEXP '/' SPLEXP
    | SPLEXP POW SPLEXP
    | FunCal
;

FunCal: VAR '(' Exps ')'
;

Exps: EXP | Exps ',' Exps 
;

%%

void yyerror(const char *s) {
    cout << yylineno << endl;
    exit(1);
}

int main(void) {
    yyparse();
    return 0;
}
