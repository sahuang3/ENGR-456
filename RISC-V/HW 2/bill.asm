.globl bill

bill:	
	# initialize
	addi sp, sp, -4 # allocate space
	sw ra, 0(sp) # return address
	
	li t1, 0 # 'i' counter
	li t2, 100 # 100 mins
	li t3, 500 # 500 mins
	li t4, 1 # temp counter
	li t5, 0 # result
	
	# Loop first 100 mins, $0.01/mins
	loop100mins:
	bge t1, t2, endloop100mins
	addi t1, t1, 1
	addi t5, t5, 1
	sub x10, x10, t4
	beq x10, zero, end
	j loop100mins
	
	endloop100mins:
	li t1, 0
	
	# Loop first 500 mins, $0.05/mins
	loop500mins:
	bge t1, t3, endloop500mins
	addi t1, t1, 1
	addi t5, t5, 5
	sub x10, x10, t4
	beq x10, zero, end
	j loop500mins
	
	endloop500mins:
	li t1, 0
	
	# Loop after 500 mins, $0.10/mins
	lastmins:
	bge t1, x10, lastmins
	addi t1, t1, 1
	addi t5, t5, 10
	beq t1, x10, end
	j lastmins
	
	end:
	mv a0, t5
	
	# restore registers
	lw ra, 0(sp) # restore return address
	addi sp, sp, 4 # deallovate space
	ret
