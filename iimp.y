%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
int yyparse();
int yylex();
int yyerror(char *s);
%}

/* l'element par lequel commence l'analyse,
ce ne doit pas etre un token */

%union{
    char* string;
    int number;	
}

%token <string> If El Wh Do Th Mo Pl Mu Se Sk Af
%left Af
%left Mu
%left Pl Mo
%right Se El Do
%token <string> V
%token <number> I
%type <string> C
%type <string> '(' ')' 
%start C

%%
E: E Pl T //{printf("%s\n", $2);}
 | E Mo T //{printf("%s\n", $2);}
 | T

T: T Mu F {printf("%s\n", $2);}
 | F

F: '('E')'
 | I {printf("%d ",$1);}
 | V {printf("%s ",$1);}

C : V Af E {printf("%s %s \n", $1,$2);}
  | Sk
  | '(' C ')'
  | If E Th C El C 
  | Wh E Do C
  | C Se C
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


