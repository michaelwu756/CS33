#include<unistd.h>
int main()
{
  char* const  argv[2]={"/bin/rm", "target.txt"};
  execve("/bin/rm",argv,NULL);
}
