	.file	"2.73.c"
	.text
	.p2align 4,,15
	.globl	saturating_add
	.type	saturating_add, @function
saturating_add:
.LFB0:
	.cfi_startproc
	pushl	%edi
	.cfi_def_cfa_offset 8
	.cfi_offset 7, -8
	pushl	%esi
	.cfi_def_cfa_offset 12
	.cfi_offset 6, -12
	pushl	%ebx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	16(%esp), %ebx
	movl	20(%esp), %ecx
	leal	(%ebx,%ecx), %esi
	sarl	$31, %ebx
	sarl	$31, %ecx
	movl	%ebx, %edx
	andl	%ecx, %ebx
	movl	%esi, %edi
	orl	%ecx, %edx
	sarl	$31, %edi
	notl	%edx
	andl	%edi, %edx
	notl	%edi
	movl	%edi, %ecx
	movl	%edx, %eax
	andl	%ebx, %ecx
	andl	$2147483647, %eax
	movl	%ecx, %ebx
	orl	%ecx, %edx
	andl	$-2147483648, %ebx
	notl	%edx
	orl	%ebx, %eax
	andl	%esi, %edx
	popl	%ebx
	.cfi_restore 3
	.cfi_def_cfa_offset 12
	addl	%edx, %eax
	popl	%esi
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	popl	%edi
	.cfi_restore 7
	.cfi_def_cfa_offset 4
	ret
	.cfi_endproc
.LFE0:
	.size	saturating_add, .-saturating_add
	.ident	"GCC: (GNU) 6.3.0"
	.section	.note.GNU-stack,"",@progbits
