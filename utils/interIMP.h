#ifndef modsrc_H
#define modsrc_H
#include "environ.h"

typedef struct list_obj{
	union {
		char* id; /* identificateur */
		int valeur; /* constante */
	}data;
	int type; /* Reprend le token */
	struct list_obj* fils_gauche;
	struct list_obj* fils_droit;
}noeud;

noeud* creerNoeud(noeud* node_g, noeud* node_d, int type, int val, char* id);
void libererArbre(noeud* n);

int start(ENV *e,noeud* n);
#endif

