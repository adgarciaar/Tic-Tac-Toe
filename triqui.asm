#  --- --- ---
# | 1 | 2 | 3 |
#  --- --- ---
# | 4 | 5 | 6 |
#  --- --- ---
# | 7 | 8 | 9 |
#  --- --- ---

#1 en la casilla para X
#-1 en la casilla para O

#.globl main

.data # Section where data is stored in memory (allocated in RAM), similar to
      # variables in higher level languages

	turnoJugador1: .asciiz "\nTurno jugador 1 (X)\n"
	turnoJugador2: .asciiz "\nTurno jugador 2 (O)\n"
	digitarPosicion: .asciiz "\nDigite posición:\n"
	finalizacion: .asciiz "\nJuego finalizado\n"
	posicionIncorrecta: .asciiz "\nPosición incorrecta. Vuelta a introducirla\n"
	simboloX: .asciiz "  X  "
	simboloO: .asciiz "  O  "
	vacio: .asciiz "     "
	barra: .asciiz "|"
	saltoLinea: .asciiz "\n"
	ganaPartidaJugador1: .asciiz "\nGana el jugador 1\n"
	ganaPartidaJugador2: .asciiz "\nGana el jugador 2\n"
	empate: .asciiz "\nEl juego ha terminado en empate\n"
	bienvenido: .asciiz "\nBienvenido\nDigite el número de una de las siguientes opciones:\n"
	digiteNuevoJuegoJugadores: .asciiz "\n1. Nuevo juego para 2 jugadores\n"
	digiteNuevoJuegoMaquina: .asciiz "2. Nuevo juego para 1 jugador vs máquina\n"
	digiteSalir: .asciiz "3. Salir\n"
	barrasHorizontales: .asciiz "-------------------"
	referenciaLinea1: .asciiz "|  1  |  2  |  3  |"
	referenciaLinea2: .asciiz "|  4  |  5  |  6  |"
	referenciaLinea3: .asciiz "|  7  |  8  |  9  |"
	espacio: .asciiz "            "
	turnoMaquina: .asciiz "Juega la máquina\n"
	ganaMaquina: .asciiz "Gana la máquina. ¿Será que algún día las máquinas gobernarán la Tierra?\n"

.text #código de aquí en adelante

main:
	jal imprimirMenuInicio #imprimir menú de inicio
	
	li $v0, 5 # system call code for Read Integer
	syscall # reads the value into $v0
	beq $v0, 1, nuevoJuegoJugadores # si el valor digitado es 1 arranca nuevo juego
	beq $v0, 2, nuevoJuegoContraMaquina # si el valor digitado es 1 arranca nuevo juego
	beq $v0, 3, fin # si el valor digitado es 2 se termina la ejecución
	
imprimirMenuInicio:
	la $a0 bienvenido # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	la $a0 digiteNuevoJuegoJugadores # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	la $a0 digiteNuevoJuegoMaquina # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	la $a0 digiteSalir # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	jr $ra #return a main
	
nuevoJuegoJugadores:
	li $s1, 1 # para saber si es entre humanos
	jal inicializarTabla
	jal imprimirTabla #imprimir tabla inicial
	
	li $v1,1 #asignar a v1 el valor de 1 para arrancar el ciclo siguiente
	b loopTurnos #lanzar los 9 turnos
	
nuevoJuegoContraMaquina:
	li $s1, 2 # para saber si es entre humano y máquina
	jal inicializarTabla
	jal imprimirTabla #imprimir tabla inicial
	
	li $v1,1 #asignar a v1 el valor de 1 para arrancar el ciclo siguiente
	b loopTurnosContraMaquina #lanzar los 9 turnos
	
loopTurnosContraMaquina:    	
    	
    	#turno jugador 1
    	jal lanzarTurnoJugador1
    	jal imprimirTabla	
	jal validarTresEnLinea #validar si alguno ganó
	add $v1,$v1,1 #incrementar v1 en 1 (contador)
	
	bgt $v1,9,empateJugadores #cuando llega a 9 rompe el ciclo (hay empate)
	
	#turno máquina
    	jal lanzarTurnoMaquina    	
	jal imprimirTabla	
	
	jal validarTresEnLinea #validar si alguno ganó
	add $v1,$v1,1 #incrementar v1 en 1 (contador)
	
	b loopTurnosContraMaquina #volver a ejecutar la función
	
lanzarTurnoMaquina:

	#imprimir turno máquina
	la $a0 turnoMaquina # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	b pedirPosicionMaquina
	
pedirPosicionMaquina:

	li $a2, 2 #asignar a a2 el valor de jugador 2
	li $a3, -1 #asignar a a3 valor de -1 para adicionar un O en la casilla
	
	################################################
	#jugadas de alta prioridad
	
	#primero ver si se puede ganar
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 1 | 2 | 3 |
	add $t0,$t1,$t2 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, -2, hacerJugadaMaquinaFila1AltaPrioridad # puede ganar la máquina
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 4 | 5 | 6 |
	add $t0,$t4,$t5 #sumar
	add $t0,$t0,$t6 #sumar
	beq $t0, -2, hacerJugadaMaquinaFila2AltaPrioridad # puede ganar la máquina
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 7 | 8 | 9 |
	add $t0,$t7,$t8 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, -2, hacerJugadaMaquinaFila3AltaPrioridad # puede ganar la máquina
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 | 
	# | 4 |
	# | 7 | 
	add $t0,$t1,$t4 #sumar
	add $t0,$t0,$t7 #sumar
	beq $t0, -2, hacerJugadaMaquinaColumna1AltaPrioridad # puede ganar la máquina
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 2 |
	# | 5 |
	# | 8 |
	add $t0,$t2,$t5 #sumar
	add $t0,$t0,$t8 #sumar
	beq $t0, -2, hacerJugadaMaquinaColumna2AltaPrioridad # puede ganar la máquina
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 3 |
	# | 6 |
	# | 9 |
	add $t0,$t3,$t6 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, -2, hacerJugadaMaquinaColumna3AltaPrioridad # puede ganar la máquina
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	add $t0,$t1,$t5 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, -2, hacerJugadaMaquinaTranversal1AltaPrioridad # puede ganar la máquina
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	add $t0,$t7,$t5 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, -2, hacerJugadaMaquinaTranversal2AltaPrioridad # puede ganar la máquina
	
	###################
	#evitar que gane el humano

	li $t0, 0 # asignar valor de 0 a t1
	# validar | 1 | 2 | 3 |
	add $t0,$t1,$t2 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, 2, hacerJugadaMaquinaFila1AltaPrioridad # va a ganar el humano
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 4 | 5 | 6 |
	add $t0,$t4,$t5 #sumar
	add $t0,$t0,$t6 #sumar
	beq $t0, 2, hacerJugadaMaquinaFila2AltaPrioridad # va a ganar el humano
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 7 | 8 | 9 |
	add $t0,$t7,$t8 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 2, hacerJugadaMaquinaFila3AltaPrioridad # va a ganar el humano
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 | 
	# | 4 |
	# | 7 | 
	add $t0,$t1,$t4 #sumar
	add $t0,$t0,$t7 #sumar
	beq $t0, 2, hacerJugadaMaquinaColumna1AltaPrioridad # va a ganar el humano
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 2 |
	# | 5 |
	# | 8 |
	add $t0,$t2,$t5 #sumar
	add $t0,$t0,$t8 #sumar
	beq $t0, 2, hacerJugadaMaquinaColumna2AltaPrioridad # va a ganar el humano
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 3 |
	# | 6 |
	# | 9 |
	add $t0,$t3,$t6 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 2, hacerJugadaMaquinaColumna3AltaPrioridad # va a ganar el humano
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	add $t0,$t1,$t5 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 2, hacerJugadaMaquinaTranversal1AltaPrioridad # va a ganar el humano
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	add $t0,$t7,$t5 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, 2, hacerJugadaMaquinaTranversal2AltaPrioridad # va a ganar el humano
	
	######################################################
	#jugadas de media prioridad
	#si se tiene una marca para alguna opción entonces marcar la segunda
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 1 | 2 | 3 |
	add $t0,$t1,$t2 #sumar
	add $t0,$t0,$t3 #sumar
	#beq $t0, 1, hacerJugadaMaquinaFila1MediaPrioridad 
	beq $t0, -1, hacerJugadaMaquinaFila1MediaPrioridad #
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 4 | 5 | 6 |
	add $t0,$t4,$t5 #sumar
	add $t0,$t0,$t6 #sumar
	#beq $t0, 1, hacerJugadaMaquinaFila2MediaPrioridad 
	beq $t0, -1, hacerJugadaMaquinaFila2MediaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 7 | 8 | 9 |
	add $t0,$t7,$t8 #sumar
	add $t0,$t0,$t9 #sumar
	#beq $t0, 1, hacerJugadaMaquinaFila3MediaPrioridad 
	beq $t0, -1, hacerJugadaMaquinaFila3MediaPrioridad
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 | 
	# | 4 |
	# | 7 | 
	add $t0,$t1,$t4 #sumar
	add $t0,$t0,$t7 #sumar
	#beq $t0, 1, hacerJugadaMaquinaColumna1MediaPrioridad 
	beq $t0, -1, hacerJugadaMaquinaColumna1MediaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 2 |
	# | 5 |
	# | 8 |
	add $t0,$t2,$t5 #sumar
	add $t0,$t0,$t8 #sumar
	#beq $t0, 1, hacerJugadaMaquinaColumna2MediaPrioridad 
	beq $t0, -1, hacerJugadaMaquinaColumna2MediaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 3 |
	# | 6 |
	# | 9 |
	add $t0,$t3,$t6 #sumar
	add $t0,$t0,$t9 #sumar
	#beq $t0, 1, hacerJugadaMaquinaColumna3MediaPrioridad 
	beq $t0, -1, hacerJugadaMaquinaColumna3MediaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	add $t0,$t1,$t5 #sumar
	add $t0,$t0,$t9 #sumar
	#beq $t0, 1, hacerJugadaMaquinaTranversal1MediaPrioridad
	beq $t0, -1, hacerJugadaMaquinaTranversal1MediaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	add $t0,$t7,$t5 #sumar
	add $t0,$t0,$t3 #sumar
	#beq $t0, 1, hacerJugadaMaquinaTranversal2MediaPrioridad 
	beq $t0, -1, hacerJugadaMaquinaTranversal2MediaPrioridad
	
	#####################################################################
	#jugada donde haya una marca del humano
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 1 | 2 | 3 |
	add $t0,$t1,$t2 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, 1, hacerJugadaMaquinaFila1BajaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 4 | 5 | 6 |
	add $t0,$t4,$t5 #sumar
	add $t0,$t0,$t6 #sumar
	beq $t0, 1, hacerJugadaMaquinaFila2BajaPrioridad
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 7 | 8 | 9 |
	add $t0,$t7,$t8 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 1, hacerJugadaMaquinaFila3BajaPrioridad
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 | 
	# | 4 |
	# | 7 | 
	add $t0,$t1,$t4 #sumar
	add $t0,$t0,$t7 #sumar
	beq $t0, 1, hacerJugadaMaquinaColumna1BajaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 2 |
	# | 5 |
	# | 8 |
	add $t0,$t2,$t5 #sumar
	add $t0,$t0,$t8 #sumar
	beq $t0, 1, hacerJugadaMaquinaColumna2BajaPrioridad
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 3 |
	# | 6 |
	# | 9 |
	add $t0,$t3,$t6 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 1, hacerJugadaMaquinaColumna3BajaPrioridad 
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	add $t0,$t1,$t5 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 1, hacerJugadaMaquinaTranversal1BajaPrioridad
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	add $t0,$t7,$t5 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, 1, hacerJugadaMaquinaTranversal2BajaPrioridad
	
hacerJugadaMaquinaFila1AltaPrioridad:
	# | 1 | 2 | 3 |
	beq $t1, 0, verificarCasilla1
	beq $t2, 0, verificarCasilla2
	beq $t3, 0, verificarCasilla3

hacerJugadaMaquinaFila2AltaPrioridad:
	# | 4 | 5 | 6 |
	beq $t4, 0, verificarCasilla4
	beq $t5, 0, verificarCasilla5
	beq $t6, 0, verificarCasilla6
	
hacerJugadaMaquinaFila3AltaPrioridad:
	# | 7 | 8 | 9 |
	beq $t7, 0, verificarCasilla7
	beq $t8, 0, verificarCasilla8
	beq $t9, 0, verificarCasilla9
	
hacerJugadaMaquinaColumna1AltaPrioridad:
	# | 1 | 
	# | 4 |
	# | 7 | 
	beq $t1, 0, verificarCasilla1
	beq $t4, 0, verificarCasilla4
	beq $t7, 0, verificarCasilla7

hacerJugadaMaquinaColumna2AltaPrioridad:
	# | 2 |
	# | 5 |
	# | 8 |
	beq $t2, 0, verificarCasilla2
	beq $t5, 0, verificarCasilla5
	beq $t8, 0, verificarCasilla8
	
hacerJugadaMaquinaColumna3AltaPrioridad:
	# | 3 |
	# | 6 |
	# | 9 |
	beq $t3, 0, verificarCasilla3
	beq $t6, 0, verificarCasilla6
	beq $t9, 0, verificarCasilla9
	
hacerJugadaMaquinaTranversal1AltaPrioridad:
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	beq $t1, 0, verificarCasilla1
	beq $t5, 0, verificarCasilla5
	beq $t9, 0, verificarCasilla9
	
hacerJugadaMaquinaTranversal2AltaPrioridad:
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	beq $t3, 0, verificarCasilla3
	beq $t5, 0, verificarCasilla5
	beq $t7, 0, verificarCasilla7
	
hacerJugadaMaquinaFila1MediaPrioridad:
	# | 1 | 2 | 3 |
	beq $t1, -1, verificarCasilla2 #si la casilla 1 está ocupada entonces ir por la 2
	beq $t2, -1, verificarCasilla1 #si la casilla 2 está ocupada entonces ir por la 1 o 3
	beq $t3, -1, verificarCasilla2 #si la casilla 3 está ocupada entonces ir por la 2
	
hacerJugadaMaquinaFila2MediaPrioridad:
	# | 4 | 5 | 6 |
	beq $t4, -1, verificarCasilla5 #si la casilla 4 está ocupada entonces ir por la 5
	beq $t5, -1, verificarCasilla4 #si la casilla 5 está ocupada entonces ir por la 4 o 5
	beq $t6, -1, verificarCasilla5 #si la casilla 6 está ocupada entonces ir por la 5
	
hacerJugadaMaquinaFila3MediaPrioridad:
	# | 7 | 8 | 9 |
	beq $t7, -1, verificarCasilla8 #si la casilla 7 está ocupada entonces ir por la 8
	beq $t8, -1, verificarCasilla7 #si la casilla 8 está ocupada entonces ir por la 7 o 9
	beq $t9, -1, verificarCasilla8 #si la casilla 9 está ocupada entonces ir por la 8
	
hacerJugadaMaquinaColumna1MediaPrioridad:
	# | 1 | 
	# | 4 |
	# | 7 |
	beq $t1, -1, verificarCasilla4 #si la casilla 1 está ocupada entonces ir por la 4
	beq $t4, -1, verificarCasilla7 #si la casilla 4 está ocupada entonces ir por la 1 o 7
	beq $t7, -1, verificarCasilla4 #si la casilla 7 está ocupada entonces ir por la 4
	
hacerJugadaMaquinaColumna2MediaPrioridad:
	# | 2 |
	# | 5 |
	# | 8 |
	beq $t2, -1, verificarCasilla5 #si la casilla 2 está ocupada entonces ir por la 5
	beq $t5, -1, verificarCasilla2 #si la casilla 5 está ocupada entonces ir por la 2 o 8
	beq $t8, -1, verificarCasilla5 #si la casilla 8 está ocupada entonces ir por la 5

hacerJugadaMaquinaColumna3MediaPrioridad:
	# | 3 |
	# | 6 |
	# | 9 |
	beq $t3, -1, verificarCasilla6 #si la casilla 3 está ocupada entonces ir por la 6
	beq $t6, -1, verificarCasilla3 #si la casilla 6 está ocupada entonces ir por la 3 o 9
	beq $t9, -1, verificarCasilla6 #si la casilla 9 está ocupada entonces ir por la 6
	
hacerJugadaMaquinaTranversal1MediaPrioridad:
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	beq $t1, -1, verificarCasilla5 #si la casilla 1 está ocupada entonces ir por la 5
	beq $t5, -1, verificarCasilla1 #si la casilla 5 está ocupada entonces ir por la 1 o 9
	beq $t9, -1, verificarCasilla5 #si la casilla 9 está ocupada entonces ir por la 5
	
hacerJugadaMaquinaTranversal2MediaPrioridad:
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	beq $t7, -1, verificarCasilla5 #si la casilla 7 está ocupada entonces ir por la 5
	beq $t5, -1, verificarCasilla7 #si la casilla 6 está ocupada entonces ir por la 7 o 3
	beq $t3, -1, verificarCasilla5 #si la casilla 3 está ocupada entonces ir por la 5
	
	
hacerJugadaMaquinaFila1BajaPrioridad:
	# | 1 | 2 | 3 |
	beq $t1, 1, verificarCasilla2 #si la casilla 1 está ocupada entonces ir por la 2
	beq $t2, 1, verificarCasilla1 #si la casilla 2 está ocupada entonces ir por la 1 o 3
	beq $t3, 1, verificarCasilla2 #si la casilla 3 está ocupada entonces ir por la 2
	
hacerJugadaMaquinaFila2BajaPrioridad:
	# | 4 | 5 | 6 |
	beq $t4, 1, verificarCasilla5 #si la casilla 4 está ocupada entonces ir por la 5
	beq $t5, 1, verificarCasilla4 #si la casilla 5 está ocupada entonces ir por la 4 o 5
	beq $t6, 1, verificarCasilla5 #si la casilla 6 está ocupada entonces ir por la 5
	
hacerJugadaMaquinaFila3BajaPrioridad:
	# | 7 | 8 | 9 |
	beq $t7, 1, verificarCasilla8 #si la casilla 7 está ocupada entonces ir por la 8
	beq $t8, 1, verificarCasilla7 #si la casilla 8 está ocupada entonces ir por la 7 o 9
	beq $t9, 1, verificarCasilla8 #si la casilla 9 está ocupada entonces ir por la 8
	
hacerJugadaMaquinaColumna1BajaPrioridad:
	# | 1 | 
	# | 4 |
	# | 7 |
	beq $t1, 1, verificarCasilla4 #si la casilla 1 está ocupada entonces ir por la 4
	beq $t4, 1, verificarCasilla7 #si la casilla 4 está ocupada entonces ir por la 1 o 7
	beq $t7, 1, verificarCasilla4 #si la casilla 7 está ocupada entonces ir por la 4
	
hacerJugadaMaquinaColumna2BajaPrioridad:
	# | 2 |
	# | 5 |
	# | 8 |
	beq $t2, 1, verificarCasilla5 #si la casilla 2 está ocupada entonces ir por la 5
	beq $t5, 1, verificarCasilla2 #si la casilla 5 está ocupada entonces ir por la 2 o 8
	beq $t8, 1, verificarCasilla5 #si la casilla 8 está ocupada entonces ir por la 5

hacerJugadaMaquinaColumna3BajaPrioridad:
	# | 3 |
	# | 6 |
	# | 9 |
	beq $t3, 1, verificarCasilla6 #si la casilla 3 está ocupada entonces ir por la 6
	beq $t6, 1, verificarCasilla3 #si la casilla 6 está ocupada entonces ir por la 3 o 9
	beq $t9, 1, verificarCasilla6 #si la casilla 9 está ocupada entonces ir por la 6
	
hacerJugadaMaquinaTranversal1BajaPrioridad:
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	beq $t1, 1, verificarCasilla5 #si la casilla 1 está ocupada entonces ir por la 5
	beq $t5, 1, verificarCasilla1 #si la casilla 5 está ocupada entonces ir por la 1 o 9
	beq $t9, 1, verificarCasilla5 #si la casilla 9 está ocupada entonces ir por la 5
	
hacerJugadaMaquinaTranversal2BajaPrioridad:
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	beq $t7, 1, verificarCasilla5 #si la casilla 7 está ocupada entonces ir por la 5
	beq $t5, 1, verificarCasilla7 #si la casilla 6 está ocupada entonces ir por la 7 o 3
	beq $t3, 1, verificarCasilla5 #si la casilla 3 está ocupada entonces ir por la 5
	
inicializarTabla:	
	li $t1, 0 # asignar valor a casilla 1 (t1)
	li $t2, 0 # asignar valor a casilla 2 (t2)
	li $t3, 0 # asignar valor a casilla 3 (t3)
	li $t4, 0 # asignar valor a casilla 4 (t4)
	li $t5, 0 # asignar valor a casilla 5 (t5)
	li $t6, 0 # asignar valor a casilla 6 (t6)
	li $t7, 0 # asignar valor a casilla 7 (t7)
	li $t8, 0 # asignar valor a casilla 8 (t8)
	li $t9, 0 # asignar valor a casilla 9 (t9)
	#comprobar que se inicializaron las casillas
	#li $v0, 1 # Code to print an integer is 1
	#move $a0, $t8 # Pass argument to system in $a0
	#syscall # print the string	
	jr $ra #return
	
lanzarTurnoJugador1:
	#turno 1
	
	#imprimir turno jugador 1
	la $a0 turnoJugador1 # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	b pedirPosicionJugador1	

lanzarTurnoJugador2:
	#turno 2
	
	#imprimir turno jugador 1
	la $a0 turnoJugador2 # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	b pedirPosicionJugador2
	
loopTurnos:    	
    	#li $v0, 1 # Code to print an integer is 1
	#move $a0, $v1 # Pass argument to system in $a0
	#syscall # print the string
    	
    	#turno jugador 1
    	jal lanzarTurnoJugador1
    	jal imprimirTabla	
	jal validarTresEnLinea #validar si alguno ganó
	add $v1,$v1,1 #incrementar v1 en 1 (contador)
	
	bgt $v1,9,empateJugadores #cuando llega a 9 rompe el ciclo (hay empate)
	
	#turno jugador 2
    	jal lanzarTurnoJugador2    	
	jal imprimirTabla	
	jal validarTresEnLinea #validar si alguno ganó
	add $v1,$v1,1 #incrementar v1 en 1 (contador)
	
	b loopTurnos #volver a ejecutar la función

imprimirTabla:
	addi $sp, $sp, -4 #pedir espacio en pila
	sw $ra, 0($sp) #save return address to stack
	
	jal imprimirSaltoLinea
	jal imprimirBarrasHorizontales
	
	#imprimir guía de tabla a la derecha
	jal imprimirEspacio
	jal imprimirBarrasHorizontales
	
	jal imprimirSaltoLinea
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
	
	#imprimir guía de tabla a la derecha
	jal imprimirEspacio
	jal imprimirReferencia1	
	jal imprimirSaltoLinea
	jal imprimirBarrasHorizontales
	
	#imprimir guía de tabla a la derecha
	jal imprimirEspacio
	jal imprimirBarrasHorizontales
	
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
	
	#imprimir guía de tabla a la derecha
	jal imprimirEspacio
	jal imprimirReferencia2
	jal imprimirSaltoLinea
	jal imprimirBarrasHorizontales
	
	jal imprimirEspacio
	jal imprimirBarrasHorizontales
	
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
	
	#imprimir guía de tabla a la derecha
	jal imprimirEspacio
	jal imprimirReferencia3	
	jal imprimirSaltoLinea
	jal imprimirBarrasHorizontales
	
	jal imprimirEspacio
	jal imprimirBarrasHorizontales
	
	jal imprimirSaltoLinea
	
	lw $ra, 0($sp) #load return address
	addi $sp, $sp, 4  #realocar espacio en pila
	jr $ra #return
		
imprimirPos:	
	beq $a1, 1, imprimirX
	beq $a1, -1, imprimirO
	beq $a1, 0, imprimirVacio
	
imprimirEspacio:
	la $a0 espacio # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return
	
imprimirReferencia1:
	la $a0 referenciaLinea1 # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return
	
imprimirReferencia2:
	la $a0 referenciaLinea2 # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return
	
imprimirReferencia3:
	la $a0 referenciaLinea3 # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return

imprimirBarra:
	la $a0 barra # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return
	
imprimirSaltoLinea:
	la $a0 saltoLinea # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return
	
imprimirBarrasHorizontales:
	la $a0 barrasHorizontales # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return

imprimirO:
	la $a0 simboloO # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return

imprimirVacio:
	la $a0 vacio # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string	
	jr $ra #return

imprimirX:	
	la $a0 simboloX # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	jr $ra #return

pedirPosicionJugador1:
	li $a2, 1 #asignar a a2 el valor de jugador 1

	#pedir posición jugada jugador 1
	
	la $a0 digitarPosicion # load address of mensaje
	li $v0 4 # system call code for print_str
	#syscall # print the string

	li $v0, 5 # system call code for Read Integer
	syscall # reads the value into $v0
	
	bltz $v0, fin # si el valor es menor a cero se va a fin
	beqz $v0, fin # si el valor es igual a cero se va a fin
	bgt $v0, 9, rectificarPosicion # si el valor es mayor a 9
	
	li $a3, 1 #asignar a a3 valor de 1 para adicionar una X en la casilla
	
	beq $v0, 1, verificarCasilla1 # si es casilla 1
	beq $v0, 2, verificarCasilla2 # si es casilla 2
	beq $v0, 3, verificarCasilla3 # si es casilla 3
	beq $v0, 4, verificarCasilla4 # si es casilla 4
	beq $v0, 5, verificarCasilla5 # si es casilla 5
	beq $v0, 6, verificarCasilla6 # si es casilla 6
	beq $v0, 7, verificarCasilla7 # si es casilla 7
	beq $v0, 8, verificarCasilla8 # si es casilla 8
	beq $v0, 9, verificarCasilla9 # si es casilla 9
	
pedirPosicionJugador2:
	li $a2, 2 #asignar a a2 el valor de jugador 2

	#pedir posición jugada jugador 2

	la $a0 digitarPosicion # load address of mensaje
	li $v0 4 # system call code for print_str
	#syscall # print the string

	li $v0, 5 # system call code for Read Integer
	syscall # reads the value into $v0
	
	bltz $v0, fin # si el valor es menor a cero se va a fin
	beqz $v0, fin # si el valor es igual a cero
	bgt $v0, 9, rectificarPosicion # si el valor es mayor a 9
	
	li $a3, -1 #asignar a a3 valor de -1 para adicionar un O en la casilla
	
	beq $v0, 1, verificarCasilla1 # si es casilla 1
	beq $v0, 2, verificarCasilla2 # si es casilla 2
	beq $v0, 3, verificarCasilla3 # si es casilla 3
	beq $v0, 4, verificarCasilla4 # si es casilla 4
	beq $v0, 5, verificarCasilla5 # si es casilla 5
	beq $v0, 6, verificarCasilla6 # si es casilla 6
	beq $v0, 7, verificarCasilla7 # si es casilla 7
	beq $v0, 8, verificarCasilla8 # si es casilla 8
	beq $v0, 9, verificarCasilla9 # si es casilla 9
	
verificarCasilla1:
	beq $t1, 0, _adicionarSimbolo1 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo1:
	move $t1, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos

verificarCasilla2:
	beq $t2, 0, _adicionarSimbolo2 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo2:
	move $t2, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos

verificarCasilla3:
	beq $t3, 0, _adicionarSimbolo3 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo3:
	move $t3, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos
	
verificarCasilla4:
	beq $t4, 0, _adicionarSimbolo4 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo4:
	move $t4, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos
	
verificarCasilla5:
	beq $t5, 0, _adicionarSimbolo5 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo5:
	move $t5, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos
	
verificarCasilla6:
	beq $t6, 0, _adicionarSimbolo6 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo6:
	move $t6, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos
	
verificarCasilla7:
	beq $t7, 0, _adicionarSimbolo7 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo7:
	move $t7, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos
	
verificarCasilla8:
	beq $t8, 0, _adicionarSimbolo8 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo8:
	move $t8, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos
	
verificarCasilla9:
	beq $t9, 0, _adicionarSimbolo9 # si la casilla está en 0 (se puede adicionar)
	b rectificarPosicion
_adicionarSimbolo9:
	move $t9, $a3 #asignar a la casilla 1 el valor de jugador (1 o 2)
	jr $ra #retornar a ciclo de turnos
	
rectificarPosicion:
	la $a0 posicionIncorrecta # load address of msg8. into $a0
	li $v0 4 # system call code for print_str
	syscall # print the string
	beq $a2, 1, pedirPosicionJugador1 # si el valor es 1 corresponde a jugador 1
	beq $a2, 2, pedirPosicionJugador2 # si el valor es 1 corresponde a jugador 1
	
validarTresEnLinea:
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 1 | 2 | 3 |
	add $t0,$t1,$t2 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 4 | 5 | 6 |
	add $t0,$t4,$t5 #sumar
	add $t0,$t0,$t6 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	li $t0, 0 # asignar valor de 0 a t1
	# validar | 7 | 8 | 9 |
	add $t0,$t7,$t8 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 | 
	# | 4 |
	# | 7 | 
	add $t0,$t1,$t4 #sumar
	add $t0,$t0,$t7 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 2 |
	# | 5 |
	# | 8 |
	add $t0,$t2,$t5 #sumar
	add $t0,$t0,$t8 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 3 |
	# | 6 |
	# | 9 |
	add $t0,$t3,$t6 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# | 1 |   |   |
	# |   | 5 |   |
	# |   |   | 9 |
	add $t0,$t1,$t5 #sumar
	add $t0,$t0,$t9 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	li $t0, 0 # asignar valor de 0 a t1
	#validar
	# |   |   | 3 |
	# |   | 5 |   |
	# | 7 |   |   |
	add $t0,$t7,$t5 #sumar
	add $t0,$t0,$t3 #sumar
	beq $t0, 3, ganaJugador1 # si la suma da 3 entonces gana jugador 1
	beq $t0, -3, ganaJugador2 # si la suma da 6 entonces gana jugador 2
	
	jr $ra #retornar a ciclo de turnos
	
ganaJugador1:
	la $a0 ganaPartidaJugador1 # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	b main #retorna a main

ganaJugador2:
	beq $s1, 2, ganaOrdenador
	la $a0 ganaPartidaJugador2 # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	b main #retorna a main

ganaOrdenador:
	la $a0 ganaMaquina # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	b main #retorna a main

empateJugadores:
	la $a0 empate # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	b main #retorna a main

fin:
	#imprimir adiós
	la $a0 finalizacion # load address of mensaje
	li $v0 4 # system call code for print_str
	syscall # print the string
	
	#terminar ejecución
	li $v0, 10 # terminate program run and
	syscall # return control to system
