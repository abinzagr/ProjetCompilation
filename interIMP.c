#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "utils/modsrc.h"
#include "utils/environ.h"

noeud* creerNoeudcons(noeud*nodeg,noeud* nodd,int cons){
		noeud* new_ele = (noeud*)malloc(sizeof(noeud));			
			new_ele->data.valeur = cons;
			new_ele->fils_gauche = nodeg;
			new_ele->fils_droit = nodd;
			new_ele->type =1; 
	return new_ele;
}


noeud* creerNoeudide(struct list_obj*nodeg,struct list_obj* nodd,char* n_var){
	noeud* new_ele = (noeud*)malloc(sizeof(noeud));			
		new_ele->data.var =(char*) malloc(strlen(n_var)*sizeof(char));
		strcpy(new_ele->data.var,n_var); 
		new_ele->fils_gauche = nodeg;
		new_ele->fils_droit = nodd;
		if(strcmp(n_var,":=")!=0)/* && strcmp(n_var,"*")!=0 && strcmp(n_var,"-")!=0 && strcmp(n_var,"+")!=0 && strcmp(n_var,";")!=0 &&strcmp(n_var,"skip")!=0 && strcmp(n_var,"if")!=0 && strcmp(n_var,"while")!=0 && strcmp(n_var,"do")!=0 && strcmp(n_var,"then")!=0 && strcmp(n_var,"else")!=0 )*/
			{new_ele->type =2;}
		else 
			new_ele->type = 3;			
	return new_ele;
}


int traitement(ENV *e,noeud *n) {
	if (!n) return 0;
	printf("%d\n",n->type);
	switch(n->type) {
	    case 1:   return n->data.valeur;
	    case 2:   printf("%s",n->data.var);return valch(*e,n->data.var); 
	    case 3:  
		if(strcmp(n->data.var,"while")==0){
	 		while(traitement(e,n->fils_gauche))
				traitement(e,n->fils_droit);
	                return 0;
		}
		if(strcmp(n->data.var,"if")==0){
			traitement(e,n->fils_gauche);
                        traitement(e,n->fils_droit);
                        } 
			return 0;
		if(strcmp(n->data.var,"else")==0){
			if(traitement(e,n->fils_gauche)){
			traitement(e,n->fils_droit);
                        }
			 
		}
		if(strcmp(n->data.var,"then")==0){
			if(!traitement(e,n->fils_gauche)){
			traitement(e,n->fils_droit);
                        }
			 
		}
		if(strcmp(n->data.var,":=")==0){	
			initenv(e,n->fils_gauche->data.var);printf("%s\n",n->fils_gauche->data.var);
			return affect(*e, n->fils_gauche->data.var, traitement(e,n->fils_droit));				
		}
  		if(strcmp(n->data.var,";" )==0){
			traitement(e,n->fils_gauche);
			return traitement(e,n->fils_droit);

		}
	   	if(strcmp(n->data.var,"+" )==0){
			return( traitement(e,n->fils_gauche) + traitement(e,n->fils_gauche));	
		}
		if(strcmp(n->data.var,"-" )==0){
			return(traitement(e,n->fils_gauche) - traitement(e,n->fils_gauche));			
		}
		if(strcmp(n->data.var,"*" )==0){
			return( traitement(e,n->fils_gauche) * traitement(e,n->fils_gauche));			
		}
	    
    }
    return 0;
}

int start(ENV *e,noeud* n) {
    int res = traitement(e,n);
    ecrire_env(*e);
    return res;
}

