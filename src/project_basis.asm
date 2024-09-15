# Deputter Pablo - s0205440
# project_basis.asm: maze werkend gekregen + snoepjes geïmplementeerd, maar niet dsf-algoritme.
# Unit Width: 16
# Unit Heigth: 16
# Display Width: 512
# Display Height: 256
# Base address: 0x10008000 ($gp)
# pixels = 256/16 * 512/16 = 512
# Als maar de helft van het doolhof op het Bitmap Display wordt geladen --> disconnect en connect opnieuw.

# Important registers:
#		- $t4 is used as a "True/False" register, if it value is 1 the exit has been found
#		- $t7 is used to store x - value of exit
#		- $t8 is used to store y - value of exit
#		- $t9 is used to hold the amount of remaining candies

.globl main
	
.data
# maze elements:
inputFile: .asciiz "input.txt"
wall: .word 0x000000ff 		# blue
w: .asciiz "w"
passage: .word 0x00000000 	# black
p: .asciiz "p"
player: .word 0x00ffff00 	# yellow
s: .asciiz "s"
exit: .word 0x0000ff00 		# green
u: .asciiz "u"
candy: .word 0xffffffff 	# white
c: .asciiz "c"
newline: .asciiz "\n" 	# newline
# display info:
height: .byte 16 		# height pixels
width: .byte 32			# width pixels	
bufferSize: .space 2048 	# stond in slides?
baseAddress: .word 0x10008000 	# global pointer
# messages:
messageWall: .asciiz "Player can't move into a wall! \n"
messageVictory: .asciiz "Victory! You escaped the maze!"

.text

main:
	# making game area
	la 	$t0, inputFile 	# laad address inputFile in $t0.
	move 	$a0, $t0	# Put procedure arguments
	jal 	readInputFile 	# Call procedure
	
	move	$s0, $v0	# $s0 holds player x - valye
	move	$s1, $v1	# $s1 holds player y - value
	
	# game loop
	j 	gameLoop
	
readInputFile:
# will read input txt file # 1 #

	sw 	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move 	$fp, $sp	# frame	pointer now points to the top of the stack
	subu 	$sp, $sp, 40 	# allocate 10*4 = 36 bytes on the stack ERROR
	sw 	$ra, -4($fp)	# store the value of the return address
	
	sw 	$s0, -8($fp)	# holds inputFile
	sw 	$s1, -12($fp)  	# holds buffer address
	sw 	$s2, -16($fp)	# holds amount of characters left
	sw 	$s3, -20($fp)	# holds x - value
	sw 	$s4, -24($fp)	# holds y - value
	sw	$s5, -28($fp)	# holds current character index
	sw	$s6, -32($fp)	# holds x - value of player
	sw	$s7, -36($fp)	# holds y - value of player
	
	move 	$s0, $a0 	# $s0 = inputFile
	
	# open inputFile
	li 	$v0, 13 	# system call for opening a file
	la 	$a0, inputFile
	li 	$a1, 0 		# open for reading
	li 	$a2, 0 		# mode is ignored
	syscall 		# Syscall to open file (file descriptor returned in $v0)
	
	move 	$s6, $v0 	# store file descriptor in $s0 ERROR
	
	# read inputFile from buffer
	li 	$v0, 14 	# system call for reading from a file
	move 	$a0, $s6	# store file descriptor in argument register ERROR
	la 	$a1, bufferSize	# load address of buffer to load the contents to
	la	$a2, 2048	# max number of characters = size of buffer
	syscall			# Syscall to read from file ($v0 contains the # characters read)
	
	la 	$s1, bufferSize # save address of buffer in $s1
	move 	$s2, $v0	# move $v0 to $s2 == characters remaining	
	addi	$s3, $s3, 0	# x - value == 0
	addi	$s4, $s4, -1 	# y - value == 0
	addi	$s5, $s5, -1	# char index == 0
	
	j iterator

exitReadInputFile:
# exit readInputFile # 1 #
		
	# Close file
	li 	$v0, 16 	# system call for close file
	move 	$a0, $s6 	# file descriptor to close
	syscall 		# close file 		
	
	move	$v0, $s6	# move x - value to $v0
	move	$v1, $s7	# move y - value to $v1
	li	$t4, 0		# later needed so cannot be 1
	
	lw	$s7, -36($fp)	# reset saved register $s7
	lw	$s6, -32($fp)	# reset saved register $s6
	lw	$s5, -28($fp)	# reset saved register $s5
	lw	$s4, -24($fp)	# reset saved register $s4
	lw	$s3, -20($fp)	# reset saved register $s3
	lw	$s2, -16($fp)	# reset saved register $s2
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current frame
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra		# jump to return address
	
iterator:
# iterates over all char's in buffer

	beq 	$s2, 0, exitReadInputFile
	addi 	$s2, $s2, -1  	# amount of characters left -1
	addi 	$s4, $s4, 1	# y - value + 1
	addi	$s5, $s5, 1	# char index == 0, 1, 2, ...
	
	add	$t1, $s5, $s1	# calculate address of current character
	lb 	$t2, 0($t1)	# $t2 holds char
	
	j	detectCharacter

detectCharacter:
	li 	$t3, 'w'
	beq 	$t2, $t3, displayWall

	li 	$t3, 'p'
	beq 	$t2, $t3, displayPassage
	
	li 	$t3, 's'
	beq 	$t2, $t3, displayPlayer
	
	li 	$t3, 'u'
	beq 	$t2, $t3, displayExit
	
	li 	$t3, 'c'
	beq 	$t2, $t3, displayCandy
	
	li 	$t3, '\n'
	beq 	$t2, $t3, incrementX

displayWall:
# displays a wall on bitmap

	la 	$t1, wall	# $t1 holds color of wall
	j 	displayElement
	
displayPassage:
# displays a passage on bitmap

	la	$t1, passage	# $t1 holds color of passage
	j 	displayElement
	
displayPlayer:
# displays player on bitmap

	la	$t1, player	# $t1 holds color of player
	addi	$s6, $s3, 0	# $s6 holds current player x - value
	addi	$s7, $s4, 0	# $s7 holds current player y - value
	j 	displayElement
	
displayExit:
# displays exit on bitmap
	
	bne 	$t9, 0, hideExit # $t9 holds amount of candy, if not zero --> hideExit

	# find remaining candy?
	addi	$t6, $s2, 0	# amount of characters left
	addi	$t5, $s5, 0	# char index
	la	$t1, exit	# $t1 holds color of exit
	j	findCandy	# finds candy in buffer string

hideExit:
# hides exit on bitmap and saves values

	addi	$t7, $s3, 0	# $t7 holds exit x - value
	addi	$t8, $s4, 0	# $t8 holds exit y - value
	la	$t1, passage	
	j	displayElement
	
findCandy:
# finds candy in buffer string
	
	beq	$t6, 0, displayElement # no candy found. --> displayElement
	addi	$t6, $t6, -1	# amount of characters left
	addi	$t5, $t5, 1	# char index
	
	add	$t4, $t6, $s1	# calculate address of current character
	lb	$t2, 0($t4)	# $t2 holds character
	
	li 	$t3, 'c'
	beq 	$t2, $t3, hideExit
	bne 	$t2, $t3, findCandy

displayCandy:
# displays candy on bitmap
	la	$t1, candy	# $t1 holds color of candy
	addi	$t9, $t9, 1	# $t9 HOLDS AMOUNT OF CANDY!!!!!
	j 	displayElement
	
incrementX:
# x - Value gets increased
	addi 	$s3, $s3, 1	# x - value + 1
	li	$s4, -1		# y - value gets resetted
	j 	iterator

displayElement:
# color correct bitmap pixel
	la 	$a0, 0($s3)	# x - value as $a0
	la 	$a1, 0($s4)	# y - value as $a1
	jal 	calculateAddressOffset # calculate address in bitmap
	
	add	$v1, $v1, $gp
	lw	$t1, 0($t1)
	sw	$t1, 0($v1)
	
	j	iterator

calculateAddressOffset:
# calculates address in bitmap off x - value and y - value

	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 28	# allocate 16 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	
	sw	$s0, -8($fp)	# holds x - value
	sw	$s1, -12($fp)	# holds y - valye
	sw	$s2, -16($fp)	# holds displayWidth
	sw	$s3, -20($fp)	# holds baseAddress
	sw	$s4, -24($fp)	# holds final result
	
	move 	$s0, $a0	# holds x - value
	move	$s1, $a1	# holds y - value	
	
	lb	$s2, width	# holds displayWidth
	la	$s3, baseAddress # holds baseAddress
	
	mul	$s4, $s0, $s2	# index
	add	$s4, $s4, $s1	# index
	mul 	$s4, $s4, 4	# index * 4 bytes
	# add	$s4, $s4, $s3	# add baseAddress
	
	move	$v1, $s4	# store result in $v1
	
	lw	$s4, -24($fp)	# reset saved register $s4
	lw	$s3, -20($fp)	# reset saved register $s3
	lw	$s2, -16($fp)	# reset saved register $s2
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current frame
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra		# return to returnAddress

updatePlayer:
# update player position if possible # 2 #

	sw	$fp, 0($sp)	# push old frame pointer (dynamic link)
	move	$fp, $sp	# frame	pointer now points to the top of the stack
	subu	$sp, $sp, 40	# allocate 40 bytes on the stack
	sw	$ra, -4($fp)	# store the value of the return address
	
	sw	$s0, -8($fp)	# holds address of current player position on bitmap
	sw	$s1, -12($fp)	# holds current x - valye
	sw	$s2, -16($fp)	# holds current y - value
	sw	$s3, -20($fp)	# holds new x - value
	sw	$s4, -24($fp)	# holds new y - value
	sw	$s5, -28($fp)	# holds address of new player position on bitmap
	sw	$s6, -32($fp)	# register used control of new player position
	sw	$s7, -36($fp)	# "
	
	move 	$s1, $a0	# $s1 holds current x - value
	move 	$s2, $a1	# $s2 holds current y - value
	move	$s3, $a2	# $s3 holds new x - value
	move	$s4, $a3	# $s4 holds new y - value
	
	addi	$a0, $s1, 0
	addi	$a1, $s2, 0
	jal 	calculateAddressOffset
	
	move	$s0, $v1	# $s0 holds addressOffset of current player position
	add	$s0, $s0, $gp	# $s0 holds now the address of current player position on bitmap
	
	addi	$a0, $s3, 0
	addi	$a1, $s4, 0
	jal	calculateAddressOffset
	
	move	$s5, $v1	# $s5 holds addressOffset of new player position
	add	$s5, $s5, $gp	# $s5 holds now the address of new player position on bitmap
	
	# Is correcto mundo?
	la	$s6, wall	# $s6 holds address of wall
	lw	$s6, 0($s6)	# $s6 holds color of wall
	lw	$s7, 0($s5)	# $s7 holds color of new player position
	beq	$s6, $s7, errorWall	# error if colors are the same (player new position is a wall)
	
	la	$s6, candy
	lw	$s6, 0($s6)	# $s6 holds color of candy
	lw	$s7, 0($s5)
	beq	$s6, $s7, candyDecrease	# decrease candy amount if player new position is a candy
	
	la	$s6, exit	
	lw	$s6, 0($s6)	# $s6 holds color of exit
	lw	$s7, 0($s5)	
	beq	$s6, $s7, foundExit # branch if player new position is exit
	
	j	updateDisplay	# enkel als alles correcto mundo is!!!

exitUpdatePlayer:
# exitUpdatePlayer procedure # 2 #
	
	lw	$s7, -36($fp)	# reset saved register $s7
	lw	$s6, -32($fp)	# reset saved register $s6
	lw	$s5, -28($fp)	# reset saved register $s5
	lw	$s4, -24($fp)	# reset saved register $s4
	lw	$s3, -20($fp)	# reset saved register $s3
	lw	$s2, -16($fp)	# reset saved register $s2
	lw	$s1, -12($fp)	# reset saved register $s1
	lw	$s0, -8($fp)	# reset saved register $s0
	lw	$ra, -4($fp)    # get return address from frame
	move	$sp, $fp        # get old frame pointer from current frame
	lw	$fp, ($sp)	# restore old frame pointer
	jr	$ra		# jump to return address

errorWall:
# new player position is a wall
	la	$a0, messageWall
	li	$v0, 4
	syscall
	
	move	$v0, $s1	# store old x - value in $v0
	move	$v1, $s2	# store old y - value in $v1
	
	j	exitUpdatePlayer

candyDecrease:
# new player position is a candy

	addi	$t9, $t9, -1	# decrease candy amount
	beq	$zero, $t9, revealExit	# if all candy is eaten --> reveal exit
	j	updateDisplay

revealExit:
# reveals the exit if all candy are eaten
	
	move	$a0, $t7	# $a0 holds x - value of exit
	move	$a1, $t8	# $a1 holds y - value of exit
	jal	calculateAddressOffset
	
	move	$t7, $v1	
	add	$t7, $t7, $gp	# $t7 holds exit location
	la	$t1, exit	
	lw	$t1, 0($t1)	# $t1 holds color of exit
	sw	$t1, 0($t7)	# display exit on correct address
	
	la	$s6, exit	
	lw	$s6, 0($s6)	# $s6 holds color of exit
	lw	$s7, 0($s5)	
	beq	$s6, $s7, foundExit # branch if player new position is exit
	
	j	updateDisplay

foundExit:
# player has found exit
	
	addi	$t4, $t4, 1	# will be checked everytime in gameLoop
	j	updateDisplay

updateDisplay:
# move player and change colors

	# display passage in old player position
	la	$t1, passage	# $t1 holds address of passage color
	lw	$t1, 0($t1)	# $t1 holds color of passage
	sw	$t1, 0($s0)	# display passage in old player position
	
	# display player in new player position
	la	$t1, player	# $t1 holds address of player color
	lw	$t1, 0($t1)	# $t1 holds color of player
	sw	$t1, 0($s5)	# display player in new player position
	
	move	$v0, $s3	# store new x - value in $v0
	move	$v1, $s4	# store new y - value in $v1
	
	j	exitUpdatePlayer

gameLoop:
# main gameLoop

	li 	$a0, 60
	li 	$v0, 32
	syscall		# adds 60ms delay
	
	# check for input
	lw 	$t1, 0xffff0000 # $t1 holds input value?
	# beq	$t1, 0, gameLoop # $t1 == 0 --> no input detected
	beq 	$t1, 1, detectInput # $t1 == 1 --> input detected
	
	j 	gameLoop	# no input!!
	
detectInput:
# 'z' = move player up
# 's' = move player down
# 'q' = move player left
# 'd' = move player right
# 'x' = exit game

	lw 	$t2, 0xffff0004 # holds character input
	li	$s2, 0
	li	$s3, 0		# reset new values
	
	li  	$t3, 'z'
	beq 	$t2, $t3, playerUp
	
	li	$t3, 's'
	beq	$t2, $t3, playerDown
	
	li	$t3, 'q'
	beq	$t2, $t3, playerLeft
	
	li 	$t3, 'd'
	beq	$t2, $t3, playerRight
	
	li	$t3, 'x'
	beq	$t2, $t3, exitGame
	
	j 	gameLoop	# character is not recognized!!

playerUp:
	addi	$s2, $s0, -1	# x - value gets decreased
	addi	$s3, $s1, 0
	j	movePlayer
	
playerDown:
	addi 	$s2, $s0, 1	# x - value gets increased 
	addi	$s3, $s1, 0
	j	movePlayer
	
playerLeft:
	addi	$s3, $s1, -1 	# y - value gets decreased
	addi	$s2, $s0, 0
	j	movePlayer

playerRight:
	addi	$s3, $s1, 1	# y - value gets increased
	addi	$s2, $s0, 0
	j 	movePlayer
	
movePlayer:
# prepare procedure

	move	$a0, $s0
	move	$a1, $s1
	move	$a2, $s2
	move	$a3, $s3
	jal	updatePlayer	# update player position
	
	move	$s0, $v0	# move new OR old x - value in $s0
	move	$s1, $v1	# move new OR old y - value in $s1
	
	beq	$t4, 1, exitVictory # exit is found --> exit game
	
	j 	gameLoop

exitGame:
# will exit the game clean

	li	$v0, 10
	syscall

exitVictory:
# will exit the game only if the player has found the exit
	li 	$a0, 60
	li 	$v0, 32
	syscall	
			
	la	$a0, messageVictory
	li	$v0, 4	
	
	syscall
	j	exitGame


