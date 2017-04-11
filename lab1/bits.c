/* 
 * CS:APP Data Lab 
 * 
 * <Michael Wu, UID: 404751542>
 * 
 * bits.c - Source file with your solutions to the Lab.
 *          This is the file you will hand in to your instructor.
 *
 * WARNING: Do not include the <stdio.h> header; it confuses the dlc
 * compiler. You can still use printf for debugging without including
 * <stdio.h>, although you might get a compiler warning. In general,
 * it's not good practice to ignore compiler warnings, but in this
 * case it's OK.  
 */

#if 0
/*
 * Instructions to Students:
 *
 * STEP 1: Read the following instructions carefully.
 */

You will provide your solution to the Data Lab by
editing the collection of functions in this source file.

INTEGER CODING RULES:
 
  Replace the "return" statement in each function with one
  or more lines of C code that implements the function. Your code 
  must conform to the following style:
 
  int Funct(arg1, arg2, ...) {
      /* brief description of how your implementation works */
      int var1 = Expr1;
      ...
      int varM = ExprM;

      varJ = ExprJ;
      ...
      varN = ExprN;
      return ExprR;
  }

  Each "Expr" is an expression using ONLY the following:
  1. Integer constants 0 through 255 (0xFF), inclusive. You are
      not allowed to use big constants such as 0xffffffff.
  2. Function arguments and local variables (no global variables).
  3. Unary integer operations ! ~
  4. Binary integer operations & ^ | + << >>
    
  Some of the problems restrict the set of allowed operators even further.
  Each "Expr" may consist of multiple operators. You are not restricted to
  one operator per line.

  You are expressly forbidden to:
  1. Use any control constructs such as if, do, while, for, switch, etc.
  2. Define or use any macros.
  3. Define any additional functions in this file.
  4. Call any functions.
  5. Use any other operations, such as &&, ||, -, or ?:
  6. Use any form of casting.
  7. Use any data type other than int.  This implies that you
     cannot use arrays, structs, or unions.

 
  You may assume that your machine:
  1. Uses 2s complement, 32-bit representations of integers.
  2. Performs right shifts arithmetically.
  3. Has unpredictable behavior when shifting an integer by more
     than the word size.

EXAMPLES OF ACCEPTABLE CODING STYLE:
  /*
   * pow2plus1 - returns 2^x + 1, where 0 <= x <= 31
   */
  int pow2plus1(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     return (1 << x) + 1;
  }

  /*
   * pow2plus4 - returns 2^x + 4, where 0 <= x <= 31
   */
  int pow2plus4(int x) {
     /* exploit ability of shifts to compute powers of 2 */
     int result = (1 << x);
     result += 4;
     return result;
  }

FLOATING POINT CODING RULES

For the problems that require you to implent floating-point operations,
the coding rules are less strict.  You are allowed to use looping and
conditional control.  You are allowed to use both ints and unsigneds.
You can use arbitrary integer and unsigned constants.

You are expressly forbidden to:
  1. Define or use any macros.
  2. Define any additional functions in this file.
  3. Call any functions.
  4. Use any form of casting.
  5. Use any data type other than int or unsigned.  This means that you
     cannot use arrays, structs, or unions.
  6. Use any floating point data types, operations, or constants.


NOTES:
  1. Use the dlc (data lab checker) compiler (described in the handout) to 
     check the legality of your solutions.
  2. Each function has a maximum number of operators (! ~ & ^ | + << >>)
     that you are allowed to use for your implementation of the function. 
     The max operator count is checked by dlc. Note that '=' is not 
     counted; you may use as many of these as you want without penalty.
  3. Use the btest test harness to check your functions for correctness.
  4. Use the BDD checker to formally verify your functions
  5. The maximum number of ops for each function is given in the
     header comment for each function. If there are any inconsistencies 
     between the maximum ops in the writeup and in this file, consider
     this file the authoritative source.

/*
 * STEP 2: Modify the following functions according the coding rules.
 * 
 *   IMPORTANT. TO AVOID GRADING SURPRISES:
 *   1. Use the dlc compiler to check that your solutions conform
 *      to the coding rules.
 *   2. Use the BDD checker to formally verify that your solutions produce 
 *      the correct answers.
 */


#endif
/* 
 * bang - Compute !x without using !
 *   Examples: bang(3) = 0, bang(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4 
 */
int bang(int x) {
  /*If x is not zero, then either x or its complement must be negative. So
    using bitwise or on a nonzero number and its complement ~x+1 will result in a 1
    in the leading digit. Then I shift this right by 31 to move the sign bit to
    the first bit and complement it so that all nonzero numbers map to zero. Zero
    will map to a string of 32 ones, which I mask with 1 to return 1. So this
    returns 1 if x is zero, 0 otherwise. This is the behaviour of !.
   */
  return ~((x|(~x+1))>>31)&1;
}

/*
 * bitCount - returns count of number of 1's in word
 * Examples: bitCount(5) = 2, bitCount(7) = 3
 * Legal ops: ! ~ & ^ | + << >>
 * Max ops: 40
 * Rating: 4
 */
int bitCount(int x) {
  /*This code creates 5 masks, in order they are 0x55555555, 0x33333333,
    0x0F0F0F0F, 0x00FF00FF, and 0x0000FFFF. Then it uses the 0x55555555 mask,
    which is an alternating string of zeros and ones, to add each digit to the
    one to the right of it. This generates a string of numbers every two bits,
    whose sums represents the number of ones in x. Then each two bit number is
    added to the two bit number to the right with the second mask, and so on
    with four bits and the third mask, eight bits and the fourth mask, and
    finally sixteen bits and the fifth mask. Then that leaves one number that
    occupies all 32 bits that represents the total number of ones in the
    original number x.
   */
  int mask1 = 0x55;
  int mask2 = 0x33;
  int mask3 = 0x0F;
  int mask4 = 0xFF;
  int mask5 = 0xFF;
  mask1|=mask1<<8;
  mask1|=mask1<<16;
  mask2|=mask2<<8;
  mask2|=mask2<<16;
  mask3|=mask3<<8;
  mask3|=mask3<<16;
  mask4|=mask4<<16;
  mask5|=mask5<<8;

  x=(x&mask1)+((x>>1)&mask1);
  x=(x&mask2)+((x>>2)&mask2);
  x=(x&mask3)+((x>>4)&mask3);
  x=(x&mask4)+((x>>8)&mask4);
  x=(x&mask5)+((x>>16)&mask5);
  
  return x;
}
/* 
 * bitOr - x|y using only ~ and & 
 *   Example: bitOr(6, 5) = 7
 *   Legal ops: ~ &
 *   Max ops: 8
 *   Rating: 1
 */
int bitOr(int x, int y) {
  /*This uses demorgans law and the fact that (x or y) = (not x) nand (not y) */
  return ~(~x&~y);
}
/*
 * bitRepeat - repeat x's low-order n bits until word is full.
 *   Can assume that 1 <= n <= 32.
 *   Examples: bitRepeat(1, 1) = -1
 *             bitRepeat(7, 4) = 0x77777777
 *             bitRepeat(0x13f, 8) = 0x3f3f3f3f
 *             bitRepeat(0xfffe02, 9) = 0x10080402
 *             bitRepeat(-559038737, 31) = -559038737
 *             bitRepeat(-559038737, 32) = -559038737
 *   Legal ops: int and unsigned ! ~ & ^ | + - * / % << >>
 *             (This is more general than the usual integer coding rules.)
 *   Max ops: 40
 *   Rating: 4
 */
int bitRepeat(int x, int n) {
  /*This casts x as an unsigned integer a and uses logical shift to make the
    first 32-n bits from the left zero, leaving n bits on the right. Then it
    uses shifts to fill in the spaces to the left of the first n bits. To ensure
    that each shift is defined, I made sure to shift by n multiple times rather
    than shifting by 2*n, 4*n, 8*n, and 16*n.
   */
  unsigned int a = x;
  int emptybits = 32-n;
  x=(a<<emptybits)>>emptybits;
  x=x|x<<n;
  x=x|x<<n<<n;
  x=x|x<<n<<n<<n<<n;
  x=x|x<<n<<n<<n<<n<<n<<n<<n<<n;
  x=x|x<<n<<n<<n<<n<<n<<n<<n<<n<<n<<n<<n<<n<<n<<n<<n<<n;
  return x;
}
/* 
 * fitsBits - return 1 if x can be represented as an 
 *  n-bit, two's complement integer.
 *   1 <= n <= 32
 *   Examples: fitsBits(5,3) = 0, fitsBits(-4,3) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 2
 */
int fitsBits(int x, int n) {
  /*If x can fit in n bits, then x will consist of 32-(n-1) leading digits of either
    all ones or all zeros. My implementation shifts x to the right by
    (n-1). Then if x is all ones or all zeros, it can be represented in n bits,
    so the function returns 1. For everything else it returns zero.
   */
  x=x>>(n+~0);
  return !x|!~x;
}
/* 
 * getByte - Extract byte n from word x
 *   Bytes numbered from 0 (LSB) to 3 (MSB)
 *   Examples: getByte(0x12345678,1) = 0x56
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2
 */
int getByte(int x, int n) {
  /*This shifts x to the right by n*8 bits then uses a mask to extract the
    rightmost two bits, which is the bit we want.
  */
  return (x>>(n<<3))&0xFF;
}
/* 
 * isLessOrEqual - if x <= y  then return 1, else return 0 
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y) {
  /*My implementation first checks if the signs of x and y are different. It
    does this by using sign extension so that xPosYNeg is all ones if x is
    positive and y is negative, and zero otherwise. The similar concept applies
    for yPosXNeg. I also calculate the difference between y and x by using the
    fact that -x=~x+1. I will only use this if the signs of x and y match to
    prevent overflow. In my return statement I use a mask for the first
    bit. Then I ensure that I always return zero if x is positive and y is
    negative and always return one if y is positive and x is negative. In the
    case that both signs match, I look at the value of the difference y-x. This
    cannot overflow because the signs of x and y are the same. If this is
    positive or zero then we want to return 1, so we right shift by 31 to get
    the leading bit and complement it with ~(difference>>31).
   */
  int xPosYNeg = ~(x>>31)&(y>>31);
  int yPosXNeg = (x>>31)&~(y>>31);
  int difference = y+~x+1;
  return 1&~xPosYNeg&(yPosXNeg|~(difference>>31));
}
/* 
 * isPositive - return 1 if x > 0, return 0 otherwise 
 *   Example: isPositive(-1) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 8
 *   Rating: 3
 */
int isPositive(int x) {
  /*This uses the fact that positive numbers and zero lead with 0. So shifting x
    to the right by 31 and complementing it results in a string of ones when the
    leading digit is zero. Using !(!x) creates a mask for the first digit that
    is 1 when x is not zero, and zero when x is zero. So this gives us 1 only
    when x is positive.
   */
  return ~(x>>31)&!(!x);
}
/* 
 * logicalShift - shift x to the right by n, using a logical shift
 *   Can assume that 0 <= n <= 31
 *   Examples: logicalShift(0x87654321,4) = 0x08765432
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3 
 */
int logicalShift(int x, int n) {
  /*This left shifts 1 so that the ones digit occupies the (31-n)th bit position,
    then copies that one to the right to create a mask that preserves everything
    up and including the (31-n)th bit of (x>>n). This sets any ones added on the
    left when arithmetically shifting to zero, which is the same as a logical shift.
   */
  int mask = 0x1<<(32+~n);
  mask = mask|mask>>1;
  mask = mask|mask>>2;
  mask = mask|mask>>4;
  mask = mask|mask>>8;
  mask = mask|mask>>16;
  return (x>>n)&mask;
}
/* 
 * tmin - return minimum two's complement integer 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
  /*This uses the fact that tmin = 0x80000000, which is obtained by shifting 1
    to the left 31 times.
   */
  return 1<<31;
}
