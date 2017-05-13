static float u2f(unsigned u)
{
  return *(float*)(&u);
}
float fpwr4(int x)
{
  unsigned exp, frac;
  unsigned u;

  if (x < -74){
    /* Too small. Return 0.0 */
    exp = 0;
    frac = 0;
  } else if (x < -63){
    /* Denormalized result */
    exp = 0;
    frac = 1<<(2*x+149);
  } else if (x < 64){
    /* Normalized result. */
    exp = 2*x+127;
    frac = 0;
  } else {
    /* Too big. Return +oo */
    exp = 255;
    frac = 0;
  }

  /* Pack exp and frac int 32 bits */
  u = exp << 23 | frac;
  /* Return as float */
  return u2f(u);
}
