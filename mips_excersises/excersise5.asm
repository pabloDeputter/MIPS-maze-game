# excersise5.asm: Prints "Prime" if geven number is a prime number else "No prime".
# Registers used:
# $v0 : syscall parameter and return value
# $a0 : syscall parameter and print value
# $t0 : used to store input integer of user
# $t1 : used to store divisor 2 and will add 1 every loop
# $t2 : used to store remainder of $t0 / $t1.

	.data
ask_msg:	.asciiz	"Give up a integer: "
outputPrime:	.asciiz "Prime"
outputNoPrime: 	.asciiz "No prime"
divisor:	.word	2

	.text 
main:
	la $a0, ask_msg			# Load address of ask_msg in $a0.
	li $v0, 4			# Syscall code for printing of string.
	syscall				# Issues a system call.
	
	li $v0, 5			# Store user input into $v0.
	syscall				# Issues a system call.
	
	move $t0, $v0			# Move input value to save location / register 0.

	ble $t0, 1, noPrime		# If input value equal or less than 1 jump to noPrime.
	beq $t0, 2, Prime		# If input value equal to 2 jump to Prime.
	lw $t1, divisor			# Store value of divisor in $t1.		
	bgt $t0, 1, Loop		# If input greater than 1 jump to Loop.

Check:
	add $t1, $t1, 1			# Adds 1 and value of $t1 and store result in $t1.
	beq $t0, $t0, Prime		# If divisor and input integer are equal jump to Prime.
	j Loop
	
Loop:
	rem $t2, $t0, $t1		# Stores remainder of $t0 / $t1 in $t2.
	beq $t2, 0, noPrime		# If remainder equal to zero jump to noPrime.
	j Check				# Jump unconditionally to Check.
	 
Prime:
	la $a0, outputPrime		# Load value of outputPrime in $a0.
	li $v0, 4			# Syscall code for printing of string.
	syscall				# Issues a system call.
	
	j exit				# Jump unconditionally to exit address.
noPrime:	
	la $a0, outputNoPrime		# Load value of outputNoPrime in $a0.
	li $v0, 4			# Syscall code for printing of string.
	syscall				# Issues a system call.
	
	j exit				# Jump unconditionally to exit address.
	
exit:
	li $v0, 10			# Syscall code will shutdown program
	syscall				# Issues a system call.
	
