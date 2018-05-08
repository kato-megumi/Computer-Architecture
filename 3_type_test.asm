.eqv KEY_CODE 0xFFFF0004 # ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 # =1 if has a new keycode ?

.macro  push($reg) # Push a .word register
sw      $reg, ($sp)
addi    $sp, $sp, -4
.end_macro
.macro clear($reg)
xor $reg,$reg,$reg
.end_macro
.macro  pop($reg) # Pop a .word register
addi    $sp, $sp, 4
lw      $reg, ($sp)
.end_macro
.data
	string: .ascii "cat and dog"
	end: .word 0
.text
main:
	li $s0, KEY_CODE
	li $s1, KEY_READY
	li $s2, string
	li $s3, end
	sub $s2,$s3,$s2 # $s2 = string.len()
	li $s3,0 #current char
	li $s4,0 #correct char
Loop:   
	nop
WaitForKey:
	lw $t1, 0($s1) # $t1 = [$s1] = KEY_READY
	beq $t1, $zero, WaitForKey # if $t1 == 0 then Polling
	lw $t0, 0($s0) # $t0 = [$s0] = KEY_CODE
	sw $0, 0($s0)
	sw $0, 0($s1)

