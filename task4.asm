#author: Kuan Jun Qiang
#Aim   :faithfully translate python code into pproperly commented MIPS program
#three global variable: prompt, newline, space

    .data
i:			.word 	0
space:			.asciiz " "
newline_str:		.asciiz "\n"
    
    .text
.globl bubble_sort
#create my_list
	#copy $sp to $fp
	addi $fp, $sp, 0  
	
	#allocate local variable
	addi $sp, $sp, -4 
	
	addi $v0, $0, 9		#allocate memory
	syscall
	addi $t0, $0, 4	    #$t0=4
	sw $t0, ($v0)		#($v0)=4
	sw $v0, -4($fp)		
	lw $t0, -4($fp)		
	addi $t1, $0, 4		#$t1 = 4
	sw $t1, 4($t0)		#first var = 4
	addi $t2, $0, -2	#$t1 = -2
	sw $t2, 8($t0)		#second var = -2
	addi $t3, $0, 6	    #$t1 = 6
	sw $t3, 12($t0)		#third var = 6
    addi $t3, $0, 7	    #$t1 = 7
	sw $t3, 12($t0)		#third var = 7

    #allocate local variable
	addi $sp, $sp, -4 

	lw $t0, -4($fp)		#arg 1 = my_list
	sw $t0, 0($sp)  	#first var = my_list

	jal bubble_sort

print_loop:	# while i < len(the_list)
			lw $t0, i				# i
			lw $t1, -4($fp)			# the_list
			lw $t1, ($t1)			# len(the_list)

			slt $t0, $t0, $t1		# i < len(the_list)
			beq $t0, $0, exit		# if not true (not jump)

			# Print the number
			addi $v0, $0, 1

			# print(the_list[i])
			lw $t0, -4($fp)		# &the_list
			lw $t1, i			# i
			sll $t1, $t1, 2		# i *= 4
			add $t0, $t0, $t1	# &the_list + (offset)
			lw $a0, 4($t0)		# skip over length
			syscall
			
			# Print a space
			addi $v0, $0, 4
			la $a0, space
			syscall

			# i = i + 1
            lw $t0, i
			addi $t0, $t0, 1
			sw $t0, i

			j print_loop

			# Exit the program
exit:		addi $v0, $0, 4     # $v0 = 4 for printing a string
			la $a0, newline_str # $a0 = newline_str for printing a new line
			syscall

			# Exit the program
			addi $v0, $0, 10  # $v0 = 10 for exiting the program
			syscall

bubble_sort:
    # save $fp and $ra , and update $fp
    addi $sp, $sp, -8         #make space for $fp and $ra
    sw $fp , 0 ($sp)          #Store $fp on stack 
    sw $ra , 4 ($sp)          #Store $ra on stack 
    addi $fp , $sp , 0        #copy $sp to $fp
    
    #allocate 5 local variables
    addi $sp, $sp, -20
    
    #setup length
    lw $t0, 8($fp)        #load test_list1 
    lw $t1, ($t0)         # load length
    sw $t1, -20($fp)       #store length
    
    #i = 0
    sw $0, -16($fp)
    
    #item =0
    sw $0, -12($fp)
    
    #item_to_right = 0
    sw $0, -8($fp)
         
    #a=0
    sw $0, -4($fp)

loop_a :
    #for a in range(n-1)
    lw $t0, -4($fp)     #load a
    lw $t1, -20($fp)    #load n 
    addi $t1,  $t1, -1
    slt $t2, $t0, $t1   #a smaller than n-1
    beq $t2, $0, endloop_a # branch to endlopp_a if a greater than n-1
    
    #reset i to 0
    sw $0, -16($fp)
    
loop_i:
    #for i in range(n-1)
    lw $t0, -16($fp)    #load i
    lw $t1, -20($fp)    #load n 
    addi $t1,  $t1, -1 #n-1
    slt $t2, $t0, $t1  # i< n-1
    beq $t2, $0, endloop_i #if i smaller thab n-1 is false, brancg to endloop_i
    
    #item = the_list[i]
    lw $t0, 8($fp)    #load the_list
    lw $t1, -16 ($fp) #load i
    sll $t1, $t1, 2 # i times 4
    add $t0, $t0, $t1
    lw $t2, 4($t0) #load the_list[i]
    sw $t2, -12($fp)
    
    #item_to_right = the_list[i+1]
    lw $t0, 8($fp)    #load the_list
    lw $t1, -16 ($fp) #load i
    addi $t1, $t1, 1
    sll $t1, $t1, 2 # i times 4
    add $t0, $t0, $t1
    lw $t2, 4($t0) # load the_list[i+1]
    sw $t2, -8($fp)

    #if item greater than item_to_right
    lw $t0, -12($fp) #load item
    lw $t1, -8($fp)  #load item_to_right
    slt $t0, $t1, $t0 
    beq $t0, $0, endif #if item_to right smaller tha item, branch to endif
    
    #the list[i] = item_to_right
    lw $t0, -8($fp)
    lw $t1, 8($fp)   #load the_list
    lw $t2, -16($fp)# load i
    sll $t2, $t2, 2 #i times 4
    add $t1, $t1, $t2
    sw $t0, 4($t1)   #load the_list[i]
    
    #the_list[i+1] = item
    lw $t0, -12($fp)
    lw $t1, 8($fp)   #load the_list
    lw $t2, -16($fp) #load i
    addi $t2, $t2, 1 #i+1
    sll $t2, $t2, 2  #i times 4
    add $t1, $t1, $t2
    sw $t0, 4($t1)   #load the_list[i+1]
    
endif: #add 1 to i
    lw $t0, -16($fp) #load i
    addi $t0, $t0, 1 #add 1 to i
    sw $t0, -16($fp)
    
    j loop_i

endloop_i:
    #add 1 to a
    lw $t0, -4($fp)   #load a
    addi, $t0, $t0, 1 #add 1 to a
    sw $t0, -4($fp)
    
    j loop_a

endloop_a:
    lw $v0, -20($fp)    #set return value to $v0
    addi $sp, $sp, 20   #deallocate 2 local varaiable
    #restore %fp and $ra
    lw $fp, 0($sp)      #restore $fp
    lw $ra, 4($sp)      #restore #ra
    addi $sp, $sp, 8    #remove space on stack for $fp and $ra
    jr $ra              #return to address pointed to by $ra

