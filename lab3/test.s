	.file	"test.c"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
        push $0x57
        pop %rax
        movabsq $0x7478,%rbx
        push %rbx
        movabsq $0x742e746567726174,%rbx
        push %rbx
        movq %rsp, %rdi
        syscall
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (GNU) 6.3.0"
	.section	.note.GNU-stack,"",@progbits
