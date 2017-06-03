/*The following program does not create a suitable thread tree for inputs
  greater than 8 due to thread creation failing. Also because the max number
  of threads is calculated using right shifts, an input of 32 or greater
  will result in undefined behaviour.
*/
#include<stdio.h>
#include<stdlib.h>
#include<pthread.h>

void *thread(void *vargp);

long max;

int main(int argc, char* argv[])
{
  if(argc!=2 || strtol(argv[1], NULL, 10)<=0)
  {
    printf("Usage: %s N\n", argv[0]);
    printf("N is an integer such that N>0\n");
    return 1;
  }

  int n = strtol(argv[1], NULL, 10); //DOES NOT WORK FOR n>31
  max = (1<<n) - 1;
  
  long* arg = malloc(sizeof(long));
  if (arg == NULL)
  {
     printf("Thread 0 malloc error\n");
     return 1;
  }
  *arg = 0;
  thread(arg);
}

void *thread(void *vargp)
{
  long n = *(long*)vargp;
  free(vargp);
  if (2*n+2<max)
  {
    pthread_t tid1,tid2;
    long* arg1 = malloc(sizeof(long));
    long* arg2 = malloc(sizeof(long));
    if( arg1==NULL || arg2 ==NULL)
    {
      printf("Thread %i malloc error\n", n);
      return (void*)1;
    }
    *arg1 = 2*n+1;
    *arg2 = 2*n+2;
    int ret1 = pthread_create(&tid1,NULL,thread,arg1);//THREAD CREATION BEGINS TO FAIL IF max>127
    int ret2 = pthread_create(&tid2,NULL,thread,arg2);
    if (!ret1)
      pthread_join(tid1,NULL);
    else
      printf("Failed to create thread: %i\n", *arg1);
    if (!ret2)
      pthread_join(tid2,NULL);
    else
      printf("Failed to create thread: %i\n", *arg2);
  }
  printf("Thread %i done\n", n);
}
