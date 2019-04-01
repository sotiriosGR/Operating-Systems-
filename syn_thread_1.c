/*MAME : SOTIRIOS ALEXIOU*/
/*AM : 5712*/
/*ETOS SPOUDWN : 4o*/

#include "display.h"
#include <unistd.h>
#include <pthread.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <stdio.h>

/* edv shlvnoymai to mutex */
	
	pthread_mutex_t mutex ;

/*εδω οταν θα δημιουργειται ενα νημα θα καλειται η function */

void *disp(void *argument){
	
	int i ;

		for(i=0;i<10;i++)
{ /* εδω το Mutex κλειδωνει */

	pthread_mutex_lock(&mutex);

	display( (char*)argument );
/* εδω το mutex ξεκλειδωνει*/

	pthread_mutex_unlock(&mutex);
}

return NULL ;

}

int main()
{ /* εδω δηλωνουμαι τισ μεταβλητες του νηματος */
	
	pthread_t thread_id1 , thread_id2;

/* εδω γινεται η αρχικοποιηση του mutex ως ξεκλειδωμενο" */
	
	if( pthread_mutex_init(&mutex,NULL) != 0 )
	
	{
		printf("\n mutex init faild ");
	}

/* εδω δημιουργουνται τα 2 νηματα*/
	
	if( pthread_create( &thread_id1 , NULL , disp , (void*)"Hello world\n") != 0 || pthread_create( &thread_id2 , NULL , disp , (void*)"Kalimera kosme\n") != 0  )

	{

		printf("\n pthread create faild ");
	}

	pthread_join(thread_id1,NULL);

pthread_join(thread_id2,NULL);
/* το mutex καταστραφηκε οταν ολοκληρωθηκε η λειτουργεια του νηματος*/
	
	pthread_mutex_destroy(&mutex);

return 0;
}