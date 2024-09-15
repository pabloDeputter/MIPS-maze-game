# excersise2.asm: represents a cpp for-loop in MIPS.
# Registers used:
# $v0 : syscall parameter and return value
# $a0 : syscall parameter and print value
# $t1 : used to store current value of iterator
# $t2 : used to store max value iterator can be

	.data
iterator_current:	.word 1		# Current value of iterator.
iterator_limit:		.word 11	# Max value of iterator.
iterator_newline:	.asciiz	"\n"	# Used to print iterator values.

	.text
main:
	lw $t1, iterator_current	# Load value of iterator_current in $t1.
	lw $t2, iterator_limit		# Load value of iterator_limit in $t2.

loop:
	bge  $t1, $t2, exit		# Branch to exit adress if $t1 => $t2.
	
	move $a0, $t1			# Load value stored in $t1 into $aO.
	li $v0, 1			# Syscall code for printing integer.
	syscall
	
	la $a0, iterator_newline	# Load value of iterator_newline in $a0.
	li $v0, 4			# Syscall code for printing integer.
	syscall
	
	addi  $t1, $t1, 1 		# Add 1 to $t1.
	j  loop 			# Jump unconditionally to loop adress.
exit:
	li, $v0, 10			# Syscall code for exit program.
	syscall				# Issues a system call.
