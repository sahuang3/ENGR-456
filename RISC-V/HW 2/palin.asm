.globl palin

palin:
	# initialize
	addi sp, sp, -4 # allocate space
	sw ra, 0(sp) # return address
	
	mv t0, a0
	
	li t1, 0 # result
	li t2, 0 # first index
	li t3, 31 # last index
	
	# loop to compare the bits from both sides
	loop:
	srl a0, t0, t2
	sll a1, t0, t3
	
	# compare the values
	beq a0, a1, equal
	
	# if values are not the same, set result to 0
	li t1, 0
	j end
	
	# if equal
	equal:
	
	# increment/decrement both sides by 1
	addi t2, t2, 1
	addi t3, t3, -1
	
	# check position of first and last bit index until middle
	bge t2, t3, end
	j loop
	
	end:
	mv a0, t1
	
	# restore registers
	lw ra, 0(sp) # restore return address
	addi sp, sp, 4 # deallovate space
	ret
