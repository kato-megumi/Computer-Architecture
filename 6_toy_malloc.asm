.data
	CharPtr: .word 0 # Bien con tro, tro toi kieu asciiz
	BytePtr: .word 0 # Bien con tro, tro toi kieu Byte
	WordPtr: .word 0 # Bien con tro, tro toi mang kieu Word
.kdata
	# Bien chua dia chi dau tien cua vung nho con trong
	Sys_TheTopOfFree: .word 1
	# Vung khong gian tu do, dung de cap bo nho cho cac bien con tro
	Sys_MyFreeSpace:
.text
	#Khoi tao vung nho cap phat dong
	jal SysInitMem
	#-----------------------
	# Cap phat cho bien con tro, gom 3 phan tu,moi phan tu 1 byte
	#-----------------------
	la $a0, CharPtr
	addi $a1, $zero, 3
	addi $a2, $zero, 1
	jal malloc
	#-----------------------
	# Cap phat cho bien con tro, gom 6 phan tu, moi phan tu 1 byte
	#-----------------------
	la $a0, BytePtr
	addi $a1, $zero, 6
	addi $a2, $zero, 1
	jal malloc
	#-----------------------
	# Cap phat cho bien con tro, gom 5 phan tu, moi phan tu 4 byte
	#-----------------------
	la $a0, WordPtr
	addi $a1, $zero, 5
	addi $a2, $zero, 4
	jal malloc
lock: 
	j lock
	nop
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
	sw $t8, 0($a0) #Cat dia chi do vao bien con tro
	addi $v0, $t8, 0 # Dong thoi la ket qua tra ve cua ham
	mul $t7, $a1,$a2 #Tinh kich thuoc cua mang can cap phat
	add $t6, $t8, $t7 #Tinh dia chi dau tien con trong
	sw $t6, 0($t9) #Luu tro lai dia chi dau tien do vao bien Sys_TheTopOfFree
	jr $ra