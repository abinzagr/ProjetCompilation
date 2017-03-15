%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include "environc3a.h"
#include "bilquad.h"

BILQUAD biliste;
int ligne = 1;
char* etiquette;
char* operateur ;
char* arg1 ;
char* arg2 ;
char* resultat ;
int rien;

int intop(char *);
void raz();
void interpreterc3a(ENV* ,QUAD);
void compilerc3a(QUAD);
void ecrirevar(FILE* fd, ENV e);

%}

ETIQ [A-Z][A-Z0-9]*
OP [A-Z][a-z]*
VAR [A-Za-z][A-Za-z0-9]*
CONST [0-9]*
VIDE [" "|\t|]*

%s ETIQUETTE OPERATEUR ARGUMENT1 ARGUMENT2 RESULTAT
%%
<ETIQUETTE,INITIAL>{ETIQ} {
etiquette = (char*)malloc(sizeof(char));
strcpy(etiquette, yytext);}

<ETIQUETTE,INITIAL>":" {BEGIN OPERATEUR;}
<OPERATEUR>{OP} {
operateur = (char*)malloc(sizeof(char)); strcpy(operateur, yytext);}

<OPERATEUR>":" {BEGIN ARGUMENT1;}
<ARGUMENT1>{VAR}|{CONST} {
arg1 = Idalloc(); strcpy(arg1,yytext);}

<ARGUMENT1>":" {BEGIN ARGUMENT2;}

<ARGUMENT2>{VAR}|{CONST} {
arg2 = Idalloc(); strcpy(arg2, yytext);}

<ARGUMENT2>":" {BEGIN RESULTAT;}

<RESULTAT>{VAR} {
resultat = Idalloc(); strcpy(resultat, yytext);}

<RESULTAT>\n {BEGIN ETIQUETTE;
if(biliste.debut == NULL)
biliste = creer_bilquad( creer_quad(etiquette,intop(operateur),arg1,arg2,resultat));
else
biliste =concatq(biliste,creer_bilquad(creer_quad(etiquette,intop(operateur),arg1,arg2,resultat)));
raz();}

<ETIQUETTE,RESULTAT><<EOF>> {printf("tout s'est bien déroulé\n");/*ecrire_bilquad(biliste);*/ return EXIT_SUCCESS;}

<OPERATEUR,ARGUMENT1,ARGUMENT2><<EOF>> {printf("il y eu des erreurs\n");/*ecrire_bilquad(biliste)*/;return EXIT_FAILURE;}
.|\n {}
%%

int intop(char * op){
if(strcmp(op,"Pl") == 0)
return Pl;
if(strcmp(op,"Mo") == 0)
return Mo;
if(strcmp(op,"Mu") == 0)
return Mu;
if(strcmp(op,"Afc") == 0)
return Afc;
if(strcmp(op,"Af") == 0)
return Af;
if(strcmp(op,"Sk") == 0)
return Sk;
if(strcmp(op,"St") == 0)
return St;
if(strcmp(op,"Jp") == 0)
return Jp;
if(strcmp(op,"Jz") == 0)
return Jz;
}

void raz(){
etiquette = NULL;
operateur= NULL ;
arg1 = NULL ;
arg2 = NULL ;
resultat = NULL ;
}

int main(int argc, char **argv){

if(argc < 2){
fprintf(stderr, "iC3A i(pour interpreter) ou  c(pour compiler)");
return EXIT_FAILURE;
}

if(yylex() == EXIT_FAILURE){
fprintf(stderr,"Probleme de compréhension du fichier\n");
return EXIT_FAILURE ;
}

if(strcmp(argv[1],"i") == 0){
//Interprétation du fichier C3A
ENV e = Envalloc();

interpreterc3a(&e, biliste.debut);
ecrire_env(e);
libenv(e);
}
else
if(strcmp(argv[1],"c") == 0)
compilerc3a(biliste.debut);


libbilquad(biliste);

return EXIT_SUCCESS;
}


/************************ Interpreteur************************/ 
void interpreterc3a(ENV* e ,QUAD curseur){
while(curseur != NULL){
switch(curseur->OP){

case Sk :
if(curseur->RES != NULL)
initenv(e,curseur->RES);
break;

case Mu :
case Mo :
case Pl : //creer la var res dans e (si elle existe elle ne sera pas créée)
//ensuite recuperer les valeur des arguments pour faire les opérations dessus
initenv(e,curseur->RES);
affect(*e,curseur->RES,eval (curseur->OP, valch(*e,curseur->ARG1),valch(*e,curseur->ARG2)));
break;

case Af : //recuperer l'environnement associé et affecté la valeur 
initenv(e,curseur->ARG1);
affect(*e, curseur->ARG1, valch(*e, curseur->ARG2));
break;

case Afc : 
initenv(e,curseur->RES);
affect(*e, curseur->RES, strtoimax(curseur->ARG1,NULL,10));
break;

case St :
return ;

case Jz : 
if (valch(*e, curseur->ARG1) != 0)
break;
//else
case Jp : 
curseur = rechbq(curseur->RES, biliste);
break;

default :
break;

}
curseur = curseur->SUIV;

}
}

/*************************PARTIE STATIC DU COMPILATEUR******************/

void ecrireinit(FILE* fd){
fprintf(fd,"\t.pos\t 0\t#debut zone code \n");
fprintf(fd,"INIT\t\t :irmovl Data, %%edx\t#adresse de la zone de donnees\n");
fprintf(fd,"\t\tirmovl 256, %%eax\t#espace pile\n");
fprintf(fd,"\t\taddl   %%edx, %%eax\n");
fprintf(fd,"\t\trrmovl %%eax, %%esp\t#init pile \n");
fprintf(fd,"\t\trrmovl %%eax, %%ebp\n");
}

void ecrirefct(FILE* fd){

fprintf(fd,"MUL\t\t:nop                        #ssprog mult:M[M[%%edx]]:=X*Y\n");
fprintf(fd,"\t\tmrmovl 4(%%esp), %%eax\t#A := X\n");   
fprintf(fd,"\t\tmrmovl 8(%%esp), %%ebx\t# B:= Y\n");   
fprintf(fd,"\t\tandl   %%eax, %%eax\t# si A==0 return 0\n");
fprintf(fd,"\t\tje     END\n");                           
fprintf(fd,"SIGN\t\t:nop\t#si A <= 0 alors (X:= -A,Y:= -B\n");
fprintf(fd,"\t\tjg     MULPLUS\t#cas ou A > 0\n");
fprintf(fd,"\t\tirmovl 0, %%ecx\n");                
fprintf(fd,"\t\tsubl   %%eax, %%ecx\n");                
fprintf(fd,"\t\trrmovl %%ecx, %%eax\n");                
fprintf(fd,"\t\trmmovl %%eax, 4(%%esp)\t#X := -A\n");  
fprintf(fd,"\t\tirmovl 0, %%ecx\n");                
fprintf(fd,"\t\tsubl   %%ebx, %%ecx\n");                
fprintf(fd,"\t\trrmovl %%ecx, %%ebx\n");                
fprintf(fd,"\t\trmmovl %%ebx, 8(%%esp)\t#Y := -B\n");  
fprintf(fd,"MULPLUS\t\t:nop\t\t#ssprog X>0->M[M[%%edx]]:=X*Y\n");
fprintf(fd,"\t\tmrmovl 4(%%esp), %%eax\t#A := X\n");   
fprintf(fd,"\t\tandl   %%eax, %%eax\t\t# si X==0 return 0\n");
fprintf(fd,"\t\tje     END\n");                           
fprintf(fd,"\t\tirmovl 1, %%esi\t\t# A:=A-1\n");  
fprintf(fd,"\t\tsubl   %%esi, %%eax\n");                
fprintf(fd,"\t\tmrmovl 8(%%esp), %%ebx\t# B:= Y\n");   
fprintf(fd,"\t\tpushl  %%ebx\t\t# empiler B, puis A\n");
fprintf(fd,"\t\tpushl  %%eax\n");                          
fprintf(fd,"\t\tcall   MULPLUS\t# M[%%edx]:= A * B=(X-1) *Y \n");
fprintf(fd,"\t\tpopl   %%eax\t\t# depiler A puis B\n");
fprintf(fd,"\t\tpopl   %%eax\n");                          
fprintf(fd,"\t\tmrmovl 0(%%edx), %%eax\t# M[%%edx]:= M[%%edx] + Y\n");
fprintf(fd,"\t\tmrmovl 8(%%esp), %%ebx\n");                
fprintf(fd,"\t\taddl   %%ebx, %%eax\n");                
fprintf(fd,"\t\trmmovl %%eax, 0(%%edx)\t#end MUL(X<>0) ret(Z)\n");
fprintf(fd,"\t\tret\n");                                  
fprintf(fd,"END\t\t:irmovl 0, %%eax\t\t#end MUL(X==0) ret(Z)\n");
fprintf(fd,"\t\trmmovl %%eax, 0(%%edx)\n");             
fprintf(fd,"\t\tret\n");                                  
fprintf(fd,"\t\t.align    8\t#debut zone donnees\n");
fprintf(fd,"Data\t\t:\n");                                     
}

void ecrirevar(FILE* fd, ENV e){
ENV curseur = e; 
while(curseur != NULL){
fprintf(fd,"%s:\t.long 0\n",curseur->ID);
curseur = curseur->SUIV;
}
}

/************************ Compilateur ************************/
void compilerc3a(QUAD liste){
/*****Init Environnement*****/
ENV e = Envalloc();
interpreterc3a(&e,liste);
/*****INIT Fichier sortie ********/
FILE* fd = fopen("out.ys", "w");
ecrireinit(fd);
//********Mega switch pour tout transformer ********//
while(liste!=NULL){
switch(liste->OP){
case Sk :
fprintf(fd,"%s:\tnop\n",liste->ETIQ);
break;

case Jz :
fprintf(fd,"%s:\tmrmovl %s, %%eax\n",liste->ETIQ,liste->ARG1);
fprintf(fd,"\t\tandl %%eax, %%eax\n");
fprintf(fd,"\t\tje %s\n",liste->RES);
break;

case Jp :
fprintf(fd,"%s:\tjmp %s",liste->ETIQ,liste->RES);
break;

case Af:
fprintf(fd,"%s:\tmrmovl %s, %%eax\n",liste->ETIQ,liste->ARG2);
fprintf(fd,"\t\trmmovl %%eax , %s\n", liste->ARG1);
break;

case Afc:
fprintf(fd,"%s:\tirmovl %s,%%eax\n",liste->ETIQ,liste->ARG1);
fprintf(fd,"\t\trmmovl %%eax, %s\n",liste->RES);
break;

case Mu :
fprintf(fd,"%s:\tmrmovl %s , %%eax\n", liste->ETIQ,liste->ARG1);
fprintf(fd,"\t\tmrmovl %s, %%ebx\n", liste->ARG2);
fprintf(fd,"\t\tpushl %%ebx\n");
fprintf(fd,"\t\tpushl %%eax\n");
fprintf(fd,"\t\tcall MUL\n");
fprintf(fd,"\t\tpopl %%eax\n");
fprintf(fd,"\t\tpopl %%ebx\n");
fprintf(fd,"\t\tmrmovl 0(%%edx), %%eax\n");
fprintf(fd,"\t\trmmovl %%eax, %s \n",liste->RES);
break;

case Mo: 
fprintf(fd,"%s:\tmrmovl %s, %%ebx \n",liste->ETIQ,liste->ARG2);
fprintf(fd,"\t\tmrmovl %s, %%eax\n",liste->ARG1);
fprintf(fd,"\t\tsubl %%eax, %%ebx\n");
fprintf(fd,"\t\trmmovl %ebx, %s\n",liste->RES);
break;

case Pl:
fprintf(fd,"%s:\tmrmovl %s,%%eax \n",liste->ETIQ,liste->ARG2);
fprintf(fd,"\t\tmrmovl %s,%%ebx \n",liste->ARG1);
fprintf(fd,"\t\taddl %%eax, %%ebx\n");
fprintf(fd,"\t\trmmovl %%ebx, %s\n", liste->RES);
break;

case St:
fprintf(fd,"%s:\thalt\n",liste->ETIQ);
break;
}

liste=liste->SUIV;
}

//////////////////////////////////////////////////////

ecrirefct(fd);
ecrirevar(fd,e);
libenv(e);
}

