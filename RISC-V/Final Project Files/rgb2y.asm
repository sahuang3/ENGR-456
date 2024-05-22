.globl rgb2y

rgb2y:
	addi sp, sp, -4
	sw ra, 0(sp)
	
    	li t0, 0        # counter for loop, until 64*4 = 256

loop: 

	# Red
    	mv t1, x10	# loading t1 with x10/Red
    	add t1, t1, t0	# adding counter for array index
    	lw t2, 0(t1)	# loading t2 with new index
    	li t3, 38	# loading t3 = 38
    	mul t2, t2, t3	# t2 = R * 38

    	# Green
    	mv t1, x11	# loading t1 with x11/Green
    	add t1, t1, t0	# adding counter for array index
    	lw t4, 0(t1)	# loading t4 with new index
    	li t3, 75	# loading t3 = 75
    	mul t4, t4, t3	# t3 = G * 75

    	# Blue
    	mv t1, x12	# loading t1 with x12/Blue
    	add t1, t1, t0	# adding counter for array index
    	lw t5, 0(t1)	# loading t5 with new index
    	li t3, 15	# loading t3 = 15
    	mul t5, t5, t3	# loading t5 = B * 15

    	add t2, t2, t4	# R38+G75
    	add t2, t2, t5	# R38+G75+B15
    	li t3, 16320
    	sub t2, t2, t3	# R38+G75+B15-16320
    	srai t2, t2, 7	# (SRA((R38+G75+B15-16320),7))

    	mv t1, x13
    	add t1, t1, t0
    	sw t2,0(t1)

    	addi t0, t0, 4	# i++
	
	# Branch condition: i<256
    	li t3, 256
    	bne t0, t3, loop
    	
    	lw ra, 0(sp)
    	addi sp, sp, 4
    	
    	ret
