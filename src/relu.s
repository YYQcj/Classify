.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the number of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    addi sp, sp, -8 # stack pointer for two register
    sw s0, 0(sp) # save s0 register for index
    sw s1, 4(sp) # save s1 register for array element value
    li s0, 1
    blt a1, s0, error_exit
    mv s0, x0 # assign s0 to zero
loop_start:
    bge s0, a1, loop_end # if index >= len, loop end
    lw s1, 0(a0) # load value from array address
    bge s1, x0, loop_continue # if arr[index] >= 0, jump to loop_continue 
    # arr[index] < 0, replace arr[index] with 0
    sw x0, 0(a0)
loop_continue:
    addi s0, s0, 1 # index++
    addi a0, a0, 4 # one int = 4 bytes
    j loop_start
loop_end:
    # Epilogue
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
	ret
error_exit:
    li a0, 8
    ecall
