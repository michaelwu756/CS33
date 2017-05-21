	.file	"test.c"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC0:
	.string	"/bin/rm"
.LC1:
	.string	"target.txt"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	subq	$24, %rsp
	.cfi_def_cfa_offset 32
	xorl	%edx, %edx
	movabsq	$0x7fffffffd040, %rdi
	movq	%rsp, %rsi
	movabsq	$0x7fffffffd040, %rax
	movq	%rax, (%rsp)
	movabsq  $0x7fffffffd048, %rax
	movq	%rax, 8(%rsp)
	movq	$0, 16(%rsp)
	movq	$0x4025b0, %rax
	call	*%rax
	xorl	%eax, %eax
	addq	$24, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 6.3.0"
	.section	.note.GNU-stack,"",@progbits
