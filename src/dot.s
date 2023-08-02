.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
dot:
    # Prologue
    li t0, 1 
    blt a2, t0, error_length
    blt a3, t0, error_stride
    blt a4, t0, error_stride
    li t0, 4
    mul a3, a3, t0
    mul a4, a4, t0
    mv t0, x0 # t0 for index
    mv t1, x0 # t1 for multiply
    mv t2, x0 # t2 for sum
loop_start:
    bge t0, a2, loop_end
    lw t3, 0(a0)
    lw t4, 0(a1)
    mul t1, t3, t4
    add t2, t2, t1
    addi t0, t0, 1
    add a0, a0, a3
    add a1, a1, a4
    j loop_start
loop_end:
    # Epilogue
    mv a0, t2
    ret
error_length:
    li a0, 5
    ecall
error_stride:
    li a0, 6
    ecall
