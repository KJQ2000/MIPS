#__author__ = "Kuan Jun Qiang"
#aim: perform computation
	.data
prompt:		.asciiz"Array length: "
prompt2:	.asciiz"Enter num: "
prompt3:	.asciiz"The minimum element in this list is "
newline: .asciiz "\n"
size:    .word 0
i:       .word 0
minimum: .word 0
list:    .word 0

	.text
#print prompt
	la $a0, prompt		#load prompt into $a0
	addi $v0, $0, 4 	#code for print string
	syscall

#read and store integer
	addi $v0, $0, 5		#code for read string
	syscall
	sw $v0, size		#store $v0 into size

#create array
	addi $v0, $0,9		#code for allocate space
	lw $t0, size		#load size into $t0
	addi $t1, $0, 4		#$t1 =4
	mult $t0, $t1		#size *4
	mflo $t1
	addi $a0, $t1,4		# $a0 = $t1 +4
	syscall
	sw $v0, list		#list == address
	sw $t0, ($v0)		#size == len(list)
	
#read list[i]
	la $a0, prompt2		#load prompt2 into $a0
	addi $v0, $0, 4		#code for print string
	syscall
	
	addi $v0, $0, 5		#code for read interger
	syscall
	sw $v0, minimum		#minimum == integer[0]
	
#i += 1
	lw $t0, i		#load i into $t0
	addi $t0, $t0,1		#i+=1
	sw $t0, i		#store into i
	
forloop:
#for i in range(size)
	lw $t0, i		#load i into $t0
	lw $t1, size		#load size into $t1
	slt $t2, $t0, $t1	# if size < i
	beq $t2, $0, end	# if size < i branch to end
	
	lw $t0, i		#load i into $t0
	lw $t1, list		#load list into $t1
	addi $t2, $0, 4		#t2 =4
	mult $t0, $t2		#i*4
	mflo $t0		#$t0 = i*4
	add $t0, $t0, $t1	#list + (i*4)

#read list[i]
	la $a0, prompt2		#load prompt2 into $a0
	addi $v0, $0, 4		#code for printing string 
	syscall
	
	addi $v0, $0, 5		#code for read input
	syscall
	sw $v0, 4($t0)		# store into list[i]
	
	lw $t0, minimum		#load minimum into $t0
	slt $t1, $t0, $v0	#if minimum less than input
	bne $t1, $0, continue	#if minimum less than input, continue loop
	sw $v0, minimum

continue:
#i += 1
	lw $t0, i		#load i into $t0
	addi $t0, $t0,1		#i+=1
	sw $t0, i		#store into i
	
	j forloop

end:
	la $a0, prompt3		#load prompt3 into $a0
	addi $v0, $0, 4		#code for printing string
	syscall
	
	lw $a0, minimum		#load minimum into $a0
	addi $v0, $0, 1		#code for printing integer
	syscall
	
	la $a0, newline 	#load address of newline
	addi $v0, $0, 4 	#print newline
	syscall
	
	addi $v0, $0, 10 	#code for exit program
	syscall
