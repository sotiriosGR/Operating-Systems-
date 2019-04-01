/*MAME : SOTIRIOS ALEXIOU*/
/*AM : 5712*/
/*ETOS SPOUDWN : 4o*/

#include "display.h"
#include <unistd.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>
#define FALSE 0

#define TRUE 1
/* εδω δηλωνουμαι το mutex */

pthread_mutex_t mutex ;

/* εδω δηλωνουμαι τις μεταβλητες της καταστασης */

pthread_cond_t cond_var ;

int predicate_1 = TRUE ;
int predicate_2 = FALSE ;
void *disp1(void *argument){
int i ;

	for(i=0;i<10;i++)
{/* αναμονη*/

	pthread_mutex_lock(&mutex);
		
		while(predicate_1 == FALSE) pthread_cond_wait(&cond_var,&mutex);
		
		predicate_1 = FALSE ;
	
	pthread_mutex_unlock(&mutex);
    
	display( (char*)argument );
/*ενεργοποιουμαι*/
	pthread_mutex_lock(&mutex);
		
		predicate_2 = TRUE ;
		
		pthread_cond_signal(&cond_var);
	
	pthread_mutex_unlock(&mutex);
}

return NULL ;

}
void *disp2(void *argument){
int i ;

	for(i=0;i<10;i++)
{/* αναμονη */
	
	pthread_mutex_lock(&mutex);

while(predicate_2 == FALSE) pthread_cond_wait(&cond_var,&mutex);

	predicate_2 = FALSE ;

	pthread_mutex_unlock(&mutex);

	display( (char*)argument );

/* ενεργοποιηση*/

	pthread_mutex_lock(&mutex);

	predicate_1 = TRUE ;

	pthread_cond_signal(&cond_var);

	pthread_mutex_unlock(&mutex);
}
return NULL ;
}
int main()
{/* εδβ δηλωνουμαι τισ μεταβλητες νηματος */
	
	pthread_t thread_id1 , thread_id2;
/* αρχικοποιηση του mutex ως "ξεκλειδωμενο" */
	
		if( pthread_mutex_init(&mutex,NULL) != 0 )
{
			printf("\n mutex init faild ");
}
/* αρχηκοποιηση μεταβλητωων καταστασης*/
	
	pthread_cond_init(&cond_var,NULL);
/* εδβ δημιουργουμαι τα 2 νηματα*/

		if( pthread_create( &thread_id1 , NULL , disp1 , (void*)"ab") != 0 || pthread_create( &thread_id2 , NULL , disp2 , (void*)"cd\n") != 0  )
{
			printf("\n pthread create faild ");
}
	pthread_join(thread_id1,NULL);

	pthread_join(thread_id2,NULL);

	pthread_mutex_destroy(&mutex);
/* εδω το Mutex καταστρεφεται οταν ολοκληρωθει η λειτουργεια των νηματων*/
return 0;
}