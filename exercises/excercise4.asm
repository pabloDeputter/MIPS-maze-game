# excersise4.asm : use of JumpTable.
# Registers used:
# $s1 : contains base address of jumpTable
# $t1 : used to modify the jumpTable
# $t2 : used to load value of exprValue
# $s2 : used to store value of exprValue
# $t3 : used to load value of result
# $s3 : used to store value of exprValue
# $t6 : used to load value of CASES
# $t1 : used to store address to jump to in jumpTable
# $t0 : used as ZERO register
# $v0 : syscall parameter and return value
# $a0 : syscall parameter and print value

	.eqv CASES 2		# Number of cases.
	.eqv CASES_SPACE 12	# Number of cases + 1 x 4.
	
	.data			# Data segment.
	
	.align 2		# Aligns to multiple of 4.

jumpTable:
	.space CASES_SPACE	# Allocates 12 consecutive words to store different pointers to addresses
				# of different cases.

exprValue: 
	.word 1			# Value of i.
result:    
	.word 0			# Value of a.
newLine:
	.asciiz	"\n"		# Prints out a newLine.
	
	.text			# Text segment.
	
	# Fill jumpTable with addresses of different cases.
	
	la $s1, jumpTable	# $s1 contains base address of jumpTable.
	la $t1, C0
	sw $t1, 0($s1)
	la $t1, C1
	sw $t1, 4($s1)
	la $t1, C2
	sw $t1, 8($s1)
	
	# Load integer exprValue in $s2.
	
	la $t2, exprValue	# Load exprValue into $t2.
	lw $s2, 0($t2)		# Load value of $t2 into $s2 with offset ZERO.
	
	# Load integer result in $s3.
	
	la $t3, result		# Load result into $t3.
	lw $s3, 0($t3)		# Load value of $t3 into $s3 with offset ZERO.
	
	# Check if exprValue in range 0 ... CASES.
	
	blt $s2, $zero, Default	# Branch to Default if $s2 is less than ZERO.
	li $t6, CASES		# Load value of CASES into $t6.
	bgt $s2, $t6, Default	# Branch to Default if $s2 is greater than CASES.
	
	# Use the jumpTable to branch to the correct case for exprValue.
	
	sll $t1, $s2, 2		# Multiple exprValue by 4 and store address in $t0.
	add $t1, $s1, $t1	# ADD value in $t0 with base address of jumptTable and store result in $t0.
	lw $t1, 0($t1)		# Store address of $t1 in $t1 with offsett ZERO.
	jr $t1			# Jump to jumpTable address $t1 unconditionally.
	
	# Cases
C0:
	addi $s3, $t0, 9	# Set value of result to 9.
	j Exit			# Jump unconditionally to Exit.
C1:
	addi $s3, $t0, 6	# Set value of result to 6.
				# No break --> fallTrough to the next case.
C2:
	addi $s3, $t0, 8	# Set value of result to 8.
	j Exit			# Jump unconditionally to Exit.
	
Default:
	addi $s3, $t0, 7	# Set value of result to 7.
	j Exit			# Jump unconditionally to Exit.
Exit:
	# Store and print result + newLine.
	
	move $a0, $s3
	li $v0, 1
	syscall
	
	la $a0, newLine		# Load address of newLine into $a0.
	li $v0, 4		# Syscall code will print out a string.
	syscall			# Issues a system call.
	
	# Exit program.
	
	li $v0, 10		# Syscall code will shutdown program
	syscall			# Issues a system call.


	