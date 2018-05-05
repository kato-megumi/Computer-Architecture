.data
	start:  .asciiz "     Disk1              Disk2              Disk3      \n "
	string: .asciiz " --------------     --------------     -------------- \n"
	a1:  .asciiz "|     "
	a2: .asciiz "     |   "
	b1: .asciiz "[[ "
	b2: .asciiz "]]   "
	promt: .asciiz "Nhap chuoi ki tu : "
	error: .asciiz "\ndo dai xau phai la boi cua 8"
	error2:.asciiz "\nXau khong duoc rong"
	digit_to_hex:	.byte	'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
	.align 2
	buffer: .space  5000
	buff: .word 0
	x: .byte 0
.text
	la $a0, promt
	li $v0,4
	syscall 
	la $a0, buffer
	li $a1, 4000
	li $v0 ,8
	syscall
	la $s0, buffer
count:
	lb $t0, 0($s0) #bien dem s0 =* buffer[i]; t0 = buffer[i]
	beq $t0, $zero, end_count # if t0=0 end count loop
	addi $s0,$s0,1 #increase s0++
	j count
end_count:
	sub $s0, $s0, $a0 #string length
	addi $s0,$s0,-1 #minus "enter" character 
	srl $t0, $s0, 3 # divide by 8, t0 is amount of 2 block
	andi $s0, $s0, 7 # kiem tra la boi cua 8 hay khong 
	bne $s0, $zero, print_err # neu khong thi bao loi
	beq $t0, $zero, print_err2 # neu do dai = 0 cung bao loi
	la $a0, start 
	li $v0,4
	syscall #in
	jal print_ # lai in
	move $a0,$0
loop:
	jal print_line #goi ham print_line voi tham so a0, a0 la block hien tai
	addi $a0,$a0,1
	bne $a0,$t0,loop
	jal print_
	j end



print_line: # @param $a0
	addiu $sp,$sp,-8 
	sw $ra, 4($sp)
	sw $a0, 8($sp) # push a0, ra
	rem $t9,$a0,3 
	sll $t1, $a0, 3
	la $t2,buffer
	add $t2,$t2,$t1
	lw $t3, 0($t2) 
	lw $t4, 4($t2)
	xor $t5,$t3,$t4
	beqz $t9,type0
	beq $t9, 1, type1
	j type2
type0:
	move $a1,$t3
	jal print_block  #goi ham print_block voi tham so a1 
	move $a1,$t4
	jal print_block
	jal print_xor
	j end_switch
type1:
	move $a1,$t3
	jal print_block
	jal print_xor
	move $a1,$t4
	jal print_block
	j end_switch
type2:
	jal print_xor
	move $a1,$t3
	jal print_block
	move $a1,$t3
	jal print_block
end_switch:
	li $a0,'\n'
	li $v0,11
	syscall
	lw $a0, 8($sp) 
	lw $ra, 4($sp)
	addiu $sp,$sp,8 #pop ra,a0
	jr $ra



print_block: # @param $a1 
	la $a0, a1
	li $v0,4
	syscall
	la $a0, buff
	sw $a1, 0($a0)
	li $v0,4
	syscall
	la $a0, a2
	li $v0,4
	syscall
	jr $ra




print_xor:
	la $a0, b1
	li $v0,4
	syscall
	la $s1,digit_to_hex

	srl $s0, $t5, 4
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	and $s0,$t5,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	li $a0,','
	li $v0,11
	syscall

	srl $s0, $t5, 12
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	srl $s0, $t5, 8
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	li $a0,','
	li $v0,11
	syscall

	srl $s0, $t5, 20
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	srl $s0, $t5, 16
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	li $a0,','
	li $v0,11
	syscall

	srl $s0, $t5, 28
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	srl $s0, $t5, 24
	and $s0,$s0,0xf
	add $s2,$s1,$s0
	lb $a0,0($s2)
	li $v0,11
	syscall

	la $a0, b2
	li $v0,4
	syscall
	jr $ra



print_:
	la $a0, string
	li $v0,4
	syscall
	jr $ra



print_err:
	la $a0,error
	li $v0,4
	syscall #print Error message
	j end
print_err2:
	la $a0,error2
	li $v0,4
	syscall #print Error message
end:
	li $v0,10
	syscall

