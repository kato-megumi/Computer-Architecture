.data
	CharPtr: .word 0 # Bien con tro, tro toi kieu asciiz
	BytePtr: .word 0 # Bien con tro, tro toi kieu Byte
	WordPtr: .word 0 # Bien con tro, tro toi mang kieu Word
	menu: .asciiz "1.\n"
.kdata
	Sys_TheTopOfFree: .word 1 # Bien chua dia chi dau tien cua vung nho con trong
	Sys_MyFreeSpace: # Vung khong gian tu do, dung de cap bo nho cho cac bien con tro
.text
	#Khoi tao vung nho cap phat dong
	jal SysInitMem
print_menu:
	la $a0,menu
	la $v0,4
	syscall
	li $v0,5
	syscall
	addi $at, $zero, 1
	beq $v0, $at, op1
	addi $at, $at, 1
	beq $v0, $at, op2
	addi $at, $at, 1
	beq $v0, $at, op3
	addi $at, $at, 1
	beq $v0, $at, op4
	addi $at, $at, 1
	beq $v0, $at, op5
	addi $at, $at, 1
	beq $v0, $at, op6
	addi $at, $at, 1
	beq $v0, $at, op7
	li $v0,10
	syscall
op1:
	
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
	addi $t8,$t8,1
	andi $t8, $t8, 0xfffffffc
skip:
	sw $t8, 0($a0) #Cat dia chi do vao bien con tro
	addi $v0, $t8, 0 # Dong thoi la ket qua tra ve cua ham
	mul $t7, $a1,$a2 #Tinh kich thuoc cua mang can cap phat
	add $t6, $t8, $t7 #Tinh dia chi dau tien con trong
	sw $t6, 0($t9) #Luu tro lai dia chi dau tien do vao bien Sys_TheTopOfFree
	jr $ra
	#------------------------------------------
	# @param khong co
	# @return $v0 luong bo nho da duoc cap phat
	#------------------------------------------
cal_mem:
	la $t9, Sys_TheTopOfFree
	la $t8, Sys_MyFreeSpace
	sub $v0, $t9, $t8
	jr $ra


Malloc2:

#	Chương trình cho bên dưới là hàm malloc(), kèm theo đó là ví dụ minh họa, được viết bằng hợp ngữ
#	MIPS, để cấp phát bộ nhớ cho một biến con trỏ nào đó. Hãy đọc chương trình và hiểu rõ nguyên tắc cấp
#	phát bộ nhớ động.
#	Trên cơ sở đó, hãy hoàn thiện chương trình như sau. Lưu ý, ngoài viết các hàm đó, cần viết thêm một số
#	ví dụ minh họa để thấy việc sử dụng hàm đó như thế nào.
#	1) Việc cấp phát bộ nhớ kiểu word/mảng word có 1 lỗi, đó là chưa bảo đảm qui tắc địa chỉ của kiểu
#	word phải chia hết cho 4. Hãy khắc phục lỗi này.
#	2) Viết hàm lấy giá trị Word /Byte của biến con trỏ (tương tự như *CharPtr, *BytePtr, *WordPtr)
#	3) Viết hàm lấy địa chỉ biến con trỏ (tương tự như &CharPtr, &BytePtr, *WordPtr)
#	4) Viết hàm thực hiện copy 2 con trỏ xâu kí tự (Xem ví dụ về CharPtr)
#	5) Viết hàm tính toàn bộ lượng bộ nhớ đã cấp phát cho các biến động
#	6) Hãy viết hàm Malloc2 để cấp phát cho mảng 2 chiều kiểu .word với tham số vào gồm:
#	a. Địa chỉ đầu của mảng
#	b. Số dòng
#	c. Số cột
#	7) Tiếp theo câu 6, hãy viết 2 hàm GetArray[i][j] và SetArray[i][j] để lấy/thiết lập giá trị cho phần tử
#	ở dòng I cột j của mảng.