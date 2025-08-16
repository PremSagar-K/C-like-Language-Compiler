
%{
    #include<bits/stdc++.h>
    using namespace std;

    #include "parser.tab.h"

    void yyerror(const char *);
%}

%%

"//".*          { /* Ignore single-line comments */ }

\"(.*)\"        {yylval.strval = strdup(yytext); return STRING_INP;}
\'(.*)\'        {yylval.strval = strdup(yytext); return CHAR_INP;}

main            {return MAIN;}

int             {return INT;}
char            {return CHAR;}

if              {return IF;}
else            {return ELSE;}

"<="            {yylval.strval = strdup(yytext); return COND;}
"=="            {yylval.strval = strdup(yytext); return COND;}
">="            {yylval.strval = strdup(yytext); return COND;}
"<"             {yylval.strval = strdup(yytext); return COND;}
">"             {yylval.strval = strdup(yytext); return COND;}
"!="            {yylval.strval = strdup(yytext); return COND;}

"&&"            {yylval.strval = strdup(yytext); return AND;}
"||"            {yylval.strval = strdup(yytext); return OR;}
"!"             {return *yytext;}

for             {return FOR;}
while           {return WHILE;}

return          {return RETURN;}

[+\-\*\/]       {return *yytext;}

"**"            {return POW;}

[a-zA-Z_][a-zA-Z_0-9]*   {yylval.strval = strdup(yytext); return NAME;}

[0-9]+          {yylval.intval = atoi(yytext); return NUM;}

[\{\}\(\)\;\=\,\[\]] {return *yytext;}

[ \t]
[\n]            { }

.               {yyerror((const char*)"unknown character");}

%%

int yywrap(void)
{
    return 1;
}
