.globl organize

organize:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li t0, 0	# i = 0
	li t1, 0	# size = 0
	li t2, 0	# result
	li t3, 0	# temp
	li t4, 0	# temp bit array
	li t5, 0	# size placeholder
	
	
loop:	
	li t6, 512
	bge t0, t6, end
	
	lw a3, 0(a1)
	add t1, t1, a3
	
	# neg check
	lw a4, 0(a0)
	bltz a4, negative
	
	# first time check
	beqz t3, first
	
negative_back:
	# shift temp bit array by a3 bits and OR with a4
	sll t4, t4, a3
	or t4, t4, a4
	
	# check size >= 8
	li t6, 8
	bge t1, t6, write
	
next:
	addi t0, t0, 4
	addi a0, a0, 4
	addi a1, a1, 4
	j loop
	
end:
	# if size != 0, pad
	bnez t1, pad
	
done:
    	lw ra, 0(sp)
    	addi sp, sp, 4
    	ret 
	
first:
	# first time counter = 1
	li t3, 1
	mv t4, a4
	j next
	
write:
	# size - 8
	addi t1, t1, -8
	
	# shift temp bit array by size
	srl t2, t4, t1
	sw t2, 0(a2)
	addi a2, a2, 4
	
	# difference between sizes and shifting
	li t6, 32
	sub t5, t6, t1
	sll t4, t4, t5
	srl t4, t4, t5
	
	beqz t1, remove
	
remove_back:
	# must byte stuff if 0xff
	li t6, 0xff
	beq t2, t6, byte_stuffing
	j next
	
negative:
	# subtract 1
	addi a4, a4, -1
	# discard all bits outside of size
	li t6, 32
	sub t6, t6, a3
	sll a4, a4, t6
	srl a4, a4, t6
	j negative_back
	
byte_stuffing:
	# stuffing 0 into x12
	sw zero, 0(a2)
	addi a2, a2, 4
	j next
	
remove:
	# clearing temp bit array
	xor t4, t4, t4
	j remove_back
	
pad:
	# shift and add temp bit array and size by 1
	slli t4, t4, 1
	addi t4, t4, 1
	addi t1, t1, 1
	
	# size < 8, pad
	li t6, 8
	blt t1, t6, pad
	
	sw t4, 0(a2)
	
	# temp bit array = 0xff
	li t6, 0xff
	beq t4, t6, stuffing_last
	j done
	
stuffing_last:
	addi a2, a2, 4
	sw zero, 0(a2)
	j done
