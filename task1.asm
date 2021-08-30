#__author__ = "Kuan Jun Qiang"
#aim: perform computation

	.data
prompt:		.asciiz "Enter first: "
prompt2:        .asciiz "Enter second: "
prompt3:	.asciiz "Result: "
first:          .word 0
second:         .word 0
one:		.word 1
result:		.word 0
newline:	.asciiz"\n"

            .text
#print prompt
	la $a0, prompt		#load prompt into $a0
        addi $v0, $0, 4		#code for print string
        syscall

#read and store first
	addi $v0, $0, 5		#code for read integer
	syscall
	sw $v0, first		#store $v0 into first

#print prompt2
	la $a0, prompt2		#load prompt2 into $a0
	addi $v0, $0, 4		#code for print string
	syscall

#read and store second
	addi $v0, $0, 5		#code for read integer
	syscall
	sw $v0, second		#store $v0 into second

#condition
	lw $t0, first			#load first into $t0
	lw $t1, second			#load second into $t1
	lw $t4, one			#load one into $t4
	slt $t3, $t0, $t4		#if first smaller than 1, $t3 equal to 1
	bne $t3, $0, elif		#branch to elif if first smaller than 1
	slt $t3, $t1, $0		#if second smaller than 0, $t3 equal to 1
	bne $t3, $0, elif		#branch to elif if second smaller than 1


	lw $t0, first			#load first into $t0
	lw $t1, second			#load second into $t1
	div $t1,$t0			#$t1//$t0
	mflo $t0			#move answer to $t0
	sw $t0, result			#store $t0 into result
	j end


elif:
	lw $t0, first			#load first into $t0
	lw $t1, second			#load second into $t1
	beq $t0, $t1 ,computeelif	#if first == second branch to computeelif
	slt $t3, $t1, $t0		#if first > second $t3 =1
	bne $t3, $0, else		#if first > second branch to else
	
	
computeelif:
	lw $t0, first			#load first into $t0
	lw $t1, second			#load second into $t1
	mult $t0, $t1			#first*second
	mflo $t0			#answer to $t0
	sw $t0, result			#store $t0 to answer
	j end

else:
	lw $t0, second			#load second into $t0
	add $t0, $t0, $t0		#second*2
	sw $t0, result			# store $t0 into result
	j end

end: 
	la $a0, prompt3			#load prompt into $a0
	addi $v0, $0, 4			#code for print string
	syscall
	
	lw $a0, result			#load result into $a0
	addi $v0, $0, 1			#code for print integer
	syscall
	
	la $a0, newline			#load newline into $a0
	addi $v0, $0, 4			#code for print string
	syscall
	
	addi $v0, $0,10			#code for exit program
	syscall
