.data
	msg01: .asciiz "\n|	|	|	|\n"
	msg02: .asciiz "|	|	|	|\n"
	msg03: .asciiz "|	|	|	|\n"
	msg04: .asciiz "\nTurno jugador 1\n"
	msg05: .asciiz "\nTurno jugador 2\n"
	msg06: .asciiz "Digite fila:\n"
	msg07: .asciiz "Digite columna:\n"
	msg08: .asciiz "Adiós\n"
.text

main:

	#imprimir tabla vacía

	la $a0 msg01 # load address of msg1. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string

	la $a0 msg02 # load address of msg2. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string

	la $a0 msg03 # load address of msg3. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string

	la $a0 msg04 # load address of msg4. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string

	la $a0 msg06 # load address of msg4. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string

	li $v0, 5 # system call code for Read Integer
	syscall # reads the value into $v0
	
	bltz $v0, end # si el valor es menor a cero

	move $a0, $v0
	#la $a0 5 # load address of msg4. into $a0
	li $v0, 1 # system call code for Print Integer
	syscall # print

end:
	li $v0, 10 # terminate program run and
	syscall # return control to system