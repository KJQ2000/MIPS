#author: Kuan Jun Qiang
#Aim   :faithfully translate python code into pproperly commented MIPS program
#two global variable: prompt, newline
		

#declaration
		.data
prompt: .asciiz "The minimum element in this list is "
newline: .asciiz "\n"


		.text	
.globl	get_minimum	
main:
#create my_list
	#copy $sp to $fp
	addi $fp, $sp, 0  
	
	#allocate local variable
	addi $sp, $sp, -4 
	
	addi $v0, $0, 9		#allocate memory
	syscall
	addi $t0, $0, 3		#$t0=3
	sw $t0, ($v0)		#($v0)=3
	sw $v0, -4($fp)		
	lw $t0, -4($fp)		
	addi $t1, $0, 2		#$t1 = 2
	sw $t1, 4($t0)		#first var = 2
	addi $t2, $0, 4		#$t2 = 4
	sw $t2, 8($t0)		#second var = 4
	addi $t3, $0, -1	#$t3 = -1
	sw $t3, 12($t0)		#third var = -1

#get_minimum
	#allocate local variable
	addi $sp, $sp, -4 

	lw $t0, -4($fp)		#arg 1 = my_list
	sw $t0, 0($sp)  	#first var = my_list

	jal get_minimum 

	addi $sp, $sp, 4 	#remove argument
	sw $v0, -4($fp)  	#store return value

	#print prompt
	la $a0, prompt	   	#load prompt
	addi $v0, $0, 4 	#print prompt
	syscall
	
	#print return value
	lw $a0, -4($fp)		#load return value
	addi $v0, $0, 1		#print int
	syscall
	
	#print newline
	la $a0, newline		
	addi $v0, $0, 4		
	syscall

	addi $sp, $sp, 4 #remove local variable

	addi $v0, $0, 10 #exit
	syscall

get_minimum:
	#allocate local variables
	addi $sp, $sp, -8
	sw $ra, 4($sp)
	sw $fp, 0($sp)

	#copy $sp into $fp
	addi $fp, $sp, 0

	#allocate local variables
	addi $sp, $sp, -12 

	#min_item = my_list[0]
	lw $t0, 4($t0)
	sw $t0, -12($fp)

	#for i in range(1, len(my_list))
	addi $t0, $0, 1
	sw $t0, -8($fp)

#loop
inner_loop:
	#load i from 1
	lw $t0, -8($fp) 	#$t0= i
	lw $t2, 8($fp)		#$t2= my_list
	lw $t1, ($t2)		#$t1= length of my_list
	slt $t0, $t0, $t1	#i< length
	beq $t0, $0, end	#if i< length -> end

	# item = the_list[i]
	lw $t0, -8($fp)		
	lw $t1, 8($fp)		
	sll $t0, $t0, 2		
	add $t1, $t1, $t0	
	lw $t2, 4($t1)		
	sw $t2, -4($fp)		
		
	# if min_item > item:
	lw $t0, -4($fp)		
	lw $t1, -12($fp)	
	slt $t2, $t0, $t1	
	beq $t2, $0, end_i	
		
	# min_item = item
	lw $t0, -4($fp)		
	sw $t0, -12($fp)

end_i:
	# i +=1
	lw $t0, -8($fp)		
	addi $t0, $t0, 1	
	sw $t0, -8($fp)		
		
	# loop again
	j inner_loop


end:
	#return min_item
	lw $v0, -12($fp)

	#Remove local variables
	addi $sp, $sp, 12 

	# Restore $fp and $ra
	lw $fp, 0($sp)		
	lw $ra, 4($sp)		
	addi $sp, $sp, 8

	#Return to caller
	jr $ra
