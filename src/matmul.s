
.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error checks
    bge x0, a1, error_m0
    bge x0, a2, error_m0
    bge x0, a4, error_m1
    bge x0, a5, error_m1   
    bne a2, a4, error_not_match
    # Prologue
    addi sp, sp, -32
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    mv s0, x0 # s0 for m0 row index
    mv s1, x0 # s1 for m1 column index
    mv s2, a3 # save the addrs of m1
outer_loop_start:
    bge s0, a1, outer_loop_end
inner_loop_start:
    bge s1, a4, inner_loop_end
    # call dot func
    # save the args
    sw a0, 16(sp) 
    sw a1, 20(sp) 
    sw a3, 24(sp)
    sw a4, 28(sp)
    mv a1, a3 # assign the args, a0 = m0, a1 = m1's vector
    li a3, 1 # vector2 stride, a2 no need change
    mv a4, a5 # vector1 stride
    jal dot
    sw a0, 0(a6)
    # lw a1, 0(a6)
    # jal print_int
    # li a1 '\n'
    # jal ra print_char
    lw a0, 16(sp)
    lw a1, 20(sp)
    lw a3, 24(sp)
    lw a4, 28(sp)
    
    # Next Loop
    addi s1, s1, 1
    addi a3, a3, 4
    addi a6, a6, 4
    j inner_loop_start
inner_loop_end:
    li s1, 4
    mul s1, s1, a2
    add a0, a0, s1
    mv s1, x0
    addi s0, s0, 1
    mv a3, s2
    j outer_loop_start
outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    addi sp, sp, 32
    ret
error_m0:
    li a0, 2 
    ecall
error_m1:
    li a0, 3
    ecall
error_not_match:
    li a0, 4
    ecall
