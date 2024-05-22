 .globl huffman_y

huffman_y:

	# a0 = arr_sample_rle_vals
	# a1 = arr_sample_rle_codes
	# a2 = arr_DC_huffman_table
	# a3 = arr_DC_huffman_sizes
	# a4 = arr_AC_huffman_table
	# a5 = arr_huffman_vals
	# a6 = arr_huffman_size

	lw t0, 0(a0)		# x_val[0]
	mv a7, t0
	
	# size_of_bits = get_size(x_val[0])
	j get_size
	
back_get_size:
	mv t0, a7
	li t1, 0		# out_index = 0
	
	# index = current size * 4
	li t2, 4
	mul t3, t3, t2
	
	# y_val[out_index] = huffman_table_DC_Y[size_of_bits]
	add a2, a2, t3	
	lw t4, 0(a2)		# huffman_table_DC_Y[size_of_bits]
	sw t4, 0(a5)		# y_val[out_index] = huffman_table_DC_Y[size_of_bits]
	sub a2, a2, t3
	
	# y_size[out_index] = huffman_table_DC_Y_sizes[size_of_bits]
	add a3, a3, t3	
	lw t4, 0(a3)		# huffman_table_DC_Y_sizes[size_of_bits]	
	sw t4, 0(a6)		# y_size[out_index] = huffman_table_DC_Y_sizes[size_of_bits]
	sub a3, a3, t3
	
	addi t1, t1, 4		# out_index++
	
	# y_val[out_index] = x_val[0]
	add a5, a5, t1		# y_val[out_index]
	sw t0, 0(a5)		# y_val[out_index] = x_val[0]
	sub a5, a5, t1
	
	# y_size[out_index] = size_of_bits
	add a6, a6, t1		# y_size[out_index]
	li t2, 4
	div t3, t3, t2
	sw t3, 0(a6)		# y_size[out_index] = size_of_bits
	sub a6, a6, t1
	mul t3, t3, t2
	
	addi t1, t1, 4		# out_index++
	li t5, 4		# in_index = 1
	li t4, 1		# code = 1

while:	
	# code <= 0, done
	blez t4, done
	
	# code > 0
	add a1, a1, t5
	lw, t4, 0(a1)		# code = x_code[in_index]
	sub a1, a1, t5
				
	add a0, a0, t5
	lw a7, 0(a0)		# val = x_val[in_index]
	sub a0, a0, t5
	
	addi t5, t5, 4		# in_index++			
	
while_nested:
	# code != 0xf0, break
	li t2, 0xf0
	bne t4, t2, break
	
	# code == 0xf0
	add a5, a5, t1		# y_val[out_index]
	li t2, 4
	mul t4, t4, t2
	add a4, a4, t4
	lw t0, 0(a4)		# get_AC_Y_val(code)
	sw t0, 0(a5)		# y_val[out_index] = get_AC_Y_val(code)
	sub a5, a5, t1
	
	add a6, a6, t1		# y_size[out_index]
	j get_size3

get_size_AC_nested_while:
	# continue while nested loop
	add a6, a6, t1		# y_size[out_index]
	sw t3, 0(a6)		# y_size[out_index] = get_size_AC(get_AC_Y_val(code))
	sub a6, a6, t1
	
	li t2, 4
	sub a4, a4, t4
	div t4, t4, t2
	
	addi t1, t1, 4		# out_index++
	
	add a1, a1, t5
	lw, t4, 0(a1)		# code = x_code[in_index]
	sub a1, a1, t5
	
	add a0, a0, t5
	lw a7, 0(a0)		# val = x_val[in_index]
	sub a0, a0, t5
	
	addi t5, t5, 4		# in_index++	
	j while_nested
	
break:
	# val != 1, skip
	li t2, 1
	bne a7, t2, skip_if
	
	# val == 1 && code == 0, done
	beqz t4, done

skip_if:
	# continue while loop
	add a5, a5, t1		# y_val[out_index]
	
	li t2, 4
	mul t4, t4, t2
	add a4, a4, t4
	lw t0, 0(a4)		# get_AC_Y_val(code)
	sw t0, 0(a5)		# y_val[out_index] = get_AC_Y_val(code)
	sub a5, a5, t1
	
	j get_size4

back_get_size4:
	# continue while loop
	add a6, a6, t1		# y_size[out_index]
	sw t3, 0(a6)		# y_size[out_index] = get_size_AC(get_AC_Y_val(code))
	sub a6, a6, t1
	
	addi t1, t1, 4		# out_index++
	
	li t2, 4
	sub a4, a4, t4
	div t4, t4, t2
	
	# code == 0, done
	beqz t4, done
	
	add a5, a5, t1		# y_val[out_index]
	sw a7, 0(a5) 		# y_val[out_index] = val
	sub a5, a5, t1
	add a6, a6, t1		# y_size[out_index]
	
	j get_size2

back_get_size2:
	# continue while loop
	sw t3, 0(a6)		# y_size[out_index] = get_size(val)
	sub a6, a6, t1
	
	addi t1, t1, 4		# out_index++
	j while
	
done:
	ret


# size_of_bits = get_size(x_val[0])
get_size:
	# val != 0, next1
	bnez t0, next1
	li t3, 0
	beqz zero, end1
	
next1:
	# val is negative, 2's complement
	bgez t0, next2
	not t0, t0		# ~val
	addi t0, t0, 1		# val = ~val + 1

next2:
	li t3, 0		# uint26_t size = 0	
	li t2, 0xff00
	# MSB for 8 bits
	and t6, t0, t2		# val & 0xff00
	beqz t6, next3
	srli t0, t0, 8		# val = val >> 8
	ori t3, t3, 8		# size |= 8
	
next3:
	# MSB for 4 bits
	li t2, 0xf0	
	and t6, t0, t2		# val & 0xf0
	beqz t6, next4
	srli t0, t0, 4		# val = val >> 4
	ori t3, t3, 4		# size |= 4
	
next4:
	# MSB for 2 bits
	li t2, 0xc	
	and t6, t0, t2		# val & 0xc
	beqz t6, next5
	srli t0, t0, 2		# val = val >> 2
	ori t3, t3, 2		# size |= 2
	
next5:
	# Last bit
	li t2, 0x2	
	and t6, t0, t2		# val & 0x2
	beqz t6, end1
	ori t3, t3, 1		# size |= 1
	
end1:
	addi t3, t3, 1		# size + 1
	j  back_get_size
	
	
# First y_size[out_index] = get_size_AC(get_AC_Y_val(code))
get_size2:
	# val != 0, next1_2
	bnez a7, next1_2
	li t3, 0
	beqz zero, end1
	
next1_2:
	# val is negative, 2's complement
	bgez a7, next2_2
	not a7, a7		# ~val
	addi a7, a7, 1		# val = ~val + 1

next2_2:
	li t3, 0		# uint26_t size = 0	
	li t2, 0xff00
	# MSB for 8 bits
	and t6, a7, t2		# val & 0xff00
	beqz t6, next3_2
	srli a7, a7, 8		# val = val >> 8
	ori t3, t3, 8		# size |= 8
	
next3_2:
	# MSB for 4 bits
	li t2, 0xf0	
	and t6, a7, t2		# val & 0xf0
	beqz t6, next4_2
	srli a7, a7, 4		# val = val >> 4
	ori t3, t3, 4		# size |= 4
	
next4_2:
	# MSB for 2 bits
	li t2, 0xc	
	and t6, a7, t2		# val & 0xc
	beqz t6, next5_2
	srli a7, a7, 2		# val = val >> 2
	ori t3, t3, 2		# size |= 2
	
next5_2:
	# Last bit
	li t2, 0x2	
	and t6, a7, t2		# val & 0x2
	beqz t6, end2
	ori t3, t3, 1		# size |= 1
	
end2:
	addi t3, t3, 1		# size + 1
	j  back_get_size2
	

	
# First y_val[out_index] = get_AC_Y_val(code)
get_size3:
	li t3, 0		# uint8_t size = 0
	li t2, 0xff00
	# MSB for 8 bits
	and t6, t0, t2
	beqz t6, next_val1
	srai t0, t0, 8		# val = SHR(val, 8)
	ori t3, t3, 8		# size |= 8
	
next_val1:
	# MSB for 4 bits
	li t2, 0xf0
	and t6, t0, t2
	beqz t6, next_val2
	srai t0, t0, 4		# val = SHR(val, 4)
	ori t3, t3, 4		# size |= 4
	
next_val2:
	# MSB for 2 bits
	li t2, 0xc
	and t6, t0, t2
	beqz t6, next_val3
	srai t0, t0, 2		# val = SHR(val, 2)
	ori t3, t3, 2		# size |= 2

next_val3:
	# Last bit
	li t2, 0x2
	and t6, t0, t2
	beqz t6, next_val4
	ori t3, t3, 1		# size |= 1

next_val4:
	addi t3, t3, 1		# size++
	# size > 2, return size
	li t2, 2
	bge t3, t2, end_AC
	# size < 2, return 2
	li t3, 2
	
end_AC:	
	j get_size_AC_nested_while
	
			
# Second y_val[out_index] = get_AC_Y_val(code)
get_size4:
	li t3, 0		# uint8_t size = 0
	li t2, 0xff00
	# MSB for 8 bits
	and t6, t0, t2
	beqz t6, next_val1_1
	srai t0, t0, 8		# val = SHR(val, 8)
	ori t3, t3, 8		# size |= 8
	
next_val1_1:
	# MSB for 4 bits
	li t2, 0xf0
	and t6, t0, t2
	beqz t6, next_val2_1
	srai t0, t0, 4		# val = SHR(val, 4)
	ori t3, t3, 4		# size |= 4
	
next_val2_1:
	# MSB for 2 bits
	li t2, 0xc
	and t6, t0, t2
	beqz t6, next_val3_1
	srai t0, t0, 2		# val = SHR(val, 2)
	ori t3, t3, 2		# size |= 2

next_val3_1:
	# Last bit
	li t2, 0x2
	and t6, t0, t2
	beqz t6, next_val4_1
	ori t3, t3, 1		# size |= 1

next_val4_1:
	addi t3, t3, 1		# size++
	# size > 2, return size
	li t2, 2
	bge t3, t2, end_AC2
	# size < 2, return 2
	li t3, 2
	
end_AC2:	
	j back_get_size4
