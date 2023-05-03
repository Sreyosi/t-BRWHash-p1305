.include "../source/p1305_macros.s"
.globl p1305_nrBRW_computation
p1305_nrBRW_computation:

/*Parameters passed to p1305_nrBRW_computation by caller: rdi=no of bits, rsi=points to input message, rdx= points to input key, rcx=points to output*/


subq $600, %rsp

movq %rbx, 16(%rsp)
movq %r12, 24(%rsp)
movq %r13, 32(%rsp)
movq %r14, 40(%rsp)
movq %r15, 48(%rsp)
movq %rbp, 56(%rsp)
movq %rdx, 72(%rsp)
movq %rcx, 104(%rsp)



/*compute no_of_16-byte-blocks*/
xorq %rdx, %rdx
movq %rdi, %rax
movq %rax, 112(%rsp)

/*** load the effective address of the memory where the squares have been stored ***/
leaq squares, %rdi
movq %rdi, 64(%rsp)
/**********************************************************************************/


movq $128, %r12
divq %r12 /* divq requires dividend to be in rdx:rax..returns quotient in rax and remainder in rdx */

/*increase no_of_blocks by 1 if there is imperfect last block*/
cmp $0, %rdx
je no_imperfect_block
inc %rax
no_imperfect_block: movq %rax, 80(%rsp)
movq $0, %r8
movq $0, %r9
movq $0, %r10
movq $0, %r11
movq $0, %r12
cmp $15, %rax
jle only_horner /**** jump to the extra section if number of blocks is at most 15*****/ 



     /**** For larger messages we need to compute number of chunks of blocks of input messages with number of look-ahead blocks(in this that no of look-ahead blocks is 16)********/ 
     comp_lookahead:    /*compute no of perfect chunks of look-ahead blocks*/

               
		
		xorq %rdx, %rdx
		movq $16, %r12
		divq %r12 
		movq %rdx, 80(%rsp)
		movq %rax, 88(%rsp) /*store the number of perfect look-ahead blocks*/
		leaq squares, %rdi
                movq %rdi, 64(%rsp)
       

    
    
     /* prepare stack and other iteration details*/
     movq $1, 96(%rsp)
   
     leaq stack, %r9 
     movq %r9, 160(%rsp)
     movq %r9, 168(%rsp)
     movq $0, 120(%rsp)

/*nrBRW Computation for messsages at least  16-block long*/
        
start:          movq 64(%rsp), %rdx
               
                /* m6+(tau^2) */
		
		prepare_and_add_store_1 80(%rsi), 88(%rsi), 16(%rdx), 24(%rdx), 32(%rdx), %rax, %rbx, %rcx
		
		
		
		/*** m2+tau^2 ***/
			
		prepare_and_add 16(%rsi), 24(%rsi), %r11, %r12, %r13, %r14, %r15, %rdi
		
		 
		/*  m5+tau  */

		movq 64(%rsp), %rdx
		
		prepare_and_add_store_2 64(%rsi), 72(%rsi), 0(%rdx), 8(%rdx),  $0, 128(%rsp), 136(%rsp), 144(%rsp)
		
		             
                /* m1+tau  */
                
                prepare_and_add_2 0(%rsi), 8(%rsi)
                
                
                
		/* m4+tau^4 */
		
		movq 56(%rdx), %rbp
		movq %rbp, 216(%rsp)
		 
		prepare_and_add_store  48(%rsi), 56(%rsi), 136(%rdx), 144(%rdx), 152(%rdx), 200(%rsp), 208(%rsp), 216(%rsp)
		
		
					
		BRW_7	128(%rsp), 136(%rsp), 144(%rsp), %rax, %rbx,	%rcx, 96(%rsi), 104(%rsi), %r11, %r12, %r13, %r14, %r15, %rdi, 224(%rsp),232(%rsp),240(%rsp),248(%rsp),256(%rsp),32(%rsi), 40(%rsi),200(%rsp), 208(%rsp), 216(%rsp)
		/*******************************************************************************************************************************************************************************/
		
		reduce %r8, %r9, %r10, %r11, %r12
		
		movq 112(%rsi), %r14
		movq 120(%rsi), %r15
		movq $0, %r13
		
		
		movq 64(%rsp), %rdx
		
		addq 160(%rdx), %r14
		adcq 168(%rdx), %r15
		adcq 176(%rdx), %r13
		
		movq %r11, %rax
		movq %r12, %rbx
		
		mul_3x3 %r14, %r15, %r13, %rdi, %rax, %rbx  
		
		movq %r8, 224(%rsp)
		movq %r9, 232(%rsp)
		movq %r10, 240(%rsp)
		movq %r11, 248(%rsp)
		movq %r12, 256(%rsp)
		/****************************************************************************************************************************************************************************/
		/** m14+tau^2 **/
		
		movq 64(%rsp), %rdx
		
		prepare_and_add_store_1 208(%rsi), 216(%rsi), 16(%rdx), 24(%rdx), 32(%rdx), %rax, %rbx, %rcx

                /* m10+tau^2 */
                
               prepare_and_add 144(%rsi), 152(%rsi), %r11, %r12, %r13, %r14, %r15, %rdi
                
		/* m13+tau */
		
		
		prepare_and_add_store_2 192(%rsi), 200(%rsi), 0(%rdx), 8(%rdx),  $0, 128(%rsp), 136(%rsp), 144(%rsp)
		
		
		/** m9+tau **/
		
		prepare_and_add_2 128(%rsi), 136(%rsi)
	
		
                 
		/* m16+tau^4 */
		
		movq 56(%rdx), %rbp
		movq %rbp, 216(%rsp)
		 
		prepare_and_add_store  176(%rsi), 184(%rsi), 136(%rdx), 144(%rdx), 152(%rdx), 200(%rsp), 208(%rsp), 216(%rsp)
					
		BRW_7	128(%rsp), 136(%rsp), 144(%rsp), %rax, %rbx,	%rcx, 224(%rsi), 232(%rsi), %r11, %r12, %r13, %r14, %r15, %rdi, 304(%rsp),312(%rsp),320(%rsp),328(%rsp),336(%rsp),160(%rsi), 168(%rsi),200(%rsp), 208(%rsp), 216(%rsp) 
		
		/***********************************************************************************/
	        
		add_unreduced 224(%rsp), 232(%rsp), 240(%rsp), 248(%rsp), 256(%rsp)					
		
		
		check_stack: movq 96(%rsp), %rbp
    	
                		movq $0, %r13
               
				shrq $1, %rbp
				jc common
				movq 160(%rsp), %r14
			
		loop1:        add_unreduced -40(%r14), -32(%r14), -24(%r14), -16(%r14), -8(%r14)
						
			       inc %r13
                              subq $40, %r14
                              shrq $1, %rbp

        			jnc loop1
        			
        			movq %r14, 160(%rsp)
                
		common:  addq $1, 96(%rsp)
		reduce %r8, %r9, %r10, %r11, %r12
		movq %r11, %rax
		movq %r12, %rbx
		
                       
		movq 64(%rsp), %rdx
     		addq $184, %rdx
               
		imul $24, %r13, %r13
		addq %r13, %rdx
		
		movq 240(%rsi), %r14
		movq 248(%rsi), %r15
		movq $0, %r13
		
		addq 0(%rdx), %r14
		adcq 8(%rdx), %r15
		adcq 16(%rdx), %r13	
		
    		mul_3x3 %r14, %r15, %r13, %rdi, %rax, %rbx 
    		
    		
		movq 96(%rsp), %rcx
		
		
		movq 160(%rsp), %rdi
		
		
		addq $256, %rsi
		
		
		
		cmp %rcx, 88(%rsp)
		jl common1
		
		
		addq $40, 160(%rsp)
	        movq %r8,0(%rdi)
		movq %r9,8(%rdi)
		movq %r10, 16(%rdi)
		movq %r11, 24(%rdi)
		movq %r12, 32(%rdi)
		
		
                              
                jmp start
               		/*************************************************************************************/
		
common1:        movq 160(%rsp), %r14
    		 movq 168(%rsp), %r13

		
                

        loop3:  cmp %r13, %r14
                jle horner
               
          	addq -40(%r14), %r8

		adcq -32(%r14), %r9

	        adcq -24(%r14), %r10

		adcq -16(%r14), %r11

		adcq -8(%r14), %r12

		

                subq $40, %r14
    		        
                        
                jmp loop3
                
               
   		
    horner: movq 80(%rsp), %rcx /*check how many blocks are left...only one case will be satisfied*/
        
	cmpq $0, %rcx
	je final_reduction
	
	reduce %r8, %r9, %r10, %r11, %r12
		
	/* #blocks = 1 */
        cmpq    $1,%rcx
	je      S1

	
	/* #blocks = 2 */
	 cmpq    $2,%rcx
	je      S2
	
	/* #blocks = 3 */
	cmpq    $3,%rcx
	je      S3
	
	/* #blocks = 4 */
	cmpq    $4,%rcx
	je      S4
	
	/* #blocks = 5 */
	cmpq    $5,%rcx
	je      S5
	
	/* #blocks = 6 */
	cmpq    $6,%rcx
	je      S6
	
	/* #blocks = 7 */
	cmpq    $7,%rcx
	je      S7
	
	S8:     movq %r11, %rax
		movq %r12, %rbx
		movq %rdi, %rcx
		movq    64(%rsp),%rdi
		mul_3x3 160(%rdi), 168(%rdi), 176(%rdi), %rcx, %rax, %rbx
		
		jmp LB8
	
	
	S1: 	movq    64(%rsp),%rbp
		horner_mul_2x3_initial 0(%rbp), 8(%rbp), %rdi, %r11, %r12
		addq 0(%rsi), %r13
		adcq 8(%rsi), %r14
		adcq $0, %r15
		adcq $0, %rax
		adcq $0, %rcx
		
		movq %r13, %r8
		movq %r14, %r9
		movq %r15, %r10
		movq %rax, %r11
		movq %rcx, %r12
		
		/*add_unreduced 0(%rsi), 8(%rsi),$0, $0, $0*/
		addq $16, %rsi
		
		jmp final_reduction
	
	S2: 	movq %r11, %rax
		movq %r12, %rbx
		movq %rdi, %rcx
		movq    64(%rsp),%rdi
		mul_3x3 16(%rdi), 24(%rdi), 32(%rdi), %rcx, %rax, %rbx
		horner_mul_2x2 0(%rsi), 8(%rsi), 0(%rdi), 8(%rdi)
		add_unreduced %r13, %r14, %r15, %rax, $0
		
		add_unreduced 16(%rsi), 24(%rsi), $0, $0, $0
	
		jmp final_reduction
		
	S3: 	movq %r11, %rax
		movq %r12, %rbx
		movq %rdi, %rcx
		movq    64(%rsp),%rdi
		
		mul_3x3 40(%rdi), 48(%rdi), 56(%rdi), %rcx, %rax, %rbx
		horner_mul_2x3_initial 0(%rsi), 8(%rsi), 16(%rdi), 24(%rdi), 32(%rdi)
		
		add_unreduced %r13, %r14, %r15, %rax, %rcx
	
		horner_mul_2x2 16(%rsi), 24(%rsi), 0(%rdi), 8(%rdi)
		
		add_unreduced %r13, %r14, %r15, %rax, %rcx
		
		add_unreduced 32(%rsi), 40(%rsi), $0, $0, $0
		
		jmp final_reduction
	
	S4: 	movq %r11, %rax
		movq %r12, %rbx
		movq %rdi, %rcx
		movq    64(%rsp),%rdi
		mul_3x3 136(%rdi), 144(%rdi), 152(%rdi), %rcx, %rax, %rbx
		
		jmp LB4
	
	S5: 	movq %r11, %rax
		movq %r12, %rbx
		movq %rdi, %rcx
		movq    64(%rsp),%rdi
		mul_3x3 64(%rdi), 72(%rdi), 80(%rdi), %rcx, %rax, %rbx
		
		jmp LB5
 
	S6: 	movq %r11, %rax
		movq %r12, %rbx
		movq %rdi, %rcx
		movq    64(%rsp),%rdi
		mul_3x3 88(%rdi), 96(%rdi), 104(%rdi), %rcx, %rax, %rbx
		
		jmp LB6
 
	S7: 	movq %r11, %rax
		movq %r12, %rbx
		movq %rdi, %rcx
		movq    64(%rsp),%rdi
		mul_3x3 112(%rdi), 120(%rdi), 128(%rdi), %rcx, %rax, %rbx
		
		jmp LB7
	
	
       only_horner: movq    64(%rsp),%rdi
	movq 80(%rsp), %rcx
	/* #blocks = 1 */
        cmpq    $1,%rcx
	je      LB1

	
	/* #blocks = 2 */
	cmpq    $2,%rcx
	je      LB2
	
	/* #blocks = 3 */
	cmpq    $3,%rcx
	je      LB3
	
	/* #blocks = 4 */
	cmpq    $4,%rcx
	je      LB4
	
	/* #blocks = 5 */
	cmpq    $5,%rcx
	je      LB5
	
	/* #blocks = 6 */
	cmpq    $6,%rcx
	je      LB6
	
	/* #blocks = 7 */
	cmpq    $7,%rcx
	je      LB7
	
LB8:	/* m1*tau^7 */
	movq 64(%rsp), %rdi
	one: horner_mul_2x3_initial 0(%rsi), 8(%rsi), 112(%rdi), 120(%rdi), 128(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	/* m1*tau^7 + m2*tau^6 */
	
	two: horner_mul_2x3_initial 16(%rsi), 24(%rsi), 88(%rdi), 96(%rdi), 104(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 */
	
	three: horner_mul_2x3_initial 32(%rsi), 40(%rsi), 64(%rdi), 72(%rdi), 80(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 */
	
	four: horner_mul_2x3_initial 48(%rsi), 56(%rsi), 136(%rdi), 144(%rdi), 152(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 */
	
	five: horner_mul_2x3_initial 64(%rsi), 72(%rsi), 40(%rdi), 48(%rdi), 56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 */
	
	six: horner_mul_2x3_initial 80(%rsi), 88(%rsi), 16(%rdi), 24(%rdi), 32(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 + m7*tau */
	seven: horner_mul_2x2 96(%rsi), 104(%rsi), 0(%rdi), 8(%rdi)
	
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	reduce_1 %r8, %r9, %r10, %r11, %r12
	
	addq 112(%rsi),%r8
	adcq 120(%rsi), %r9
	adcq $0, %r10
	
	addq    $128,%rsi

	movq    80(%rsp),%rcx
	subq    $8,%rcx
	movq    %rcx,80(%rsp)	
	
	/* #blocks = 0 */	
	cmpq    $0,%rcx	
	je      final_reduction
	

	
	/* #blocks > 1 */
	cmpq    $1,%rcx	
	jne     LT2
	
LT1:
	/* tau*(m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 + m7*tau + m8) */
	
	horner_mul_2x3_initial 0(%rdi), 8(%rdi),%r8, %r9, %r10
		addq 0(%rsi), %r13
		adcq 8(%rsi), %r14
		adcq $0, %r15
		adcq $0, %rax
		adcq $0, %rcx
		
		movq %r13, %r8
		movq %r14, %r9
		movq %r15, %r10
		movq %rax, %r11
		movq %rcx, %r12
		
	
	
	jmp     final_reduction
	movq 64(%rsp), %rdi
LT2:
	/* #blocks > 2 */
	cmpq    $2,%rcx	
	jne     LT3	
	addq    $16,%rdi
	jmp     LMULT

LT3:
	/* #blocks > 3 */
	cmpq    $3,%rcx
	jne     LT4
	/* #blocks = 3 */
	addq    $40,%rdi
	jmp     LMULT

LT4:
	/* #blocks > 4 */
	cmpq    $4,%rcx
	jne     LT5
	/* #blocks = 4 */	
	addq    $136,%rdi
	jmp     LMULT

LT5:
	/* #blocks > 5 */
	cmpq    $5,%rcx
	jne     LT6
	/* #blocks = 5 */	
	addq    $64,%rdi
	jmp     LMULT

LT6:
	/* #blocks > 6 */
	cmpq    $6,%rcx
	jne     LT7
	/* #blocks = 6 */	
	addq    $88,%rdi
	jmp     LMULT

LT7:
	/* #blocks > 7 */
	cmpq    $7,%rcx
	jne     LT8
	/* #blocks = 7 */	
	addq    $112,%rdi
	jmp     LMULT

LT8:
	/* #blocks >= 8 */
	addq    $160,%rdi

LMULT:

	/* tau^n*(m1*tau^7 + m2*tau^6 + m3*tau^5 + m4*tau^4 + m5*tau^3 + m6*tau^2 + m7*tau + m8) */
	movq %r8, %rax
	movq %r9, %rbx
	movq %r10, %r13
	mul_3x3 %rax, %rbx, %r13, 0(%rdi), 8(%rdi), 16(%rdi)
	
	/* #blocks = 2 */
	cmpq    $2,%rcx
	je      LB2
	
	/* #blocks = 3 */
	cmpq    $3,%rcx
	je      LB3
	
	/* #blocks = 4 */
	cmpq    $4,%rcx
	je      LB4
	
	/* #blocks = 5 */
	cmpq    $5,%rcx
	je      LB5
	
	/* #blocks = 6 */
	cmpq    $6,%rcx
	je      LB6
	
	/* #blocks = 7 */
	cmpq    $7,%rcx
	je      LB7
	
	/* #blocks >= 8 */
	jmp     LB8
		
LB2:	/* m1*tau */
	movq 64(%rsp), %rdi
	horner_mul_2x2	0(%rsi),	8(%rsi),	0(%rdi),	8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, $0
	add_unreduced 16(%rsi), 24(%rsi), $0, $0, $0
	
	jmp final_reduction
	
LB3:
	/*movq    88(%rsp),%rsi*/
	movq 64(%rsp), %rdi
	/* m1*tau^2 */
	
	horner_mul_2x3_initial	0(%rsi), 8(%rsi), 16(%rdi), 24(%rdi), 32(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
		
	/* m1*tau^2 + m2*tau */
	
	horner_mul_2x2	16(%rsi), 24(%rsi), 0(%rdi), 8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	add_unreduced 32(%rsi), 40(%rsi), $0, $0, $0
	
	jmp     final_reduction
	
LB4:
	/*movq    88(%rsp),%rsi*/
	movq 64(%rsp), %rdi
	/* m1*tau^3 */
	
	horner_mul_2x3_initial 0(%rsi), 8(%rsi), 40(%rdi), 48(%rdi), 56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	/* m1*tau^3 + m2*tau^2 */
	
	horner_mul_2x3_initial 16(%rsi), 24(%rsi), 16(%rdi), 24(%rdi), 32(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	/* m1*tau^3 + m2*tau^2 + m3*tau */
	
	horner_mul_2x2 32(%rsi), 40(%rsi), 0(%rdi), 8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	add_unreduced 48(%rsi), 56(%rsi), $0, $0, $0
	
	jmp final_reduction
	
LB5:
	/*movq    88(%rsp),%rsi*/
	movq 64(%rsp), %rdi

	/* m1*tau^4 */
	
	horner_mul_2x3_initial 0(%rsi), 8(%rsi),  136(%rdi), 144(%rdi), 152(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^4 + m2*tau^3 */
	
	horner_mul_2x3_initial 16(%rsi), 24(%rsi), 40(%rdi),48(%rdi),56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^4 + m2*tau^3 + m3*tau^2 */
	
	horner_mul_2x3_initial 32(%rsi), 40(%rsi), 16(%rdi),24(%rdi),32(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx	
	
	
	/* m1*tau^4 + m2*tau^3 + m3*tau^2 + m4*tau */
	
	horner_mul_2x2 48(%rsi), 56(%rsi), 0(%rdi),8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	add_unreduced 64(%rsi), 72(%rsi), $0, $0, $0
	
	jmp final_reduction
	
LB6:/*movq    88(%rsp),%rsi*/

	movq 64(%rsp), %rdi
	/* m1*tau^5 */
	
	horner_mul_2x3_initial 0(%rsi), 8(%rsi), 64(%rdi), 72(%rdi), 80(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^5 + m2*tau^4 */
	
	horner_mul_2x3_initial 16(%rsi), 24(%rsi), 136(%rdi),144(%rdi),152(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^5 + m2*tau^4 + m3*tau^3 */
	
	horner_mul_2x3_initial 32(%rsi), 40(%rsi), 40(%rdi),48(%rdi),56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^5 + m2*tau^4 + m3*tau^3 + m4*tau^2 */
	
	horner_mul_2x3_initial 48(%rsi), 56(%rsi), 16(%rdi),24(%rdi),32(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	/* m1*tau^5 + m2*tau^4 + m3*tau^3 + m4*tau^2 + m5*tau */
	
	horner_mul_2x2 64(%rsi), 72(%rsi), 0(%rdi),8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	add_unreduced 80(%rsi), 88(%rsi), $0, $0, $0
	
	jmp final_reduction
	
LB7:	movq 64(%rsp), %rdi

	/* m1*tau^6 */
	
	horner_mul_2x3_initial 0(%rsi),8(%rsi),88(%rdi), 96(%rdi), 104(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	/* m1*tau^6 + m2*tau^5 */
	horner_mul_2x3_initial 16(%rsi), 24(%rsi), 64(%rdi), 72(%rdi), 80(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 */
	
	horner_mul_2x3_initial 32(%rsi), 40(%rsi), 136(%rdi),144(%rdi),152(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 + m4*tau^3 */
	horner_mul_2x3_initial 48(%rsi), 56(%rsi), 40(%rdi), 48(%rdi),  56(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 + m4*tau^3 + m5*tau^2 */
	
	horner_mul_2x3_initial	64(%rsi),	72(%rsi),	16(%rdi),	24(%rdi),	32(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	
	
	/* m1*tau^6 + m2*tau^5 + m3*tau^4 + m4*tau^3 + m5*tau^2 + m6*tau */
	
	horner_mul_2x2	80(%rsi), 88(%rsi), 0(%rdi), 8(%rdi)
	add_unreduced %r13, %r14, %r15, %rax, %rcx
	add_unreduced 96(%rsi), 104(%rsi), $0, $0, $0
	
	jmp final_reduction
		
	
	
LB1:   
	/* key = (r15 : r14) */
	/*movq 64(%rsp), %rdi
	movq    0(%rdi),%r14
	movq    8(%rdi),%r15*/

	/* message block = (rax : r13) */
	addq    0(%rsi),%r8
	adcq    8(%rsi),%r9
	adcq    $0, %r10
	adcq    $0, %r11
	adcq    $0, %r12
	
	



final_reduction: reduce %r8, %r9, %r10, %r11, %r12
		  
	
L3:	/* final computation */
	movq 64(%rsp), %rsi
	movq %r11, %rax
	movq %r12, %rbx
	mul_3x3 16(%rsi), 24(%rsi), 32(%rsi), %rdi, %rax, %rbx
	movq 112(%rsp), %rdx
        
	
	movq 0(%rsi), %rax
	movq 8(%rsi), %rbx
        
	mulx %rax, %rcx, %r15
	
	mulx %rbx, %rdi, %rsi
	adcx %rdi, %r15
	adcx zero, %rsi

	add_unreduced %rcx, %r15, %rsi, $0, $0
        
       
        
       reduce %r8, %r9, %r10, %r11, %r12
      		
	r:	movq %r12, %r15
		shrq $2, %r15
		andq mask62, %r12
		imul $5, %r15, %r15
		addq %r15, %rdi
		adcq $0, %r11
		adcq $0, %r12

		movq    %rdi, %r8
		movq    %r11, %r9
		movq    %r12, %r10

		subq    p0,%r8
		sbbq    p1,%r9
		sbbq    p2,%r10

		movq    %r10,%r14
		shlq    $62,%r14

		cmovc   %r8, %rdi
		cmovc   %r9, %r11
		cmovc   %r10, %r12
	
	
	movq 104(%rsp), %rcx

	movq %rdi,0(%rcx)
	movq %r11,8(%rcx)
	/*movq %r12, 16(%rcx)*/

    
                
                
		
e:		movq 16(%rsp), %rbx
		movq 24(%rsp), %r12
		movq 32(%rsp), %r13
		movq 40(%rsp), %r14
		movq 48(%rsp), %r15
		movq 56(%rsp), %rbp


		addq $600, %rsp

ret
