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
linesep: .asciiz "\n_____________________________________"
tabs: 	 .asciiz "\t\t"
Prompt:  
    .asciiz     "\n W E L C O M E  T O   T H E  T O W E R OF H A N O I   G A M E  \n\n Please enter the number of disks: "

StepsCount: .asciiz  "\nCurrent number of steps : "

To:
    .ascii      " to "
    .globl main  
    
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
     PRINT2LOOPf:
          
     la $a0, space
     syscall
     beq $t6, 0, NEXT2f
     mul $t5, $t6, 4
     addi $t6, $t6, -1
     
     add $t4, $s5, $t5
     
     lw $t3, 0($t4)
     beq $t3, 0, PEG2PRINT2f
     beq $t3, 9, PEG2PRINT2f
     bne $t3, 1, s22f
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PEG2PRINT2f
     
     s22f:
     bne $t3, 2, s32f
     li $v0, 4
     la $a0, blockS2
     syscall

     
     j PEG2PRINT2f
     
     s32f:
     bne $t3, 3, s42f
     li $v0, 4
     la $a0, blockS3
     syscall

     
     j PEG2PRINT2f
     
     s42f:
     bne $t3, 4, s52f
     li $v0, 4
     la $a0, blockS4
     syscall
     
      j PEG2PRINT2f
     
     s52f:
     bne $t3, 5, s62f
     li $v0, 4
     la $a0, blockS5
     syscall
     
      j PEG2PRINT2f
     
     s62f:
     li $v0, 4
     la $a0, blockS6
     syscall

     ######## peg 2 print
     PEG2PRINT2f:
     add $t4, $t8, $t5
     
     li $v0, 4
     la $a0, tabs
     syscall
     
     lw $t3, 0($t4)
     beq $t3, 0, PEG3PRINT2f
     beq $t3, 9, PEG3PRINT2f
     bne $t3, 1, sp222f
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PEG3PRINT2f
     
     sp222f:
     bne $t3, 2, sp232f
     li $v0, 4
     la $a0, blockS2
     syscall
     
     j PEG3PRINT2f
     
     sp232f:
     bne $t3, 3, sp242f
     li $v0, 4
     la $a0, blockS3
     syscall

     
     j PEG3PRINT2f
     
     sp242f:
     bne $t3, 4, s52f
     li $v0, 4
     la $a0, blockS4
     syscall
     
      j PEG3PRINT2f
     
     sp252f:
     bne $t3, 5, s62f
     li $v0, 4
     la $a0, blockS5
     syscall
     
      j PEG3PRINT2f
     
     sp262f:
     li $v0, 4
     la $a0, blockS6
     syscall
     
     PEG3PRINT2f:
     ######### PEG 3 PRINT
      add $t4, $t9, $t5
      
     li $v0, 4
     la $a0, tabs
     syscall
     
     
     lw $t3, 0($t4)
     beq $t3, 0, PRINT2LOOPf
     beq $t3, 9, PRINT2LOOPf
     bne $t3, 1, sp322f
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PRINT2LOOPf
     
     sp322f:
     bne $t3, 2, sp332f
     li $v0, 4
     la $a0, blockS2
     syscall
     
     j PRINT2LOOPf
     
     sp332f:
     bne $t3, 3, sp342f
     li $v0, 4
     la $a0, blockS3
     syscall
     
     j PRINT2LOOPf
     
     sp342f:
     bne $t3, 4, sp352f
     li $v0, 4
     la $a0, blockS4
     syscall
     
     j PRINT2LOOPf
     
     sp352f:
     bne $t3, 5, sp362f
     li $v0, 4
     la $a0, blockS5
     syscall
     
     j PRINT2LOOPf
     
     sp362f:
     
     li $v0, 4
     la $a0, blockS6
     syscall
     
     j PRINT2LOOPf
     
     
     
    	
    	NEXT2f:

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
    	##########################################################

    
    
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
     beq $t3, 9, PEG2PRINT
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
     li $v0, 4
     la $a0, blockS6
     syscall

     ######## peg 2 print
     PEG2PRINT:
     add $t4, $t8, $t5
     
     li $v0, 4
     la $a0, tabs
     syscall
     
     lw $t3, 0($t4)
     beq $t3, 0, PEG3PRINT
     beq $t3, 9, PEG3PRINT
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
     li $v0, 4
     la $a0, blockS6
     syscall
     
     PEG3PRINT:
     ######### PEG 3 PRINT
      add $t4, $t9, $t5
      
     li $v0, 4
     la $a0, tabs
     syscall
     
     
     lw $t3, 0($t4)
     beq $t3, 0, PRINTLOOP
     beq $t3, 9, PRINTLOOP
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
     
     li $v0, 4
     la $a0, blockS6
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
    	##########################################################
    
    addi $a0, $t0, 0		# restore $a0
    
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
    	addi $sp, $sp, -32
    #save to stack
    	sw $s3, 28($sp)		#store address of aux array
    	sw $s2, 24($sp)		#store address of end array
    	sw $s1, 20($sp)		#store address of start array
    	sw $ra, 16($sp)		#store return address, for return to recursive call
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
    		add  $t3, $s3, $zero		#copy aux array to temp
    		add  $s3, $s2, $zero		#
    		add  $s2, $t3, 0 		#
    		 		
    	#recursive call
    		jal hanoi_towers   

    	
    #load off stack
    	lw $s3, 28($sp)		#load aux array
    	lw $s2, 24($sp)		#load end array
    	lw $s1, 20($sp)		#load start array
    	lw $ra, 16($sp)
    	lw $a3, 12($sp)		#load a3(extra_peg)
    	lw $a2, 8($sp)		#load a2(end_peg)
    	lw $a1, 4($sp)		#load a1(start_peg)
    	lw $a0, 0($sp)		#load a0(num_of_disks)
   
    #move a disk from start_peg to end_peg
    	addi $t0, $a0, 0		# temp save $a0
    	addi $t1, $zero, 1

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
     PRINT2LOOP:
          
     la $a0, space
     syscall
     beq $t6, 0, NEXT2
     mul $t5, $t6, 4
     addi $t6, $t6, -1
     
     add $t4, $s5, $t5
     
     lw $t3, 0($t4)
     beq $t3, 0, PEG2PRINT2
     beq $t3, 9, PEG2PRINT2
     bne $t3, 1, s22
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PEG2PRINT2
     
     s22:
     bne $t3, 2, s32
     li $v0, 4
     la $a0, blockS2
     syscall

     
     j PEG2PRINT2
     
     s32:
     bne $t3, 3, s42
     li $v0, 4
     la $a0, blockS3
     syscall

     
     j PEG2PRINT2
     
     s42:
     bne $t3, 4, s52
     li $v0, 4
     la $a0, blockS4
     syscall
     
     j PEG2PRINT2
     s52:
     bne $t3, 5, s62
     li $v0, 4
     la $a0, blockS5
     syscall
     
     j PEG2PRINT2
     s62:
     li $v0, 4
     la $a0, blockS6
     syscall

     ######## peg 2 print
     PEG2PRINT2:
     add $t4, $t8, $t5
     
     li $v0, 4
     la $a0, tabs
     syscall
     
     lw $t3, 0($t4)
     beq $t3, 0, PEG3PRINT2
     beq $t3, 9, PEG3PRINT2
     bne $t3, 1, sp222
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PEG3PRINT2
     
     sp222:
     bne $t3, 2, sp232
     li $v0, 4
     la $a0, blockS2
     syscall
     
     j PEG3PRINT2
     
     sp232:
     bne $t3, 3, sp242
     li $v0, 4
     la $a0, blockS3
     syscall

     j PEG3PRINT2
     
     sp242:
     bne $t3, 4, sp252
     li $v0, 4
     la $a0, blockS4
     syscall
     j PEG3PRINT2
     
     sp252:
     bne $t3, 5, sp262
     li $v0, 4
     la $a0, blockS5
     syscall
     
     j PEG3PRINT2
     
     sp262:
     li $v0, 4
     la $a0, blockS6
     syscall
     
     PEG3PRINT2:
     ######### PEG 3 PRINT
      add $t4, $t9, $t5
      
     li $v0, 4
     la $a0, tabs
     syscall
     
     
     lw $t3, 0($t4)
     beq $t3, 0, PRINT2LOOP
     beq $t3, 9, PRINT2LOOP
     bne $t3, 1, sp322
     li $v0, 4
     la $a0, blockS1
     syscall
     
     j PRINT2LOOP
     
     sp322:
     bne $t3, 2, sp332
     li $v0, 4
     la $a0, blockS2
     syscall
     
     j PRINT2LOOP
     
     sp332:
     bne $t3, 3, sp342
     li $v0, 4
     la $a0, blockS3
     syscall
     
     j PRINT2LOOP
     
     sp342:
     bne $t3, 4, sp352
     li $v0, 4
     la $a0, blockS4
     syscall
     
     j PRINT2LOOP
     
     sp352:
     bne $t3, 5, sp362
     li $v0, 4
     la $a0, blockS5
     syscall
     
     
     j PRINT2LOOP
     
     sp362:
     li $v0, 4
     la $a0, blockS6
     syscall
     
     j PRINT2LOOP
     
    	
    	NEXT2:
  
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
    	##########################################################
    	
    	
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
    		addi $t3, $a3, 0		#copy var into temp
    		addi $a3, $a1, 0		#extra_peg = start_peg
    		addi $a1, $t3, 0		#start_peg = extra_peg
    		addi $a0, $a0, -1		#num of disk-- 
    		add  $t3, $s3, $zero		#copy aux array to temp
    		add  $s3, $s1, 0		#aux = start
    		add  $s1, $t3, 0 		#start = aux		
    	#recursive call
    	
    		jal hanoi_towers  
    		
    	#load params off stack
    	
    		lw $ra, 16($sp)
    		
    #clear stack
    	addi $sp, $sp, 32

    #return
    	add $v0, $zero, $t5
    	 

    	jr $ra
