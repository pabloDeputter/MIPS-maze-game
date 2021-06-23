# excersise6.asm: Asks for radious of circle and will print the area.
# Registers used:
# $v0 : syscall parameter and return value
# $a0 : syscall parameter and print value
# $f0 : used to store Floating Point integer value
# $f1 : used to store input value from pi
# $f2 : used to store value from $f0 * $f0
# $f3 : used to store value from $f2 * $f1

	.data
ask_msg:	.asciiz	"Enter a positive floating point integer: "
return_msg:	.asciiz "Return the area of circle"
# Voor de extra nauwkeurigheid.
pi:		.float 3.141592653589793238462643383279502884197169399375105820974944592307816

	.text
	la $a0, ask_msg			# Load address of ask_msg in $a0.
	li $v0, 4			# Syscall code for printing of string.
	syscall				# Issues a system call.
	
	li $v0, 6			# Store user input into $f0.
	syscall				# Issues a system call.

	l.s  $f1, pi			# Store value from pi in $f1.
	
	mul.s $f2, $f0, $f0		# Multiplication of Floating Point between $f0 and $f0, store result in $f2.
	mul.s $f3, $f2, $f1		# Multiplication of Floating Point between $f1 and $f2, store result in $f23.
	
		
	mov.s $f12, $f3			# Move value from $f3 to $f12.
	li $v0, 2			# Syscall code for printing of Floating Point.
	syscall				# Issues a system call.

	j exit				# Jump unconditionally to exit address.		
	
exit:
	li $v0, 10			# Syscall code will shutdown program
	syscall				# Issues a system call.
