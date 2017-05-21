	.file	"thttpd.c"
	.text
	.p2align 4,,15
	.type	handle_hup, @function
handle_hup:
.LFB4:
	.cfi_startproc
	movl	$1, got_hup(%rip)
	ret
	.cfi_endproc
.LFE4:
	.size	handle_hup, .-handle_hup
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"  thttpd - %ld connections (%g/sec), %d max simultaneous, %lld bytes (%g/sec), %d httpd_conns allocated"
	.text
	.p2align 4,,15
	.type	thttpd_logstats, @function
thttpd_logstats:
.LFB35:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	testq	%rdi, %rdi
	jle	.L3
	movq	stats_bytes(%rip), %r8
	pxor	%xmm2, %xmm2
	movq	stats_connections(%rip), %rdx
	pxor	%xmm1, %xmm1
	pxor	%xmm0, %xmm0
	movl	httpd_conn_count(%rip), %r9d
	cvtsi2ssq	%rdi, %xmm2
	movl	stats_simultaneous(%rip), %ecx
	movl	$.LC0, %esi
	movl	$6, %edi
	cvtsi2ssq	%r8, %xmm1
	movl	$2, %eax
	cvtsi2ssq	%rdx, %xmm0
	divss	%xmm2, %xmm1
	divss	%xmm2, %xmm0
	cvtss2sd	%xmm1, %xmm1
	cvtss2sd	%xmm0, %xmm0
	call	syslog
.L3:
	movq	$0, stats_connections(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE35:
	.size	thttpd_logstats, .-thttpd_logstats
	.section	.rodata.str1.8
	.align 8
.LC1:
	.string	"throttle #%d '%.80s' rate %ld greatly exceeding limit %ld; %d sending"
	.align 8
.LC2:
	.string	"throttle #%d '%.80s' rate %ld exceeding limit %ld; %d sending"
	.align 8
.LC3:
	.string	"throttle #%d '%.80s' rate %ld lower than minimum %ld; %d sending"
	.text
	.p2align 4,,15
	.type	update_throttles, @function
update_throttles:
.LFB25:
	.cfi_startproc
	movl	numthrottles(%rip), %edi
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	movabsq	$6148914691236517206, %r12
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	xorl	%ebx, %ebx
	testl	%edi, %edi
	jg	.L68
	jmp	.L16
	.p2align 4,,10
	.p2align 3
.L14:
	movl	numthrottles(%rip), %edi
.L11:
	addl	$1, %ebx
	addq	$48, %rbp
	cmpl	%edi, %ebx
	jge	.L16
.L68:
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	movq	32(%rcx), %rdx
	movq	24(%rcx), %rsi
	movq	8(%rcx), %r9
	movq	$0, 32(%rcx)
	movq	%rdx, %rax
	shrq	$63, %rax
	addq	%rdx, %rax
	sarq	%rax
	leaq	(%rax,%rsi,2), %rsi
	movq	%rsi, %rax
	sarq	$63, %rsi
	imulq	%r12
	subq	%rsi, %rdx
	cmpq	%r9, %rdx
	movq	%rdx, %r8
	movq	%rdx, 24(%rcx)
	jle	.L10
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L11
	leaq	(%r9,%r9), %rdx
	cmpq	%rdx, %r8
	jle	.L12
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$.LC1, %esi
	movl	$5, %edi
.L93:
	xorl	%eax, %eax
	call	syslog
	movq	%rbp, %rcx
	addq	throttles(%rip), %rcx
	popq	%rsi
	.cfi_def_cfa_offset 40
	popq	%rdi
	.cfi_def_cfa_offset 32
	movq	24(%rcx), %r8
.L10:
	movq	16(%rcx), %r9
	cmpq	%r8, %r9
	jle	.L14
	movl	40(%rcx), %eax
	testl	%eax, %eax
	je	.L14
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$5, %edi
	xorl	%eax, %eax
	movl	$.LC3, %esi
	addl	$1, %ebx
	addq	$48, %rbp
	call	syslog
	movl	numthrottles(%rip), %edi
	popq	%rax
	.cfi_def_cfa_offset 40
	popq	%rdx
	.cfi_def_cfa_offset 32
	cmpl	%edi, %ebx
	jl	.L68
	.p2align 4,,10
	.p2align 3
.L16:
	movl	max_connects(%rip), %eax
	testl	%eax, %eax
	jle	.L6
	subl	$1, %eax
	movq	connects(%rip), %rcx
	movq	throttles(%rip), %rdi
	leaq	9(%rax,%rax,8), %r8
	movq	$-1, %r9
	salq	$4, %r8
	addq	%rcx, %r8
	jmp	.L27
	.p2align 4,,10
	.p2align 3
.L17:
	addq	$144, %rcx
	cmpq	%r8, %rcx
	je	.L6
.L27:
	movl	(%rcx), %eax
	subl	$2, %eax
	cmpl	$1, %eax
	ja	.L17
	movl	56(%rcx), %esi
	movq	%r9, 64(%rcx)
	testl	%esi, %esi
	jle	.L17
	movslq	16(%rcx), %rax
	leaq	(%rax,%rax,2), %rax
	salq	$4, %rax
	addq	%rdi, %rax
	movslq	40(%rax), %r10
	movq	8(%rax), %rax
	cqto
	idivq	%r10
	cmpl	$1, %esi
	movq	%rax, %rbx
	movq	%rax, 64(%rcx)
	je	.L17
	movslq	20(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movslq	40(%r10), %r11
	movq	8(%r10), %rax
	cqto
	idivq	%r11
	cmpq	$-1, %rbx
	movq	%rax, %r11
	je	.L18
	cmpq	%rbx, %rax
	cmovg	%rbx, %r11
.L18:
	cmpl	$2, %esi
	movq	%r11, 64(%rcx)
	je	.L17
	movslq	24(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movslq	40(%r10), %rbx
	movq	8(%r10), %rax
	cqto
	idivq	%rbx
	cmpq	$-1, %r11
	movq	%rax, %rbx
	je	.L19
	cmpq	%r11, %rax
	cmovg	%r11, %rbx
.L19:
	cmpl	$3, %esi
	movq	%rbx, 64(%rcx)
	je	.L17
	movslq	28(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movslq	40(%r10), %r11
	movq	8(%r10), %rax
	cqto
	idivq	%r11
	cmpq	$-1, %rbx
	movq	%rax, %r11
	je	.L20
	cmpq	%rbx, %rax
	cmovg	%rbx, %r11
.L20:
	cmpl	$4, %esi
	movq	%r11, 64(%rcx)
	je	.L17
	movslq	32(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movslq	40(%r10), %rbx
	movq	8(%r10), %rax
	cqto
	idivq	%rbx
	cmpq	$-1, %r11
	movq	%rax, %rbx
	je	.L21
	cmpq	%r11, %rax
	cmovg	%r11, %rbx
.L21:
	cmpl	$5, %esi
	movq	%rbx, 64(%rcx)
	je	.L17
	movslq	36(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movslq	40(%r10), %r11
	movq	8(%r10), %rax
	cqto
	idivq	%r11
	cmpq	$-1, %rbx
	movq	%rax, %r11
	je	.L22
	cmpq	%rbx, %rax
	cmovg	%rbx, %r11
.L22:
	cmpl	$6, %esi
	movq	%r11, 64(%rcx)
	je	.L17
	movslq	40(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movslq	40(%r10), %rbx
	movq	8(%r10), %rax
	cqto
	idivq	%rbx
	cmpq	$-1, %r11
	movq	%rax, %rbx
	je	.L23
	cmpq	%r11, %rax
	cmovg	%r11, %rbx
.L23:
	cmpl	$7, %esi
	movq	%rbx, 64(%rcx)
	je	.L17
	movslq	44(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movslq	40(%r10), %r11
	movq	8(%r10), %rax
	cqto
	idivq	%r11
	cmpq	$-1, %rbx
	movq	%rax, %r11
	je	.L24
	cmpq	%rbx, %rax
	cmovg	%rbx, %r11
.L24:
	cmpl	$8, %esi
	movq	%r11, 64(%rcx)
	je	.L17
	movslq	48(%rcx), %rax
	leaq	(%rax,%rax,2), %r10
	salq	$4, %r10
	addq	%rdi, %r10
	movq	8(%r10), %rax
	movslq	40(%r10), %rbx
	cqto
	idivq	%rbx
	cmpq	$-1, %r11
	movq	%rax, %r10
	je	.L25
	cmpq	%r11, %rax
	cmovg	%r11, %r10
.L25:
	cmpl	$9, %esi
	movq	%r10, 64(%rcx)
	je	.L17
	movslq	52(%rcx), %rax
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	addq	%rdi, %rsi
	movq	8(%rsi), %rax
	movslq	40(%rsi), %r11
	cqto
	idivq	%r11
	cmpq	$-1, %r10
	je	.L26
	cmpq	%r10, %rax
	cmovg	%r10, %rax
.L26:
	movq	%rax, 64(%rcx)
	addq	$144, %rcx
	cmpq	%r8, %rcx
	jne	.L27
.L6:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L12:
	.cfi_restore_state
	subq	$8, %rsp
	.cfi_def_cfa_offset 40
	movq	(%rcx), %rcx
	movl	%ebx, %edx
	pushq	%rax
	.cfi_def_cfa_offset 48
	movl	$.LC2, %esi
	movl	$6, %edi
	jmp	.L93
	.cfi_endproc
.LFE25:
	.size	update_throttles, .-update_throttles
	.section	.rodata.str1.8
	.align 8
.LC4:
	.string	"%s: no value required for %s option\n"
	.text
	.p2align 4,,15
	.type	no_value_required, @function
no_value_required:
.LFB14:
	.cfi_startproc
	testq	%rsi, %rsi
	jne	.L99
	rep ret
.L99:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC4, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE14:
	.size	no_value_required, .-no_value_required
	.section	.rodata.str1.8
	.align 8
.LC5:
	.string	"%s: value required for %s option\n"
	.text
	.p2align 4,,15
	.type	value_required, @function
value_required:
.LFB13:
	.cfi_startproc
	testq	%rsi, %rsi
	je	.L105
	rep ret
.L105:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rdi, %rcx
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC5, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE13:
	.size	value_required, .-value_required
	.section	.rodata.str1.8
	.align 8
.LC6:
	.string	"usage:  %s [-C configfile] [-p port] [-d dir] [-r|-nor] [-dd data_dir] [-s|-nos] [-v|-nov] [-g|-nog] [-u user] [-c cgipat] [-t throttles] [-h host] [-l logfile] [-i pidfile] [-T charset] [-P P3P] [-M maxage] [-V] [-D]\n"
	.section	.text.unlikely,"ax",@progbits
	.type	usage, @function
usage:
.LFB11:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC6, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE11:
	.size	usage, .-usage
	.text
	.p2align 4,,15
	.type	wakeup_connection, @function
wakeup_connection:
.LFB30:
	.cfi_startproc
	cmpl	$3, (%rdi)
	movq	$0, 96(%rdi)
	je	.L110
	rep ret
	.p2align 4,,10
	.p2align 3
.L110:
	movq	8(%rdi), %rax
	movl	$2, (%rdi)
	movq	%rdi, %rsi
	movl	$1, %edx
	movl	704(%rax), %eax
	movl	%eax, %edi
	jmp	fdwatch_add_fd
	.cfi_endproc
.LFE30:
	.size	wakeup_connection, .-wakeup_connection
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"up %ld seconds, stats for %ld seconds:"
	.text
	.p2align 4,,15
	.type	logstats, @function
logstats:
.LFB34:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	testq	%rdi, %rdi
	je	.L115
.L112:
	movq	(%rdi), %rax
	movl	$1, %ecx
	movl	$.LC7, %esi
	movl	$6, %edi
	movq	%rax, %rdx
	movq	%rax, %rbx
	subq	start_time(%rip), %rdx
	subq	stats_time(%rip), %rbx
	movq	%rax, stats_time(%rip)
	cmove	%rcx, %rbx
	xorl	%eax, %eax
	movq	%rbx, %rcx
	call	syslog
	movq	%rbx, %rdi
	call	thttpd_logstats
	movq	%rbx, %rdi
	call	httpd_logstats
	movq	%rbx, %rdi
	call	mmc_logstats
	movq	%rbx, %rdi
	call	fdwatch_logstats
	movq	%rbx, %rdi
	call	tmr_logstats
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L115:
	.cfi_restore_state
	movq	%rsp, %rdi
	xorl	%esi, %esi
	call	gettimeofday
	movq	%rsp, %rdi
	jmp	.L112
	.cfi_endproc
.LFE34:
	.size	logstats, .-logstats
	.p2align 4,,15
	.type	show_stats, @function
show_stats:
.LFB33:
	.cfi_startproc
	movq	%rsi, %rdi
	jmp	logstats
	.cfi_endproc
.LFE33:
	.size	show_stats, .-show_stats
	.p2align 4,,15
	.type	handle_usr2, @function
handle_usr2:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movl	(%rax), %ebp
	movq	%rax, %rbx
	xorl	%edi, %edi
	call	logstats
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE6:
	.size	handle_usr2, .-handle_usr2
	.p2align 4,,15
	.type	occasional, @function
occasional:
.LFB32:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rsi, %rdi
	call	mmc_cleanup
	call	tmr_cleanup
	movl	$1, watchdog_flag(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE32:
	.size	occasional, .-occasional
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC8:
	.string	"/tmp"
	.text
	.p2align 4,,15
	.type	handle_alrm, @function
handle_alrm:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	__errno_location
	movq	%rax, %rbx
	movl	(%rax), %ebp
	movl	watchdog_flag(%rip), %eax
	testl	%eax, %eax
	je	.L124
	movl	$360, %edi
	movl	$0, watchdog_flag(%rip)
	call	alarm
	movl	%ebp, (%rbx)
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L124:
	.cfi_restore_state
	movl	$.LC8, %edi
	call	chdir
	call	abort
	.cfi_endproc
.LFE7:
	.size	handle_alrm, .-handle_alrm
	.section	.rodata.str1.1
.LC9:
	.string	"child wait - %m"
	.text
	.p2align 4,,15
	.type	handle_chld, @function
handle_chld:
.LFB3:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	call	__errno_location
	movl	(%rax), %r12d
	movq	%rax, %rbx
	.p2align 4,,10
	.p2align 3
.L126:
	leaq	12(%rsp), %rsi
	movl	$1, %edx
	movl	$-1, %edi
	call	waitpid
	testl	%eax, %eax
	je	.L127
	js	.L142
	movq	hs(%rip), %rdx
	testq	%rdx, %rdx
	je	.L126
	movl	36(%rdx), %eax
	subl	$1, %eax
	cmovs	%ebp, %eax
	movl	%eax, 36(%rdx)
	jmp	.L126
	.p2align 4,,10
	.p2align 3
.L142:
	movl	(%rbx), %eax
	cmpl	$4, %eax
	je	.L126
	cmpl	$11, %eax
	je	.L126
	cmpl	$10, %eax
	je	.L127
	movl	$.LC9, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L127:
	movl	%r12d, (%rbx)
	addq	$16, %rsp
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE3:
	.size	handle_chld, .-handle_chld
	.section	.rodata.str1.8
	.align 8
.LC10:
	.string	"out of memory copying a string"
	.align 8
.LC11:
	.string	"%s: out of memory copying a string\n"
	.text
	.p2align 4,,15
	.type	e_strdup, @function
e_strdup:
.LFB15:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	strdup
	testq	%rax, %rax
	je	.L146
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 8
	ret
.L146:
	.cfi_restore_state
	movl	$.LC10, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC11, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE15:
	.size	e_strdup, .-e_strdup
	.section	.rodata.str1.1
.LC12:
	.string	"r"
.LC13:
	.string	" \t\n\r"
.LC14:
	.string	"debug"
.LC15:
	.string	"port"
.LC16:
	.string	"dir"
.LC17:
	.string	"chroot"
.LC18:
	.string	"nochroot"
.LC19:
	.string	"data_dir"
.LC20:
	.string	"symlink"
.LC21:
	.string	"nosymlink"
.LC22:
	.string	"symlinks"
.LC23:
	.string	"nosymlinks"
.LC24:
	.string	"user"
.LC25:
	.string	"cgipat"
.LC26:
	.string	"cgilimit"
.LC27:
	.string	"urlpat"
.LC28:
	.string	"noemptyreferers"
.LC29:
	.string	"localpat"
.LC30:
	.string	"throttles"
.LC31:
	.string	"host"
.LC32:
	.string	"logfile"
.LC33:
	.string	"vhost"
.LC34:
	.string	"novhost"
.LC35:
	.string	"globalpasswd"
.LC36:
	.string	"noglobalpasswd"
.LC37:
	.string	"pidfile"
.LC38:
	.string	"charset"
.LC39:
	.string	"p3p"
.LC40:
	.string	"max_age"
	.section	.rodata.str1.8
	.align 8
.LC41:
	.string	"%s: unknown config option '%s'\n"
	.text
	.p2align 4,,15
	.type	read_config, @function
read_config:
.LFB12:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movl	$.LC12, %esi
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbx
	subq	$112, %rsp
	.cfi_def_cfa_offset 160
	call	fopen
	testq	%rax, %rax
	je	.L194
	movq	%rax, %r12
	movabsq	$4294977024, %r13
.L148:
	movq	%r12, %rdx
	movl	$1000, %esi
	movq	%rsp, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L198
	movl	$35, %esi
	movq	%rsp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L149
	movb	$0, (%rax)
.L149:
	movl	$.LC13, %esi
	movq	%rsp, %rdi
	call	strspn
	leaq	(%rsp,%rax), %rbp
	cmpb	$0, 0(%rbp)
	je	.L148
	.p2align 4,,10
	.p2align 3
.L190:
	movl	$.LC13, %esi
	movq	%rbp, %rdi
	call	strcspn
	leaq	0(%rbp,%rax), %rbx
	movzbl	(%rbx), %eax
	cmpb	$32, %al
	ja	.L151
	btq	%rax, %r13
	jnc	.L151
	movl	$1, %eax
	.p2align 4,,10
	.p2align 3
.L152:
	addq	$1, %rbx
	movzbl	(%rbx), %ecx
	movq	%r13, %rdx
	movb	$0, -1(%rbx)
	shrq	%cl, %rdx
	notq	%rdx
	andl	$1, %edx
	cmpb	$32, %cl
	cmova	%eax, %edx
	testb	%dl, %dl
	je	.L152
.L151:
	movl	$61, %esi
	movq	%rbp, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L185
	leaq	1(%rax), %r14
	movb	$0, (%rax)
.L153:
	movl	$.LC14, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L199
	movl	$.LC15, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L200
	movl	$.LC16, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L201
	movl	$.LC17, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L202
	movl	$.LC18, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L203
	movl	$.LC19, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L204
	movl	$.LC20, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L196
	movl	$.LC21, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L197
	movl	$.LC22, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L196
	movl	$.LC23, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L197
	movl	$.LC24, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L205
	movl	$.LC25, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L206
	movl	$.LC26, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L207
	movl	$.LC27, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L208
	movl	$.LC28, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L209
	movl	$.LC29, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L210
	movl	$.LC30, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L211
	movl	$.LC31, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L212
	movl	$.LC32, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L213
	movl	$.LC33, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L214
	movl	$.LC34, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L215
	movl	$.LC35, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L216
	movl	$.LC36, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L217
	movl	$.LC37, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L218
	movl	$.LC38, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L219
	movl	$.LC39, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	je	.L220
	movl	$.LC40, %esi
	movq	%rbp, %rdi
	call	strcasecmp
	testl	%eax, %eax
	jne	.L181
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	.p2align 4,,10
	.p2align 3
.L155:
	movl	$.LC13, %esi
	movq	%rbx, %rdi
	call	strspn
	leaq	(%rbx,%rax), %rbp
	cmpb	$0, 0(%rbp)
	jne	.L190
	jmp	.L148
.L199:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, debug(%rip)
	jmp	.L155
.L200:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	atoi
	movw	%ax, port(%rip)
	jmp	.L155
.L185:
	xorl	%r14d, %r14d
	jmp	.L153
.L201:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, dir(%rip)
	jmp	.L155
.L202:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L155
.L203:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L155
.L196:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, no_symlink_check(%rip)
	jmp	.L155
.L204:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, data_dir(%rip)
	jmp	.L155
.L197:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, no_symlink_check(%rip)
	jmp	.L155
.L205:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, user(%rip)
	jmp	.L155
.L207:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	atoi
	movl	%eax, cgi_limit(%rip)
	jmp	.L155
.L206:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, cgi_pattern(%rip)
	jmp	.L155
.L198:
	movq	%r12, %rdi
	call	fclose
	addq	$112, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L209:
	.cfi_restore_state
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, no_empty_referers(%rip)
	jmp	.L155
.L208:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, url_pattern(%rip)
	jmp	.L155
.L210:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, local_pattern(%rip)
	jmp	.L155
.L194:
	movq	%rbx, %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L211:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, throttlefile(%rip)
	jmp	.L155
.L213:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, logfile(%rip)
	jmp	.L155
.L212:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, hostname(%rip)
	jmp	.L155
.L181:
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movq	%rbp, %rcx
	movl	$.LC41, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L220:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, p3p(%rip)
	jmp	.L155
.L219:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, charset(%rip)
	jmp	.L155
.L218:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	value_required
	movq	%r14, %rdi
	call	e_strdup
	movq	%rax, pidfile(%rip)
	jmp	.L155
.L217:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_global_passwd(%rip)
	jmp	.L155
.L216:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_global_passwd(%rip)
	jmp	.L155
.L215:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$0, do_vhost(%rip)
	jmp	.L155
.L214:
	movq	%r14, %rsi
	movq	%rbp, %rdi
	call	no_value_required
	movl	$1, do_vhost(%rip)
	jmp	.L155
	.cfi_endproc
.LFE12:
	.size	read_config, .-read_config
	.section	.rodata.str1.1
.LC42:
	.string	"nobody"
.LC43:
	.string	"iso-8859-1"
.LC44:
	.string	""
.LC45:
	.string	"-V"
.LC46:
	.string	"thttpd/2.27.0 Oct 3, 2014"
.LC47:
	.string	"-C"
.LC48:
	.string	"-p"
.LC49:
	.string	"-d"
.LC50:
	.string	"-r"
.LC51:
	.string	"-nor"
.LC52:
	.string	"-dd"
.LC53:
	.string	"-s"
.LC54:
	.string	"-nos"
.LC55:
	.string	"-u"
.LC56:
	.string	"-c"
.LC57:
	.string	"-t"
.LC58:
	.string	"-h"
.LC59:
	.string	"-l"
.LC60:
	.string	"-v"
.LC61:
	.string	"-nov"
.LC62:
	.string	"-g"
.LC63:
	.string	"-nog"
.LC64:
	.string	"-i"
.LC65:
	.string	"-T"
.LC66:
	.string	"-P"
.LC67:
	.string	"-M"
.LC68:
	.string	"-D"
	.text
	.p2align 4,,15
	.type	parse_args, @function
parse_args:
.LFB10:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	movl	$80, %eax
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	%edi, %r13d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$8, %rsp
	.cfi_def_cfa_offset 64
	cmpl	$1, %edi
	movl	$0, debug(%rip)
	movw	%ax, port(%rip)
	movq	$0, dir(%rip)
	movq	$0, data_dir(%rip)
	movl	$0, do_chroot(%rip)
	movl	$0, no_log(%rip)
	movl	$0, no_symlink_check(%rip)
	movl	$0, do_vhost(%rip)
	movl	$0, do_global_passwd(%rip)
	movq	$0, cgi_pattern(%rip)
	movl	$0, cgi_limit(%rip)
	movq	$0, url_pattern(%rip)
	movl	$0, no_empty_referers(%rip)
	movq	$0, local_pattern(%rip)
	movq	$0, throttlefile(%rip)
	movq	$0, hostname(%rip)
	movq	$0, logfile(%rip)
	movq	$0, pidfile(%rip)
	movq	$.LC42, user(%rip)
	movq	$.LC43, charset(%rip)
	movq	$.LC44, p3p(%rip)
	movl	$-1, max_age(%rip)
	jle	.L253
	movq	8(%rsi), %rbx
	movq	%rsi, %r14
	movl	$1, %ebp
	movl	$.LC45, %r12d
	cmpb	$45, (%rbx)
	je	.L260
	jmp	.L224
	.p2align 4,,10
	.p2align 3
.L269:
	leal	1(%rbp), %r15d
	cmpl	%r15d, %r13d
	jg	.L267
	movl	$.LC48, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L230
.L229:
	movl	$.LC49, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L230
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L230
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, dir(%rip)
.L228:
	addl	$1, %ebp
	cmpl	%ebp, %r13d
	jle	.L222
.L270:
	movslq	%ebp, %rax
	movq	(%r14,%rax,8), %rbx
	cmpb	$45, (%rbx)
	jne	.L224
.L260:
	movl	$3, %ecx
	movq	%rbx, %rsi
	movq	%r12, %rdi
	repz cmpsb
	je	.L268
	movl	$.LC47, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L269
	movl	$.LC48, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L229
	leal	1(%rbp), %r15d
	cmpl	%r15d, %r13d
	jle	.L230
	movslq	%r15d, %rax
	movl	%r15d, %ebp
	movq	(%r14,%rax,8), %rdi
	addl	$1, %ebp
	call	atoi
	cmpl	%ebp, %r13d
	movw	%ax, port(%rip)
	jg	.L270
.L222:
	cmpl	%ebp, %r13d
	jne	.L224
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%rbp
	.cfi_def_cfa_offset 40
	popq	%r12
	.cfi_def_cfa_offset 32
	popq	%r13
	.cfi_def_cfa_offset 24
	popq	%r14
	.cfi_def_cfa_offset 16
	popq	%r15
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L230:
	.cfi_restore_state
	movl	$.LC50, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L231
	movl	$1, do_chroot(%rip)
	movl	$1, no_symlink_check(%rip)
	jmp	.L228
	.p2align 4,,10
	.p2align 3
.L231:
	movl	$.LC51, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L232
	movl	$0, do_chroot(%rip)
	movl	$0, no_symlink_check(%rip)
	jmp	.L228
	.p2align 4,,10
	.p2align 3
.L267:
	movslq	%r15d, %rax
	movl	%r15d, %ebp
	movq	(%r14,%rax,8), %rdi
	call	read_config
	jmp	.L228
	.p2align 4,,10
	.p2align 3
.L232:
	movl	$.LC52, %edi
	movl	$4, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L233
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L233
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, data_dir(%rip)
	jmp	.L228
	.p2align 4,,10
	.p2align 3
.L233:
	movl	$.LC53, %edi
	movl	$3, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	jne	.L234
	movl	$0, no_symlink_check(%rip)
	jmp	.L228
	.p2align 4,,10
	.p2align 3
.L234:
	movl	$.LC54, %edi
	movl	$5, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L271
	movl	$.LC55, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L236
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L236
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, user(%rip)
	jmp	.L228
.L271:
	movl	$1, no_symlink_check(%rip)
	jmp	.L228
.L236:
	movl	$.LC56, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L237
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L237
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, cgi_pattern(%rip)
	jmp	.L228
.L237:
	movl	$.LC57, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L272
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L240
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L241
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, hostname(%rip)
	jmp	.L228
.L272:
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L239
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, throttlefile(%rip)
	jmp	.L228
.L239:
	movl	$.LC58, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L240
.L241:
	movl	$.LC60, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L242
	movl	$1, do_vhost(%rip)
	jmp	.L228
.L240:
	movl	$.LC59, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L241
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L241
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, logfile(%rip)
	jmp	.L228
.L242:
	movl	$.LC61, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L273
	movl	$.LC62, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L244
	movl	$1, do_global_passwd(%rip)
	jmp	.L228
.L273:
	movl	$0, do_vhost(%rip)
	jmp	.L228
.L253:
	movl	$1, %ebp
	jmp	.L222
.L244:
	movl	$.LC63, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L245
	movl	$0, do_global_passwd(%rip)
	jmp	.L228
.L268:
	movl	$.LC46, %edi
	call	puts
	xorl	%edi, %edi
	call	exit
.L245:
	movl	$.LC64, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L274
	movl	$.LC65, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L248
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L247
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, charset(%rip)
	jmp	.L228
.L274:
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L247
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, pidfile(%rip)
	jmp	.L228
.L247:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L250
.L249:
	movl	$.LC67, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L250
	leal	1(%rbp), %r15d
	cmpl	%r15d, %r13d
	jle	.L250
	movslq	%r15d, %rax
	movl	%r15d, %ebp
	movq	(%r14,%rax,8), %rdi
	call	atoi
	movl	%eax, max_age(%rip)
	jmp	.L228
.L248:
	movl	$.LC66, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L249
	leal	1(%rbp), %eax
	cmpl	%eax, %r13d
	jle	.L250
	movslq	%eax, %rdx
	movl	%eax, %ebp
	movq	(%r14,%rdx,8), %rdx
	movq	%rdx, p3p(%rip)
	jmp	.L228
.L250:
	movl	$.LC68, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L224
	movl	$1, debug(%rip)
	jmp	.L228
.L224:
	call	usage
	.cfi_endproc
.LFE10:
	.size	parse_args, .-parse_args
	.section	.rodata.str1.1
.LC69:
	.string	"%.80s - %m"
.LC70:
	.string	" %4900[^ \t] %ld-%ld"
.LC71:
	.string	" %4900[^ \t] %ld"
	.section	.rodata.str1.8
	.align 8
.LC72:
	.string	"unparsable line in %.80s - %.80s"
	.align 8
.LC73:
	.string	"%s: unparsable line in %.80s - %.80s\n"
	.section	.rodata.str1.1
.LC74:
	.string	"|/"
	.section	.rodata.str1.8
	.align 8
.LC75:
	.string	"out of memory allocating a throttletab"
	.align 8
.LC76:
	.string	"%s: out of memory allocating a throttletab\n"
	.text
	.p2align 4,,15
	.type	read_throttlefile, @function
read_throttlefile:
.LFB17:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	movl	$.LC12, %esi
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rdi, %rbp
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$10048, %rsp
	.cfi_def_cfa_offset 10096
	call	fopen
	testq	%rax, %rax
	je	.L311
	leaq	16(%rsp), %rdi
	leaq	32(%rsp), %r13
	leaq	5041(%rsp), %r12
	xorl	%esi, %esi
	movq	%rax, %rbx
	call	gettimeofday
	.p2align 4,,10
	.p2align 3
.L277:
	movq	%rbx, %rdx
	movl	$5000, %esi
	movq	%r13, %rdi
	call	fgets
	testq	%rax, %rax
	je	.L312
	movl	$35, %esi
	movq	%r13, %rdi
	call	strchr
	testq	%rax, %rax
	je	.L278
	movb	$0, (%rax)
.L278:
	movq	%r13, %rax
.L279:
	movl	(%rax), %ecx
	addq	$4, %rax
	leal	-16843009(%rcx), %edx
	notl	%ecx
	andl	%ecx, %edx
	andl	$-2139062144, %edx
	je	.L279
	movl	%edx, %ecx
	shrl	$16, %ecx
	testl	$32896, %edx
	cmove	%ecx, %edx
	leaq	2(%rax), %rcx
	movl	%edx, %edi
	cmove	%rcx, %rax
	addb	%dl, %dil
	sbbq	$3, %rax
	subq	%r13, %rax
	testl	%eax, %eax
	movl	%eax, %edx
	jle	.L281
	leal	-1(%rax), %edx
	movslq	%edx, %rax
	movzbl	32(%rsp,%rax), %edi
	cmpb	$32, %dil
	jbe	.L313
	.p2align 4,,10
	.p2align 3
.L282:
	leaq	8(%rsp), %rcx
	leaq	5040(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rsp, %r8
	movl	$.LC70, %esi
	movq	%r13, %rdi
	call	__isoc99_sscanf
	cmpl	$3, %eax
	je	.L284
	leaq	5040(%rsp), %rdx
	xorl	%eax, %eax
	movq	%rsp, %rcx
	movl	$.LC71, %esi
	movq	%r13, %rdi
	call	__isoc99_sscanf
	cmpl	$2, %eax
	jne	.L288
	movq	$0, 8(%rsp)
	.p2align 4,,10
	.p2align 3
.L284:
	cmpb	$47, 5040(%rsp)
	jne	.L290
	jmp	.L314
	.p2align 4,,10
	.p2align 3
.L291:
	leaq	2(%rax), %rsi
	leaq	1(%rax), %rdi
	call	strcpy
.L290:
	leaq	5040(%rsp), %rdi
	movl	$.LC74, %esi
	call	strstr
	testq	%rax, %rax
	jne	.L291
	movslq	numthrottles(%rip), %r14
	movl	maxthrottles(%rip), %eax
	cmpl	%eax, %r14d
	jl	.L292
	testl	%eax, %eax
	jne	.L293
	movl	$4800, %edi
	movl	$100, maxthrottles(%rip)
	call	malloc
	movq	%rax, throttles(%rip)
.L294:
	testq	%rax, %rax
	je	.L315
.L295:
	leaq	(%r14,%r14,2), %r14
	leaq	5040(%rsp), %rdi
	salq	$4, %r14
	addq	%rax, %r14
	call	e_strdup
	movq	%rax, (%r14)
	movslq	numthrottles(%rip), %rax
	movq	(%rsp), %rcx
	movq	%rax, %rdx
	leaq	(%rax,%rax,2), %rax
	addl	$1, %edx
	salq	$4, %rax
	addq	throttles(%rip), %rax
	movl	%edx, numthrottles(%rip)
	movq	%rcx, 8(%rax)
	movq	8(%rsp), %rcx
	movq	$0, 24(%rax)
	movq	$0, 32(%rax)
	movl	$0, 40(%rax)
	movq	%rcx, 16(%rax)
	jmp	.L277
	.p2align 4,,10
	.p2align 3
.L313:
	movabsq	$4294977024, %r8
	movl	%edx, %edx
	movq	%rax, %rcx
	subq	%rdx, %rcx
	btq	%rdi, %r8
	movq	%r8, %rsi
	jc	.L308
	jmp	.L282
	.p2align 4,,10
	.p2align 3
.L316:
	movzbl	31(%rsp,%rax), %edx
	cmpb	$32, %dl
	ja	.L282
	subq	$1, %rax
	btq	%rdx, %rsi
	jnc	.L282
.L308:
	cmpq	%rax, %rcx
	movl	%eax, %edx
	movb	$0, 0(%r13,%rax)
	jne	.L316
.L281:
	testl	%edx, %edx
	je	.L277
	jmp	.L282
.L288:
	movq	%r13, %rcx
	movq	%rbp, %rdx
	xorl	%eax, %eax
	movl	$.LC72, %esi
	movl	$2, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movq	%r13, %r8
	movq	%rbp, %rcx
	movl	$.LC73, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L277
.L293:
	addl	%eax, %eax
	movq	throttles(%rip), %rdi
	movl	%eax, maxthrottles(%rip)
	cltq
	leaq	(%rax,%rax,2), %rsi
	salq	$4, %rsi
	call	realloc
	movq	%rax, throttles(%rip)
	jmp	.L294
.L292:
	movq	throttles(%rip), %rax
	jmp	.L295
.L312:
	movq	%rbx, %rdi
	call	fclose
	addq	$10048, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L314:
	.cfi_restore_state
	leaq	5040(%rsp), %rdi
	movq	%r12, %rsi
	call	strcpy
	jmp	.L290
.L311:
	movq	%rbp, %rdx
	movl	$.LC69, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%rbp, %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L315:
	movl	$.LC75, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC76, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE17:
	.size	read_throttlefile, .-read_throttlefile
	.section	.rodata.str1.1
.LC77:
	.string	"-"
.LC78:
	.string	"re-opening logfile"
.LC79:
	.string	"a"
.LC80:
	.string	"re-opening %.80s - %m"
	.text
	.p2align 4,,15
	.type	re_open_logfile, @function
re_open_logfile:
.LFB8:
	.cfi_startproc
	movl	no_log(%rip), %eax
	testl	%eax, %eax
	jne	.L317
	cmpq	$0, hs(%rip)
	je	.L317
	movq	logfile(%rip), %rsi
	testq	%rsi, %rsi
	je	.L317
	movl	$.LC77, %edi
	movl	$2, %ecx
	repz cmpsb
	jne	.L331
.L317:
	rep ret
	.p2align 4,,10
	.p2align 3
.L331:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	xorl	%eax, %eax
	movl	$.LC78, %esi
	movl	$5, %edi
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	call	syslog
	movq	logfile(%rip), %rdi
	movl	$.LC79, %esi
	call	fopen
	movq	logfile(%rip), %rbp
	movq	%rax, %rbx
	movl	$384, %esi
	movq	%rbp, %rdi
	call	chmod
	testq	%rbx, %rbx
	je	.L321
	testl	%eax, %eax
	jne	.L321
	movq	%rbx, %rdi
	call	fileno
	movl	$2, %esi
	movl	%eax, %edi
	movl	$1, %edx
	xorl	%eax, %eax
	call	fcntl
	movq	hs(%rip), %rdi
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbx, %rsi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	jmp	httpd_set_logfp
	.p2align 4,,10
	.p2align 3
.L321:
	.cfi_restore_state
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rdx
	movl	$.LC80, %esi
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 8
	movl	$2, %edi
	xorl	%eax, %eax
	jmp	syslog
	.cfi_endproc
.LFE8:
	.size	re_open_logfile, .-re_open_logfile
	.section	.rodata.str1.1
.LC81:
	.string	"too many connections!"
	.section	.rodata.str1.8
	.align 8
.LC82:
	.string	"the connects free list is messed up"
	.align 8
.LC83:
	.string	"out of memory allocating an httpd_conn"
	.text
	.p2align 4,,15
	.type	handle_newconnect, @function
handle_newconnect:
.LFB19:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rdi, %r12
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movl	%esi, %ebp
	subq	$16, %rsp
	.cfi_def_cfa_offset 48
	movl	num_connects(%rip), %eax
.L341:
	cmpl	%eax, max_connects(%rip)
	jle	.L351
	movslq	first_free_connect(%rip), %rax
	cmpl	$-1, %eax
	je	.L335
	leaq	(%rax,%rax,8), %rbx
	salq	$4, %rbx
	addq	connects(%rip), %rbx
	movl	(%rbx), %eax
	testl	%eax, %eax
	jne	.L335
	movq	8(%rbx), %rdx
	testq	%rdx, %rdx
	je	.L352
.L337:
	movq	hs(%rip), %rdi
	movl	%ebp, %esi
	call	httpd_get_conn
	testl	%eax, %eax
	je	.L340
	cmpl	$2, %eax
	jne	.L353
	movl	$1, %eax
.L332:
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L353:
	.cfi_restore_state
	movl	4(%rbx), %eax
	movl	$1, (%rbx)
	movl	$-1, 4(%rbx)
	addl	$1, num_connects(%rip)
	movl	%eax, first_free_connect(%rip)
	movq	(%r12), %rax
	movq	$0, 96(%rbx)
	movq	$0, 104(%rbx)
	movq	%rax, 88(%rbx)
	movq	8(%rbx), %rax
	movq	$0, 136(%rbx)
	movl	$0, 56(%rbx)
	movl	704(%rax), %edi
	call	httpd_set_ndelay
	movq	8(%rbx), %rax
	xorl	%edx, %edx
	movq	%rbx, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	addq	$1, stats_connections(%rip)
	movl	num_connects(%rip), %eax
	cmpl	stats_simultaneous(%rip), %eax
	jle	.L341
	movl	%eax, stats_simultaneous(%rip)
	jmp	.L341
	.p2align 4,,10
	.p2align 3
.L340:
	movq	%r12, %rdi
	movl	%eax, 12(%rsp)
	call	tmr_run
	movl	12(%rsp), %eax
	addq	$16, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 32
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L352:
	.cfi_restore_state
	movl	$720, %edi
	call	malloc
	testq	%rax, %rax
	movq	%rax, 8(%rbx)
	je	.L354
	movl	$0, (%rax)
	addl	$1, httpd_conn_count(%rip)
	movq	%rax, %rdx
	jmp	.L337
	.p2align 4,,10
	.p2align 3
.L351:
	xorl	%eax, %eax
	movl	$.LC81, %esi
	movl	$4, %edi
	call	syslog
	movq	%r12, %rdi
	call	tmr_run
	xorl	%eax, %eax
	jmp	.L332
.L335:
	movl	$2, %edi
	movl	$.LC82, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L354:
	movl	$2, %edi
	movl	$.LC83, %esi
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE19:
	.size	handle_newconnect, .-handle_newconnect
	.section	.rodata.str1.8
	.align 8
.LC84:
	.string	"throttle sending count was negative - shouldn't happen!"
	.text
	.p2align 4,,15
	.type	check_throttles, @function
check_throttles:
.LFB23:
	.cfi_startproc
	movq	$-1, %rax
	movl	$0, 56(%rdi)
	movq	%rax, 72(%rdi)
	movq	%rax, 64(%rdi)
	movl	numthrottles(%rip), %eax
	testl	%eax, %eax
	jle	.L380
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	xorl	%r12d, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	xorl	%ebp, %ebp
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rdi, %rbx
	jmp	.L371
	.p2align 4,,10
	.p2align 3
.L362:
	cmpq	%rdi, %rax
	cmovl	%rdi, %rax
	movq	%rax, 72(%rbx)
.L358:
	addl	$1, %r12d
	cmpl	%r12d, numthrottles(%rip)
	jle	.L363
.L381:
	addq	$48, %rbp
	cmpl	$9, 56(%rbx)
	jg	.L363
.L371:
	movq	8(%rbx), %rax
	movq	240(%rax), %rsi
	movq	throttles(%rip), %rax
	movq	(%rax,%rbp), %rdi
	call	match
	testl	%eax, %eax
	je	.L358
	movq	%rbp, %rdx
	addq	throttles(%rip), %rdx
	movq	8(%rdx), %rax
	movq	24(%rdx), %rcx
	leaq	(%rax,%rax), %rsi
	cmpq	%rsi, %rcx
	jg	.L366
	movq	16(%rdx), %rdi
	cmpq	%rdi, %rcx
	jl	.L366
	movl	40(%rdx), %ecx
	testl	%ecx, %ecx
	js	.L359
	addl	$1, %ecx
	movslq	%ecx, %r8
.L360:
	movslq	56(%rbx), %rsi
	leal	1(%rsi), %r9d
	movl	%r9d, 56(%rbx)
	movl	%r12d, 16(%rbx,%rsi,4)
	movl	%ecx, 40(%rdx)
	cqto
	idivq	%r8
	movq	64(%rbx), %rdx
	cmpq	$-1, %rdx
	je	.L361
	cmpq	%rdx, %rax
	cmovg	%rdx, %rax
.L361:
	movq	%rax, 64(%rbx)
	movq	72(%rbx), %rax
	cmpq	$-1, %rax
	jne	.L362
	addl	$1, %r12d
	cmpl	%r12d, numthrottles(%rip)
	movq	%rdi, 72(%rbx)
	jg	.L381
.L363:
	popq	%rbx
	.cfi_remember_state
	.cfi_restore 3
	.cfi_def_cfa_offset 24
	movl	$1, %eax
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L359:
	.cfi_restore_state
	movl	$3, %edi
	xorl	%eax, %eax
	movl	$.LC84, %esi
	call	syslog
	movq	%rbp, %rdx
	addq	throttles(%rip), %rdx
	movl	$1, %r8d
	movl	$1, %ecx
	movl	$0, 40(%rdx)
	movq	8(%rdx), %rax
	movq	16(%rdx), %rdi
	jmp	.L360
	.p2align 4,,10
	.p2align 3
.L366:
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 24
	xorl	%eax, %eax
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 8
	ret
.L380:
	movl	$1, %eax
	ret
	.cfi_endproc
.LFE23:
	.size	check_throttles, .-check_throttles
	.p2align 4,,15
	.type	shut_down, @function
shut_down:
.LFB18:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	xorl	%esi, %esi
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	xorl	%ebp, %ebp
	xorl	%ebx, %ebx
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	movq	%rsp, %rdi
	call	gettimeofday
	movq	%rsp, %rdi
	call	logstats
	movl	max_connects(%rip), %ecx
	movq	connects(%rip), %r12
	testl	%ecx, %ecx
	jg	.L401
	jmp	.L389
	.p2align 4,,10
	.p2align 3
.L386:
	movq	8(%rax), %rdi
	testq	%rdi, %rdi
	je	.L387
	call	httpd_destroy_conn
	movq	connects(%rip), %r12
	leaq	(%r12,%rbx), %r13
	movq	8(%r13), %rdi
	call	free
	subl	$1, httpd_conn_count(%rip)
	movq	$0, 8(%r13)
.L387:
	addl	$1, %ebp
	addq	$144, %rbx
	cmpl	%ebp, max_connects(%rip)
	jle	.L389
.L401:
	leaq	(%r12,%rbx), %rax
	movl	(%rax), %edx
	testl	%edx, %edx
	je	.L386
	movq	8(%rax), %rdi
	movq	%rsp, %rsi
	call	httpd_close_conn
	movq	connects(%rip), %r12
	leaq	(%r12,%rbx), %rax
	jmp	.L386
	.p2align 4,,10
	.p2align 3
.L389:
	movq	hs(%rip), %rbx
	testq	%rbx, %rbx
	je	.L385
	movl	72(%rbx), %edi
	movq	$0, hs(%rip)
	cmpl	$-1, %edi
	je	.L390
	call	fdwatch_del_fd
.L390:
	movl	76(%rbx), %edi
	cmpl	$-1, %edi
	je	.L391
	call	fdwatch_del_fd
.L391:
	movq	%rbx, %rdi
	call	httpd_terminate
.L385:
	call	mmc_destroy
	call	tmr_destroy
	movq	connects(%rip), %rdi
	call	free
	movq	throttles(%rip), %rdi
	testq	%rdi, %rdi
	je	.L382
	call	free
.L382:
	addq	$24, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE18:
	.size	shut_down, .-shut_down
	.section	.rodata.str1.1
.LC85:
	.string	"exiting"
	.text
	.p2align 4,,15
	.type	handle_usr1, @function
handle_usr1:
.LFB5:
	.cfi_startproc
	movl	num_connects(%rip), %eax
	testl	%eax, %eax
	je	.L414
	movl	$1, got_usr1(%rip)
	ret
.L414:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	call	shut_down
	movl	$5, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
	.cfi_endproc
.LFE5:
	.size	handle_usr1, .-handle_usr1
	.section	.rodata.str1.1
.LC86:
	.string	"exiting due to signal %d"
	.text
	.p2align 4,,15
	.type	handle_term, @function
handle_term:
.LFB2:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movl	%edi, %ebx
	call	shut_down
	movl	$5, %edi
	movl	%ebx, %edx
	movl	$.LC86, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE2:
	.size	handle_term, .-handle_term
	.p2align 4,,15
	.type	clear_throttles.isra.0, @function
clear_throttles.isra.0:
.LFB36:
	.cfi_startproc
	movl	56(%rdi), %edx
	testl	%edx, %edx
	jle	.L417
	movslq	16(%rdi), %rcx
	movq	throttles(%rip), %rax
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$1, %edx
	je	.L417
	movslq	20(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$2, %edx
	je	.L417
	movslq	24(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$3, %edx
	je	.L417
	movslq	28(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$4, %edx
	je	.L417
	movslq	32(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$5, %edx
	je	.L417
	movslq	36(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$6, %edx
	je	.L417
	movslq	40(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$7, %edx
	je	.L417
	movslq	44(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$8, %edx
	je	.L417
	movslq	48(%rdi), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	subl	$1, 40(%rax,%rcx)
	cmpl	$9, %edx
	je	.L417
	movslq	52(%rdi), %rdx
	leaq	(%rdx,%rdx,2), %rdx
	salq	$4, %rdx
	subl	$1, 40(%rax,%rdx)
.L417:
	rep ret
	.cfi_endproc
.LFE36:
	.size	clear_throttles.isra.0, .-clear_throttles.isra.0
	.p2align 4,,15
	.type	really_clear_connection, @function
really_clear_connection:
.LFB28:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	movq	%rdi, %rbx
	subq	$16, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	movq	200(%rdi), %rax
	addq	%rax, stats_bytes(%rip)
	cmpl	$3, (%rbx)
	je	.L448
	movl	704(%rdi), %edi
	movq	%rsi, 8(%rsp)
	call	fdwatch_del_fd
	movq	8(%rbx), %rdi
	movq	8(%rsp), %rsi
.L448:
	call	httpd_close_conn
	movq	%rbx, %rdi
	call	clear_throttles.isra.0
	movq	104(%rbx), %rdi
	testq	%rdi, %rdi
	je	.L449
	call	tmr_cancel
	movq	$0, 104(%rbx)
.L449:
	movl	first_free_connect(%rip), %eax
	movl	$0, (%rbx)
	subl	$1, num_connects(%rip)
	movl	%eax, 4(%rbx)
	subq	connects(%rip), %rbx
	movabsq	$-8198552921648689607, %rax
	sarq	$4, %rbx
	imulq	%rax, %rbx
	movl	%ebx, first_free_connect(%rip)
	addq	$16, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE28:
	.size	really_clear_connection, .-really_clear_connection
	.section	.rodata.str1.8
	.align 8
.LC87:
	.string	"replacing non-null linger_timer!"
	.align 8
.LC88:
	.string	"tmr_create(linger_clear_connection) failed"
	.text
	.p2align 4,,15
	.type	clear_connection, @function
clear_connection:
.LFB27:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	96(%rdi), %rdi
	testq	%rdi, %rdi
	je	.L455
	call	tmr_cancel
	movq	$0, 96(%rbx)
.L455:
	movl	(%rbx), %edx
	cmpl	$4, %edx
	je	.L468
	movq	8(%rbx), %rax
	movl	556(%rax), %ecx
	testl	%ecx, %ecx
	je	.L457
	cmpl	$3, %edx
	je	.L458
	movl	704(%rax), %edi
	call	fdwatch_del_fd
	movq	8(%rbx), %rax
.L458:
	movl	704(%rax), %edi
	movl	$1, %esi
	movl	$4, (%rbx)
	call	shutdown
	movq	8(%rbx), %rax
	xorl	%edx, %edx
	movq	%rbx, %rsi
	movl	704(%rax), %edi
	call	fdwatch_add_fd
	cmpq	$0, 104(%rbx)
	je	.L459
	movl	$.LC87, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L459:
	xorl	%r8d, %r8d
	movl	$500, %ecx
	movq	%rbx, %rdx
	movl	$linger_clear_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	testq	%rax, %rax
	movq	%rax, 104(%rbx)
	je	.L469
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L468:
	.cfi_restore_state
	movq	104(%rbx), %rdi
	call	tmr_cancel
	movq	8(%rbx), %rax
	movq	$0, 104(%rbx)
	movl	$0, 556(%rax)
.L457:
	addq	$8, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	really_clear_connection
.L469:
	.cfi_restore_state
	movl	$2, %edi
	movl	$.LC88, %esi
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE27:
	.size	clear_connection, .-clear_connection
	.p2align 4,,15
	.type	finish_connection, @function
finish_connection:
.LFB26:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	subq	$8, %rsp
	.cfi_def_cfa_offset 32
	movq	8(%rdi), %rdi
	call	httpd_write_response
	addq	$8, %rsp
	.cfi_def_cfa_offset 24
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	jmp	clear_connection
	.cfi_endproc
.LFE26:
	.size	finish_connection, .-finish_connection
	.p2align 4,,15
	.type	handle_read, @function
handle_read:
.LFB20:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	movq	%rsi, %r12
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	8(%rdi), %rbx
	movq	%rdi, %rbp
	movq	160(%rbx), %rsi
	movq	152(%rbx), %rdx
	cmpq	%rdx, %rsi
	jb	.L473
	cmpq	$5000, %rdx
	jbe	.L526
.L525:
	movq	httpd_err400form(%rip), %r8
	movq	httpd_err400title(%rip), %rdx
	movl	$.LC44, %r9d
	movq	%r9, %rcx
	movl	$400, %esi
	movq	%rbx, %rdi
	call	httpd_send_err
.L524:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	movq	%r12, %rsi
	movq	%rbp, %rdi
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	finish_connection
	.p2align 4,,10
	.p2align 3
.L526:
	.cfi_restore_state
	leaq	152(%rbx), %rsi
	leaq	144(%rbx), %rdi
	addq	$1000, %rdx
	call	httpd_realloc_str
	movq	152(%rbx), %rdx
	movq	160(%rbx), %rsi
.L473:
	subq	%rsi, %rdx
	addq	144(%rbx), %rsi
	movl	704(%rbx), %edi
	call	read
	testl	%eax, %eax
	je	.L525
	js	.L527
	cltq
	addq	%rax, 160(%rbx)
	movq	(%r12), %rax
	movq	%rbx, %rdi
	movq	%rax, 88(%rbp)
	call	httpd_got_request
	testl	%eax, %eax
	je	.L472
	cmpl	$2, %eax
	je	.L525
	movq	%rbx, %rdi
	call	httpd_parse_request
	testl	%eax, %eax
	js	.L524
	movq	%rbp, %rdi
	call	check_throttles
	testl	%eax, %eax
	je	.L528
	movq	%r12, %rsi
	movq	%rbx, %rdi
	call	httpd_start_request
	testl	%eax, %eax
	js	.L524
	movl	528(%rbx), %eax
	testl	%eax, %eax
	je	.L483
	movq	536(%rbx), %rax
	movq	%rax, 136(%rbp)
	movq	544(%rbx), %rax
	addq	$1, %rax
	movq	%rax, 128(%rbp)
.L484:
	cmpq	$0, 712(%rbx)
	je	.L529
	cmpq	%rax, 136(%rbp)
	jge	.L524
	movq	(%r12), %rax
	movl	704(%rbx), %edi
	movl	$2, 0(%rbp)
	movq	$0, 112(%rbp)
	movq	%rax, 80(%rbp)
	call	fdwatch_del_fd
	movl	704(%rbx), %edi
	movq	%rbp, %rsi
	movl	$1, %edx
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	jmp	fdwatch_add_fd
	.p2align 4,,10
	.p2align 3
.L527:
	.cfi_restore_state
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L472
	cmpl	$11, %eax
	jne	.L525
.L472:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L528:
	.cfi_restore_state
	movq	208(%rbx), %r9
	movq	httpd_err503form(%rip), %r8
	movl	$.LC44, %ecx
	movq	httpd_err503title(%rip), %rdx
	movl	$503, %esi
	movq	%rbx, %rdi
	call	httpd_send_err
	jmp	.L524
	.p2align 4,,10
	.p2align 3
.L483:
	movq	192(%rbx), %rax
	testq	%rax, %rax
	js	.L530
	movq	%rax, 128(%rbp)
	jmp	.L484
.L529:
	movl	56(%rbp), %ecx
	testl	%ecx, %ecx
	jle	.L531
	movslq	16(%rbp), %rsi
	movq	throttles(%rip), %rax
	movq	200(%rbx), %rdx
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$1, %ecx
	je	.L488
	movslq	20(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$2, %ecx
	je	.L488
	movslq	24(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$3, %ecx
	je	.L488
	movslq	28(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$4, %ecx
	je	.L488
	movslq	32(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$5, %ecx
	je	.L488
	movslq	36(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$6, %ecx
	je	.L488
	movslq	40(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$7, %ecx
	je	.L488
	movslq	44(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$8, %ecx
	je	.L488
	movslq	48(%rbp), %rsi
	leaq	(%rsi,%rsi,2), %rsi
	salq	$4, %rsi
	addq	%rdx, 32(%rax,%rsi)
	cmpl	$9, %ecx
	je	.L488
	movslq	52(%rbp), %rcx
	leaq	(%rcx,%rcx,2), %rcx
	salq	$4, %rcx
	addq	%rdx, 32(%rax,%rcx)
.L488:
	movq	%rdx, 136(%rbp)
	jmp	.L524
.L530:
	movq	$0, 128(%rbp)
	xorl	%eax, %eax
	jmp	.L484
.L531:
	movq	200(%rbx), %rdx
	jmp	.L488
	.cfi_endproc
.LFE20:
	.size	handle_read, .-handle_read
	.section	.rodata.str1.8
	.align 8
.LC89:
	.string	"%.80s connection timed out reading"
	.align 8
.LC90:
	.string	"%.80s connection timed out sending"
	.text
	.p2align 4,,15
	.type	idle, @function
idle:
.LFB29:
	.cfi_startproc
	movl	max_connects(%rip), %edx
	testl	%edx, %edx
	jle	.L546
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movq	%rsi, %r13
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	xorl	%r12d, %r12d
	xorl	%ebp, %ebp
	subq	$8, %rsp
	.cfi_def_cfa_offset 48
	jmp	.L539
	.p2align 4,,10
	.p2align 3
.L549:
	jl	.L534
	cmpl	$3, %eax
	jg	.L534
	movq	0(%r13), %rax
	subq	88(%rbx), %rax
	cmpq	$299, %rax
	jg	.L547
.L534:
	addl	$1, %ebp
	addq	$144, %r12
	cmpl	%edx, %ebp
	jge	.L548
.L539:
	movq	%r12, %rbx
	addq	connects(%rip), %rbx
	movl	(%rbx), %eax
	cmpl	$1, %eax
	jne	.L549
	movq	0(%r13), %rax
	subq	88(%rbx), %rax
	cmpq	$59, %rax
	jle	.L534
	movq	8(%rbx), %rax
	addl	$1, %ebp
	addq	$144, %r12
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC89, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	movq	httpd_err408title(%rip), %rdx
	movq	8(%rbx), %rdi
	movl	$.LC44, %r9d
	movq	httpd_err408form(%rip), %r8
	movq	%r9, %rcx
	movl	$408, %esi
	call	httpd_send_err
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	movl	max_connects(%rip), %edx
	cmpl	%edx, %ebp
	jl	.L539
	.p2align 4,,10
	.p2align 3
.L548:
	addq	$8, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_restore 3
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_restore 6
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_restore 12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_restore 13
	.cfi_def_cfa_offset 8
.L546:
	rep ret
	.p2align 4,,10
	.p2align 3
.L547:
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -40
	.cfi_offset 6, -32
	.cfi_offset 12, -24
	.cfi_offset 13, -16
	movq	8(%rbx), %rax
	leaq	16(%rax), %rdi
	call	httpd_ntoa
	movl	$.LC90, %esi
	movq	%rax, %rdx
	movl	$6, %edi
	xorl	%eax, %eax
	call	syslog
	movq	%r13, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	movl	max_connects(%rip), %edx
	jmp	.L534
	.cfi_endproc
.LFE29:
	.size	idle, .-idle
	.section	.rodata.str1.8
	.align 8
.LC91:
	.string	"replacing non-null wakeup_timer!"
	.align 8
.LC92:
	.string	"tmr_create(wakeup_connection) failed"
	.section	.rodata.str1.1
.LC93:
	.string	"write - %m sending %.80s"
	.text
	.p2align 4,,15
	.type	handle_send, @function
handle_send:
.LFB21:
	.cfi_startproc
	pushq	%r13
	.cfi_def_cfa_offset 16
	.cfi_offset 13, -16
	pushq	%r12
	.cfi_def_cfa_offset 24
	.cfi_offset 12, -24
	movl	$1000000000, %edx
	pushq	%rbp
	.cfi_def_cfa_offset 32
	.cfi_offset 6, -32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	.cfi_offset 3, -40
	movq	%rsi, %rbp
	movq	%rdi, %rbx
	subq	$40, %rsp
	.cfi_def_cfa_offset 80
	movq	64(%rdi), %rax
	movq	8(%rdi), %r12
	cmpq	$-1, %rax
	je	.L551
	leaq	3(%rax), %rdx
	testq	%rax, %rax
	cmovns	%rax, %rdx
	sarq	$2, %rdx
.L551:
	movq	472(%r12), %rax
	testq	%rax, %rax
	jne	.L552
	movq	136(%rbx), %rsi
	movq	128(%rbx), %rax
	movl	704(%r12), %edi
	subq	%rsi, %rax
	cmpq	%rdx, %rax
	cmovbe	%rax, %rdx
	addq	712(%r12), %rsi
	call	write
	testl	%eax, %eax
	js	.L631
.L554:
	je	.L557
	movq	0(%rbp), %rdx
	movslq	%eax, %rcx
	movq	%rdx, 88(%rbx)
	movq	472(%r12), %rdx
	testq	%rdx, %rdx
	je	.L564
	cmpq	%rcx, %rdx
	ja	.L632
	subl	%edx, %eax
	movq	$0, 472(%r12)
	movslq	%eax, %rcx
.L564:
	movq	8(%rbx), %rsi
	movq	%rcx, %rdx
	movq	%rcx, %rax
	addq	136(%rbx), %rdx
	movl	56(%rbx), %edi
	addq	200(%rsi), %rax
	testl	%edi, %edi
	movq	%rdx, 136(%rbx)
	movq	%rax, 200(%rsi)
	jle	.L569
	movslq	16(%rbx), %r8
	movq	throttles(%rip), %rsi
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$1, %edi
	je	.L569
	movslq	20(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$2, %edi
	je	.L569
	movslq	24(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$3, %edi
	je	.L569
	movslq	28(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$4, %edi
	je	.L569
	movslq	32(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$5, %edi
	je	.L569
	movslq	36(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$6, %edi
	je	.L569
	movslq	40(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$7, %edi
	je	.L569
	movslq	44(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$8, %edi
	je	.L569
	movslq	48(%rbx), %r8
	leaq	(%r8,%r8,2), %r8
	salq	$4, %r8
	addq	%rcx, 32(%rsi,%r8)
	cmpl	$9, %edi
	je	.L569
	movslq	52(%rbx), %rdi
	leaq	(%rdi,%rdi,2), %rdi
	salq	$4, %rdi
	addq	%rcx, 32(%rsi,%rdi)
.L569:
	cmpq	128(%rbx), %rdx
	jge	.L633
	movq	112(%rbx), %rdx
	cmpq	$100, %rdx
	jg	.L634
.L570:
	movq	64(%rbx), %rcx
	cmpq	$-1, %rcx
	je	.L550
	movq	0(%rbp), %r13
	subq	80(%rbx), %r13
	movl	$1, %edx
	cmove	%rdx, %r13
	cqto
	idivq	%r13
	cmpq	%rax, %rcx
	jge	.L550
	movl	704(%r12), %edi
	movl	$3, (%rbx)
	call	fdwatch_del_fd
	movq	8(%rbx), %rax
	movq	200(%rax), %rax
	cqto
	idivq	64(%rbx)
	movl	%eax, %r12d
	subl	%r13d, %r12d
	cmpq	$0, 96(%rbx)
	je	.L572
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L572:
	testl	%r12d, %r12d
	movl	$500, %ecx
	jle	.L629
	movslq	%r12d, %r12
	imulq	$1000, %r12, %rcx
	jmp	.L629
	.p2align 4,,10
	.p2align 3
.L552:
	movq	368(%r12), %rcx
	movq	%rax, 8(%rsp)
	movq	128(%rbx), %rsi
	movq	136(%rbx), %rax
	movl	704(%r12), %edi
	movq	%rcx, (%rsp)
	subq	%rax, %rsi
	movq	%rax, %rcx
	addq	712(%r12), %rcx
	cmpq	%rdx, %rsi
	cmovbe	%rsi, %rdx
	movq	%rsp, %rsi
	movq	%rdx, 24(%rsp)
	movl	$2, %edx
	movq	%rcx, 16(%rsp)
	call	writev
	testl	%eax, %eax
	jns	.L554
.L631:
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L550
	cmpl	$11, %eax
	je	.L557
	cmpl	$32, %eax
	setne	%cl
	cmpl	$22, %eax
	setne	%dl
	testb	%dl, %cl
	je	.L561
	cmpl	$104, %eax
	je	.L561
	movq	208(%r12), %rdx
	movl	$.LC93, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L561:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	clear_connection
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L557:
	.cfi_restore_state
	addq	$100, 112(%rbx)
	movl	704(%r12), %edi
	movl	$3, (%rbx)
	call	fdwatch_del_fd
	cmpq	$0, 96(%rbx)
	je	.L560
	movl	$.LC91, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
.L560:
	movq	112(%rbx), %rcx
.L629:
	xorl	%r8d, %r8d
	movq	%rbx, %rdx
	movl	$wakeup_connection, %esi
	movq	%rbp, %rdi
	call	tmr_create
	testq	%rax, %rax
	movq	%rax, 96(%rbx)
	je	.L635
.L550:
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L634:
	.cfi_restore_state
	subq	$100, %rdx
	movq	%rdx, 112(%rbx)
	jmp	.L570
	.p2align 4,,10
	.p2align 3
.L632:
	movq	368(%r12), %rdi
	subl	%eax, %edx
	movslq	%edx, %r13
	movq	%r13, %rdx
	leaq	(%rdi,%rcx), %rsi
	call	memmove
	movq	%r13, 472(%r12)
	xorl	%ecx, %ecx
	jmp	.L564
	.p2align 4,,10
	.p2align 3
.L633:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	finish_connection
	addq	$40, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%rbp
	.cfi_def_cfa_offset 24
	popq	%r12
	.cfi_def_cfa_offset 16
	popq	%r13
	.cfi_def_cfa_offset 8
	ret
.L635:
	.cfi_restore_state
	movl	$2, %edi
	movl	$.LC92, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE21:
	.size	handle_send, .-handle_send
	.p2align 4,,15
	.type	linger_clear_connection, @function
linger_clear_connection:
.LFB31:
	.cfi_startproc
	movq	$0, 104(%rdi)
	jmp	really_clear_connection
	.cfi_endproc
.LFE31:
	.size	linger_clear_connection, .-linger_clear_connection
	.p2align 4,,15
	.type	handle_linger, @function
handle_linger:
.LFB22:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	movq	%rdi, %rbx
	movq	%rsi, %rbp
	movl	$4096, %edx
	subq	$4104, %rsp
	.cfi_def_cfa_offset 4128
	movq	8(%rdi), %rax
	movq	%rsp, %rsi
	movl	704(%rax), %edi
	call	read
	testl	%eax, %eax
	js	.L642
	je	.L640
.L637:
	addq	$4104, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.p2align 4,,10
	.p2align 3
.L642:
	.cfi_restore_state
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L637
	cmpl	$11, %eax
	je	.L637
.L640:
	movq	%rbp, %rsi
	movq	%rbx, %rdi
	call	really_clear_connection
	addq	$4104, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	handle_linger, .-handle_linger
	.section	.rodata.str1.1
.LC94:
	.string	"%d"
.LC95:
	.string	"getaddrinfo %.80s - %.80s"
.LC96:
	.string	"%s: getaddrinfo %s - %s\n"
	.section	.rodata.str1.8
	.align 8
.LC97:
	.string	"%.80s - sockaddr too small (%lu < %lu)"
	.text
	.p2align 4,,15
	.type	lookup_hostname.constprop.1, @function
lookup_hostname.constprop.1:
.LFB37:
	.cfi_startproc
	pushq	%r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	pushq	%r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	xorl	%eax, %eax
	pushq	%r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	movq	%rcx, %r13
	pushq	%rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	movq	%rdi, %rbp
	movl	$6, %ecx
	movq	%rsi, %r12
	movq	%rdx, %r14
	movl	$10, %esi
	subq	$80, %rsp
	.cfi_def_cfa_offset 128
	movl	$.LC94, %edx
	leaq	32(%rsp), %rbx
	movq	%rbx, %rdi
	rep stosq
	movzwl	port(%rip), %ecx
	leaq	16(%rsp), %rdi
	movl	$1, 32(%rsp)
	movl	$1, 40(%rsp)
	call	snprintf
	movq	hostname(%rip), %rdi
	leaq	8(%rsp), %rcx
	leaq	16(%rsp), %rsi
	movq	%rbx, %rdx
	call	getaddrinfo
	testl	%eax, %eax
	jne	.L662
	movq	8(%rsp), %rax
	testq	%rax, %rax
	je	.L645
	xorl	%ebx, %ebx
	xorl	%esi, %esi
	jmp	.L649
	.p2align 4,,10
	.p2align 3
.L664:
	cmpl	$10, %edx
	jne	.L646
	testq	%rsi, %rsi
	cmove	%rax, %rsi
.L646:
	movq	40(%rax), %rax
	testq	%rax, %rax
	je	.L663
.L649:
	movl	4(%rax), %edx
	cmpl	$2, %edx
	jne	.L664
	testq	%rbx, %rbx
	cmove	%rax, %rbx
	movq	40(%rax), %rax
	testq	%rax, %rax
	jne	.L649
.L663:
	testq	%rsi, %rsi
	je	.L665
	movl	16(%rsi), %r8d
	cmpq	$128, %r8
	ja	.L661
	movl	$16, %ecx
	movq	%r14, %rdi
	rep stosq
	movq	%r14, %rdi
	movl	16(%rsi), %edx
	movq	24(%rsi), %rsi
	call	memmove
	movl	$1, 0(%r13)
.L651:
	testq	%rbx, %rbx
	je	.L666
	movl	16(%rbx), %r8d
	cmpq	$128, %r8
	ja	.L661
	xorl	%eax, %eax
	movl	$16, %ecx
	movq	%rbp, %rdi
	rep stosq
	movq	%rbp, %rdi
	movl	16(%rbx), %edx
	movq	24(%rbx), %rsi
	call	memmove
	movl	$1, (%r12)
.L654:
	movq	8(%rsp), %rdi
	call	freeaddrinfo
	addq	$80, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx
	.cfi_def_cfa_offset 40
	popq	%rbp
	.cfi_def_cfa_offset 32
	popq	%r12
	.cfi_def_cfa_offset 24
	popq	%r13
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	ret
.L665:
	.cfi_restore_state
	movq	%rbx, %rax
.L645:
	movl	$0, 0(%r13)
	movq	%rax, %rbx
	jmp	.L651
.L666:
	movl	$0, (%r12)
	jmp	.L654
.L661:
	movq	hostname(%rip), %rdx
	movl	$2, %edi
	movl	$128, %ecx
	movl	$.LC97, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L662:
	movl	%eax, %edi
	movl	%eax, %ebx
	call	gai_strerror
	movq	hostname(%rip), %rdx
	movq	%rax, %rcx
	movl	$.LC95, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	%ebx, %edi
	call	gai_strerror
	movq	stderr(%rip), %rdi
	movq	hostname(%rip), %rcx
	movq	%rax, %r8
	movq	argv0(%rip), %rdx
	movl	$.LC96, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
	.cfi_endproc
.LFE37:
	.size	lookup_hostname.constprop.1, .-lookup_hostname.constprop.1
	.section	.rodata.str1.1
.LC98:
	.string	"can't find any valid address"
	.section	.rodata.str1.8
	.align 8
.LC99:
	.string	"%s: can't find any valid address\n"
	.section	.rodata.str1.1
.LC100:
	.string	"unknown user - '%.80s'"
.LC101:
	.string	"%s: unknown user - '%s'\n"
.LC102:
	.string	"/dev/null"
	.section	.rodata.str1.8
	.align 8
.LC103:
	.string	"logfile is not an absolute path, you may not be able to re-open it"
	.align 8
.LC104:
	.string	"%s: logfile is not an absolute path, you may not be able to re-open it\n"
	.section	.rodata.str1.1
.LC105:
	.string	"fchown logfile - %m"
.LC106:
	.string	"fchown logfile"
.LC107:
	.string	"chdir - %m"
.LC108:
	.string	"chdir"
.LC109:
	.string	"daemon - %m"
.LC110:
	.string	"w"
.LC111:
	.string	"%d\n"
	.section	.rodata.str1.8
	.align 8
.LC112:
	.string	"fdwatch initialization failure"
	.section	.rodata.str1.1
.LC113:
	.string	"chroot - %m"
	.section	.rodata.str1.8
	.align 8
.LC114:
	.string	"logfile is not within the chroot tree, you will not be able to re-open it"
	.align 8
.LC115:
	.string	"%s: logfile is not within the chroot tree, you will not be able to re-open it\n"
	.section	.rodata.str1.1
.LC116:
	.string	"chroot chdir - %m"
.LC117:
	.string	"chroot chdir"
.LC118:
	.string	"data_dir chdir - %m"
.LC119:
	.string	"data_dir chdir"
.LC120:
	.string	"tmr_create(occasional) failed"
.LC121:
	.string	"tmr_create(idle) failed"
	.section	.rodata.str1.8
	.align 8
.LC122:
	.string	"tmr_create(update_throttles) failed"
	.section	.rodata.str1.1
.LC123:
	.string	"tmr_create(show_stats) failed"
.LC124:
	.string	"setgroups - %m"
.LC125:
	.string	"setgid - %m"
.LC126:
	.string	"initgroups - %m"
.LC127:
	.string	"setuid - %m"
	.section	.rodata.str1.8
	.align 8
.LC128:
	.string	"started as root without requesting chroot(), warning only"
	.align 8
.LC129:
	.string	"out of memory allocating a connecttab"
	.section	.rodata.str1.1
.LC130:
	.string	"fdwatch - %m"
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB9:
	.cfi_startproc
	pushq	%r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	pushq	%r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	movl	%edi, %r12d
	pushq	%rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	movq	%rsi, %rbp
	subq	$4424, %rsp
	.cfi_def_cfa_offset 4480
	movq	(%rsi), %rbx
	movl	$47, %esi
	movq	%rbx, %rdi
	movq	%rbx, argv0(%rip)
	call	strrchr
	leaq	1(%rax), %rdx
	testq	%rax, %rax
	movl	$9, %esi
	cmovne	%rdx, %rbx
	movl	$24, %edx
	movq	%rbx, %rdi
	call	openlog
	movq	%rbp, %rsi
	movl	%r12d, %edi
	leaq	176(%rsp), %rbp
	leaq	48(%rsp), %r12
	call	parse_args
	call	tzset
	leaq	28(%rsp), %rcx
	leaq	24(%rsp), %rsi
	movq	%rbp, %rdx
	movq	%r12, %rdi
	call	lookup_hostname.constprop.1
	movl	24(%rsp), %ecx
	testl	%ecx, %ecx
	jne	.L669
	cmpl	$0, 28(%rsp)
	je	.L804
.L669:
	movq	throttlefile(%rip), %rdi
	movl	$0, numthrottles(%rip)
	movl	$0, maxthrottles(%rip)
	movq	$0, throttles(%rip)
	testq	%rdi, %rdi
	je	.L670
	call	read_throttlefile
.L670:
	call	getuid
	testl	%eax, %eax
	movl	$32767, %r15d
	movl	$32767, 4(%rsp)
	je	.L805
.L671:
	movq	logfile(%rip), %rbx
	testq	%rbx, %rbx
	je	.L741
	movl	$.LC102, %edi
	movl	$10, %ecx
	movq	%rbx, %rsi
	repz cmpsb
	je	.L806
	movl	$.LC77, %esi
	movq	%rbx, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L675
	movq	stdout(%rip), %r14
.L673:
	movq	dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L679
	call	chdir
	testl	%eax, %eax
	js	.L807
.L679:
	leaq	304(%rsp), %rbx
	movl	$4096, %esi
	movq	%rbx, %rdi
	call	getcwd
	movq	%rbx, %rdx
.L680:
	movl	(%rdx), %ecx
	addq	$4, %rdx
	leal	-16843009(%rcx), %eax
	notl	%ecx
	andl	%ecx, %eax
	andl	$-2139062144, %eax
	je	.L680
	movl	%eax, %ecx
	shrl	$16, %ecx
	testl	$32896, %eax
	cmove	%ecx, %eax
	leaq	2(%rdx), %rcx
	cmove	%rcx, %rdx
	movl	%eax, %ecx
	addb	%al, %cl
	sbbq	$3, %rdx
	subq	%rbx, %rdx
	cmpb	$47, 303(%rsp,%rdx)
	je	.L682
	movw	$47, (%rbx,%rdx)
.L682:
	movl	debug(%rip), %edx
	testl	%edx, %edx
	jne	.L683
	movq	stdin(%rip), %rdi
	call	fclose
	movq	stdout(%rip), %rdi
	cmpq	%rdi, %r14
	je	.L684
	call	fclose
.L684:
	movq	stderr(%rip), %rdi
	call	fclose
	movl	$1, %esi
	movl	$1, %edi
	call	daemon
	testl	%eax, %eax
	movl	$.LC109, %esi
	js	.L802
.L685:
	movq	pidfile(%rip), %rdi
	testq	%rdi, %rdi
	je	.L686
	movl	$.LC110, %esi
	call	fopen
	testq	%rax, %rax
	movq	%rax, %r13
	je	.L808
	call	getpid
	movq	%r13, %rdi
	movl	%eax, %edx
	movl	$.LC111, %esi
	xorl	%eax, %eax
	call	fprintf
	movq	%r13, %rdi
	call	fclose
.L686:
	call	fdwatch_get_nfiles
	testl	%eax, %eax
	movl	%eax, max_connects(%rip)
	js	.L809
	subl	$10, %eax
	cmpl	$0, do_chroot(%rip)
	movl	%eax, max_connects(%rip)
	jne	.L810
.L689:
	movq	data_dir(%rip), %rdi
	testq	%rdi, %rdi
	je	.L693
	call	chdir
	testl	%eax, %eax
	js	.L811
.L693:
	movl	$handle_term, %esi
	movl	$15, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_term, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_chld, %esi
	movl	$17, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$1, %esi
	movl	$13, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_hup, %esi
	movl	$1, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr1, %esi
	movl	$10, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_usr2, %esi
	movl	$12, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$handle_alrm, %esi
	movl	$14, %edi
	xorl	%eax, %eax
	call	sigset
	movl	$360, %edi
	movl	$0, got_hup(%rip)
	movl	$0, got_usr1(%rip)
	movl	$0, watchdog_flag(%rip)
	call	alarm
	call	tmr_init
	xorl	%esi, %esi
	cmpl	$0, 28(%rsp)
	movl	no_empty_referers(%rip), %eax
	movq	%rbp, %rdx
	movzwl	port(%rip), %ecx
	movl	cgi_limit(%rip), %r9d
	movq	cgi_pattern(%rip), %r8
	movq	hostname(%rip), %rdi
	cmove	%rsi, %rdx
	cmpl	$0, 24(%rsp)
	pushq	%rax
	.cfi_def_cfa_offset 4488
	movl	do_global_passwd(%rip), %eax
	pushq	local_pattern(%rip)
	.cfi_def_cfa_offset 4496
	pushq	url_pattern(%rip)
	.cfi_def_cfa_offset 4504
	pushq	%rax
	.cfi_def_cfa_offset 4512
	movl	do_vhost(%rip), %eax
	cmovne	%r12, %rsi
	pushq	%rax
	.cfi_def_cfa_offset 4520
	movl	no_symlink_check(%rip), %eax
	pushq	%rax
	.cfi_def_cfa_offset 4528
	movl	no_log(%rip), %eax
	pushq	%r14
	.cfi_def_cfa_offset 4536
	pushq	%rax
	.cfi_def_cfa_offset 4544
	movl	max_age(%rip), %eax
	pushq	%rbx
	.cfi_def_cfa_offset 4552
	pushq	%rax
	.cfi_def_cfa_offset 4560
	pushq	p3p(%rip)
	.cfi_def_cfa_offset 4568
	pushq	charset(%rip)
	.cfi_def_cfa_offset 4576
	call	httpd_initialize
	addq	$96, %rsp
	.cfi_def_cfa_offset 4480
	testq	%rax, %rax
	movq	%rax, hs(%rip)
	je	.L803
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$120000, %ecx
	movl	$occasional, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L812
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$5000, %ecx
	movl	$idle, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L813
	cmpl	$0, numthrottles(%rip)
	jle	.L699
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$2000, %ecx
	movl	$update_throttles, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L814
.L699:
	movq	JunkClientData(%rip), %rdx
	xorl	%edi, %edi
	movl	$1, %r8d
	movl	$3600000, %ecx
	movl	$show_stats, %esi
	call	tmr_create
	testq	%rax, %rax
	je	.L815
	xorl	%edi, %edi
	call	time
	movq	$0, stats_connections(%rip)
	movq	%rax, stats_time(%rip)
	movq	%rax, start_time(%rip)
	movq	$0, stats_bytes(%rip)
	movl	$0, stats_simultaneous(%rip)
	call	getuid
	testl	%eax, %eax
	jne	.L702
	xorl	%esi, %esi
	xorl	%edi, %edi
	call	setgroups
	testl	%eax, %eax
	movl	$.LC124, %esi
	js	.L802
	movl	%r15d, %edi
	call	setgid
	testl	%eax, %eax
	movl	$.LC125, %esi
	js	.L802
	movq	user(%rip), %rdi
	movl	%r15d, %esi
	call	initgroups
	testl	%eax, %eax
	js	.L816
.L705:
	movl	4(%rsp), %edi
	call	setuid
	testl	%eax, %eax
	movl	$.LC127, %esi
	js	.L802
	cmpl	$0, do_chroot(%rip)
	je	.L817
.L702:
	movslq	max_connects(%rip), %rbp
	movq	%rbp, %rbx
	imulq	$144, %rbp, %rbp
	movq	%rbp, %rdi
	call	malloc
	testq	%rax, %rax
	movq	%rax, connects(%rip)
	je	.L708
	xorl	%ecx, %ecx
	testl	%ebx, %ebx
	movq	%rax, %rdx
	jle	.L713
	.p2align 4,,10
	.p2align 3
.L781:
	addl	$1, %ecx
	movl	$0, (%rdx)
	movq	$0, 8(%rdx)
	movl	%ecx, 4(%rdx)
	addq	$144, %rdx
	cmpl	%ecx, %ebx
	jne	.L781
.L713:
	movl	$-1, -140(%rax,%rbp)
	movq	hs(%rip), %rax
	movl	$0, first_free_connect(%rip)
	movl	$0, num_connects(%rip)
	movl	$0, httpd_conn_count(%rip)
	testq	%rax, %rax
	je	.L714
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L715
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
	movq	hs(%rip), %rax
.L715:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L714
	xorl	%edx, %edx
	xorl	%esi, %esi
	call	fdwatch_add_fd
.L714:
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
	.p2align 4,,10
	.p2align 3
.L716:
	movl	terminate(%rip), %eax
	testl	%eax, %eax
	je	.L739
	cmpl	$0, num_connects(%rip)
	jle	.L818
.L739:
	movl	got_hup(%rip), %eax
	testl	%eax, %eax
	jne	.L819
.L717:
	leaq	32(%rsp), %rdi
	call	tmr_mstimeout
	movq	%rax, %rdi
	call	fdwatch
	testl	%eax, %eax
	movl	%eax, %ebx
	js	.L820
	leaq	32(%rsp), %rdi
	call	tmr_prepare_timeval
	testl	%ebx, %ebx
	je	.L821
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L730
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L725
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L726
.L729:
	movq	hs(%rip), %rax
	testq	%rax, %rax
	je	.L730
.L725:
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L730
	call	fdwatch_check_fd
	testl	%eax, %eax
	jne	.L822
	.p2align 4,,10
	.p2align 3
.L730:
	call	fdwatch_get_next_client_data
	cmpq	$-1, %rax
	movq	%rax, %rbx
	je	.L823
	testq	%rbx, %rbx
	je	.L730
	movq	8(%rbx), %rax
	movl	704(%rax), %edi
	call	fdwatch_check_fd
	testl	%eax, %eax
	je	.L824
	movl	(%rbx), %eax
	cmpl	$2, %eax
	je	.L733
	cmpl	$4, %eax
	je	.L734
	cmpl	$1, %eax
	jne	.L730
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_read
	jmp	.L730
.L806:
	movl	$1, no_log(%rip)
	xorl	%r14d, %r14d
	jmp	.L673
.L683:
	call	setsid
	jmp	.L685
.L809:
	movl	$.LC112, %esi
.L802:
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
.L803:
	movl	$1, %edi
	call	exit
.L805:
	movq	user(%rip), %rdi
	call	getpwnam
	testq	%rax, %rax
	je	.L825
	movl	16(%rax), %ecx
	movl	20(%rax), %r15d
	movl	%ecx, 4(%rsp)
	jmp	.L671
.L804:
	movl	$.LC98, %esi
	movl	$3, %edi
	xorl	%eax, %eax
	call	syslog
	movq	stderr(%rip), %rdi
	movq	argv0(%rip), %rdx
	movl	$.LC99, %esi
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L824:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	clear_connection
	jmp	.L730
.L820:
	call	__errno_location
	movl	(%rax), %eax
	cmpl	$4, %eax
	je	.L716
	cmpl	$11, %eax
	je	.L716
	movl	$3, %edi
	movl	$.LC130, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L734:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_linger
	jmp	.L730
.L733:
	leaq	32(%rsp), %rsi
	movq	%rbx, %rdi
	call	handle_send
	jmp	.L730
.L823:
	leaq	32(%rsp), %rdi
	call	tmr_run
	movl	got_usr1(%rip), %eax
	testl	%eax, %eax
	je	.L716
	cmpl	$0, terminate(%rip)
	jne	.L716
	movq	hs(%rip), %rax
	movl	$1, terminate(%rip)
	testq	%rax, %rax
	je	.L716
	movl	72(%rax), %edi
	cmpl	$-1, %edi
	je	.L737
	call	fdwatch_del_fd
	movq	hs(%rip), %rax
.L737:
	movl	76(%rax), %edi
	cmpl	$-1, %edi
	je	.L738
	call	fdwatch_del_fd
.L738:
	movq	hs(%rip), %rdi
	call	httpd_unlisten
	jmp	.L716
.L819:
	call	re_open_logfile
	movl	$0, got_hup(%rip)
	jmp	.L717
.L821:
	leaq	32(%rsp), %rdi
	call	tmr_run
	jmp	.L716
.L810:
	movq	%rbx, %rdi
	call	chroot
	testl	%eax, %eax
	js	.L826
	movq	logfile(%rip), %r13
	testq	%r13, %r13
	je	.L691
	movl	$.LC77, %esi
	movq	%r13, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L691
	xorl	%eax, %eax
	orq	$-1, %rcx
	movq	%rbx, %rdi
	repnz scasb
	movq	%rbx, %rsi
	movq	%r13, %rdi
	notq	%rcx
	leaq	-1(%rcx), %rdx
	movq	%rcx, 8(%rsp)
	call	strncmp
	testl	%eax, %eax
	jne	.L692
	movq	8(%rsp), %rcx
	movq	%r13, %rdi
	leaq	-2(%r13,%rcx), %rsi
	call	strcpy
.L691:
	movq	%rbx, %rdi
	movw	$47, 304(%rsp)
	call	chdir
	testl	%eax, %eax
	jns	.L689
	movl	$.LC116, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC117, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L741:
	xorl	%r14d, %r14d
	jmp	.L673
.L675:
	movq	%rbx, %rdi
	movl	$.LC79, %esi
	call	fopen
	movq	logfile(%rip), %rbx
	movq	%rax, %r14
	movl	$384, %esi
	movq	%rbx, %rdi
	call	chmod
	testq	%r14, %r14
	je	.L744
	testl	%eax, %eax
	jne	.L744
	cmpb	$47, (%rbx)
	je	.L678
	movl	$.LC103, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC104, %esi
	xorl	%eax, %eax
	call	fprintf
.L678:
	movq	%r14, %rdi
	call	fileno
	movl	$1, %edx
	movl	%eax, %edi
	movl	$2, %esi
	xorl	%eax, %eax
	call	fcntl
	call	getuid
	testl	%eax, %eax
	jne	.L673
	movq	%r14, %rdi
	call	fileno
	movl	4(%rsp), %esi
	movl	%r15d, %edx
	movl	%eax, %edi
	call	fchown
	testl	%eax, %eax
	jns	.L673
	movl	$.LC105, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC106, %edi
	call	perror
	jmp	.L673
.L807:
	movl	$.LC107, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC108, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L808:
	movq	pidfile(%rip), %rdx
	movl	$2, %edi
	movl	$.LC69, %esi
	xorl	%eax, %eax
	call	syslog
	movl	$1, %edi
	call	exit
.L812:
	movl	$2, %edi
	movl	$.LC120, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L811:
	movl	$.LC118, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC119, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L692:
	xorl	%eax, %eax
	movl	$.LC114, %esi
	movl	$4, %edi
	call	syslog
	movq	argv0(%rip), %rdx
	movq	stderr(%rip), %rdi
	movl	$.LC115, %esi
	xorl	%eax, %eax
	call	fprintf
	jmp	.L691
.L817:
	movl	$.LC128, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L702
.L814:
	movl	$2, %edi
	movl	$.LC122, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L726:
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	76(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L716
	jmp	.L729
.L822:
	movq	hs(%rip), %rax
	leaq	32(%rsp), %rdi
	movl	72(%rax), %esi
	call	handle_newconnect
	testl	%eax, %eax
	jne	.L716
	jmp	.L730
.L815:
	movl	$2, %edi
	movl	$.LC123, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L744:
	movq	%rbx, %rdx
	movl	$.LC69, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movq	logfile(%rip), %rdi
	call	perror
	movl	$1, %edi
	call	exit
.L818:
	call	shut_down
	movl	$5, %edi
	movl	$.LC85, %esi
	xorl	%eax, %eax
	call	syslog
	call	closelog
	xorl	%edi, %edi
	call	exit
.L813:
	movl	$2, %edi
	movl	$.LC121, %esi
	call	syslog
	movl	$1, %edi
	call	exit
.L826:
	movl	$.LC113, %esi
	movl	$2, %edi
	xorl	%eax, %eax
	call	syslog
	movl	$.LC17, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L825:
	movq	user(%rip), %rdx
	movl	$.LC100, %esi
	movl	$2, %edi
	call	syslog
	movq	stderr(%rip), %rdi
	movq	user(%rip), %rcx
	movl	$.LC101, %esi
	movq	argv0(%rip), %rdx
	xorl	%eax, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L708:
	movl	$.LC129, %esi
	jmp	.L802
.L816:
	movl	$.LC126, %esi
	movl	$4, %edi
	xorl	%eax, %eax
	call	syslog
	jmp	.L705
	.cfi_endproc
.LFE9:
	.size	main, .-main
	.local	watchdog_flag
	.comm	watchdog_flag,4,4
	.local	got_usr1
	.comm	got_usr1,4,4
	.local	got_hup
	.comm	got_hup,4,4
	.comm	stats_simultaneous,4,4
	.comm	stats_bytes,8,8
	.comm	stats_connections,8,8
	.comm	stats_time,8,8
	.comm	start_time,8,8
	.globl	terminate
	.bss
	.align 4
	.type	terminate, @object
	.size	terminate, 4
terminate:
	.zero	4
	.local	hs
	.comm	hs,8,8
	.local	httpd_conn_count
	.comm	httpd_conn_count,4,4
	.local	first_free_connect
	.comm	first_free_connect,4,4
	.local	max_connects
	.comm	max_connects,4,4
	.local	num_connects
	.comm	num_connects,4,4
	.local	connects
	.comm	connects,8,8
	.local	maxthrottles
	.comm	maxthrottles,4,4
	.local	numthrottles
	.comm	numthrottles,4,4
	.local	throttles
	.comm	throttles,8,8
	.local	max_age
	.comm	max_age,4,4
	.local	p3p
	.comm	p3p,8,8
	.local	charset
	.comm	charset,8,8
	.local	user
	.comm	user,8,8
	.local	pidfile
	.comm	pidfile,8,8
	.local	hostname
	.comm	hostname,8,8
	.local	throttlefile
	.comm	throttlefile,8,8
	.local	logfile
	.comm	logfile,8,8
	.local	local_pattern
	.comm	local_pattern,8,8
	.local	no_empty_referers
	.comm	no_empty_referers,4,4
	.local	url_pattern
	.comm	url_pattern,8,8
	.local	cgi_limit
	.comm	cgi_limit,4,4
	.local	cgi_pattern
	.comm	cgi_pattern,8,8
	.local	do_global_passwd
	.comm	do_global_passwd,4,4
	.local	do_vhost
	.comm	do_vhost,4,4
	.local	no_symlink_check
	.comm	no_symlink_check,4,4
	.local	no_log
	.comm	no_log,4,4
	.local	do_chroot
	.comm	do_chroot,4,4
	.local	data_dir
	.comm	data_dir,8,8
	.local	dir
	.comm	dir,8,8
	.local	port
	.comm	port,2,2
	.local	debug
	.comm	debug,4,4
	.local	argv0
	.comm	argv0,8,8
	.ident	"GCC: (GNU) 6.3.0"
	.section	.note.GNU-stack,"",@progbits
