#ifndef modsrc_H
#define modsrc_H
#include "environ.h"

typedef struct list_obj{
	union {
		char* var; /* op & identificateur*/
		int valeur; /* constante*/
	}data;
int type; /* defini le type du noeud "var-cons ou op" */
struct list_obj* fils_gauche;
struct list_obj* fils_droit;
}noeud;;
noeud* creerNoeudcons(struct list_obj*nodeg,struct list_obj* nodd,int cons);
noeud* creerNoeudide(struct list_obj*nodeg,struct list_obj* nodd,char* ide);
int start(ENV *e,noeud* n);
#endif

