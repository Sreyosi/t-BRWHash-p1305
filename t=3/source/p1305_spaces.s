.bss
.globl squares
.globl h_kp
.globl stack
.globl key
squares: .space 32000 

stack: .space 32000
key: .space 192

.data
.globl length
.globl mask62
.globl zero
.globl constant
.globl mask62_upper
.globl p0
.globl p1
.globl p2
.p2align 4
zero: .quad 0x0
mask62: .quad 0x3
constant: .quad 0xa000000000000000
length: .quad 0x0
mask62_upper: .quad 0xfffffffffffffffc
p0	: .quad 0xFFFFFFFFFFFFFFFB
p1	: .quad 0xFFFFFFFFFFFFFFFF
p2	: .quad 0x0000000000000003

