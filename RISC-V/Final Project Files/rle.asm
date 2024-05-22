.globl rle

rle:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	li t0, 0x0000	# t0 = 0x0000
	sw t0, 0(x11)	# y_code[0] = 0x0000
	addi x11, x11, 4	
	
	lw t0, 0(x10)	# t0 = x[0]
	sw t0, 0(x12)	# y_val[0] = x[0]
	addi x12, x12, 4
	
	li t0, 4	# i = 1
	li t1, 0	# zero_count = 0
	li t2, 0	# out_index = 0
	
loop:
	# for loop
	li t3, 256	# 64 * 4 = 256
	bge t0, t3, end
	add x10, x10, t0	# x[i]
	lw t4, 0(x10)	# val = x[i]
	
	# else
	bnez t4, while	
	addi t1, t1, 1	# zero_count++
	beqz zero, no_condition

while:
	# zero_count > 15
	li t3, 15
	ble t1, t3, while_break
	
	li t3, 0x00f0
	add x11, x11, t2	# y_code[out_index]
	sw t3, 0(x11)	# y_code[out_index] = 0x00f0
	sub x11, x11, t2
	
	li t3, 0x0000
	add x12, x12, t2	# y_val[out_index]
	sw t3, 0(x12)	# y_vak[out_index] = 0x0000
	sub x12, x12, t2
	
	li t3, 16
	sub t1, t1, t3	# zero_count -= 16
	addi t2, t2, 4
	
	j while

while_break:
	add x11, x11, t2
	slli t5, t1, 4	# zero_count << 4
	mv a3, t4
	j get_size

for_loop_else:	# continue
	mv t4, a3
	or t5, t5, t6	# zero_count << 4 | get_size(val)
	sw t5, 0(x11)	# y_code[out_index] = zero_count << 4 | get_size(val)
	sub x11, x11, t2
	
	add x12, x12, t2	# y_val[out_index]
	sw t4, 0(x12)	# y_val[out_index] = val
	sub x12, x12, t2
	li t1, 0	# zero_count = 0
	addi t2, t2, 4	# out_index ++ 

no_condition:
	sub x10, x10, t0
	addi t0, t0, 4	# i++
	j loop

end: 
	# after for loop
	lw t1, 0(x10)	# x[63]
	beqz t1, done
	li t1, 0x0000
	add x11, x11, t2
	sw t1, 0(x11)	# y_code[out_index] = 0x0000
	sub x11, x11, t2
	
	li t1, 0x0001
	add x12, x12, t2
	sw t1, 0(x12)	# y_val[out_index] = 0x0001
	sub x12, x12, t2

done:
    	lw ra, 0(sp)
    	addi sp, sp, 4
    	ret 
	
get_size: 
	# val = t4
	# size = t6
	# loader = t3
	
	# val < 0, val = ~val + 1
	bnez t4, get_size1
	
	li t6, 0	# size = 0
	# val == 0, return 0
	beqz zero, end_size
	
get_size1:
	# val < 0, val = ~val + 1
	bgez t4, get_size2
	not t4, t4	# val = ~val
	addi t4, t4, 1	# val = ~val + 1
	
get_size2:
	li t6, 0	# uint16_t size = 0
	li t3, 0xff00
	and a4, t4, t3	# val = 0xff00
	beqz a4, get_size3
	srli t4, t4, 8	# val = val >> 8
	ori t6, t6, 8	# size |= 8

get_size3:
	li t3, 0xf0
	and a4, t4, t3	# val & 0xf0
	beqz a4, get_size4
	srli t4, t4, 4	# val = val >> 4
	ori t6, t6, 4	# size |= 4
	
get_size4:
	li t3, 0xc
	and a4, t4, t3	# val & 0xc
	beqz a4, get_size5
	srli t4, t4, 2	# val = val >> 2
	ori t6, t6, 2	# size |= 2
	
get_size5:
	li t3, 0x2
	and a4, t4, t3	# val & 0x2
	beqz a4, end_size
	ori t6, t6, 1	# size |= 1
	
end_size:
	addi t6, t6, 1	# size + 1
	j for_loop_else
	

