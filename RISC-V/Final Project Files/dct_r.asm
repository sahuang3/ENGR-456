.globl dct_r

dct_r:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li t0, 0	# j = 0
	
loop:
	# x[j+0] +- x[j+7]
	lw t1, 0(a0)
	lw t2, 28(a0)
	add a2, t1, t2	# a00 = x[j+0] + x[j+7]
	sub a3, t1, t2	# a70 = x[j+0] - x[j+7]
	
	# x[j+1] +- x[j+6]
	lw t1, 4(a0)
	lw t2, 24(a0)
	add a4, t1, t2	# a10 = x[j+1] + x[j+6]
	sub a5, t1, t2	# a60 = x[j+1] - x[j+6]
	
	# x[j+2] +- x[j+5]
	lw t1, 8(a0)
	lw t2, 20(a0)
	add a6, t1, t2	# a20 = x[j+2] + x[j+5]
	sub a7, t1, t2	# a50 = x[j+2] - x[j+5]
	
	# x[j+3] +- x[j+4]
	lw t1, 12(a0)
	lw t2, 16(a0)
	add t3, t1, t2	# a30 = x[j+3] + x[j+4]
	sub t4, t1, t2	# a40 = x[j+3] - x[j+4]
	
	add t1, a2, t3	# a01 = a00 + a30
	sub t2, a2, t3	# a31 = a00 - a30
	
	add a2, a4, a6	# a11 = a10 + a20
	sub t3, a4, a6	# a21 = a10 - a20
	
	add a4, t4, a7	# neg_a41 = a40 + a50
	add a6, a7, a5	# a51 = a50 + a60
	add a7 ,a5, a3 	# a61 = a60 + a70
	
	add a5, t3, t2 	# a22 = a21 + a31
	
	# 11585 = 10 1101 0100 0001
	li t4, 0	
	addi t4, t4, 45	# 10 1101
	slli t4, t4, 8	# 10 1101 0000 0000
	addi t4, t4, 65 # Add 0100 0001
	mul a5, a5, t4	# a23 = a22 * 11585
	
	# 6270
	li t4, 6270
	sub t3, a7, a4 	# (a61 - neg_a41)
	mul t3, t3, t4	# mul5 = (a61 - neg_a41) * 6270
	
	# 8867 = 10 0010 1010 0011 
	li t4, 0
	addi t4, t4, 34	# 10 0010
	slli t4, t4, 8 	# 10 0010 0000 0000
	addi t4, t4, 163 # Add 1010 0011
	mul a4, a4, t4  # (neg_a41 * 8867)
	sub a4, a4, t3	# a43 = (neg_a41 * 8867) - mul5
	
	# 11585 (Same as previous)
	li t4, 0
	addi t4, t4, 45
	slli t4, t4, 8
	addi t4, t4, 65	
	mul a6, a6, t4	# a53 = a51 * 11585
	
	# 21407 = 101 0011 1001 1111
	li t4, 83	# 101 0011
	slli t4, t4, 8	# 101 0011 0000 0000
	addi t4, t4, 159 # Add 1001 1111
	mul a7, a7, t4	# (a61 * 21407)
	sub a7, a7, t3	# a63 = (a61 * 21407) - mul5
	
	slli a3, a3, 14	# temp1 = a70 << 14
	add t4, a3, a6	# a54 = temp1 + a53
	sub a6, a3, a6	# a74 = temp1 - a53
	
	add t3, t1, a2	# a01 + a11
	sw t3, 0(a1)	# y[j+0] = a01 + a11
	
	sub t3, t1, a2 	# a01 - a11
	sw t3, 16(a1)	# y[j+4] = a01 - a11
	
	slli t2, t2, 14	# temp1 = a31 << 14
	add t1, t2, a5	# temp = temp1 + a23
	
	li a2, 0x2000
	add t1, t1, a2	# (temp + 0x2000)
	srai t1, t1, 14	# (temp + 0x2000) >> 14		
	sw t1, 8(a1)	# y[j+2] = (temp + 0x2000) >> 14
	
	sub t1, t2, a5	# temp = temp1 - a23
	add t1, t1, a2	# (temp + 0x2000)
	srai t1, t1, 14	# (temp + 0x2000) >> 14
	sw t1, 24(a1)	# y[j+6] = (temp + 0x2000) >> 14
	
	
	add t1, a6, a4	# temp = a74 + a43
	add t1, t1, a2	# (temp + 0x2000)
	srai t1, t1, 14	# (temp + 0x2000) >> 14
	sw t1, 20(a1)	# y[j+5] = (temp + 0x2000) >> 14
	
	add t1, t4, a7	# temp = a54 + a63
	add t1, t1, a2	# (temp + 0x2000)
	srai t1, t1, 14	# (temp + 0x2000) >> 14
	sw t1, 4(a1)	# y[j+1] = (temp + 0x2000) >> 14
	
	sub t1, t4, a7	# temp = a54 - a63
	add t1, t1, a2	# (temp + 0x2000)
	srai t1, t1, 14	# (temp + 0x2000) >> 14
	sw t1, 28(a1)	# y[j+7] = (temp + 0x2000) >> 14
	
	sub t1, a6, a4	# temp = a74 - a43
	add t1, t1, a2	# (temp + 0x2000)
	srai t1, t1, 14	# (temp + 0x2000) >> 14
	sw t1, 12(a1)	# y[j+3] = (temp + 0x2000) >> 14
	
	addi t0, t0, 32	# j = j + 8
	addi a1, a1, 32
	addi a0, a0, 32	
	li t1, 252	# j <= 63 * 4
	bgt t0, t1, done
	j loop
	
done:

    	lw ra, 0(sp)
    	addi sp, sp, 4
    	ret 
	

