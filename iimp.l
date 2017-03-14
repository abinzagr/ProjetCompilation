%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "iimp.tab.h"
#include "utils/modsrc.h"
char * strdup(char*);
int fileno();
%}
%option noinput nounput
V [a-zA-Z][0-9]*
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
; 	{return Se;}
skip	{return Sk;}
{I} 	{yylval = creerNoeudcons(NULL,NULL,atoi(yytext)); return I;}
{V}	{yylval = creerNoeudide(NULL,NULL,strdup(yytext));return V;}
[ \t]+	{;}
[\n] {;}
"'('" {return '(';}
"')'" {return ')';}
. {;}
<<EOF>> {return(0);}
%%
