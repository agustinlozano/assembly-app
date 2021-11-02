
                    .data
opciones: 			.asciiz "\nSeleccione una de las siguientes opciones:"
crearcat: 			.asciiz "\n\t1. Crear una lista"
agregarNodo: 		.asciiz "\n\t2. Agregar un nodo"
mostrar: 			.asciiz "\n\t3. Mostrar lista"
eliminar: 			.asciiz "\n\t4. Eliminar un nodo"
salir: 		    	.asciiz "\n\t0. para salir del menu"
respuesta:          .asciiz "\nSu respuesta: "

.text
main:	li $s1, 0				        # head <= null
	
loop:	jal ejecutarmenu				
        jal PedirUsuarioMenu			#Forzar a tomar la decision

                                        #switch
        seq $t0, $v0, 'A'
        bne $t0, $zero, C
        seq $t0, $v0, 'B'
        bne $t0, $zero, L
        seq $t0, $v0, 'C'
        bne $t0, $zero, A
        seq $t0, $v0, 'D'
        bne $t0, $zero, D
        seq $t0, $v0, 'Q'
        bne $t0, $zero, Exit
        j loop
	
	A:	
		j loop
	B:	
		j loop
	C:	
		j loop
	D:	
		j loop

ejecutarmenu:
        la $a0, opciones				# load pregunta into $a0 for printing
        li $v0, 4				# syscall code for printing string
        syscall					# print the string in $a0
        la $a0, crearcat				# load next string
        syscall					# I'm lazy; the rest is straightforward
        la $a0, agregarNodo
        syscall
        la $a0, mostrar				
        syscall
        la $a0, eliminar
        syscall
        la $a0, salir
        syscall
        jr $ra

PedirUsuarioMenu:
        li $v0, 12				# syscall code for reading a char
        syscall					# read the char (it's now in $v0)
        jr $ra					# return to caller with that value

#crearLista:
#agregarNodo:
#mostrarLista:
#eliminarNodo:

Exit:
	li $v0, 10
	syscall
