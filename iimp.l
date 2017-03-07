%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "iimp.tab.h"
char * strdup(char*);
int fileno();
%}
%option noinput nounput
V [a-zA-Z][0-9]*
I [1-9][0-9]*

%%

"if"	{yylval.string = strdup(yytext);return (If);}
"else"	{yylval.string = strdup(yytext);return (El);}
"while" {yylval.string = strdup(yytext);return (Wh);}
"do"	{yylval.string = strdup(yytext);return (Do);}
"then"	{yylval.string = strdup(yytext);return (Th);}
"-" 	{yylval.string = strdup(yytext);return (Mo);}
":="	{yylval.string = strdup(yytext);return (Af);}
"+" 	{yylval.string = strdup(yytext);return (Pl);}
"*" 	{yylval.string = strdup(yytext);return (Mu);}
";" 	{yylval.string = strdup(yytext);return (Se);}
"skip"	{yylval.string = strdup(yytext);return (Sk);}
{I} 	{yylval.number = atoi(yytext); return (I);}
{V}	{yylval.string = strdup(yytext); return (V);}
[\t]+	{;}
[\n] {;}
. {;}
<<EOF>> {return(0);}
%%

int yywrap(){
return -1;}
