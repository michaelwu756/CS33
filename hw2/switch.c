long switch_prob(long x, long n)
{
  long result = x;
  switch(n)
  {
    case 60:
      result = 8*x;
      break;
    case 61:
      result = x+75;
      break;
    case 62:
      result = 8*x;
      break;
    case 63:
      result = x>>3;
      break;
    case 64:
      x = (x<<4)-x;
    case 65:
      x*=x;
    default:
      result = x+75;
  }
  return result;
}
