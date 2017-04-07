#include<limits.h>
int saturating_add(int x, int y)
{
  int result=0;
  int overflow = __builtin_add_overflow(x,y,&result);
  int w=(int)(sizeof(int)<<3);
  overflow=((overflow<<w-1)>>w-1);
  int rSig = result>>w-1;
  return (overflow&(rSig^INT_MIN))+(result&~overflow);
}
