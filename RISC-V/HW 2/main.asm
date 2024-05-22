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
	# problem 1: palin
	# problem 2: bill
	# problem 3: sum

	# to test palin function
	print_str("\nOutput of palin function\n")
	li x10, 0x0A0FF050 # pass inputs
	call palin
	mv t0, a0
	print_str("Value stored in x10: ")
	print_int(t0)

	# to test bill function
	 print_str("\nOutput of bill function\n")
	 li x10, 0x121 # pass inputs
	 call bill
	 mv t0, a0
	 print_str("Value stored in x10: ")
	 print_int(t0)

	# to test sum function
	 print_str("\nOutput of sum function\n")
	 li x10, 0xA # pass inputs
	 call sum
	 mv t0, a0
	 print_str("Value stored in x10: ")
	 print_int(t0)

	exit()



	
