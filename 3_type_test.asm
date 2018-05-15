.eqv KEY_CODE 0xFFFF0004 # ma ky tu nhap vao
.eqv KEY_READY 0xFFFF0000 # =1 neu nhap ky tu moi
.eqv COUNTER 0xFFFF0013 # Time Counter
.eqv SEVENSEG 0xFFFF0010 # dia chi dk den led

.data
	string: .ascii "cat and dog"
	end_of_string: .byte 0
	display: .byte 63, 6, 91, 79, 102, 109, 125, 7, 127, 111
.text
main: 
	move 	$k0, $zero		# $k0 = 0 (counter)
	li 		$s0, KEY_CODE
	li 		$s1, KEY_READY
	la 		$s2, end_of_string #string end
	la 		$s3,string #current char
	li 		$s4,0 #correct char
	li 		$k1,100000
	li 		$t1, COUNTER
	sb 		$t1, 0($t1) # Enable the interrupt of TimeCounter of Digital Lab Sim
WaitForKey:
	lw 		$t1, 0($s1) # $t1 = [$s1] = KEY_READY
	bgt		$k0, $k1, LED	# if $k0 > $k1 then LED
	ble		$s2, $s3, LED #s2<=s3 then LED
	beq		$t1, $zero, WaitForKey # if $t1 == 0 then Polling
	lw		$t0, 0($s0) # $t0 = [$s0] = KEY_CODE
	beq		$t0,$0,WaitForKey
	sw 		$0, 0($s0)
	sw 		$0, 0($s1) 
	lb 		$t1,0($s3)
	bne		$t0, $t1, wrong	# if $t0 == $t1 then wrong
	addi		$s4, $s4, 1			# $s4 = $s4 + 1
wrong:
	addi		$s3, $s3, 1			# $s3 = $s3 + 1
	bgt		$s2, $s3, WaitForKey	# if $s2 != $s3 then WaitForKey
	
LED:
	li 		$t1, COUNTER
	sb 		$0, 0($t1) # Disable the interrupt of TimeCounter of Digital Lab Sim
	rem		$a0,$s4,10
	la		$a1,display
	add		$a1, $a1, $a0		# $a1 = $a1 + $a0
	lb		$a0, 0($a1)		# 
	li 		$t0, SEVENSEG
	sb		$a0, 0($t0)
	div 		$a0,$s4,10 # chia lay phan nguyen
	rem		$a0,$a0,10 # chia lay so du
	la		$a1,display
	add		$a1, $a1, $a0		# $a1 = $a1 + $a0
	lb		$a0, 0($a1)		# 
	sb		$a0, 1($t0)
end:
	li		$v0, 10		# $v0 = 0
	syscall
	
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# GENERAL INTERRUPT SERVED ROUTINE for all interrupts
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
	addi	$k0, $k0, 1			# $k0 = $k0 + 1
	eret 					# Return from exception
