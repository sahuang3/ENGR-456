.globl dct_c

dct_c:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li t0, 0	# i = 0
	
loop:
	# x[i+0] +- x[i+56]
	lw t1, 0(a0)
	lw t2, 224(a0)
	add a2, t1, t2	# a00 = x[i+0] + x[i+56]
	sub a3, t1, t2	# a70 = x[i+0] - x[i+56]
	
	# x[i+8] +- x[i+48]
	lw t1, 32(a0)
	lw t2, 192(a0)
	add a4, t1, t2	# a10 = x[i+8] + x[i+48]
	sub a5, t1, t2	# a60 = x[i+8] - x[i+48]
	
	# x[i+16] +- x[i+40]
	lw t1, 64(a0)
	lw t2, 160(a0)
	add a6, t1, t2	# a20 = x[i+16] + x[i+40]
	sub a7, t1, t2	# a50 = x[i+16] - x[i+40]
	
	# x[i+24] +- x[i+32]
	lw t1, 96(a0)
	lw t2, 128(a0)
	add t3, t1, t2	# a30 = x[i+24] + x[i+32]
	sub t4, t1, t2	# a40 = x[i+24] - x[i+32]
	
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
	slli t3, t3, 2	# a01 + a11 << 2
	sw t3, 0(a1)	# y[i+0] = a01 + a11 << 2
	
	sub t3, t1, a2 	# a01 - a11
	slli t3, t3, 2	# a01 - a11 << 2
	sw t3, 128(a1)	# y[i+32] = a01 - a11 << 2
	
	slli t2, t2, 14	# temp1 = a31 << 14
	add t1, t2, a5	# temp = temp1 + a23
	
	li a2, 0x800
	add t1, t1, a2	# (temp + 0x800)
	srai t1, t1, 12	# (temp + 0x800) >> 12		
	sw t1, 64(a1)	# y[i+16] = (temp + 0x800) >> 12
	
	sub t1, t2, a5	# temp = temp1 - a23
	add t1, t1, a2	# (temp + 0x800)
	srai t1, t1, 12	# (temp + 0x800) >> 12
	sw t1, 192(a1)	# y[i+48] = (temp + 0x800) >> 12
	
	
	add t1, a6, a4	# temp = a74 + a43
	add t1, t1, a2	# (temp + 0x800)
	srai t1, t1, 12	# (temp + 0x800) >> 12
	sw t1, 160(a1)	# y[i+40] = (temp + 0x800) >> 12
	
	add t1, t4, a7	# temp = a54 + a63
	add t1, t1, a2	# (temp + 0x800)
	srai t1, t1, 12	# (temp + 0x800) >> 12
	sw t1, 32(a1)	# y[i+8] = (temp + 0x800) >> 12
	
	sub t1, t4, a7	# temp = a54 - a63
	add t1, t1, a2	# (temp + 0x800)
	srai t1, t1, 12	# (temp + 0x800) >> 12
	sw t1, 224(a1)	# y[i+56] = (temp + 0x800) >> 12
	
	sub t1, a6, a4	# temp = a74 - a43
	add t1, t1, a2	# (temp + 0x800)
	srai t1, t1, 12	# (temp + 0x800) >> 12
	sw t1, 96(a1)	# y[i+24] = (temp + 0x800) >> 12
	
	addi t0, t0, 4	# i++
	addi a1, a1, 4
	addi a0, a0, 4	
	li t1, 28	# i <= 7 * 4
	bgt t0, t1, done
	j loop
	
done:

    	lw ra, 0(sp)
    	addi sp, sp, 4
    	ret 
	

