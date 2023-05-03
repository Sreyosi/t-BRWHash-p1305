.macro horner_mul_2x3_initial m1, m2, m3, m4, m5

	xorq    %rcx,%rcx
	movq    \m1,%rdx    

	mulx    \m3,%r13,%r14
	mulx    \m4,%rbx,%r15	
	adcx    %rbx,%r14

	mulx    \m5,%rbx,%rax	
	adcx    %rbx,%r15
	adcx	%rcx,%rax
	
	xorq    %rdx,%rdx
	movq    \m2,%rdx    

	mulx    \m3,%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	
	mulx    \m4,%rbx,%rbp
	adcx    %rbx,%r15
	adox    %rbp,%rax

	mulx    \m5,%rbx,%rbp
	adcx    %rbx,%rax
	adox    %rbp,%rcx
	adcx    zero,%rcx	
	    	    
	
.endm

.macro horner_mul_2x3 m1, m2, m3, m4, m5

	xorq    %rcx,%rcx
	movq    \m1,%rdx    

	mulx    \m3,%r13,%r14
	mulx    \m4,%rbx,%r15	
	adcx    %rbx,%r14

	mulx    \m5,%rbx,%rax	
	adcx    %rbx,%r15
	adcx	%rcx,%rax
	
	xorq    %rdx,%rdx
	movq    \m2,%rdx    

	mulx    \m3,%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	
	mulx    \m4,%rbx,%rbp
	adcx    %rbx,%r15
	adox    %rbp,%rax

	mulx    \m5,%rbx,%rbp
	adcx    %rbx,%rax
	adox    %rbp,%rcx
	adcx    zero,%rcx	
	    	    
	xorq    %rdx,%rdx

	adcx    \m3,%r15
	adox	zero,%rax
	adcx    \m4,%rax
	adox	zero,%rcx	
	adcx    \m5,%rcx

.endm

.macro horner_mul_3x2 m1, m2, m3, m4, m5
	xorq    %r14,%r14
	movq    \m1,%rdx    

	mulx    \m4,%r8,%r12
	mulx    \m5,%rbx,%r13
	adcx    %rbx,%r12
	adcx    %r14,%r13

	xorq    %rax,%rax
	movq    \m2,%rdx
	   
	mulx    \m4,%r9,%rbp
	adcx    %r12,%r9
	adox    %rbp,%r13
	    
	mulx    \m5,%rbx,%rbp
	adcx    %rbx,%r13
	adox    %rbp,%r14
	adcx    %rax,%r14

	xorq    %r12,%r12
	movq    \m3,%rdx
	    
	mulx    \m4,%r10,%rbp
	adcx    %r13,%r10
	adox    %rbp,%r14
	    
	mulx    \m5,%r11,%rbp
	adcx    %r14,%r11
	adox    %rbp,%r12
	adcx    %rax,%r12
.endm

.macro horner_mul_2x2 m1, m2, m3, m4

	xorq    %rax,%rax
	movq    \m1,%rdx    

	mulx    \m3,%r13,%r14
	mulx    \m4,%rbx,%r15	
	adcx    %rbx,%r14
	adcx    %rax,%r15	
	
	xorq    %rcx,%rcx
	
	movq    \m2,%rdx
	   
	mulx    \m3,%rbx,%rbp
	adcx    %rbx,%r14
	adox    %rbp,%r15
	    
	mulx    \m4,%rbx,%rax
	adcx    %rbx,%r15
	adox    zero,%rax
	adcx    zero,%rax
	xorq %rcx, %rcx
	/*xorq    %rdx,%rdx
			
	adcx    \m3,%r15
	adox	%rdx,%rax
	adcx    \m4,%rax
	adox	%rdx,%rcx*/
	
	
	   
.endm
.macro reduce_1 s1,s2,s3,s4,s5

		movq \s3, %rdx
		andq mask62,\s3
		andq mask62_upper,%rdx
		addq %rdx,\s1
		adcq \s4,\s2
		adcq \s5,\s3
		shrd $2,\s4,%rdx
		shrd $2,\s5,\s4
		shrq $2,\s5
		addq %rdx, \s1
		adcq \s4, \s2
		adcq \s5,\s3

		movq \s3,%rdx
		andq mask62,\s3
		shrq $2,%rdx
		imul $5,%rdx,%rdx
		
		addq %rdx, \s1
		adcq $0,\s2
		adcq $0,\s3
		
		
		
.endm

.macro reduce s1,s2,s3,s4,s5

		movq \s3, %rdi
		andq mask62,\s3
		andq mask62_upper,%rdi
		addq %rdi,\s1
		adcq \s4,\s2
		adcq \s5,\s3
		shrd $2,\s4,%rdi
		shrd $2,\s5,\s4
		shrq $2,\s5
		addq %rdi, \s1
		adcq \s2, \s4
		adcq \s3,\s5

		movq \s5,%rdi
		andq mask62,\s5
		shrq $2,%rdi
		imul $5,%rdi,%rdi
		/*addq %rdi,\s1*/
		addq \s1, %rdi
		adcq $0,\s4
		adcq $0,\s5
		
		/*movq \s5,%rdi
		andq mask62,\s5
		shrq $2,%rdi
		imul $5,%rdi,%rdi
		addq \s1,%rdi
		adcq $0,\s4
		adcq $0,\s5*/
		
		
.endm

.macro mul_3x3 r1, r2, r3, r4, r5, r6

		movq \r1, %rdx
		
		mulx 	\r4, %r8, %r9

		mulx 	\r5, %rbp, %r10
		adcx 	%rbp, %r9

		mulx	\r6, %rbp, %r11
		adcx    %rbp, %r10
		adcq	$0, %r11
		
		
		movq \r2, %rdx
		

		mulx \r4, %rbp, %r12
		adcx %rbp, %r9
		adox %r12, %r10

		mulx \r5, %rbp, %r12
		adcx %rbp, %r10
		adox %r12, %r11

		mulx \r6, %rbp, %r12
		adcx %rbp, %r11
               adox zero, %r12
		adcq $0, %r12

		movq \r3, %rdx
		

		mulx \r4, %rbp, %r13
		adcx %rbp, %r10
		adox %r13, %r11

		mulx \r5, %rbp, %r13
		adcx %rbp, %r11
		adox %r13, %r12

		mulx \r6, %rbp, %r13
		adcx %rbp, %r12

.endm

.macro add_unreduced x1, x2, x3, x4, x5

		addq \x1, %r8
		adcq \x2, %r9
		adcq \x3, %r10
		adcq \x4, %r11
		adcq \x5, %r12
		
.endm

.macro BRW_4 p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11

		mul_3x3 \p1,	\p2,	\p3,	\p4,	\p5,	\p6

		add_unreduced \p7, \p8, $0, $0, $0
		
		reduce %r8, %r9, %r10, %r11, %r12
    	  
    	  	movq %r11, %r14
    	  	movq %r12, %r15
    	  	
    	  
    	  	
    	  	mul_3x3 %rdi, %r14, %r15, \p9, \p10, \p11
    	
		
 
.endm
.macro BRW_2 m1, m2, m3, m4

	  movq 64(%rsp), %rdi
	  movq 0(%rdi), %rdx
	
	  mulx \m1, %r8, %r9

	  mulx \m2, %r10, %r11
	  adcx %r10, %r9
	  adcx zero, %r11
	  
	  movq 8(%rdi), %rdx
          
	  mulx \m1, %rbp, %r10
          adcx %rbp, %r9
	  adox %r11, %r10

          mulx \m2, %rbp, %r11
          adcx %rbp, %r10
          adox zero, %r11
          adcq $0, %r11
          
          movq $0, %r12
          add_unreduced \m3, \m4, $0, $0, $0
          
.endm
.macro	BRW_3	p1,	p2,	p3,	p4,	p5,	p6,	p7,	p8
		
		
		mul_3x3 \p1,	\p2,	\p3,	\p4,	\p5,	\p6

		add_unreduced \p7, \p8, $0, $0, $0
		
		
.endm
		
.macro	BRW_7	q1,	q2,	q3,	q4,	q5,	q6,	q7,	q8,	q9,	q10,	q11,	q12,	q13,	q14,	q15,	q16,	q17,	q18,	q19,	q20,	q21,	q22,	q23,	q24



		BRW_3 \q9, \q10, \q11, \q12, \q13, \q14,  \q20, \q21
		
		
		reduce %r8, %r9, %r10, %r11, %r12
		movq %r11, %r14
		movq %r12, %r15
		
		mul_3x3 %rdi,%r14, %r15, \q22, \q23, \q24 
						
		movq %r8, \q15
		movq %r9, \q16
		movq %r10, \q17
		movq %r11, \q18
		movq %r12, \q19
		
		
		
		BRW_3 	\q1,	\q2,	\q3, 	\q4,	\q5,	\q6,	\q7,	\q8
		
	
		
		add_unreduced \q15, \q16, \q17, \q18, \q19
		
		
				
		
		
.endm

.macro prepare_and_add_store_1 a1, a2, k1, k2, k3, s1, s2, s3

		movq \a1, \s1
		movq \a2, \s2
	        movq $0, \s3
		
		movq \k1, %r11
		movq \k2, %r12
		movq \k3, %r13
			
		addq %r11, \s1
		adcq %r12, \s2
		adcq %r13, \s3
		

.endm

.macro prepare_and_add a1, a2, k1, k2, k3, s1, s2, s3
                
                movq \a1, \s1
                movq \a2, \s2
                movq $0, \s3
		
		addq \k1, \s1
		adcq \k2, \s2
		adcq \k3, \s3
		
		
.endm


.macro prepare_and_add_store a1, a2, k1, k2, k3, s1, s2, s3
                
                movq \a1, %rbp
                movq \a2, %r8
                movq $0, %r9
		
		addq \k1, %rbp
		adcq \k2, %r8
		adcq \k3, %r9
		
		movq %rbp, \s1
		movq %r8, \s2
		movq %r9, \s3
	
.endm

.macro prepare_and_add_2 d1, d2

		addq \d1, %r11
		adcq \d2, %r12
		adcq $0, %r13
		

.endm

.macro prepare_and_add_store_2 a1, a2, k1, k2, k3, s1, s2, s3

		movq \a1, %rbp
		movq \a2, %r8
		movq $0, %r9
	
		
		movq \k1, %r11
		movq \k2, %r12
		movq \k3, %r13
			
		addq %r11, %rbp
		adcq %r12, %r8
		adcq %r13, %r9
		
		movq %rbp, \s1
		movq %r8, \s2
		movq %r9, \s3
		

.endm


