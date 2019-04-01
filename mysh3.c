
/*
ONOMAMATEPONUMO: ALEKSIOU SOTIRIOS
AM : 5712
ETOS SPOUDWN : 4o
Computer Engineering Institute Dipartment
*/


#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdio.h>

char *line_reader(void);
char **p_terminal(char *);
char **p_pipes(char *,int *);
void exe(char **,int);



char *line_reader(void)
{	
	char *line = NULL;
	ssize_t bufsize = 0;
	getline(&line,&bufsize,stdin);
	return line;
}
/* LEITOURGIA TIS sttok:
   Η λειτουργία strtok χρησιμοποιείται για να βρεί το επόμενο σημείο σε μια σειρά. Το σημείο διευκρινίζεται από έναν κατάλογο πιθανών οριοθετών.
*/   
   
char **p_terminal(char *terminal_input)
{
	int length = 0;
	char **array_of_words;
	char *word;

	int size_alloc = 16;	
	array_of_words = malloc(size_alloc * sizeof(char*));
  
	word = strtok(terminal_input, " \n\t\r");
  
	while (word != NULL) 
	{
		array_of_words[length] = word;
		length++;

		if (length >= size_alloc) 
		{
			size_alloc += 16;
			array_of_words = realloc(array_of_words, size_alloc * sizeof(char*));
		}
		word = strtok(NULL," \n\t\r");
	}
	array_of_words[length] = NULL;
	return array_of_words;
}


char **p_pipes(char *terminal_input , int *pipes_counter)
{
	int length = 0;
	char **array_of_words ;
	char *word;

	int size_alloc = 16;	
	array_of_words = malloc(size_alloc * sizeof(char*));
  
	word = strtok(terminal_input, "|\n");
  
	while (word != NULL) 
	{
		array_of_words[length] = word;
		
		if(length > 0)
		{
			(*pipes_counter)++;
		}
		
		length++;

		if (length >= size_alloc) 
		{
			size_alloc += 16;
			array_of_words = realloc(array_of_words, size_alloc * sizeof(char*));
		}
		word = strtok(NULL,"|\n");
	}
	array_of_words[length] = NULL;
	return array_of_words;
}
/* LEITOURGIA TIS fork():
   επιτρέπει σε μία διεργασία να δημιουργήσει δυναμικά άλλες διεργασίες. Η κλήση αυτή δημιουργεί ένα αντίτυπο της διεργασίας που την καλεί το παιδί οπως αποκαλειται.
   Αφοτ δημιουργηθει το καινουριο παιδι και οι δυο διεργασιες θα εκτελεσουν το επομενο βημα ποθ ακολουθει το system_call */
    
void exe(char **terminal,int pipes_counter){
	
	if(terminal[0] == NULL)return ;

	if(pipes_counter==0)
		/* εδω δεν εχουμε pipes απλα μια γραμμη εντολων */
	{
		char **terminal1 = p_terminal( terminal[0] );
		if(!strcmp("exit",terminal1[0])) exit(1);
		
		int pid;
		if(!strcmp("cd",terminal1[0]))
		{
			chdir(terminal1[1]);
		}else
		{
			pid = fork();
			if(pid == 0)
			{
				execvp(terminal1[0],terminal1);
				exit(1);
			}else if(pid > 0)
			{
				wait();
			}
		}
		/* LEITOURGIA TWN PIPES : 
		τα Pipes είναι ουσιαστικα μια κλήση συστήματος που δημιουργεί μια μονόδρομη σύνδεση επικοινωνίας μεταξύ
δύο περιγραφείς αρχείων. Η κλήση συστήματος pipes Καθοριζεται με ένα δείκτη σε μια σειρά
δύο ακεραίων. Κατά την επιστροφή, το πρώτο στοιχείο του πίνακα περιέχει το περιγραφέα αρχείου
που αντιστοιχεί στην έξοδο του pipe . Το δεύτερο στοιχείο
της συστοιχίας περιέχει το περιγραφέα αρχείου που αντιστοιχεί στην είσοδο του pipe
(Το μέρος όπου μπορείτε να γράψετε πράγματα). Ό, τι bytes αποστέλλονται στην είσοδο του pipe
μπορούν να διαβαστούν από το άλλο άκρο του pipe. */
		
	}else{
        int input = 0 ; 
		int fd[2];
		
		int i;
		for(i=0;i<=pipes_counter;i++)
		{
			pipe(fd);
			char **terminal_arg = p_terminal( terminal[i] );
			pid_t pid;
			
			if(( pid = fork() ) == 0)
			{
				if(input != 0)
				{
					dup2(input,0);
					close(input);
				}
				if(fd[1] != 1 && i !=pipes_counter)
				{
					dup2(fd[1],1);
					close(fd[1]);
				}
		
				execvp(terminal_arg[0],terminal_arg);
				exit(1);
			}else wait();
			
			close(fd[1]);
			
			input = fd[0];
		}	
	}
}

int main()
{
	char *line_input;
	char **pipe_arguments;
	
	while(1)
	{
		int pipes_counter = 0;
		
		printf("$");
		line_input = line_reader();
		pipe_arguments = p_pipes(line_input,&pipes_counter);
		exe(pipe_arguments,pipes_counter);
		free(pipe_arguments);
		free(line_input);
	}
}
/*
bibliografia kai xrisima sites pou xrisimopoiisa gia tin ulopoiisi tis aksisis: 
https://www.tutorialspoint.com/index.htm
https://www.youtube.com/watch?v=1YuTAOsfFIE
http://ryanstutorials.net/linuxtutorial/piping.php
http://www.yolinux.com/TUTORIALS/ForkExecProcesses.html
http://www.gnu.org/software/libc/manual/html_node/Implementing-a-Shell.html#Implementing-a-Shell
*/


                                                                                /*