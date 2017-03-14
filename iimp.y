%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "utils/modsrc.h"
#include "utils/environ.h"

int yyparse();
int yylex();
int yyerror(char *s);
%}

/* l'element par lequel commence l'analyse,
ce ne doit pas etre un token */

%union{
    char* string;
    struct list_obj* node;	
    int number;	
}

%token <string> If El Wh Do Th Mo Pl Mu Se Sk Af
%left Af
%left Mu
%left Pl Mo
%right Se El Do
%token <string> V
%token <number> I 
%type <node> C E T F 
%token '(' ')' 
%start A

%%
A: C		    { ENV e = Envalloc(); start(&e,$1);}
;

E: E Pl T {$$=creerNoeudide($1,$3,$2);}
 | E Mo T {$$=creerNoeudide($1,$3,$2);}
 | T 

T: T Mu F {$$=creerNoeudide($1,$3,$2);}
 | F 

F: '(' E ')'
 | I {$$=creerNoeudcons(NULL,NULL,$1);printf("%d ",$1);}
 | V {$$=creerNoeudide(NULL,NULL,$1);}

C : V Af E { noeud *fils_gauche=creerNoeudide(NULL,NULL,$1);$$=creerNoeudide(fils_gauche,$3,$2);printf("%s ",$2);}
  | Sk {$$=creerNoeudide(NULL,NULL,$1);}
  | '(' C ')'
  | If E Th C El C  //{noeud *fils_gauche=creerNoeudide(NULL,NULL,$1);$$=creerNoeudide(fils_gauche,$3,$2);printf("%s ",$2);}
  | Wh E Do C  //{noeud *fils_gauche=creerNoeudide(NULL,NULL,$1);$$=creerNoeudide(fils_gauche,$3,$2);printf("%s ",$2);}
  | C Se C {$$=creerNoeudide($1,$3,$2);}
;

%%


int yyerror(char *s) {
	printf("yyerror : %s\n",s);
	return 0;
}

int main(void) {
	yyparse();
	return 0;
}


