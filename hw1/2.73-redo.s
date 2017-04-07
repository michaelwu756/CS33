	.file	"2.73-redo.c"
	.text
	.p2align 4,,15
	.globl	saturating_add
	.type	saturating_add, @function
saturating_add:
.LFB0:
	.cfi_startproc
	movl	8(%esp), %edx
	movl	%edx, %ecx
	xorl	%edx, %edx
	addl	4(%esp), %ecx
	movl	%ecx, %eax
	seto	%dl
	sarl	$31, %eax
	negl	%edx
	addl	$-2147483648, %eax
	andl	%edx, %eax
	notl	%edx
	andl	%ecx, %edx
	addl	%edx, %eax
	ret
	.cfi_endproc
.LFE0:
	.size	saturating_add, .-saturating_add
	.ident	"GCC: (GNU) 6.3.0"
	.section	.note.GNU-stack,"",@progbits
