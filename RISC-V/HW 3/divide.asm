.globl divide

divide:
	# initialize stack frame
	addi sp, sp , -4 
    	sw ra, 0(sp)
    	
    	# variables
    	mv t0, a0
    	mv t2, a1
    	li t1, 0 # A
    	li t3, 32 # N = 32 bits
    	
    	while:
    	beq t3, zero, end
    	
    	# Step 2: A = A | ((Q >> 31) & 0x1)
    	slli t1, t1, 1 # left shift A << 1
    	mv t4, t0 # Q = Dividend
    	srli t4, t4, 31 # right shift Q >> 31
    	andi t6, t4, 0x1 # (Q >> 31) & 0x1
    	or t1, t1, t6 # A = A | (Q >> 31) & 0x1

	# Q = (Q << 1) & 0xffffffff
	slli t0, t0, 1 # Q << 1
	
	# Step 3:
	sub t6, t1, t2 # NEW_A = A - M
	
	# Step 4: MSB_NEW_A = (NEW_A >> 31) & 0x1
	srli t5, t6, 31 # NEW_A >> 31
	andi t5, t5, 0x1 # (MSB_NEW_A >> 31 ) & 0x1
	
	mv t4, t5 # Q = (MSB_NEW_A >> 31) & 0x1
	andi t4, t4, 0x1 # Q = MSB_NEW_A & 0x1
	xori t4, t4, 0x1, # Q = ~MSB_NEW_A & 0x1
	or t0, t0, t4 # Q = Q | ~MSB_NEW_A & 0x1
	
	bne t5, zero, continue # If MSB_NEW_A == 0
	mv t1, t6 # A = NEW_A
	
	continue:
	# Step 5:
   	li t4, 1
   	sub t3, t3, t4 # N = N - 1
   	j while
   	
	end:
	# Step 6:
	mv a0, t0 # Q = Quotient
	mv a1, t1 # A = Remainder

    	# restore registers
    	lw ra, 0(sp)
    	addi sp, sp, 4
    	ret
