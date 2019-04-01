/*MAME : SOTIRIOS ALEXIOU*/
/*AM : 5712*/
/*ETOS SPOUDWN : 4o*/
	#include <stdio.h>
	#include <unistd.h>
	#include <sys/types.h>
	#include <sys/ipc.h>
	#include <sys/wait.h>
    #include "display.h"
    int main()
{
	/* εδω οριζουμαι την λειτουργια up του σεμαφορου */
	struct sembuf up ;
	
			up.sem_num = 0 ; 
			
			up.sem_op = 1 ;
			
			
			up.sem_flg = 0 ;
	
	/* εδω οριζουμαι την down λειτουργεια του σεμαφορου*/
	struct sembuf down ;
		
			down.sem_num = 0 ; 
			
			down.sem_op = -1 ;
			
			down.sem_flg = 0 ;
	
	int i;
	
	/* εδω γινεται το create*/ 
	
	int semephore_parent = semget(IPC_PRIVATE, 1, 0666 );
	
	/* εδω μπλοκαρεται η κρισιμη περιοχη στον γονεα */
	
	int semephore_child = semget(IPC_PRIVATE, 1, 0666 ); 
	
	/* εδω μπλοκαρεται η κρισιμη περιοχη στο παιδι */
		
		if( semephore_parent < 0 || semephore_child < 0 )
			
			{ printf("Unable to obtain semaphore"); 
			}
	/* εδω αρχικοποιουμαι τον σεμαφορο του παιδιου σε 1 ετσι ωστε να μπει πρωτο */
	
		if( semctl(semephore_child, 0, SETVAL , 1) )
			{ printf("Unable to set semaphore Value");
			}	
    if (fork())
		{ /* εδω ειναι η διεργασια παιδι */
	for (i=0;i<10;i++)
    
	{/* εδω μπλοκαρει την κρισιμη περιοχη σε περιπτωση που τρεχει γονικη διεργασια*/
	
	semop(semephore_child, &down , 1);
	
		display("ab");
	
	semop(semephore_parent, &up , 1);
	}
	
	wait(NULL);
	
	}
		else
	{
	/* εδω ειναι η διεργασια γονεα*/
	for (i=0;i<10;i++)
	
	{ /*  εδω μπλοκαρετε η κρισιμη περιοχη σε περιπτωση που τρεχει αλλη διεργασια παιδι*/
		
		semop(semephore_parent, &down , 1);
		
		display("cd\n");
	
		semop(semephore_child, &up , 1);
	}
	}
	
	/* εδω αφοαιρουνται οι σεμαφοροι */
	
	semctl(semephore_parent , 0 , IPC_RMID);
	
	semctl(semephore_child , 0 , IPC_RMID);
	
	return 0;
    }