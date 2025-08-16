%{
   #include "parser.tab.h"
   #include <stdlib.h>
   #include <iostream>
   void yyerror(const char *);
   using namespace std;
%}

%option yylineno

%%

[\(\)]                  {return *yytext; }

[\[\]]                  {return *yytext; }

[\{\}]                  {return *yytext; }

int|float|char|void     {return TYPE; }  

[0-9]+                  {yylval.ival=stoi(yytext); return INT; }

\,                      {return *yytext;}

\"[^"]*\"               {strcpy(yylval.sval,yytext); return STRING; }

==|!=|<|<=|>|>=         {return COND_OP; }

if                      {return IF; }

else                    {return ELSE; }

for                     {return FOR; }

while                   {return WHILE; }

return                  {return RET; }

printf                  {return PRINT; }

[a-zA-Z_][a-zA-Z0-9_]*  {strcpy(yylval.sval,yytext); return VAR; }

=                       {return EQ; }

[\-\+/\*]               {return *yytext; }

\*\*                    {return POW; }

[ \n\t]  	            { }

\;                      {return ';';}

.	                    {yyerror("unknown character");}

%%

int yywrap(void) {
    return 1;
}

