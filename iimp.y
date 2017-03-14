%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "utils/modsrc.h"
#include "utils/environ.h"
#define YYSTYPE noeud*
int yyparse();
int yylex();
int yyerror(char *s);
%}

/* l'element par lequel commence l'analyse,
ce ne doit pas etre un token */

/*%union{
    char* string;
    struct list_obj* node;	
    int number;		
}*/

%token If El Wh Do Th Mo Pl Mu Se Sk Af V I
/*%left Af
%left Mu
%left Pl Mo
%right Se El Do
%type <> C E T F
%token '(' ')'*/ 
%start A

%%
A: C		    { ENV e = Envalloc(); start(&e,$1);}
;

E: E Pl T {$$=creerNoeudide($1,$3,"pl");}
 | E Mo T {$$=creerNoeudide($1,$3,"-");}
 | T 

T: T Mu F {$$=creerNoeudide($1,$3,"*");}
 | F 

F: '(' E ')'
 | I {$$=$1;}
 | V {$$=$1;}

C : V Af E { $$=creerNoeudide($1,$3,":="); ENV e = Envalloc(); start(&e,$$);}
  | Sk {$$=creerNoeudide(NULL,NULL,"skip");}
  | '(' C ')' {$$=$2;}
  | If E Th C El C {$$=creerNoeudide(creerNoeudide($2,$4,"then"),creerNoeudide($4,$6,"else"),"if");}
  | Wh E Do C  {$$=creerNoeudide($2,$4,"while");}
  | C Se C {$$=creerNoeudide($1,$3,";");}
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


