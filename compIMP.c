#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
#include "utils/interIMP.h"
#include "iimp.tab.h"
//#include "utils/bilquad.h"

char *strdup(const char *s);

static int countCT=0, countET=0, countJMP=0;

// Affichage manuel
void affichage(int etiq, char *op, char *arg1, char *arg2, char *res){ // bilquad non fonctionnel
	if(!arg1)
		arg1 = strdup("");
	if(!arg2)
		arg2 = strdup("");
	if(!res)
		res = strdup("");
    printf("ET%d\t:%s\t:%s\t:%s\t:%s\n",etiq, op, arg1, arg2, res);
}

int traitement(ENV *e,noeud *n) {
    int tmpJmp=0,tmpJmp2=0;
    int tmpCount=0;
    char arg1[30];
    char arg2[30];
    char res[30];
	if (!n) return 0;
	switch(n->type) {
	    case I:   
		sprintf(arg1,"%d",n->data.valeur);
                sprintf(res,"CT%d",++countCT);
                affichage(countET++,"Afc", arg1, NULL, res);
	        break;

	    case V:	
		sprintf(arg1, "CT%d",++countCT);
		sprintf(arg2, "%s", n->data.id);
		affichage(countET++,"Af", arg1, arg2, NULL);
	        break;

	    case Wh:    
		sprintf(arg2, "JMP%d",tmpJmp = countJMP++);
	        printf("%s\t:%s\t:%s\t:%s\t:%s\n",arg2,"Sk","","","");
	        traitement(e,n->fils_gauche);
	        sprintf(arg1, "CT%d",countCT);
                sprintf(res,"JMP%d",tmpJmp2 = countJMP++);
                affichage(countET++,"Jz",arg1,NULL,res);
                traitement(e, n->fils_droit);
                affichage(countET++,"Jp",NULL,NULL,arg1);
                printf("%s\t:%s\t:%s\t:%s\t:%s\n",res,"Sk","","","");
                return 0;

            case If:    
		traitement(e, n->fils_gauche);
                traitement(e, n->fils_droit);
		sprintf(arg1,"CT%d",countCT);
                sprintf(res,"JMP%d",tmpJmp = countJMP++);
                affichage(countET++,"Jz",arg1,NULL,res);
	        return 0; 

	     case El:
		if(traitement(e, n->fils_gauche)){
			sprintf(res, "JMP%d", tmpJmp);
			sprintf(arg1,"JMP%d",tmpJmp2 = countJMP++);
               		affichage(countET++,"Jp",NULL,NULL,arg1);
                	printf("%s\t:%s\t:%s\t:%s\t:%s\n",res,"Sk","","","");
			traitement(e, n->fils_droit);
		}

	     case Th:
		if(!traitement(e, n->fils_gauche)){
			sprintf(arg1,"JMP%d",tmpJmp2 = countJMP++);
               		affichage(countET++,"Jp",NULL,NULL,arg1);
			printf("%s\t:%s\t:%s\t:%s\t:%s\n",arg1,"Sk","","","");
			traitement(e, n->fils_droit);
		}

	     case Af:
		traitement(e, n->fils_droit);
                sprintf(arg1,"CT%d",countCT);
                affichage(countET++,"Af", n->fils_gauche->data.id, arg1, NULL);
                break;

	     case Se:
		traitement(e, n->fils_gauche); 
		return traitement(e, n->fils_droit);
	        
	     case Pl:   
		traitement(e, n->fils_gauche);
                tmpCount = countCT;
                traitement(e, n->fils_droit);
                sprintf(arg1,"CT%d",tmpCount);
                sprintf(arg2,"CT%d",countCT);
                sprintf(res,"CT%d",++countCT);
                affichage(countET++,"Pl",arg1,arg2,res);
                break;
                
             case Mo:    
		traitement(e, n->fils_gauche);
		tmpCount = countCT;
		traitement(e, n->fils_droit);
		sprintf(arg1,"CT%d",tmpCount);
		sprintf(arg2,"CT%d",countCT);
		sprintf(res,"CT%d",++countCT);
		affichage(countET++,"Mo",arg1,arg2,res);
		break;

            
             case Mu:  
		traitement(e, n->fils_gauche);
		tmpCount = countCT;
		traitement(e, n->fils_droit);
		sprintf(arg1,"CT%d",tmpCount);
		sprintf(arg2,"CT%d",countCT);
		sprintf(res,"CT%d",++countCT);
		affichage(countET++,"Mu",arg1,arg2,res);
		break;
	}
	return 0;
}


int start(ENV *e,noeud *n) {
    int res = traitement(e,n);
    affichage(countCT++,"St",NULL,NULL,NULL); // bilquad non fonctionnel (fait main)
    return res;
}

