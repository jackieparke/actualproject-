.globl main
.globl check
.text

main:
	#evlauate the expression $s0 = $t0 * 8 - $t1 + 14
	addi $t0, $t0, 5 #t0 placeholder value
	addi $t1, $tl, 23 #$t1 place holder value

	sll $s0, $t0, 3 #shift left logical: multiplication, 2^3=8= $t0*8
	#srl : division
	sub $s0, $s0, $t1 #s0 (t0 * 8)-t1 store in s0
	addi $s0, $s0, 14 #s0 = s0 + 14 (17 + 14 = 31)

check: #this is useful for debugging
	jr $ra #the return to caller 
	add $0, $0, $0 #must give no ops for branch delays 
	
