
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

opcion1:        .asciiz "\n- Agregar una nueva catogoria\n"
opcion2:        .asciiz "\nElegiste opcion 2\n"
opcion3:        .asciiz "\nElegiste opcion 3\n"
opcion4:        .asciiz "\n- Mostrar categorias\n"
opcion5:        .asciiz "\n- Ir a la siguiente categoria\n"
opcion6:        .asciiz "\n- Ir a la categoria anterior\n"
opcion7:        .asciiz "\nElegiste opcion 7\n"

#addNode
head:           .word   0
tail:           .word   0
getCategory: 		.asciiz "\n\tIngrese el nombre de la categoria: "
successMessage: .asciiz "\n\tExito! categoria ingresada\n"
endMessage:     .asciiz "\n\nFin del programa\n"
buffer:         .space  16

firstNodeMessage:      .asciiz "\tAgrega la primer categoria\n"
newNodeMessage:        .asciiz "\tAgrega una nueva categoria\n"

#printList
noObjects:      .asciiz "\n\tno tiene objetos ligados\n"
emptyList:      .asciiz "La lista esta vacia\n"
asterisk:       .asciiz "\n\t*"
colon:          .asciiz ": "
comma:          .asciiz ", "
id:             .asciiz "ID: "

#nextCategory
currentCatMessage: .asciiz "\nLa categoria actual es: "

#general
newLine:        .asciiz "\n"
tab:            .asciiz "\t"

#profe
slist: .word 0

.text
main:

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
      la    $a0, opcion1
      li    $v0, 4
      syscall

    #hacer la invocacion de la funcion addNode
      la  $a0, head
      la  $a1, tail
      jal addNode

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
      la    $a0, opcion4
      li    $v0, 4
      syscall

    #hacer la invocacion de la funcion addNode
      la  $a0, head
      jal printList

		  j loop
  E:
      la    $a0, opcion5
      li    $v0, 4
      syscall

    #hacer la invocacion de la funcion addNode
      la  $a0, head
      la  $a1, tail
      jal nextCategory

		  j loop
  F:
    #jal prevCategory
      la    $a0, opcion6
      li    $v0, 4
      syscall

    #hacer la invocacion de la funcion addNode
      la  $a0, head
      la  $a1, tail
      jal prevCategory

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

##############################################################################g
##                               add node                                   ##
##############################################################################

addNode:
    #recupero head desde $a0
        lw    $t0, ($a0)
        lw    $t1, ($a1)

    #salvar retorno en la pila: apilar $ra
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

    #reservo memoria dinamica
        jal   smalloc
        move  $t3, $v0            #almacena la dir. newNode
    
    #pedir la categoria del nuevo nodo en $t3 y hacer una reserva
        la   $a0, getCategory     #preguntamos el nombre de la cat
        li   $v0, 4               #syscall code for printing string
        syscall

        li   $a0, 16
        li   $v0, 9
        syscall
        sw   $v0, buffer

    #leemos el string ingresado
    #lee hasta encotrar el '\0' o llenar el buffer
        li   $v0, 8
        la   $a0, buffer          #a0 ahora contiene el buffer
        li   $a1, 16              #a1 ahora contiene el length
        syscall

    #almacena la categoria en el primer campo
        lw    $t4, buffer
        sw    $t4, 0($t3)         #Feedback lucas

    # #salvar retorno en la pila: apilar $ra
    #     addi  $sp, $sp, -4
    #     sw    $ra, 0($sp)

    #if head es null agregamos el primer nodo
        bne   $t0, $0, addNewNode

    #imprimir mensaje
        la    $a0, firstNodeMessage
        li    $v0, 4
        syscall

addFirstNode: 
        la    $t0, ($t3)            #head ahora contiene la direccion de newnode
        la    $t1, ($t3)            #tail ahora contiene la direccion de newnode
    
    #actualizar los punteros tail y head
        sw    $t0, head
        sw    $t1, tail

    #llamar a la funcion para hcer enlaces
        la    $a0, ($t0)            #paso el head como parametro
        la    $a1, ($t1)            #paso el tail como parametro
        la    $a2, ($t3)            #paso el newNode como parametro

        jal   makelinksAddCategory

    #imprimir mensaje de exito
        la    $a0, successMessage
        li    $v0, 4
        syscall

    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4
    #return caller
        jr    $ra

    #sino agregamos uno mas
addNewNode:
        la    $a0, newNodeMessage
        li    $v0, 4
        syscall

        la    $a0, ($t0)            #paso el head como parametro
        la    $a1, ($t1)            #paso el tail como parametro
        la    $a2, ($t3)            #paso el newNode como parametro
        jal   makelinksAddCategory


    #realiza los enlaces para aniadir un nodo a una CDLL
    #como esta funcion es leaf, no hace falta apilar $ra
makelinksAddCategory:
        sw    $a2, 8($a1)
        sw    $a1, 12($a2)
        sw    $a2, tail
        sw    $a0, 8($a2)
        sw    $a2, 12($a0)

    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr    $ra

#deleteNode:
#addObject:

##############################################################################
##                              print list                                  ##
##############################################################################

printList:
    #recupero head desde la variable head
        lw    $t0, ($a0)

    #inicializo el registro que recorre la lista: $t1
        la    $t1, ($t0)

    #if head es null la lista esta vacia
        beq    $t1, $0, catIsEmpty

    #patron con doWhile
doWhileCat:
        beq    $t1, $t0, currentCat
       
    #una vez que imprimo currentCat sigo con el resto
        la     $a0, newLine
        li     $v0, 4
        syscall

        la     $a0, tab
        li     $v0, 4
        syscall

        la     $a0, 0($t1)      #cargamos el nombre de la categoria
        li     $v0, 4           #syscall code for printing string
        syscall

continuePrinting:
    #bloque de codigo para imprimir objetos ligados a la cat
          lw     $t2, 4($t1)      #headObj = current->obj;
          move   $t3, $t2         #currentObject = headObj;
    
      #if currentObj es null entonces no tiene objetos ligados
          beq    $t3, $0, objIsEmpty
          and    $t7, $t7, $0     #contador iniciado a cero

      #sgundo patron con doWhile
doWhileObj:
          #imprimir "\n"
            la     $a0, newLine
            li     $v0, 4
            syscall

          #imprimir count
            move   $a0, $t7
            li     $v0, 1
            syscall

          #imprimir colon
            la     $a0, colon
            li     $v0, 4
            syscall

          #imprimir object->content
            la     $a0, 0($t3)
            li     $v0, 4
            syscall

          #imprimir comma
            la     $a0, comma
            li     $v0, 4
            syscall

          #imprimir "\t"
            la     $a0, tab
            li     $v0, 4
            syscall

          #imprimir id
            la     $a0, id
            li     $v0, 4
            syscall

          #imprimir object->ID
            la     $a0, 4($t3)
            li     $v0, 1
            syscall

nextObject:
      #currentObject = currentObject -> next;
        lw     $t3, 8($t3)

      #imprimir "\n"
        la     $a0, newLine
        li     $v0, 4
        syscall
    #fin bloque de codigo para imprimir objetos

nextCatToPrint:
        lw     $t1, 8($t1)      #current = current -> next;

    #condicion de salida
        bne    $t1, $t0, doWhileCat
    
    #salir de la funcion
        j $ra


currentCat:
        la     $a0, asterisk    #cargamos el asterisco para indicar la actual
        li     $v0, 4           #syscall code for printing string
        syscall

        la     $a0, 0($t1)      #cargamos el nombre de la categoria
        li     $v0, 4           #syscall code for printing string
        syscall

        j continuePrinting

catIsEmpty:
    #mostrar mensaje al user
        la     $a0, emptyList
        li     $v0, 4
        syscall
    
        j $ra

objIsEmpty:
        la     $a0, noObjects
        li     $v0, 4
        syscall
    
        j nextCatToPrint



##############################################################################
##                             next category                                ##
##############################################################################

nextCategory:
    #recupero head desde $a0
        lw    $t0, ($a0)
        lw    $t1, ($a1)
    
    # if (*head == NULL)
        bne   $t0, $0, makeLinksNextCategory

        j catIsEmpty

makeLinksNextCategory:
    # $t2 = (*head) -> next;
        lw    $t2, 8($t0)
    # (*tail) = (*tail) -> next;
        lw    $t3, 8($t1)   
        sw    $t3, tail
    # (*head) = $t2;
        sw    $t2, head
    
    # imprimir current category
        j printCurrentCat



prevCategory:
    #recupero head desde $a0
        lw    $t0, ($a0)
        lw    $t1, ($a1)
    
    # if (*head == NULL)
        bne   $t0, $0, makeLinksPrevCategory

        j catIsEmpty

makeLinksPrevCategory:
    # $t2 = (*head) -> prev;
        lw    $t2, 12($t0)
    # (*tail) = (*tail) -> prev;
        lw    $t3, 12($t1)   
        sw    $t3, tail
    # (*head) = $t2;
        sw    $t2, head

    # imprimir current category
        j printCurrentCat



printCurrentCat:
        la    $a0, currentCatMessage
        li    $v0, 4
        syscall

        la    $a0, 0($t2)
        li    $v0, 4
        syscall

        la    $a0, newLine
        li    $v0, 4
        syscall

        la    $a0, newLine
        li    $v0, 4
        syscall

        jr $ra



#deleteObject

#codigo profe
smalloc: 
        lw      $t7, slist
        beqz    $t7, sbrk
        move    $v0, $t7
        lw      $t7, 12($t7)
        sw      $t7, slist
        jr      $ra
sbrk:
        li      $a0, 16
        li      $v0, 9
        syscall
        j $ra
sfree: 
        la      $t7, slist
        sw      $t7, 12($a0)
        sw      $a0, slist
        jr      $ra


exit:
      li $v0, 10
      syscall
