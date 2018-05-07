.eqv IN_ADRESS_HEXA_KEYBOARD       0xFFFF0012 
.eqv OUT_ADRESS_HEXA_KEYBOARD 0xFFFF0014
.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?
.eqv HEADING 0xffff8010 # Integer: An angle between 0 and 359
.eqv MOVING 0xffff8050 # Boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 # Boolean (0 or non-0):
.eqv WHEREX 0xffff8030 # Integer: Current x-location of MarsBot
.eqv WHEREY 0xffff8040 
.macro  push($reg) # Push a .word register
sw      $reg, ($sp)
addi    $sp, $sp, -4
.end_macro
.macro  pop($reg) # Pop a .word register
addi    $sp, $sp, 4
lw      $reg, ($sp)
.end_macro
.data
		s_1b4: .asciiz "1b4\n"
		s_c68: .asciiz "c68\n"
		s_444: .asciiz "444\n"
		s_666: .asciiz "666\n"
		s_dad: .asciiz "dad\n"
		s_cbc: .asciiz "cbc\n"
		s_999: .asciiz "999\n"

.text
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN Procedure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
main:
	#---------------------------------------------------------
	# Enable interrupts you expect
	#---------------------------------------------------------
	# Enable the interrupt of Keyboard matrix 4x4 of Digital Lab 
	li    $t1,   IN_ADRESS_HEXA_KEYBOARD
	li    $t3,   0x80  # bit 7 of = 1 to enable interrupt   
	sb    $t3,   0($t1)
	li $s0, KEY_CODE
	li $s1, KEY_READY
Loop:   
	sw $0, 0($s0)
WaitForKey:
	lw $t1, 0($s1) # $t1 = [$s1] = KEY_READY
	beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
	lw $t0, 0($s0) # $t0 = [$s0] = KEY_CODE
	beq $t0, 0xa, enter
	beq $t0, 0x7f, delete
	j Loop
enter:
	beq $k1,0x1b4, do_1b4
	beq $k1,0xc68, do_c68
	beq $k1,0x444, do_444
	beq $k1,0x666, do_666
	beq $k1,0xdad, do_dad
	beq $k1,0xcbc, do_cbc
	beq $k1,0x999, do_999
	j delete
do_1b4:
	jal GO
	la $a0,s_1b4
	j printing
do_c68:
	jal STOP
	la $a0,s_c68
	j printing
do_444:
	li $a0,-90
	jal ROTATE
	la $a0,s_444
	j printing
do_666:
	li $a0,90
	jal ROTATE
	la $a0,s_666
	j printing
do_dad:
	jal TRACK
	la $a0,s_dad
	j printing
do_cbc:
	jal UNTRACK
	la $a0,s_cbc
	j printing
do_999:
	##------------------------------------
	la $a0,s_999
	j printing
printing:
	li $v0,4
	syscall

delete:
	li $k1,0
	nop
	b       Loop           
end_main:

#-----------------------------------------------------------
# GO procedure, to start running
# param[in] none
#-----------------------------------------------------------
GO: 
	li $at, MOVING # change MOVING port
	addi $k0, $zero,1 # to logic 1,
	sb $k0, 0($at) # to start running
	jr $ra
#-----------------------------------------------------------
# STOP procedure, to stop running
# param[in] none
#-----------------------------------------------------------
STOP: 
	li $at, MOVING # change MOVING port to 0
	sb $zero, 0($at) # to stop
	jr $ra
#-----------------------------------------------------------
# TRACK procedure, to start drawing line
# param[in] none
#-----------------------------------------------------------
TRACK:
	li $at, LEAVETRACK # change LEAVETRACK port
	addi $k0, $zero,1 # to logic 1,
	sb $k0, 0($at) # to start tracking
	jr $ra
#-----------------------------------------------------------
# UNTRACK procedure, to stop drawing line
# param[in] none
#-----------------------------------------------------------
UNTRACK:
	li $at, LEAVETRACK # change LEAVETRACK port to 0
	sb $zero, 0($at) # to stop drawing tail
	jr $ra
#-----------------------------------------------------------
# ROTATE procedure, to rotate the robot
# param[in] $a0, An angle between 0 and 359
# 0 : North (up)
# 90: East (right)
# 180: South (down)
# 270: West (left)
#-----------------------------------------------------------
ROTATE: 
	li $t0, HEADING # change HEADING port
	lw $t1, 0($t0)
	add $t1,$a0,$t1
	rem $t1,$t1,360
	sw $t1, 0($t0) # to rotate robot
	jr $ra



	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180                
	#--------------------------------------------------------
	# Processing
	#--------------------------------------------------------
IntSR:  
	push($ra)
	push($at)
	push($t0)
	push($t1)
	push($t3)
	push($a0)
	push($a1)
	li $t0, IN_ADRESS_HEXA_KEYBOARD
	li $t1, OUT_ADRESS_HEXA_KEYBOARD
	li $t3, 0x88 # check row 4 and re-enable bit 7
	sb $t3, 0($t0) # must reassign expected row
	lb $a0, 0($t1)
	li $t3, 0x84 # check row 4 and re-enable bit 7
	sb $t3, 0($t0) # must reassign expected row
	lb $at, 0($t1)
	xor $a0,$a0,$at
	li $t3, 0x82 # check row 4 and re-enable bit 7
	sb $t3, 0($t0) # must reassign expected row
	lb $at, 0($t1)
	xor $a0,$a0,$at
	li $t3, 0x81 # check row 4 and re-enable bit 7
	sb $t3, 0($t0) # must reassign expected row
	lb $at, 0($t1)
	xor $a0,$a0,$at
	andi $a0,$a0,0xff
	srl $t0, $a0, 3
	andi $t0,$t0,0x1
	neg $t0,$t0
	srl $t1, $a0,1
	or $t0,$t0,$t1
	andi $t0,$t0,0x3
	sll $a1,$t0,2 #
	srl $a0,$a0,4
	srl $t0, $a0, 3
	andi $t0,$t0,0xf
	neg $t0,$t0
	srl $t1, $a0,1
	or $t0,$t0,$t1
	andi $t0,$t0,0x3
	or $a1,$t0,$a1

	sll $k1, $k1, 4
	or $k1,$k1,$a1

next_pc:
	mfc0 $at, $14        # $at <=  Coproc0.$14 = Coproc0.epc
	addi $at, $at, 4     # $at = $at + 4   (next instruction)
	mtc0 $at, $14        # Coproc0.$14 = Coproc0.epc <= $at  
	pop($a1)
	pop($a0)
	pop($t3)
	pop($t1)
	pop($t0)
	pop($at)
	pop($ra)
return:
	eret # Return from exception                            
