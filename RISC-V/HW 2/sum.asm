.globl sum

sum:
	# initialize
	addi sp, sp, -4 # allocate space
	sw ra, 0(sp) # return address
	
	# function
	mul t0, x10, x10
	mv a0, t0
	
	# restore registers
	lw ra, 0(sp) # restore return address
	addi sp, sp, 4 # deallocate space
	ret
