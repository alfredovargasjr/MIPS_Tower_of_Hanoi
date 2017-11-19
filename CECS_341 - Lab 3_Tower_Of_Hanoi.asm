    .data
Title:
    .ascii      "Towers of Hanoi\n"
    					#Help from source: Austin Corso, GitHub asm file
Prompt:  
    .asciiz     "\nEnter the number of disks: "
Move:
    .asciiz      "\nMove disk from "
To:
    .ascii      " to "
    .globl main  
    
MoveCount:
    .word 0
    
Apeg:					#example
   .word 0, 9, 9, 9, 9, 9, 9		#A[size,3,2,0]

Bpeg:
   .word 0, 9, 9, 9, 9, 9, 9		#B[size,0,0,0]

Cpeg:
   .word 0, 9, 9, 9, 9, 9, 9		#C[size,1,0,0]
     
   .text     
main:
    
    li  $v0, 4 			#Print user prompt
    la  $a0, Prompt		#load adress for prompt
    syscall			#syscall for print string
	
    li $v0, 5			#read user input, integer
    syscall			#syscall for input
    add $a0, $v0, $zero 	#$a0 = num of disks
    
    addi $a1, $zero, 1		#$a1 = start peg
    addi $a2, $zero, 3		#$a2 = end peg
    addi $a3, $zero, 2		#$a3 = auxilary peg
   
    addi $s0, $zero, 0		#Number of moves
    la	 $s1, Apeg		#load address of A[]
    la	 $s2, Cpeg		#load address of C[]
    la	 $s3, Bpeg		#load address of B[]
    
    add $t0, $zero, $a0		#start at number of disk, heighest weight
    la	 $t1, Apeg + 4
    fillInStartPeg:
    sw	 $t0, 0($t1)
    addi $t1, $t1, 4		#move to next index 
    subi $t0, $t0, 1		#weight - 1
    bne  $t0, 0, fillInStartPeg	#exit loop when $t0 = num of disks
    sw $a0 Apeg			#add size to the first element of the array
   
    jal hanoi_towers		#jump to hanoi_towers function
    
    li $v0, 10 			# Return control to OS
    syscall
    
hanoi_towers: 
    #This is the high level language code for the tower of hanoi algorithm, called recursively
    # 
    # if (num_of_disks == 1)	#base case if only 1 disk, move to end peg
    # 	move disk to end_peg
    # else
    #   hanoi_towers(num_of_disks-1, start_peg, auxilary_peg, end_peg)
    #	move disk from start_peg to end_peg
    # 	hanoi_towers(num_of_disks-1, auxilary_peg, end_peg, start_peg)
    
    # -base case-
    # if (num_of_disks == 1)
    addi $t0, $a0, 0		# temp save $a0, num of disks
    addi $t1, $zero, 1		# $t1 = 1
    bne $a0, $t1, else		# branch if( num of disk != 1)
    li $v0, 4			# print move
    la $a0, Move
    syscall
    li $v0, 1 			# print start_peg
    move $a0, $a1
    syscall
    li $v0, 4			# print to
    la $a0, To
    syscall
    li $v0, 1 			# print end_peg
    move $a0, $a2
    syscall
    addi $a0, $t0, 0		# restore $a0
    
    addi $s0, $s0, 1		#number of moves + 1
    sw	 $s0, MoveCount
    
    #get top of A and push it to C
    lw	 $t0 0($s1)		#load sizeStart    
    sll  $t1 $t0 2		#sizeStart * 4, index of start array
    add  $s4 $t1 $s1 		#index + address of Start
    subi $t0 $t0 1		#sizeStart - 1
    sw	 $t0 0($s1)		#store new size to start array
    lw	 $t0 0($s2)		#load sizeEnd
    addi $t0 $t0 1		#sizeEnd + 1
    sw	 $t0 0($s2)		#store new size to End array
    sll  $t0 $t0 2		#sizeEnd * 4, index of end array
    add  $s5 $t0 $s2		#index + address of End
    j PopPush
    
    jr $ra			# return
    
else:
    #expand stack, keeping the 5 values [num of disks, start, aux, end, and address]
    	addi $sp, $sp, -20
    
    #save to stack
    	sw $ra, 16($sp)
    	sw $a3, 12($sp)		#store a3(aux_peg)
    	sw $a2, 8($sp)		#store a2(end_peg)
    	sw $a1, 4($sp)		#store a1(start_peg)
	sw $a0, 0($sp)		#store a0(num_of_disks)
	    
    #hanoi_towers(num_of_disks-1, start_peg, aux_peg, end_peg)    
    	#set args for subsequent recursive call
    		addi $t3, $a3, 0		#copy var into temp
    		addi $a3, $a2, 0		#aux_peg = end_peg
    		addi $a2, $t3, 0		#end_peg = aux_peg
    		addi $a0, $a0, -1		#num of disk--  
    		 		
    	#recursive call
    		jal hanoi_towers   
    	
    #load off stack
    	lw $ra, 16($sp)
    	lw $a3, 12($sp)		#load a3(extra_peg)
    	lw $a2, 8($sp)		#load a2(end_peg)
    	lw $a1, 4($sp)		#load a1(start_peg)
    	lw $a0, 0($sp)		#load a0(num_of_disks)
   
    #move a disk from start_peg to end_peg
    	addi $t0, $a0, 0		# temp save $a0
    	addi $t1, $zero, 1
    	li $v0, 4			# print move
    	la $a0, Move
    	syscall
    	li $v0, 1 			# print start_peg
    	move $a0, $a1
    	syscall
    	li $v0, 4			# print to
    	la $a0, To
    	syscall
    	li $v0, 1 			# print end_peg
    	move $a0, $a2
    	syscall
    	addi $a0, $t0, 0		# restore $a0
    	addi $s0, $s0, 1		#number of moves
    	sw   $s0, MoveCount
    
    #hanoi_towers(num_of_disks-1, extra_peg, end_peg, start_peg)  
    	#set args for subsequent recursive call
    		addi $t3, $a3, 0		#copy var into temp
    		addi $a3, $a1, 0		#extra_peg = start_peg
    		addi $a1, $t3, 0		#start_peg = extra_peg
    		addi $a0, $a0, -1		#num of disk--  		
    	#recursive call
    		jal hanoi_towers  
    	#load params off stack
    		lw $ra, 16($sp)
    		
    #clear stack
    	addi $sp, $sp, 20

    #return
    	add $v0, $zero, $t5
    	jr $ra
    	
  PopPush:
  	lw $t0,   0($s4)		#load value of Pop Start array
  	sw $zero, 0($s4)		#Start array removes poped index
  	sw $t0,   0($s5)		#push poped value on end array
  	jr $ra 				#return
