    .data
    #Help from source: Austin Corso, GitHub asm file
space: .asciiz "\n"
PegAprint: .asciiz "A"
PegBprint: .asciiz "\t\tB"
PegCprint: .asciiz "\t\tC"
blockS1: .asciiz "x"
blockS2: .asciiz "xx"
blockS3: .asciiz "xxx"
blockS4: .asciiz "xxxx"
blockS5: .asciiz "xxxxx"
blockS6: .asciiz "xxxxxx"
blockS7: .asciiz "xxxxxxx"
blockS8: .asciiz "xxxxxxxx"
blockS9: .asciiz "xxxxxxxxx"
blockS10: .asciiz "xxxxxxxxxx"
linesep: .asciiz "\n_____________________________________"
tabs: 	 .asciiz "\t\t"
Prompt:  
    .asciiz     "\n W E L C O M E  T O   T H E  T O W E R OF H A N O I   G A M E  \n\n Please enter the number of disks: "

StepsCount: .asciiz  "\nCurrent number of steps : "  
    
MoveCount:
    .word 0
    
Apeg:					#example
   .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		#A[size,3,2,0]

Bpeg:
   .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		#B[size,0,0,0]

Cpeg:
   .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0		#C[size,1,0,0]
     
   .text     
main:
    
    li  $v0, 4 			#Print user prompt
    la  $a0, Prompt		#load adress for prompt
    syscall			#syscall for print string
	
    li $v0, 5			#read user input, integer
    syscall			#syscall for input
    add $a0, $v0, $zero 	#$a0 = num of disks
   
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
   
        ####### printing pegs
    	
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal print_pegs
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
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
    addi $t1, $zero, 1		# $t1 = 1
    bne $a0, $t1, else		# branch if( num of disk != 1)
    
         ####### printing pegs
    	
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal print_pegs
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    
    addi $s0, $s0, 1		#number of moves + 1
    sw	 $s0, MoveCount
    
    #get top of Start and push it to End
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
    
    				#PopPush
    lw $t0,   0($s4)		#load value of Pop Start array
    sw $zero, 0($s4)		#Start array removes poped index
    sw $t0,   0($s5)		#push poped value on end array
    
    jr $ra			# return
    
else:
    #expand stack, keeping the 5 values [num of disks, start, aux, end, and address]
    	#addi $sp, $sp, -20
    	addi $sp, $sp, -20
    #save to stack
    	sw $ra, 16($sp)		#store return address, for return to recursive call
    	sw $s3, 12($sp)		#store address of aux array
    	sw $s2, 8($sp)		##store address of end array
    	sw $s1, 4($sp)		#store address of start array
	sw $a0, 0($sp)		#store a0(num_of_disks)
	    
    #hanoi_towers(num_of_disks-1, start_peg, aux_peg, end_peg)    
    	#set args for subsequent recursive call
    		addi $a0, $a0, -1		#num of disk--  
    		add  $t3, $s3, $zero		#copy aux array to temp
    		add  $s3, $s2, $zero		#copy address of end to aux 
    		add  $s2, $t3, 0 		#copy address of temp to aux
    		 		
    	#recursive call
    	jal hanoi_towers   

    	
    #load off stack
    	lw $ra, 16($sp)
    	lw $s3, 12($sp)		#load aux array
    	lw $s2, 8($sp)		#load end array
    	lw $s1, 4($sp)		#load start array
    	lw $a0, 0($sp)		#load a0(num_of_disks)
   
    #move a disk from start_peg to end_peg
    	addi $t0, $a0, 0		# temp save $a0
    	addi $t1, $zero, 1
    	
    	     ####### printing pegs
    	
    	addi $sp, $sp, -4
    	sw $ra, 0($sp)
    	jal print_pegs
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
    	
    	addi $a0, $t0, 0		# restore $a0
    	addi $s0, $s0, 1		#number of moves
    	sw   $s0, MoveCount
	
    	
    	#get top of Start and push it to End
    	lw   $t0 0($s1)		#load sizeStart    
    	sll  $t1 $t0 2		#sizeStart * 4, index of start array
    	add  $s4 $t1 $s1 		#index + address of Start
   	subi $t0 $t0 1		#sizeStart - 1
    	sw   $t0 0($s1)		#store new size to start array
    	lw   $t0 0($s2)		#load sizeEnd
    	addi $t0 $t0 1		#sizeEnd + 1
    	sw   $t0 0($s2)		#store new size to End array
    	sll  $t0 $t0 2		#sizeEnd * 4, index of end array
    	add  $s5 $t0 $s2		#index + address of End
    	
    	
    					
    					#PopPush
    	lw $t0,   0($s4)		#load value of Pop Start array
  	sw $zero, 0($s4)		#Start array removes poped index
  	sw $t0,   0($s5)		#push poped value on end array
    	
    
    #hanoi_towers(num_of_disks-1, aux_peg, end_peg, start_peg)  
    	#set args for subsequent recursive call
    		addi $a0, $a0, -1		#num of disk-- 
    		add  $t3, $s3, $zero		#copy aux array to temp
    		add  $s3, $s1, 0		#aux = start
    		add  $s1, $t3, 0 		#start = aux		
    	#recursive call
    	
    	jal hanoi_towers  
    		
    	#load params off stack
    	
    		lw $ra, 16($sp)
    		
    #clear stack
    	addi $sp, $sp, 20

    #return
    	add $v0, $zero, $t5
    	 

    	jr $ra


print_pegs:
      # printing size of each peg ####################################
     
     addi $s7, $a0, 0
     addi $s6, $v0, 0
     la $s5, Apeg
     la $t8, Bpeg
     la $t9, Cpeg
     
     li $v0, 4
     la $a0, PegAprint
     syscall
     li $v0, 4
     la $a0, PegBprint
     syscall
     li $v0, 4
     la $a0, PegCprint
     syscall
      la $a0, space
     syscall
     
     lw $t2, 0($s5)  # t6 = size of peg
     add $t6, $t2, $t6
     lw $t2, 0($t8)
     add $t6, $t2, $t6
     lw $t2, 0($t9)
     add $t6, $t2, $t6
     
     # check if the peg has blocks
     PRINTLOOP:
          
     la $a0, space
     syscall
     beq $t6, 0, NEXT
     mul $t5, $t6, 4
     addi $t6, $t6, -1
     
     add $t4, $s5, $t5
     
     lw $t3, 0($t4)
     beq $t3, 0, PEG2PRINT
     #beq $t3, 11, PEG2PRINT
     bne $t3, 1, s2
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PEG2PRINT
     
     s2:
     bne $t3, 2, s3
     li $v0, 4
     la $a0, blockS2
     syscall

     
     j PEG2PRINT
     
     s3:
     bne $t3, 3, s4
     li $v0, 4
     la $a0, blockS3
     syscall

     
     j PEG2PRINT
     
     s4:
     bne $t3, 4, s5
     li $v0, 4
     la $a0, blockS4
     syscall
     
     j PEG2PRINT
     
     s5:
     bne $t3, 5, s6
     li $v0, 4
     la $a0, blockS5
     syscall
     
     j PEG2PRINT
     
     s6:
     bne $t3, 6, s7
     li $v0, 4
     la $a0, blockS6
     syscall
     
     j PEG2PRINT
     
     s7:
     bne $t3, 7, s8
     li $v0, 4
     la $a0, blockS7
     syscall
     
     j PEG2PRINT
     
     s8:
     bne $t3, 8, s9
     li $v0, 4
     la $a0, blockS8
     syscall
     
     j PEG2PRINT
     
     s9:
     bne $t3, 9, s10
     li $v0, 4
     la $a0, blockS9
     syscall
     
     j PEG2PRINT
     
     s10:
     li $v0, 4
     la $a0, blockS10
     syscall

     ######## peg 2 print
     PEG2PRINT:
     add $t4, $t8, $t5
     
     li $v0, 4
     la $a0, tabs
     syscall
     
     lw $t3, 0($t4)
     beq $t3, 0, PEG3PRINT
     #beq $t3, 11, PEG3PRINT
     bne $t3, 1, sp22
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PEG3PRINT
     
     sp22:
     bne $t3, 2, sp23
     li $v0, 4
     la $a0, blockS2
     syscall
     
     j PEG3PRINT
     
     sp23:
     bne $t3, 3, sp24
     li $v0, 4
     la $a0, blockS3
     syscall

     
     j PEG3PRINT
     
     sp24:
     bne $t3, 4, sp25
     li $v0, 4
     la $a0, blockS4
     syscall
     
      j PEG3PRINT
     
     sp25:
     bne $t3, 5, sp26
     li $v0, 4
     la $a0, blockS5
     syscall
     
      j PEG3PRINT
     
     sp26:
     bne $t3, 6, sp27
     li $v0, 4
     la $a0, blockS6
     syscall
     
     j PEG3PRINT
     
     sp27:
     bne $t3, 7, sp28
     li $v0, 4
     la $a0, blockS7
     syscall
     
     j PEG3PRINT
     
     sp28:
     bne $t3, 8, sp29
     li $v0, 4
     la $a0, blockS8
     syscall
     
     j PEG3PRINT
     
     sp29:
     bne $t3, 9, sp210
     li $v0, 4
     la $a0, blockS9
     syscall
     
     j PEG3PRINT
     
     sp210:
     li $v0, 4
     la $a0, blockS10
     syscall
     
     PEG3PRINT:
     ######### PEG 3 PRINT
      add $t4, $t9, $t5
      
     li $v0, 4
     la $a0, tabs
     syscall
     
     
     lw $t3, 0($t4)
     beq $t3, 0, PRINTLOOP
     #beq $t3, 11, PRINTLOOP
     bne $t3, 1, sp32
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PRINTLOOP
     
     sp32:
     bne $t3, 2, sp33
     li $v0, 4
     la $a0, blockS2
     syscall
     
     j PRINTLOOP
     
     sp33:
     bne $t3, 3, sp34
     li $v0, 4
     la $a0, blockS3
     syscall
     
     j PRINTLOOP
     
     sp34:
     bne $t3, 4, sp35
     li $v0, 4
     la $a0, blockS4
     syscall
     
     j PRINTLOOP
     
     sp35:
     bne $t3, 5, sp36
     li $v0, 4
     la $a0, blockS5
     syscall
     j PRINTLOOP
     
     sp36:
     bne $t3, 6, sp37
     li $v0, 4
     la $a0, blockS6
     syscall
     
     j PRINTLOOP
     
     sp37:
     bne $t3, 7, sp38
     li $v0, 4
     la $a0, blockS7
     syscall
     
     j PRINTLOOP
     
     sp38:
     bne $t3, 8, sp39
     li $v0, 4
     la $a0, blockS8
     syscall
     
     j PRINTLOOP
     
     sp39:
     bne $t3, 9, sp310
     li $v0, 4
     la $a0, blockS9
     syscall
     
     j PRINTLOOP
     
     sp310:
     li $v0, 4
     la $a0, blockS10
     syscall
     
     j PRINTLOOP
     
    	
    	NEXT:
    	li  $v0, 4 			#Print Steps count prompt
   	la  $a0, StepsCount		#load adress for prompt
   	syscall
    	lw $a0, MoveCount   # Load the contents of word stored at MoveCount
   	addi $v0, $0, 1  # Set service #1 (which prints an integer)
  	syscall          # Do the system call
    	
    	li $v0, 4
    	la $a0, linesep
    	syscall
    	li $v0, 4
    	la $a0, space
    	syscall
    	
    	
	addi $a0, $s7, 0
	addi $v0, $a0, 0
    	 
	jr $ra
    	##########################################################
