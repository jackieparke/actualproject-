
.globl main 
.text
main:
    addi $s2, 8
    addi $s3, 1
    addi $s5, 4
    addi $t0, 6
    add $t1, $0, $0
    add $t2, $s5, $0
loop: 
    add $0, $0, $0
    addi $t1, 1 
    sub $t0, $t0, $t1
    add $t5, $s5, $t2
