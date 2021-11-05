
                .data
options: 			  .asciiz "\nSeleccione una de las siguientes opciones:"
crearCat: 			.asciiz "\n\t1. Agregar nueva categoria"
agregarNodo: 		.asciiz "\n\t2. Eliminar categoria actual"
agregarObj: 		.asciiz "\n\t3. Agregar nuevo objeto a categoria actual"
mostrarLista: 	.asciiz "\n\t4. Mostrar categorias y objetos"
prevCat: 			  .asciiz "\n\t5. Ir a la siguiente categoria"
nextCat: 			  .asciiz "\n\t6. Ir a la categoria anterior"
eliminarObj:    .asciiz "\n\t7. Eliminar objeto de la categoria actual"
quitMenu: 		  .asciiz "\n\t0. para salir del menu"
placeholder:    .asciiz "\nSu respuesta: "

opcion1:        .asciiz "\n\tElegiste opcion 1\n"
opcion2:        .asciiz "\n\tElegiste opcion 2\n"
opcion3:        .asciiz "\n\tElegiste opcion 3\n"
opcion4:        .asciiz "\n\tElegiste opcion 4\n"
opcion5:        .asciiz "\n\tElegiste opcion 5\n"
opcion6:        .asciiz "\n\tElegiste opcion 6\n"
opcion7:        .asciiz "\n\tElegiste opcion 7\n"

.text
main:	  li $s1, 0				        # head <= null
	
loop:	  
      jal printMenu
      #Forzar a tomar la decision
      jal getChoice

      #switch
      seq $t0, $v0, 1
      bne $t0, $zero, A
      seq $t0, $v0, 2
      bne $t0, $zero, B
      seq $t0, $v0, 3
      bne $t0, $zero, C
      seq $t0, $v0, 4
      bne $t0, $zero, D
      seq $t0, $v0, 5
      bne $t0, $zero, E
      seq $t0, $v0, 6
      bne $t0, $zero, F
      seq $t0, $v0, 7
      bne $t0, $zero, G
      bne $t0, $zero, exit
      j loop
	
	A:
    #jal addNode
      la    $a0, opcion1
      li    $v0, 4
      syscall

		j loop
	B:
    #jal deleteNode
      la    $a0, opcion2
      li    $v0, 4
      syscall

		j loop
	C:
    #jal addObject
      la    $a0, opcion3
      li    $v0, 4
      syscall

		j loop
	D:
    #jal printList
      la    $a0, opcion4
      li    $v0, 4
      syscall

		j loop
  E:
    #jal nextCategory
      la    $a0, opcion5
      li    $v0, 4
      syscall

		j loop
  F:
    #jal prevCategory
      la    $a0, opcion6
      li    $v0, 4
      syscall

		j loop
  G:
    #jal deleteObject
      la    $a0, opcion7
      li    $v0, 4
      syscall

		j loop


printMenu:
      la    $a0, options				  # Carga pregunta en $a0 para imprimrlo
      li    $v0, 4				        # syscall code for printing string
      syscall					            # print the string in $a0
      la    $a0, crearCat				  # load next string
      syscall					            # syscall code for printin string
      la    $a0, agregarNodo      # .
      syscall                     # .
      la    $a0, agregarObj			  # .
      syscall
      la    $a0, mostrarLista
      syscall
      la    $a0, prevCat
      syscall
      la    $a0, nextCat
      syscall
      la    $a0, eliminarObj
      syscall
      la    $a0, quitMenu
      syscall

      jr $ra
      

getChoice:
      la    $a0, placeholder
      li    $v0, 4
      syscall

      li    $v0, 5				         # syscall code for reading a int
      syscall					             # read the int (it's now in $v0)

      jr $ra					             # return to caller with that value

#addNode:
#deleteNode:
#addObject:
#printList:
#nextCategory
#prevCategory
#deleteObject

exit:
      li $v0, 10
      syscall
