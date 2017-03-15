#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "utils/interIMP.h"
#include "utils/environ.h"
#include "iimp.tab.h"
#include "utils/bilquad.h"

char *strdup(const char *s);
static int count=1;
BILQUAD bq;

int traitement(ENV *e,noeud *n){
//printf("Debug");
	char etiq[20];
	char arg1[20];
	char arg2[20];
	char res[20];
	QUAD* q = NULL;
	BILQUAD* bq2 = NULL;
	if (!n) return 0;
	switch(n->type){
		case I: // Integer, entier
			sprintf(etiq, "ET%d", count++);
			sprintf(arg1, "%d", n->data.valeur);
			sprintf(res, "CT%d", count);
			*q = creer_quad(etiq, Afc, arg1, "", res);
			*bq2 = creer_bilquad(*q);
			bq = concatq(bq, *bq2);
			break;
		case V: // Variable, identificateur, char*
			sprintf(etiq, "ET%d", count++);
			sprintf(res, "%s", n->data.id);
			*q = creer_quad(etiq, Sk, "", "", res);
			*bq2 = creer_bilquad(*q);
			bq = concatq(bq, *bq2);
			break;
		/*case If:
		case El:
		case Th:
		case Wh:
			return 0;*/
		case Af:
			traitement(e, n->fils_droit);
			sprintf(etiq, "ET%d", count++);
			sprintf(arg1, "%s", n->fils_gauche->data.id);
			sprintf(arg2, "CT%d", count);
			*q = creer_quad(etiq, Af, arg1, arg2, "");
			*bq2 = creer_bilquad(*q);
			bq = concatq(bq, *bq2);
			break;
		case Se:
			traitement(e,n->fils_gauche);
			return traitement(e,n->fils_droit);
		/*case Pl:
		case Mo:
		case Mu:
			break;*/
    }
    return 0;
}

int start(ENV *e,noeud* n){
    bq = bilquad_vide();
    int res = traitement(e,n);
    ecrire_bilquad(bq);
    return res;
}

