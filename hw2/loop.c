/*
loop:
  movl  %esi, %ecx //ecx = n
  movl  $1, %edx //mask = 1
  movl  $0, %eax //result = 0
  jmp   .L2
.L3:
  movq  %rdi, %r8 //r8 = x
  andq  %rdx, %r8 //r8 = x & mask
  orq   %r8, %rax //result | = r8
  salq  %cl, %rdx //mask<<=n
.L2:
  testq %rdx, %rdx
  jne   .L3 //jump if mask !=0
  ret
*/

long loop(long x, int n)
{
  long result = 0;
  long mask;
  for (mask = 1; mask !=0; mask <<=n){
    result |= x&mask;
  }
  return result;
}

/*
A)
%rdi holds x
%esi and %ecx holds n
%rax holds result
%rdx holds mask

B)
result is initially 0
mask is initially 1

C)
the test condition for mask is mask !=0

D)
mask gets updated with
salq %cl, %rdx
which performs mask<<=n

E)
result gets updated with result |= x&mask;

F)
see code above
*/
