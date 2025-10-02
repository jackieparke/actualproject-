	# y := 64 * x - y + 39
	
	.globl main
	.globl done

	.data
x:	 .byte 4
y:	.byte 200

	.text
main:
	lb $t0,x #load x into t0
	sll $t1, $t0, 6 #2^6 = 64
	lb $t3, y #load y into t3
	sub $t1, $t1, $t3 #t1 = 64 * x - y
	addi $t1, $t1, 39 # + 39
	sb $t1, y
done:
	jr $ra
	or $0, $0, $0
