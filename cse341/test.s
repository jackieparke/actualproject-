.globl main 
.globl check
.data	0x10000000
x:	.half 12
y:	.half 4
expr:	.asciiz	"x=3"

.data	0x10000020
	
output_string:	.byte 8
.text
main:
	lui $a0, 0x1000

	lui $a1, 0x1000
	ori $a1, $a1, 0x0002

	lui $a2, 0x1000
	ori $a2, $a2, 0x0004

	lui $a3, 0x1000
	ori $a3, $a3, 0x0020

	jal project1
	or $0, $0, $0
check:	
	jr $ra
	or $0, $0, $0

	
