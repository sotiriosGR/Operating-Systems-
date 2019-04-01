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
	/* εδω οριζομμαι την λειτουργια σεμαφορου */
    struct sembuf up ; 
			
			up.sem_num = 0 ;   
			
			up.sem_op = 1 ;
			
			up.sem_flg = 0 ;
	/* Ορισμος down λειτουργιας σεμαφορου */
	struct sembuf down ;
			
			down.sem_num = 0 ; 
			
			down.sem_op = -1 ;
			
			down.sem_flg = 0 ;
	int i;
		int semephore_id = semget(IPC_PRIVATE, 1, 0666 );/*CREATE*/ 
			
			if( semephore_id < 0 )
				
				{ printf("Unable to obtain semaphore"); }
	
			if( semctl(semephore_id, 0, SETVAL , 1) ) /*εδω αρχικοπουουμαι την τιμη 1*/
			
				{ printf("Unable to set semaphore Value"); }
	
	if (fork())
	{
		/* αυτη ειναι η διεργασια "παιδι" */
 		
		for (i=0;i<10;i++)
		{
			semop(semephore_id, &down , 1); /*εδω μπλοκαρουμαι την κρισιμη περιοχη αν χρησιμοποιηται ο σεμαφοροσ απο αλλη διεργασια*/
			
			display("Hello world\n");
			
			semop(semephore_id, &up , 1);
			
			}
		
		wait(NULL); 
		}
	else
	{
		/* Αυτη ειναι η διεργασια γονεα */
		
		for (i=0;i<10;i++)
		
		{
			semop(semephore_id, &down , 1); /*εδω μπλοκαρουμαι την κρισιμη περιοχη αν χρησιμοποιηται απ καποια αλλη διεργασιαths */
			
			display("Kalimera kosme\n");
			
			semop(semephore_id, &up , 1); /*εδω ξεμπλοκαρουμαι τον σεμαφορο*/
			
		}
	}
	semctl(semephore_id , 0 , IPC_RMID); /*εδω σταματαει η λειτουργια σεμαφορου*/
	return 0;
}