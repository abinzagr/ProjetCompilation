%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "utils/interIMP.h"
#include "utils/environ.h"
int yyparse();
int yylex();
int yyerror(char *s);
%}

%union{
	int val;
	char* id;
	struct list_obj* n;
}

%token<id> V
%token<val> I
%token If El Wh Do Th Mo Pl Mu Se Sk Af
%left '('
%start A

%type<n> E T F C

%%
A: C			{ENV e = Envalloc(); start(&e,$1);}
;

E: E Pl T 		{$$=creerNoeud($1,$3,Pl, -1, "");}
| E Mo T 		{$$=creerNoeud($1,$3,Mo, -1, "");}
| T			{$$=$1;}
;

T: T Mu F 		{$$=creerNoeud($1,$3,Mu, -1, "");}
| F			{$$=$1;} 
;

F: '(' E ')'		{$$=$2;}
| I 			{$$=creerNoeud(NULL, NULL, I, $1, "");}
| V			{$$=creerNoeud(NULL, NULL, V, -1, $1);}
;

C : V Af E 		{$$=creerNoeud(creerNoeud(NULL, NULL, V, -1, $1),$3,Af, -1, "");}
| Sk 			{$$=creerNoeud(NULL,NULL,Sk, -1, "");}
| '(' C ')' 		{$$=$2;}
| If E Th C El C 	{$$=creerNoeud(creerNoeud($2,$4,Th, -1, ""),creerNoeud($4,$6, El, -1, ""),If, -1, "");}
| Wh E Do C 		{$$=creerNoeud($2,$4,Wh, -1, "");}
| C Se C 		{$$=creerNoeud($1,$3,Se, -1, "");}
;

%%


int yyerror(char *s) {
	printf("yyerror : %s\n",s);
	return 0;
}

int yywrap(){
	return -1;
}

int main(int argc, char **argv){
	yyparse();
	return EXIT_SUCCESS;
}


