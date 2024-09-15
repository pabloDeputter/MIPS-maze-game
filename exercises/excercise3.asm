# excersise3.asm: Prints a pyramid with n rows.
# Registers used:
# $v0 : syscall parameter and return value
# $a0 : syscall parameter and print value
# $t1 : used to store current value of iterator
# $t2 : used to store max value iterator can be


		.data
ask_msg:	.asciiz	"Enter a positive integer: "
newLine:	.asciiz "\n"
space:		.asciiz	" "
it_current: 	.word	0

	.text
main:
	la $a0, ask_msg		# Load value of ask_msg in $a0.
	li $v0, 4		# Syscall code for printing string.
	syscall
	
	li, $v0, 5		# Syscall code for input integer.
	syscall
	
	move $t0, $v0		# Store value of $v0 in $t0, this is safer.
	
	lw $t1, it_current	# Store value of it_current in $t1.
	
	beqz $t0, exit		# Branch if value stored in $t0 is equal to zero.

loop:
	beq  $t1, $t0, exit	# Branch if $t1 and $t0 are equal.
	
	add $t2, $zero, $zero	# Store zero in $t2.
	addi $t1, $t1, 1	# Add 1 to $t1.
	
	la $a0, newLine		# Load adress of newline.
	li $v0, 4		# Prints "\n".
	syscall
	
	j loopPyramid 		# Jump unconditionally to loopPyramid adress.

loopPyramid:
	beq $t2, $t1, loop	# Branch if $t2 and $t1 are equal.
	
	addi $t2, $t2, 1	# Add 1 to $t2.
	
	move $a0, $t2		# Print value of $t2.
	li $v0, 1		# Syscall code for printing integer.
	syscall
	
	la $a0, space		# Print " ".
	li $v0, 4		# Syscall code for printing string.
	syscall
	
	j loopPyramid		# Jump unconditionally to loopPyramid adress.
	

exit:
	li $v0, 10		# Syscall code for exit program.
	syscall
