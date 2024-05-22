.globl q_y

q_y:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li t6, 0
    	
loop: 
	lw t0, 0(x10)	# x[1]
    	lw t1, 0(x11)	# Q_Y[1]
    	li t2, 0x8000
    	li t3, 0	# temp2 = 0
	mul t3, t0, t1	# temp2 = x[i] * Q_Y[i]
	add t4, t3, t2	# temp = temp2 + 0x8000
	srai t4, t4, 16
	
	sw t4, 0(x12)	# y[i] = (temp2 + 0x8000) >> 16
	addi x10, x10, 4	# x[i] next index
	addi x11, x11, 4	# Q_Y[i] next index
	addi x12, x12, 4	# y[i] next index
	
	# Branch condition: i<64
	li t5, 64
	addi t6, t6, 1
    	bne t6, t5, loop
    	
    	lw ra, 0(sp)
    	addi sp, sp, 4
    	
    	ret
