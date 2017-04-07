#include<limits.h>
int saturating_add(int x, int y)
{
  int result=x+y;
  int w=(int)(sizeof(int)<<3);
  int xSig = x>>(w-1);//most significant bits extended
  int ySig = y>>(w-1);
  int rSig = result>>(w-1);
  int posOverflow = (~xSig&~ySig&rSig);//mask for positive overflow
  int negOverflow = (xSig&ySig&~rSig);//mask for negative overflow
  return (posOverflow&INT_MAX)+(negOverflow&INT_MIN)+(result&~negOverflow&~posOverflow);
}
