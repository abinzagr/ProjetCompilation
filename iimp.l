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
V [a-zA-Z0-9]*
chiffre [0-9]
I {chiffre}+

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
{I} 	{yylval.val = atoi(yytext); return I;}
{V}	{yylval.id = strdup(yytext);return V;}
[ \t\n]	{;}
. 	{;}
<<EOF>> {return 0;}
%%
