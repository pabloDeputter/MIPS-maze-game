# excersise1.asm: A "This is my n-th MIPS-program." program.
# Registers used:
# $v0 : syscall parameter and return value
# $a0 : syscall parameter: store the ask_msg to print
# $a1 : syscall parameter: store the first_msg to print
# $a2 : syscall parameter: store the second_msg to print
# -> One syscal parameter can be used, but this is cleaner.
# $t0 : used to store the user_input integer

	.data
	
ask_msg: 	.asciiz		"Enter a positive number: "
first_msg:	.asciiz		"This is my "
second_msg:	.asciiz		"-th MIPS-program."

	.text

main:
	la $a0, ask_msg		# Load the adress of ask_msg in $a0.
	li $v0, 4		# Syscall code for printing string.
	syscall			# Issue a system call.

	li $v0, 5		# Syscall code for input integer.
	syscall			# Issue a system call.
	
	move $t0, $v0		# Move input integer to register $t0.
	
	la $a0, first_msg	# Load the adress of ask_msg in $a1.
	li $v0, 4		# Syscall code for printing string.
	syscall				# Issue a system call.
	
	move $a0, $t0		# Load the value stored in $t0 into $a0.
	li $v0, 1		# Syscall code for printing integer.
	syscall
	
	la $a0, second_msg	# Load the adress of ask_msg in $a2.
	li $v0, 4		# Syscall code for printing string.
	syscall			# Issue a system call.

exit:
	li $v0, 10		# Syscall code for exit program.
	syscall			# Issue a system call.