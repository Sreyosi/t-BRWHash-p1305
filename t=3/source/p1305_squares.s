.p2align 5
.globl p1305square
p1305square:


movq %rbp,%r11
movq %rsp, %rbp

subq $200, %rsp

movq    %r11, -8(%rbp)
movq    %rbx, -16(%rbp)
movq    %r12, -24(%rbp)
movq    %r13, -32(%rbp)
movq    %r14, -40(%rbp)
movq    %r15, -48(%rbp)


movq %rsi, %r11

movq 0(%rdi), %rcx

movq 8(%rdi), %rbx

leaq squares, %rdi

movq %rdi, -72(%rbp)


/***  copy key...tau^1 ****/

movq %rcx, 0(%rdi)

movq %rbx, 8(%rdi) 

addq $16, %rdi 

xorq %rax, %rax

subq    $1, %r11

movq %rcx, %rdx

mulx %rbx, %r8, %r9

movq $0, %r10
shld $1, %r9, %r10
shld $1, %r8, %r9
shlq $1, %r8 

mulx %rdx, %rcx, %r14 
addq %r14, %r8

movq %rbx, %rdx

mulx %rdx, %rbx, %r15
adcx %rbx, %r9
adcx %r15, %r10

movq %r9, %r14
andq mask62,%r9
andq mask62_upper,%r14
addq %r14,%rcx
adcq %r10,%r8
adcq $0,%r9
shrd $2,%r10,%r14
shrq $2,%r10
addq %r14, %rcx
adcq %r10,%r8
adcq $0,%r9

movq %r9,%r13
andq mask62,%r9
shrq $2,%r13
imul $5,%r13,%r13
addq %r13,%rcx
adcq $0,%r8
adcq $0,%r9
		

movq %r9,%r13
andq mask62,%r9
shrq $2,%r13
imul $5,%r13,%r13
addq %r13,%rcx
adcq $0,%r8
adcq $0,%r9


movq %rcx, 0(%rdi)

movq %r8, 8(%rdi)

movq %r9, 16(%rdi)

cmpq $0, %r11
jle sq

addq $24, %rdi

.START:

subq    $1, %r11



movq %rcx, %rdx

mulx %r8, %r10, %r12

mulx %r9, %r14, %r15

movq %r8, %rdx


mulx %r9, %rbx, %r13

adcx %r14, %r12
adcx %rbx, %r15
adcx zero, %r13

shld $1, %r15, %r13
shld $1, %r12, %r15
shld $1, %r10, %r12
shlq $1, %r10

movq %rcx, %rdx

mulx %rdx, %rcx, %rbx
addq %rbx, %r10

movq %r8, %rdx

mulx %rdx, %r8, %rax
adcx  %r12, %r8
adcx %rax, %r15


movq %r9, %rdx

mulx %rdx, %r9, %r14
adcx %r13, %r9


movq %r8, %r14
andq mask62,%r8
andq mask62_upper,%r14
addq %r14,%rcx
adcq %r15,%r10
adcq %r9,%r8
shrd $2,%r15,%r14
shrd $2,%r9,%r15
shrq $2,%r9
addq %r14, %rcx
adcq %r15,%r10
adcq %r8,%r9

movq %r9,%r13
andq mask62,%r9
shrq $2,%r13
imul $5,%r13,%r13
addq %r13,%rcx
adcq $0,%r10
adcq $0,%r9
		

movq %r9,%r13
andq mask62,%r9
shrq $2,%r13
imul $5,%r13,%r13
addq %r13,%rcx
adcq $0,%r10
adcq $0,%r9


movq %r10, %r8

movq %rcx, 0(%rdi)

movq %r8, 8(%rdi)

movq %r9, 16(%rdi)

addq $24, %rdi



cmpq $0, %r11

jnz .START

sq: movq    -8(%rbp),%r11
movq    -16(%rbp),%rbx
movq    -24(%rbp),%r12
movq    -32(%rbp),%r13
movq    -40(%rbp),%r14
movq    -48(%rbp),%r15

addq $200, %rsp

movq %rbp, %rsp
movq %r11, %rbp


ret












 






