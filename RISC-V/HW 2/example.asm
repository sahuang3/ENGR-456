
# Do not use label "main" in your functions, it should be used only in the calling function
.globl average

average:
	addi sp, sp , -4 # allocate space for stack frame by adujusting the stack pointer (sp register)
	sw ra, 0(sp) # save the return address (ra register) 
	# save other registers to stack if needed

	# body of the function, write your code here
	mv t1, a0
	beqz t1, exit
	mv t2, a1
	beqz t2, exit
	li t3, 2
	add t1, t1, t2
	div t1, t1, t3
	mv a0, t1

exit:	
	# restore registers from stack if needed
	lw ra, 0(sp) # Restore return address register
	addi sp, sp, 4 # deallocate space for stack frame
	ret # return to calling point
	