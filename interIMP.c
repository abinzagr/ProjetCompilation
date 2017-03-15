#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "utils/interIMP.h"
#include "iimp.tab.h"

char *strdup(const char *s);

noeud* creerNoeud(noeud* node_g, noeud* node_d, int type, int val, char* id){
	noeud* new_ele = (noeud*)malloc(sizeof(noeud));	
		
	new_ele->type = type;

	if(type == V)
		new_ele->data.valeur = val;
	else if(type == I)
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

int traitement(ENV *e,noeud *n){
	if (!n) return 0;
	switch(n->type){
		case V:
			return n->data.valeur;
		case I:
			return valch(*e,n->data.id);
		case If:
			traitement(e,n->fils_gauche);
                        traitement(e,n->fils_droit);
			return 0;
		case El:
			if(traitement(e,n->fils_gauche))
				traitement(e,n->fils_droit);
		case Th:
			if(!traitement(e,n->fils_gauche))
				traitement(e,n->fils_droit);
		case Wh:
			while(traitement(e,n->fils_gauche))
				traitement(e,n->fils_droit);
			return 0;
		case Af:
			initenv(e,n->fils_gauche->data.id);
			return affect(*e, n->fils_gauche->data.id, traitement(e,n->fils_droit));
		case Se:
			traitement(e,n->fils_gauche);
			return traitement(e,n->fils_droit);
		case Pl:
			return eval(n->data.valeur, traitement(e, n->fils_gauche), traitement(e, n->fils_droit));
		case Mo:
			return eval(n->data.valeur, traitement(e, n->fils_gauche), traitement(e, n->fils_droit));
		case Mu:
			return eval(n->data.valeur, traitement(e, n->fils_gauche), traitement(e, n->fils_droit));
    }
    return 0;
}

int start(ENV *e,noeud* n){
    int res = traitement(e,n);
    ecrire_env(*e);
    libererArbre(n);
    return res;
}
