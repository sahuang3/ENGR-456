.data

.text

# macro to terminate the simualtion
.macro exit ()
.text
li a7,10
ecall
.end_macro

# macro to print a integer value
.macro print_int (%reg)
.text
li a7,1
add x10, %reg, x0 
ecall
.end_macro

# marco to print a hexadecimal value
.macro print_hex (%reg)
.text
li a7,34
add x10, %reg, x0 
ecall
.end_macro

# macro to print a string
.macro print_str (%str)
.data
str_label: .string %str
.text
li a7, 4
la x10, str_label
ecall
.end_macro


.globl main
main: 
    # Use the following labels for functions
	# problem 1: divide

	# to test divide function
	li x10, 0x00ffffff # pass inputs
	li x11, 0x00000002 # pass inputs
	call divide
	mv t0, a0
	mv t1, a1
	print_str("\nQuotient: ")
	print_int(t0)
	print_str("\nRemainder: ")
	print_int(t1)

	exit()



	
