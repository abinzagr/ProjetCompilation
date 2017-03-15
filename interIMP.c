 #include <stdio.h> 
 #include <stdlib.h>
 #include <string.h>
 #include "utils/interIMP.h"
 #include "iimp.tab.h"
 
 char *strdup(const char *s);

 int traitement(ENV *e,noeud *n){
 	if (!n) return 0;
 	switch(n->type){
 		case I:
			return n->data.valeur;
		case V:
 			return valch(*e,n->data.id);
 		case If:
 			traitement(e,n->fils_gauche);
                         traitement(e,n->fils_droit);
 			return 0;
 		case El:
 			if(traitement(e,n->fils_gauche))
 				traitement(e,n->fils_droit);
			return 0;
 		case Th:
 			if(!traitement(e,n->fils_gauche))
 				traitement(e,n->fils_droit);
			return 0;
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
 		case Mo:
 		case Mu:
			return eval(n->type, traitement(e, n->fils_gauche), traitement(e, n->fils_droit));
     }
     return 0;
 }
 
 int start(ENV *e,noeud* n){
     int res = traitement(e,n);
     ecrire_env(*e);
     libererArbre(n);
     return res;
 }
