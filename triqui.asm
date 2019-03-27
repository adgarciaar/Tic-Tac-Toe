# | 1 | 2 | 3 |
# | 4 | 5 | 6 |
# | 7 | 8 | 9 |

.globl main
.data

	turnoJugador1: .asciiz "\nTurno jugador 1 (X)\n"
	turnoJugador2: .asciiz "\nTurno jugador 2 (O)\n"
	digitarPosicion: .asciiz "\nDigite posición:\n"
	finalizacion: .asciiz "Adiós\n"
	posicionIncorrecta: .asciiz "Posición incorrecta. Vuelta a introducirla\n"
	simboloX: .asciiz "  X  "
	simboloO: .asciiz "  O  "
	vacio: .asciiz "     "
	barra: .asciiz "|"
	saltoLinea: .asciiz "\n"

.text #código de aquí en adelante

main:

	li $t1, 0 # asignar valor a casilla 1 (t1)
	li $t2, 0 # asignar valor a casilla 2 (t2)
	li $t3, 0 # asignar valor a casilla 3 (t3)
	li $t4, 0 # asignar valor a casilla 4 (t4)
	li $t5, 0 # asignar valor a casilla 5 (t5)
	li $t6, 0 # asignar valor a casilla 6 (t6)
	li $t7, 0 # asignar valor a casilla 7 (t7)
	li $t8, 0 # asignar valor a casilla 8 (t8)
	li $t9, 0 # asignar valor a casilla 9 (t9)
	
	jal imprimirTabla
	
	jal imprimirTurnoJugador1
	jal pedirPosicionJugador1
	
	#comprobar que se inicializaron las casillas
	#li $v0, 1 # Code to print an integer is 1
	#move $a0, $t8 # Pass argument to system in $a0
	#syscall # print the string
		
	b fin
	
imprimirTurnoJugador1:
	#imprimir turno jugador 1
	la $a0 turnoJugador1 # load address of msg4. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string	
	jr $ra #return

imprimirTurnoJugador2:
	#imprimir turno jugador 2
	la $a0 turnoJugador2 # load address of msg4. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string	
	jr $ra #return

pedirPosicionJugador1:
	li $a2, 1 #asignar a a2 el valor de jugador 1

	#pedir posición jugada jugador 1
	
	la $a0 digitarPosicion # load address of msg4. into $a0
	li $v0 4 # system call code for print_str
	#syscall # print the string

	li $v0, 5 # system call code for Read Integer
	syscall # reads the value into $v0
	
	bltz $v0, fin # si el valor es menor a cero se va a fin
	beqz $v0, fin # si el valor es igual a cero se va a fin
	bgt $v0, 9, rectificarPosicion # si el valor es mayor a 9
	
	jr $ra #return

pedirPosicionJugador2:
	li $a2, 2 #asignar a a2 el valor de jugador 2

	#pedir posición jugada jugador 2

	la $a0 digitarPosicion # load address of msg4. into $a0
	li $v0 4 # system call code for print_str
	#syscall # print the string

	li $v0, 5 # system call code for Read Integer
	syscall # reads the value into $v0
	
	bltz $v0, fin # si el valor es menor a cero se va a fin
	beqz $v0, fin # si el valor es igual a cero
	bgt $v0, 9, rectificarPosicion # si el valor es mayor a 9
	
	jr $ra #return
	
imprimirTabla:

	addi $sp, $sp, -4 #pedir espacio en pila
	sw $ra, 0($sp) #save return address to stack
	
	jal imprimirBarra
	move $a1, $t1 #asignar a a1 el valor de casilla 1
	jal imprimirPos #imprimir posición 1
	jal imprimirBarra
	move $a1, $t2 #asignar a a1 el valor de casilla 2
	jal imprimirPos #imprimir posición 2
	jal imprimirBarra
	move $a1, $t3 #asignar a a1 el valor de casilla 3
	jal imprimirPos #imprimir posición 3
	jal imprimirBarra
	jal imprimirSaltoLinea
	jal imprimirBarra
	move $a1, $t4 #asignar a a1 el valor de casilla 4
	jal imprimirPos #imprimir posición 4
	jal imprimirBarra
	move $a1, $t5 #asignar a a1 el valor de casilla 5
	jal imprimirPos #imprimir posición 5
	jal imprimirBarra
	move $a1, $t6 #asignar a a1 el valor de casilla 6
	jal imprimirPos #imprimir posición 6
	jal imprimirBarra
	jal imprimirSaltoLinea
	jal imprimirBarra
	move $a1, $t7 #asignar a a1 el valor de casilla 7
	jal imprimirPos #imprimir posición 7
	jal imprimirBarra
	move $a1, $t8 #asignar a a1 el valor de casilla 8
	jal imprimirPos #imprimir posición 8
	jal imprimirBarra
	move $a1, $t9 #asignar a a1 el valor de casilla 9
	jal imprimirPos #imprimir posición 9
	jal imprimirBarra
	jal imprimirSaltoLinea
	
	lw $ra, 0($sp) #load return address
	addi $sp, $sp, 4  #realocar espacio en pila
	jr $ra #return
	
imprimirPos:	
	beq $a1, 1, imprimirX
	beq $a1, 2, imprimirO
	beq $a1, 0, imprimirVacio

imprimirBarra:
	la $a0 barra # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return
	
imprimirSaltoLinea:
	la $a0 saltoLinea # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return

imprimirO:
	la $a0 simboloO # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return

imprimirVacio:
	la $a0 vacio # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string	
	jr $ra #return

imprimirX:	
	la $a0 simboloX # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return
	
rectificarPosicion:
	la $a0 posicionIncorrecta # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string

fin:
	#imprimir adiós
	la $a0 finalizacion # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	#terminar ejecución
	li $v0, 10 # terminate program run and
	syscall # return control to system
