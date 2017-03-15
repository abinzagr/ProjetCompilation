#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "utils/interIMP.h"
#include "iimp.tab.h"

char *strdup(const char *s);

noeud* creerNoeud(noeud* node_g, noeud* node_d, int type, int val, char* id){
	noeud* new_ele = (noeud*)malloc(sizeof(noeud));	
		
	new_ele->type = type;

	if(type == I)
		new_ele->data.valeur = val;
	else if(type == V)
		new_ele->data.id = strdup(id);
	else
		new_ele->data.valeur = -1;

	new_ele->fils_gauche = node_g;
	new_ele->fils_droit = node_d;
	return new_ele;
}

void libererArbre(noeud* n){
	if(!n)
		return;
	libererArbre(n->fils_gauche);
	libererArbre(n->fils_droit);
	free(n);
}
