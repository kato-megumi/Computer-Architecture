.data
	CharPtr: .word 0 # Bien con tro, tro toi kieu asciiz
	BytePtr: .word 0 # Bien con tro, tro toi kieu Byte
	WordPtr: .word 0 # Bien con tro, tro toi mang kieu Word
	ArrayPtr: .word 0 # Bien con tro, tro toi mang 2 chieu
	row: .word 1
	col: .word 1
	menu: .asciiz "\n1.Malloc char.\n2.Malloc Byte.\n3.Malloc Word.\n4.Malloc 2D word Array.\n5.Gia tri cac bien con tro.\n6.Dia chi cac bien con tro.\n7.Get Array.\n8.Set Array.\n9.Bo nho da cap phat.\nChon 1-9 (thoat neu chon so khac):"
	mal: .asciiz "\nso hang va cot phai nho hon 1000"
	char: .asciiz "\n Nhap so phan tu cua mang char:"
	word: .asciiz "\n Nhap so phan tu cua mang word:"
	byte: .asciiz "\n Nhap so phan tu cua mang byte:"
	arr1: .asciiz "\n Nhap so cot cua mang array:"
	arr2: .asciiz "\n Nhap so hang cua mang array:"
	in_row: .asciiz "\n Nhap i:"
	in_col: .asciiz "\n Nhap j:"
	in_val: .asciiz "\n Nhap gia tri de gan:"
	out_val:.asciiz "\n Gia tri tra ve:"
	giatri: .asciiz "\n Gia tri tai cac bien con tro CharPtr BytePtr WordPtr ArrayPtr la:"
	diachi: .asciiz "\n Dia chi cua cac bien con tro CharPtr BytePtr WordPtr ArrayPtr la:"
	out:  .asciiz "\n Malloc success. Mang bat dau tai dia chi: "
	bound: .asciiz "\nindex out of bound"
	null: .asciiz "\nNull Pointer Exception. Chua khoi tao mang!!!!"
	bo_nho: .asciiz "\nBo nho da cap phat: " 
	bytes: .asciiz " bytes."
	big: .asciiz "\n input value TOO BIG!!"
	sErr: .asciiz "\n input value cant be zero"
	buffer: .space 5
.kdata
	Sys_TheTopOfFree: .word 1 # Bien chua dia chi dau tien cua vung nho con trong
	Sys_MyFreeSpace: # Vung khong gian tu do, dung de cap bo nho cho cac bien con tro
.text
	#Khoi tao vung nho cap phat dong
	jal SysInitMem
main:
print_menu:
	la $a0,menu
	jal IntDialog
	move $s0, $a0 # switch case
	beq $s0, 1, op1
	beq $s0, 2, op2
	beq $s0, 3, op3
	beq $s0, 4, op4
	beq $s0, 5, op5
	beq $s0, 6, op6
	beq $s0, 7, op7
	beq $s0, 8, op8
	beq $s0, 9, op9
	j end
op1: #Malloc char
	la $a0,char
	jal IntDialog
	jal Check_value
	move $a1,$a0 
	la $a0,CharPtr
	li $a2,1
	jal malloc  #malloc( CharPtr, IntDialog(char),1 )
	move $s0,$v0 # save return value of malloc
	la $a0,out
	li $v0,4
	syscall # in thong bao malloc success
	move $a0,$s0
	li $v0,34
	syscall
	j main
op2:
	la $a0,byte
	jal IntDialog
	jal Check_value
	move $a1,$a0
	la $a0,BytePtr
	li $a2,1
	jal malloc  #malloc( BytePtr, IntDialog(byte),1 )
	move $s0,$v0 # save return value of malloc
	la $a0,out
	li $v0,4
	syscall  # in thong bao malloc success
	move $a0,$s0
	li $v0,34
	syscall
	j main
op3:
	la $a0,word
	jal IntDialog
	jal Check_value
	move $a1,$a0
	la $a0,WordPtr
	li $a2,4
	jal malloc #malloc( WordPtr, IntDialog(word),4 )
	move $s0,$v0 # save return value of malloc
	la $a0,out
	li $v0,4
	syscall # in thong bao malloc success
	move $a0,$s0
	li $v0,34
	syscall
	j main
op4:
	la $a0,arr1
	jal IntDialog #read in_row
	move $s0,$a0 
	la $a0,arr2
	jal IntDialog #read col
	move $a1,$s0 # malloc2 2nd parameter
	move $a2,$a0 # malloc2 3rd parameter
	la $a0,ArrayPtr
	jal Malloc2 #Malloc2( ArrayPtr, IntDialog(arr1),IntDialog(arr2))
	move $s0,$v0 # save return value of malloc
	la $a0,out 
	li $v0,4
	syscall # in thong bao malloc success
	move $a0,$s0
	li $v0,34
	syscall
	j main
op5:
	la $a0,giatri
	li $v0,4
	syscall 
	
	li $a0,0
	jal Val_val
	move $a0,$v0
	li $v0,34
	syscall
	li $a0,','
	li $v0,11
	syscall

	li $a0,1
	jal Val_val
	move $a0,$v0
	li $v0,34
	syscall
	li $a0,','
	li $v0,11
	syscall

	li $a0,2
	jal Val_val
	move $a0,$v0
	li $v0,34
	syscall
	li $a0,','
	li $v0,11
	syscall

	li $a0,3
	jal Val_val
	move $a0,$v0
	li $v0,34
	syscall

	j main
op6:
	la $a0,diachi
	li $v0,4
	syscall 

	li $a0,0
	jal Val_addr
	move $a0,$v0
	li $v0,34
	syscall
	li $a0,','
	li $v0,11
	syscall

	li $a0,1
	jal Val_addr
	move $a0,$v0
	li $v0,34
	syscall
	li $a0,','
	li $v0,11
	syscall

	li $a0,2
	jal Val_addr
	move $a0,$v0
	li $v0,34
	syscall
	li $a0,','
	li $v0,11
	syscall

	li $a0,3
	jal Val_addr
	move $a0,$v0
	li $v0,34
	syscall

	j main
op7:
	la $a0,ArrayPtr
	lw $s1,0($a0)
	beqz $s1,nullptr # if *ArrayPtr==0 error null pointer
	la $a0,in_row
	jal IntDialog # get row
	move $s0,$a0
	la $a0,in_col
	jal IntDialog  #get col
	move $a2,$a0
	move $a1,$s0
	move $a0,$s1
	jal GetArray
	move $s0,$v0 # save return value of GetArray
	la $a0,out_val
	li $v0,4
	syscall
	move $a0,$s0
	li $v0,34
	syscall
	j main
op8:
	la $a0,ArrayPtr
	lw $s7,0($a0)
	beqz $s7,nullptr # if *ArrayPtr==0 error null pointer
	la $a0,in_row
	jal IntDialog # get row
	move $s0,$a0
	la $a0,in_col
	jal IntDialog  #get col
	move $s1,$a0
	la $a0,in_val
	jal IntDialog  #get val
	move $a3,$a0
	move $a1,$s0
	move $a2,$s1
	move $a0,$s7
	jal SetArray
	j main
op9:
	la $a0,bo_nho
	li $v0,4
	syscall
	jal BoNho
	move $a0,$v0
	li $v0,1
	syscall	
	la $a0,bytes
	li $v0,4
	syscall	
	j main
	#------------------------------------------
	# Tinh tong luong bo nho da cap phat
	# @param: none
	# @return $v0 chua  luong bo nho da cap phat 
	#------------------------------------------
BoNho:
	la $t9,Sys_TheTopOfFree
	lw $t9,0($t9)
	la $t8,Sys_MyFreeSpace
	sub $v0, $t9, $t8
	jr $ra
	#------------------------------------------
	# Wrapper for syscall 51 (InputDialogInt)
	# repeat if status value !=0
	#------------------------------------------
IntDialog:
	move $t9,$a0
	li $v0,51
	syscall 
	beq $a1,0,doneIn
	move $a0,$t9
	j IntDialog
doneIn:
	jr $ra
	#------------------------------------------
	# kiem tra gia tri nhap vao >0 va <2000
	#------------------------------------------
Check_value:
	bge $a0,2000,TooBig
	beqz $a0,Zero
	jr $ra
TooBig:
	la $a0,big
	j error
Zero:
	la $a0, sErr
	j error
	#------------------------------------------
	# Ham khoi tao cho viec cap phat dong
	# @param khong co
	# @detail Danh dau vi tri bat dau cua vung nho co the cap phat duoc
	#------------------------------------------
SysInitMem: 
	la $t9, Sys_TheTopOfFree #Lay con tro chua dau tien	con trong, khoi tao
	la $t7, Sys_MyFreeSpace #Lay dia chi dau tien con trong, khoi tao
	sw $t7, 0($t9) # Luu lai
	jr $ra
	#------------------------------------------
	# Ham cap phat bo nho dong cho cac bien con tro
	# @param [in/out] $a0 Chua dia chi cua bien con tro can cap phat
	# Khi ham ket thuc, dia chi vung nho duoc cap phat se luu tru vao bien con tro
	# @param [in] $a1 So phan tu can cap phat
	# @param [in] $a2 Kich thuoc 1 phan tu, tinh theo byte
	# @return $v0 Dia chi vung nho duoc cap phat
	#------------------------------------------
malloc: 
	la $t9, Sys_TheTopOfFree #
	lw $t8, 0($t9) #Lay dia chi dau tien con trong
	bne $a2, 4, skip
	addi $t8,$t8,3
	andi $t8, $t8, 0xfffffffc
skip:
	sw $t8, 0($a0) #Cat dia chi do vao bien con tro
	addi $v0, $t8, 0 # Dong thoi la ket qua tra ve cua ham
	mul $t7, $a1,$a2 #Tinh kich thuoc cua mang can cap phat
	add $t6, $t8, $t7 #Tinh dia chi dau tien con trong
	sw $t6, 0($t9) #Luu tro lai dia chi dau tien do vao bien Sys_TheTopOfFree
	jr $ra
	#------------------------------------------
	# Tinh luong bo nho da cap phat
	# @param khong co
	# @return $v0 luong bo nho da duoc cap phat
	#------------------------------------------
cal_mem:
	la $t9, Sys_TheTopOfFree
	la $t8, Sys_MyFreeSpace
	sub $v0, $t9, $t8
	jr $ra
	#------------------------------------------
	# Ham cap phat bo nho dong cho mang 2 chieu
	# @param [in/out] $a0 Chua dia chi cua bien con tro can cap phat
	# Khi ham ket thuc, dia chi vung nho duoc cap phat se luu tru vao bien con tro
	# @param [in] $a1 So hang
	# @param [in] $a2 so cot
	# @return $v0 Dia chi vung nho duoc cap phat
	#------------------------------------------
Malloc2:
	addiu $sp,$sp,-4
	sw $ra, 4($sp) #push ra
	bgt $a1,1000,mal_err
	bgt $a2,1000,mal_err
	la $s0,row
	sw $a1,0($s0)
	sw $a2,4($s0)
	mul $a1,$a1,$a2
	li $a2,4
	jal malloc
	lw $ra, 4($sp)
	addiu $sp,$sp,4 #pop ra
	jr $ra
	#------------------------------------------
	# lay gia tri cua trong mang
	# @param [in] $a0 Chua dia chi bat dau mang
	# @param [in] $a1 hang (i)
	# @param [in] $a2 cot (j)
	# @return $v0 gia tri tai hang a1 cot a2 trong mang
	#------------------------------------------
GetArray:
	la $s0,row # s0 =ptr so ha`ng
	lw $s1,0($s0) #s1 so hang
	lw $s2,4($s0) #s2 so cot
	bge $a1,$s1,bound_err #
	bge $a2,$s2,bound_err # 
	mul $s0,$s2,$a1
	addu $s0,$s0,$a2 #s0= i*col +j
	sll $s0, $s0, 2
	addu $s0,$s0,$a0 #s0 = *array + (i*col +j)*4
	lw $v0,0($s0)
	jr $ra
	#------------------------------------------
	# gan gia tri cua trong mang
	# @param [in] $a0 Chua dia chi bat dau mang
	# @param [in] $a1 hang (i)
	# @param [in] $a2 cot (j)
	# @param [in] $a3 gia tri gan
	#------------------------------------------
SetArray:
	la $s0,row # s0 =ptr so ha`ng
	lw $s1,0($s0) #s1 so hang
	lw $s2,4($s0) #s2 so cot
	bge $a1,$s1,bound_err #
	bge $a2,$s2,bound_err # 
	mul $s0,$s2,$a1
	addu $s0,$s0,$a2 #s0= i*col +j
	sll $s0, $s0, 2
	addu $s0,$s0,$a0 #s0 = *array + (i*col +j)*4
	sw $a3,0($s0)
	jr $ra
	#------------------------------------------
	# ham lay gia tri bien con tro
	# @param [in] $a0 {0:char ; 1:byte ; 2:word ; 3: array}
	# @return $v0 gia tri bien con tro
	#------------------------------------------
Val_val:
	la $t0,CharPtr
	sll $t1, $a0, 2
	addu $t0, $t0, $t1
	lw $v0, 0($t0)
	jr $ra
	#------------------------------------------
	# ham lay dia chi bien con tro
	# @param [in] $a0 {0:char ; 1:byte ; 2:word ; 3: array}
	# @return $v0 dia chi bien con tro
	#------------------------------------------
Val_addr:
	la $t0,CharPtr
	sll $t1, $a0, 2
	addu $v0, $t0, $t1
	jr $ra


mal_err:
	la $a0, mal
	j error
bound_err:
	la $a0, bound
	j error
nullptr:
	la $a0, null
	j error
error:
	li $v0,4
	syscall
	j end
end:
	li $v0,10
	syscall

