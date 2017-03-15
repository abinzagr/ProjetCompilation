%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "iimp.tab.h"
#include "utils/interIMP.h"
char * strdup(char*);
int fileno();
%}
%option noinput nounput
I [a-zA-Z0-9]*
chiffre [0-9]
V {chiffre}+

%%

if	{return If;}
else	{return El;}
while 	{return Wh;}
do	{return Do;}
then	{return Th;}
-	{return Mo;}
:=	{return Af;}
"+"	{return Pl;}
"*"	{return Mu;}
;	{return Se;}
skip	{return Sk;}
{V} 	{yylval.val = atoi(yytext); return V;}
{I}	{yylval.id = strdup(yytext);return I;}
[ \t\n]	{;}
. 	{;}
<<EOF>> {return 0;}
%%
