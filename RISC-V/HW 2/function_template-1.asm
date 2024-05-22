# Declare the listed label(s) as global to enable referencing from other files
# Use the following names for the function
# problem 1: lpyear
# problem 2: gcd
# problem 3: npnum
# problem 4: palin

.globl func_name

func_name:

	addi sp, sp , -4 # allocate space for stack frame by adujusting the stack pointer (sp register)
	sw ra, 0(sp) # save the return address (ra register) 
	# save other registers to stack if needed
	
	# body of the function, write your code here
	
	# restore registers from stack if needed
	lw ra, 0(sp) # Restore return address register
	addi sp, sp, 4 # deallocate space for stack frame
	ret # return to calling point
