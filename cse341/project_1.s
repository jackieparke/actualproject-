.globl main
.globl project1
.globl findchar
.globl multi
.globl divide
.globl subtraction
.globl addition
.globl modulus
.text
project1:
#saving registers
#do i need to refrence my frame ptr here 
	addi $sp, $sp, -36
	sw $ra, 32($sp) #16 bits/4 bytes for the return 
	sw $s0, 28($sp) #current idx in string 
	sw $s1, 24($sp) #current operation 
	sw $s2, 20($sp)  #previous char in the string 
	sw $s3, 16($sp)  #the result

	sw $s4, 12($sp) #a3 stored at s4
	sw $s5, 8($sp) #a2 stored at s5
	sw $s6, 4($sp) #a1 stored in s6
	sw $s7, 0($sp) #a0 stored in s7

	add $s0, $0, $0 #idx=0
	add $s1, $0, $0
	add $s2, $0, $0
	add $s3, $0, $0
	add $s4, $a3, $0 #s4=a3
	add $s5, $a2, $0 #s5=a2
	add $s6, $a1, $0 #s6=a1
	add $s7, $a0, $0 #s7=a0

	jal startcalc #find the equal sign and work from there 
	or $0, $0, $0
    #@ this point i have loaded the address of a0,a1,a2 
    #load 
	jal loop #we found the = and now we loop through the string 
	or $0, $0, $0
    #then make sure theres a null term 
    #need to store in $a3
	add $v0, $v0, $0 
    #we have v0 stored in the proper place in memory now 
	jal storing_final_addy_x_y
	add $s0, $0, $0 

	jal first_char_in_string
	add $s0, $0, $0 
    #the end of my operations so i have to pop off stack 
	lw $ra, 32($sp)
 	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	lw $s6, 4($sp)
	lw $s7, 0($sp)

	addi $sp, $sp, 36 #remember to move past all the things we added 
	jr $ra
	or $0, $0, $0 

startcalc:
    
	add $t0, $s0, $a2 #address of a2 in t0 THE STRING 
	lbu $t1, 0($t0) # s0 = idx 0 of thestring[i]

	addi $t3, $0, 0x00 #the null term 
	beq $t1,$t3, nullterm_at_start
	or $0, $0, $0
    
	addi $t2, $0, 0x3D #t2='='
	beq $t1, $t2, findequal #we found the equal sign 
	or $0, $0, $0 

	addi $s0, $s0, 1
	j startcalc
	or $0, $0, $0

findequal:
	addi $s0, $s0,1 #move forward to the next character 
	jr $ra
	or $0, $0, $0

nullterm_at_start:
	jr $ra
	or $0, $0, $0

loop:
	add $t0, $s0, $a2 
	lbu $t4, 0($t0) 
	addi $t3, $0, 0x00 #the nullterm
	beq $t4, $t3, nullterm #if t4(current char) = 0 we are done this is a null 
	or $0, $0, $0
	
	bne $t4, $t3, findchar 
	or $0, $0, $0 

	j loop  #repeate 
	or $0, $0, $0

nullterm:
	bne $s1, $0, apply_op_final  
	or $0, $0, $0
	beq $s2, $0, oneterm
	or $0, $0, $0
	add $v0, $s2, $0
	jr $ra
	or $0, $0, $0
oneterm:
	add $v0, $s3, $0
	jr $ra
	or $0, $0, $0
	
apply_op_final:
	# Apply the operation
	addi $t0, $0, 0x2a
	beq $s1, $t0, final_multi
	or $0, $0, $0 
	addi $t0, $0, 0x2f
	beq $s1, $t0, final_divide
	or $0, $0 ,$0 
	addi $t0, $0, 0x2d
	beq $s1, $t0, final_subtraction
	or $0, $0, $0 
	addi $t0, $0, 0x2b
	beq $s1, $t0, final_addition
	or $0, $0, $0
	addi $t0, $0, 0x25
	beq $s1, $t0, final_modulus
	or $0, $0, $0
	add $v0, $s3, $0
	jr $ra

final_addition:
	add $s3, $s3, $s2
	add $v0, $s3, $0
	jr $ra
	or $0, $0, $0

final_subtraction:
	sub $s3, $s3, $s2
	add $v0, $s3, $0
	jr $ra
	or $0, $0, $0
	
final_multi:
	add $t0, $s3, $0
	add $t1, $s2, $0
	add $t4, $0, $0
final_multi_loop:
	add $t4, $t4, $t0
	addi $t1, $t1, -1
	bne $t1, $0, final_multi_loop
	or $0, $0, $0
	add $v0, $t4, $0
	jr $ra
	or $0, $0, $0
	
final_divide:
	add $t0, $0, $0
	add $t1, $s3, $0
final_divide_loop:
	slt $t2, $t1, $s2
	bne $t2, $0, final_divide_done
	or $0, $0, $0
	addi $t0, $t0, 1
	sub $t1, $t1, $s2
	j final_divide_loop
	or $0, $0, $0
final_divide_done:
	add $v0, $t0, $0
	jr $ra
	or $0, $0, $0
	
final_modulus:
	slt $t0, $s3, $s2
	bne $t0, $0, final_modulus_done
	or $0, $0, $0
	sub $s3, $s3, $s2
	j final_modulus
	or $0, $0, $0
final_modulus_done:
	add $v0, $s3, $0
	jr $ra
	or $0, $0, $0

findchar:
    #space handeling 
	addi $t1, $0, 0x20 
	beq $t1, $t4, skipspace 
	or $0, $0, $0 

    #x/y handeling
	addi $t1, $0, 0x78 # t1='x'
	beq $t4, $t1, xvalue 
	or $0, $0, $0

	addi $t1, $0, 0x79 #t2= 'y'
	beq $t4, $t1, yvalue 
	or $0, $0, $0
    
    #number handeling 0-9 
	addi $t1, $0, 0x30 #t1= '0'
	addi $t2, $0, 0x39 # t2= '9'
	slt $t3, $t4, $t1 #if the character is less than '0' it is not a number t3 == 1 
	bne $t3, $0, findop #if char < '0' check the operations 
	or $0, $0, $0
	slt $t5, $t2, $t4 #if 9 < t4(character)
	bne $t5, $0, findop # branch not equal so if 9 > then character check the operations 
	or $0, $0, $0
    #if we made it this far then we should have an int 
	j findnumber
	or $0, $0, $0 

skipspace:
	addi $s0, $s0, 1 
	j loop 
	or $0, $0, $0 

findnumber:
#arriving here with t4 holding the current char 
	addi $t1, $0, 0x30 
	sub $t6, $t4, $t1 #t6 holds the numbers value in decmil 
    
    #ones place s2=0 still if this is the first number
	beq $s2, $0, firstnum
	or $0, $0, $0
    #tens place so s2=a single digit here 
	add $t8, $s2, $0 #t8=og s2 if there was anything in there 
	add $s2, $0, $0 
	addi $t7, $0, 10 
    
	j numberloop
	or $0, $0, $0 

firstnum:
	add $s2, $0, $t6
	j nextchar_check
	or $0, $0, $0

numberloop:
#i have to enter here if i have number that is larger then one place   
	add $s2, $s2, $t8
	addi $t7, $t7, -1 
	bne $t7, $0, numberloop
	or $0, $0, $0 
	add $s2, $s2, $t6    
	addi $s0, $s0, 1
	j loop
	or $0, $0, $0

nextchar_check:
	addi $s0, $s0, 1 #moving to the next char
	j loop 
	or $0, $0, $0  

findop:
    #multi
	addi $t0, $0, 0x2a
	beq $t4, $t0, optracker #t4 came from our loop it is the current char
	or $0, $0, $0 
    #divid
	addi $t0, $0, 0x2f
	beq $t4, $t0, optracker #t4 from loop  
	or $0, $0 ,$0 
    #sub
	addi $t0, $0, 0x2d
	beq $t4, $t0 , optracker
	or $0, $0, $0 
    #addition
	addi $t0, $0, 0x2b
	beq $t4, $t0, optracker
	or $0, $0, $0
    #mod
	addi $t0, $0, 0x25
	beq $t4, $t0, optracker
	or $0, $0, $0


xvalue: #a0
	lh $s2, 0($a0) 
	addi $s0, $s0, 1 #move forward the character
	bne $s1, $0, apply_op
	or $0, $0, $0
	j loop
	or $0, $0, $0
    
    
yvalue: #a1
	lh $s2, 0($a1) 
	addi $s0, $s0, 1 #move forward the character
	bne $s1, $0, apply_op
	or $0, $0, $0
	j loop
	or $0, $0, $0

optracker:
	add $s1, $t4, $0       # store operation
	beq $s3, $0, first_op  # if s3 is empty, move s2 to s3
	or $0, $0, $0
	j continue_op          # otherwise keep s3 as is
	or $0, $0, $0
	
first_op:
	add $s3, $s2, $0       # first operation: move s2 to s3
	
continue_op:
	add $s2, $0, $0        # clear s2
	addi $s0, $s0, 1
	j loop
	or $0, $0, $0

apply_op: 
#where i will call my operations and then branch on equal 
    #multi
	addi $t0, $0, 0x2a
	beq $s1, $t0, multi #t4 came from our loop it is the current char
	or $0, $0, $0 
    #divid
	addi $t0, $0, 0x2f
	beq $s1, $t0, divide #t4 from loop  
	or $0, $0 ,$0 
    #sub
	addi $t0, $0, 0x2d
	beq $s1, $t0 , subtraction
	or $0, $0, $0 
    #addition
	addi $t0, $0, 0x2b
	beq $s1, $t0, addition
	or $0, $0, $0
    #mod
	addi $t0, $0, 0x25
	beq $s1, $t0, modulus
	or $0, $0, $0

addition:
	add $s3, $s3, $s2 #v0 = s3(result) + s2(next character)
	add $s2, $0, $0
	j loop
	or $0, $0, $0
    
multi:
#s3=s3*s2
	add $t0, $s3, $0 #t0= result before multip apply
	add $t1, $s2, $0 #how many times we * by 
	add $t4, $0, $0 #accumulator starts at 0 will add all the s2 together

multi_loop:
	add $t4, $t4, $t0 
	addi $t1, $t1, -1 #reduce the # times we multiply by 
	bne $t1, $0, multi_loop #t1==0 then continue t1!=0 branch 
	or $0, $0, $0 

	add $s3, $t4, $0
	add $s2, $0, $0
	j loop
	or $0, $0, $0 #moving to the next character 
    
divide:
# s3= s3/s2 
	add $t0, $0, $0 #result 
	add $t1, $s3, $0 # what is left to divide
divide_loop:
	slt $t2, $t1, $s2 #if t1<s2 
	bne $t2, $0, divide_done
	or $0, $0, $0
	addi $t0, $t0, 1
	sub $t1, $t1, $s2
	j divide_loop
	or $0, $0, $0
divide_done:
	add $s3, $t0, $0
	add $s2, $0, $0
	j loop
	or $0, $0, $0 

modulus:
#s3= s3%s2
#1. if s3 < s2 then we are done return s3 and be on with our day 
	slt $t0, $s3, $s2
	bne $t0, $0, modulus_done 
#2. else subtract s3 from s2 
	sub $s3, $s3, $s2 
	j modulus
	or $0, $0, $0 
modulus_done:
	add $s2, $0, $0
	j loop
	or $0, $0, $0 

subtraction:
    #s3-s2
	sub $s3, $s3, $s2
	add $s2, $0, $0
	j loop
	or $0, $0, $0

storing_final_addy_x_y: 
#need to figure out if it was x or y before the equal sign
	add $t0, $s0, $a2 #address of a2 in t0 THE STRING 
	lbu $t4, 0($t0) # t4 = idx 0 of thestring[t0]

    #space handeling 
	addi $t1, $0, 0x20 
	beq $t1, $t4, skipspace_final_storage
	or $0, $0, $0

	addi $t3, $0, 0x78 #'x'
	beq $t4, $t3, x_before_equal_stored
	or $0, $0, $0
	addi $t3, $0, 0x79 # 'y'
	beq $t4, $t3, y_before_equal_stored
	or $0, $0, $0

skipspace_final_storage:
	addi $s0, $s0, 1 
	j storing_final_addy_x_y
	or $0, $0, $0 

x_before_equal_stored:
#store result in a0 
	sh $v0, 0($a0)
	jr $ra
	or $0, $0, $0

y_before_equal_stored:
#store result in a1
	sh $v0, 0($a1)
	jr $ra
	or $0, $0, $0

first_char_in_string:
#convert int to string and store in a3 
#1. check if first char of a2 is x or y *** you do this in storing but maybe a easier way?
	add $t0, $s0, $a2 #at the start of the string
	lbu $t4, 0($t0) 
	addi $t3, $0, 0x78 #'x'
	beq $t4, $t3, x_add_to_string
	or $0, $0, $0
	addi $t3, $0, 0x79 # 'y'
	beq $t4, $t3, y_add_to_string       
	or $0, $0, $0
    #space handeling 
	addi $t3, $0, 0x20 
	beq $t4, $t3, skipspace_str_to_int
	or $0, $0, $0

equal_in_string:
#2. store the = : 0x3d
	addi $a3, $a3, 1
	addi $t3, $0, 0x3d #'='
	sb $t3, 0($a3)
	j signcheck
	or $0, $0, $0 
#3. check if $v0 is negative
signcheck:
	slt $t4, $v0, $0       
	beq $t4, $0, int_to_string  
	or $0, $0, $0
	j negativenumber
	or $0, $0, $0

#4. extract the digits and convert to ascii 
#ex: 123 % 10 = 1 23%10 = 2 3%10= 3 then get the ascii and build backwards?
int_to_string:
	add $t1, $v0, $0 #t1=v0
	slti $t3, $t1, 10 #if v0<10 t3=1 
	bne $t3, $0, singlenumstore
	or $0, $0, $0 
	j multidigitstore
	or $0, $0, $0 
singlenumstore: 
	addi $t4, $0, 0x30
	add $t1, $t1, $t4 #i think this gets me back to hex 
    #now store in a3
	addi $a3, $a3, 1
	sb $t1, 0($a3) 
	j null_in_final_str
	addi $a3, $a3, 1

null_in_final_str:
	addi $t4, $0, 0x00 #'/0'
	sb $t4, 0($a3)
	jr $ra
	or $0, $0, $0

multidigitstore:
	add $t5, $v0, $0 #our number 
	add $t6, $0, $0 #counter 
    #continues to digit_loop
digit_loop:
	beq $t5, $0, store_digit
	or $0, $0, $0
    #divide t5 by 10 
	add $t0, $0, $0 
	add $t1, $t5, $t0 
    #continues on to divide by 10 
divide_loop_multidigit:
	slti $t3, $t1, 10 # t1<10 t3==1 else t3==0
	bne $t3, $0, push_digit
	or $0, $0, $0
	addi $t1, $t1, -10 
	addi $t0, $t0, 1 
	j divide_loop_multidigit
	or $0, $0, $0 
push_digit:
#making room on the stack of size word
	addi $sp, $sp, -4
	sw $t1, 0($sp) #push the pop happens in store digit duhh
	addi $t6, $t6, 1
	add $t5, $t0, $0 #t5 now == t0
	j digit_loop

store_digit:
#pop digits and store as ASCII
	beq $t6, $0, done_storing
	or $0, $0, $0
	addi $a3, $a3, 1  # next position
	lw $t1, 0($sp) # pop 
	addi $sp, $sp, 4
	addi $t1, $t1, 0x30 # ascii conversion happening here 
	sb $t1, 0($a3)          
	addi $t6, $t6, -1       
	j store_digit
	or $0, $0, $0

done_storing:
	addi $a3, $a3, 1
	j null_in_final_str
	or $0, $0, $0 

negativenumber:
	addi $a3, $a3, 1
	add $t3, $0, 0x2d #'-'
	sb $t3,0($a3)
	j int_to_string
	or $0, $0, $0 

skipspace_str_to_int:
	add $s0, $s0, 1
	j first_char_in_string
	or $0, $0, $0

x_add_to_string:
    #adding the x to a3 0x78
	sb $t3, 0($a3) # a3:'x'
	j equal_in_string
	or $0, $0, $0

y_add_to_string: 
    #adding the y to a3 0x79
	sb $t3, 0($a3) #a3= 'y'
	j equal_in_string
	or $0, $0, $0 
