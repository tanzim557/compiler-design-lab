%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%option noyywrap

%%

[ \t\n\r]+              { /* Ignore whitespace */ }
"//".*                  { /* Ignore comments */ }

"if"                    { return IF; }
"else"                  { return ELSE; }
"print"|"output"        { return PRINT; }
"input"                 { return INPUT; }

[0-9]+(\.[0-9]+)?%      {
                            char tmp[100];
                            strcpy(tmp, yytext);
                            tmp[strlen(tmp)-1] = '\0'; // remove %
                            yylval.val = atof(tmp) / 100.0;
                            return NUM;
                        }

[0-9]+(\.[0-9]+)?       { yylval.val = atof(yytext); return NUM; }

\"([^\"\\]|\\.)*\"      { 
                            char* str = strdup(yytext + 1);
                            str[strlen(str)-1] = '\0';
                            yylval.str = str;
                            return STRING_LITERAL; 
                        }

[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return IDENTIFIER; }

"=="                    { return EQ; }
"!="                    { return NEQ; }
"<="                    { return LEQ; }
">="                    { return GEQ; }
"<"                     { return '<'; }
">"                     { return '>'; }

"+"                     { return '+'; }
"-"                     { return '-'; }
"*"                     { return '*'; }
"/"                     { return '/'; }
"="                     { return '='; }

"{"                     { return '{'; }
"}"                     { return '}'; }
"("                     { return '('; }
")"                     { return ')'; }
";"                     { return ';'; }

.                       { printf("Unknown token: %s\n", yytext); }

%%
