.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:
    # Prologue
    li t0, 1
    blt a1, t0, error_exit
    mv t0, x0 # for index
    mv t1, x0 # for compare value
    mv t2, x0 # for store max index
loop_start:
    bge t0, a1, loop_end
    lw t3, 0(a0) 
    bge t1, t3, loop_continue
    mv t1, t3
    mv t2, t0
loop_continue:
    addi t0, t0, 1
    addi a0, a0, 4
    j loop_start
loop_end:
    mv a0, t3    
    # Epilogue
    ret
error_exit:
    li a0, 7
    ecall
