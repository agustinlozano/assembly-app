
                  .data
options:          .asciiz "\nSeleccione una de las siguientes opciones:"
crearCat:         .asciiz "\n\t1. Agregar nueva categoria"
agregarNodo:      .asciiz "\n\t2. Eliminar categoria actual"
agregarObj:       .asciiz "\n\t3. Agregar nuevo objeto a categoria actual"
mostrarLista: 	  .asciiz "\n\t4. Mostrar categorias y objetos"
prevCat:          .asciiz "\n\t5. Ir a la siguiente categoria"
nextCat:          .asciiz "\n\t6. Ir a la categoria anterior"
deleteObj:        .asciiz "\n\t7. Borrar objeto de la categoria actual"
quitMenu:         .asciiz "\n\t0. Para salir del menu"
placeholder:      .asciiz "\nSu respuesta: "

opcion1:          .asciiz "\n- Agregar una nueva catogoria\n"
opcion2:          .asciiz "\n- Eliminar categoria actual\n"
opcion3:          .asciiz "\n- Agregar nuevo objeto a categoria actual\n"
opcion4:          .asciiz "\n- Mostrar categorias\n"
opcion5:          .asciiz "\n- Ir a la siguiente categoria\n"
opcion6:          .asciiz "\n- Ir a la categoria anterior\n"
opcion7:          .asciiz "\n- Borrar el objeto de la categoria actual\n"

#addNode
head:             .word   0
tail:             .word   0
getCategory:      .asciiz "\n\tIngrese el nombre de la categoria: "
successMessage:   .asciiz "\n\tExito! categoria ingresada\n"
endMessage:       .asciiz "\n\nFin del programa\n"
buffer:           .space  16

firstNodeMessage: .asciiz "\tAgrega la primer categoria\n"
newNodeMessage:   .asciiz "\tAgrega una nueva categoria\n"

#printList
noObjects:        .asciiz "\n\tno tiene objetos ligados\n"
emptyList:        .asciiz "La lista esta vacia\n"
asterisk:         .asciiz "\n\t*"
colon:            .asciiz ": "
comma:            .asciiz ", "
id:               .asciiz "ID: "

#nextCategory
currentCatMessage:      .asciiz "\nLa categoria actual es: "

#deleteNode
theOneNode:             .asciiz "\n\tSe elemininara el unico elemento existente\n"
successDeleteMessage:   .asciiz "\n\tSe ha eliminado el nodo seleccionado\n"
emptyObjectListMessage: .asciiz "\n\tLa categoria no tiene objetos ligados que borrar"
itWillBeDeleteMessage:  .asciiz "\n\tSe borrara solo la categoria indicada"

#addObject
objectWillBeAdded:      .asciiz "\n\tSe agregara el nuevo objeto dentro de la categoria: "
addObjectKeyword:       .asciiz "\n\tIngresar la keyword del objeto: "
addFirstObjMessage:     .asciiz "\n\tAgrega el primer objeto de la lista"
addOtherObjMessage:     .asciiz "\n\tAgrega un objeto mas a la lista"
successAddObjMessage:   .asciiz "\n\tExito: objeto agregado\n\n"

#deleteObject
enterObjectID:       .asciiz "\nIngrese el ID del objeto ligado a "
foundID:             .asciiz "\nID hallado, el object es: "
emptyObjectOrlist:   .asciiz "\n\tLa lista esta vacia o bien no tiene ningun objeto ligado a ella\n\n"


#general
newLine: .asciiz "\n"
tab:     .asciiz "\t"

#profe
slist:   .word 0

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
      la    $a0, opcion2
      li    $v0, 4
      syscall
    
    #hacer la invocacion de la funcon deleteNode
      la  $a0, head
      la  $a1, tail
      jal deleteNode

      j loop
C:
      la    $a0, opcion3
      li    $v0, 4
      syscall
    
    #hacer la invocacion de la funcon addObject
      la  $a0, head
      jal addObject

      j loop
D:
      la    $a0, opcion4
      li    $v0, 4
      syscall

    #hacer la invocacion de la funcion printList
      la  $a0, head
      jal printList

      j loop
E:
      la    $a0, opcion5
      li    $v0, 4
      syscall

    #hacer la invocacion de la funcion nextCategory
      la  $a0, head
      la  $a1, tail
      jal nextCategory

      j loop
F:
      la    $a0, opcion6
      li    $v0, 4
      syscall

G:    la    $a0, opcion7
      li    $v0, 4
      syscall

    #hacer la invocacion de la funcion prevCategory
      la  $a0, head
      jal deleteObject

      j loop


printMenu:
      la    $a0, options
      li    $v0, 4
      syscall
      la    $a0, crearCat
      syscall
      la    $a0, agregarNodo
      syscall
      la    $a0, agregarObj
      syscall
      la    $a0, mostrarLista
      syscall
      la    $a0, prevCat
      syscall
      la    $a0, nextCat
      syscall
      la    $a0, deleteObj
      syscall
      la    $a0, quitMenu
      syscall

      jr $ra
      

getChoice:
      la    $a0, placeholder
      li    $v0, 4
      syscall

      li    $v0, 5                 # syscall code for reading a int
      syscall                      # read the int (it's now in $v0)

      jr $ra                       # return to caller with that value



##############################################################################
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

        jal  smalloc
        sw   $v0, buffer

    #leemos el string ingresado
    #lee hasta encotrar el '\0' o llenar el buffer
        li   $v0, 8
        la   $a0, buffer          #a0 ahora contiene el buffer
        li   $a1, 16              #a1 ahora contiene el length
        syscall

    #almacena la categoria en el primer campo
        lw    $t4, buffer
        sw    $t4, 0($t3)

    #seteamos a null el objeto ligado a la categoria
        sw    $0,  4($t3)

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



##############################################################################
##                             delete node                                  ##
##############################################################################

deleteNode:
    #recupero head y el tail
        lw    $t0, ($a0)
        lw    $t1, ($a1)

    #inicializo el registro que recorre la lista: $t2
        la    $t2, ($t0)

    #corroboro que la lista no este vacia
        beq   $t2, $0, catIsEmpty

    #salvar primer retorno en la pila
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

    # if (current == (*head) && current == (*tail)  
        bne   $t2, $t0, normalDelete
        bne   $t2, $t1, normalDelete

        la    $a0, theOneNode
        li    $v0, 4
        syscall

        move  $a0, $t0
        jal deleteAllObjects

        sw    $0, head
        sw    $0, tail

    #liberar nodo de categoria
        move  $a0, $t2
        jal   sfree

endDeleteObjects:
        la    $a0, successDeleteMessage
        li    $v0, 4
        syscall

    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr $ra


normalDelete:
        jal deleteAllObjects
        jal makeLinksDeleteCategory

        j endDeleteObjects


deleteAllObjects:
    # Obj *current  = NULL
        move  $t3, $0

    # current = head -> obj;
        lw    $t4, 4($t0)
        move  $t3, $t4
    
        beq   $t3, $0, emptyObjectList

doWhileDeletingObj:
        lw    $t3, 8($t3)
    
    #salvar segundo retorno en la pila
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

    #liberar la memoria
        move  $a0, $t3
        jal   sfree

        bne   $t3, $t4, doWhileDeleteObj

        move  $t4, $0
        sw    $t4, 4($t0)

    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr $ra 

emptyObjectList:
    #imprimo los mensajes correspondiente
        la    $a0, emptyObjectListMessage
        li    $v0, 4
        syscall

        la    $a0, itWillBeDeleteMessage
        li    $v0, 4
        syscall

        jr $ra 

makeLinksDeleteCategory:
    # (*tail) = (*head) -> prev;
        lw    $t3, 12($t0)
        move  $t1, $t3
        sw    $t1, tail
    # aux = (*tail);
        move  $t4, $t1
    # aux -> next = (*head) -> next;
        lw    $t5, 8($t0)
        sw    $t5, 8($t4)
    # aux = (*head) -> next;
        move  $t4, $t5
    # aux -> prev = (*head) -> prev
        lw    $t5, 12($t0)
        sw    $t5, 12($t4)
    #llamo a la funcion liberar
      #salvar segundo retorno en la pila
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)
    
        move  $a0, $t0
        jal   sfree
    # (*head) = aux;
        sw    $t4, head

    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr  $ra



##############################################################################
##                               add object                                 ##
##############################################################################
#   headCat -> $t0; newObj -> $t3; headObj -> $t1; tailObj -> $t2; aux -> $t7git
addObject:
    #recupero headCat desde $a0
        lw    $t0, ($a0)

    #salvar retorno en la pila: apilar $ra
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

    #reservo el bloque para el objeto
        jal   smalloc
        move  $t3, $v0

    # Obj *headObj = headCat -> obj;
        lw    $t7, 4($t0)
        move  $t1, $t7
    
    # tailObj = NULL
        move  $t2, $0

    #imprimir mensaje y categoria donde se almacenara
        la    $a0, objectWillBeAdded
        li    $v0, 4
        syscall

        la    $a0, 0($t0)
        li    $v0, 4
        syscall

        la    $a0, newLine
        li    $v0, 4
        syscall

    #imprimir segundo mensaje
        la    $a0, addObjectKeyword
        li    $v0, 4
        syscall

    #leer el string con el nombre del objeto
        jal   smalloc
        sw    $v0, buffer

        li    $v0, 8
        la    $a0, buffer          #a0 ahora contiene el buffer
        li    $a1, 16              #a1 ahora contiene el length
        syscall

    #almacena al nombre del objeto en el primer campo
        lw    $t7, buffer
        sw    $t7, 0($t3)

    #seteamos a null el ID ligado a al objeto
        sw    $0,  4($t3)

    #bloque de if - else
        beq   $t1, $0, objListIsEmpty

objListIsNotEmpty:
        la    $a0, addOtherObjMessage
        li    $v0, 4
        syscall

    # tailObj = headObj -> prev;
        lw    $t7, 12($t1)
        move  $t2, $t7
    
    #get ID
        lw     $t4, 4($t2)

        jal    makeLinksAddObject

    # newObject -> ID = prevID + 1;
        addi   $t4, $t4, 1
        sw     $t4, 4($t3)

endAddObject:
        la     $a0, successAddObjMessage
        li     $v0, 4
        syscall

    #desapilar y retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr $ra


objListIsEmpty:
        la    $a0, addFirstObjMessage
        li    $v0, 4
        syscall

    # newObject -> ID = 1;
        li    $t7, 1
        sw    $t7, 4($t3)

        la    $t1, ($t3)
        la    $t2, ($t3)
    
    #actualizar los punteros tailObj y headObj
        sw    $t1, 4($t0)
        sw    $t2, 4($t0)

    #realizar los enlaces correspondientes
        jal   makeLinksAddObject

        j endAddObject

makeLinksAddObject:
    # tailObj -> next = newObject;
        sw     $t3, 8($t2)
    # newObject -> prev = tailObj;
        sw     $t2, 12($t3)
    # newObject -> next = headObj;
        sw     $t1, 8($t3)
    # headObj -> prev = newObject;
        sw     $t3, 12($t1)
        
        j $ra



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
            lw     $a0, 4($t3)
            li     $v0, 1
            syscall

nextObject:
      #currentObject = currentObject -> next;
        lw     $t3, 8($t3)
      
        addi   $t7, $t7, 1

        bne    $t3, $t2, doWhileObj
    #fin bloque de codigo para imprimir objetos

      #imprimir "\n"
        la     $a0, newLine
        li     $v0, 4
        syscall

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
##                   next category & prev category                          ##
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



##############################################################################
##                               delete object                              ##
##############################################################################
# headCat -> $t0; headObj -> $t1; tailObj -> $t2; currentObj -> $t3; ID -> $t4; aux -> $t7
deleteObject:
        lw    $t0, ($a0)
        lw    $t7, 4($t0)

    #salvar retorno en la pila: apilar $ra
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

    # if (head != NULL && head -> obj != NULL)
        beq   $t0, $0, emptyListOrAnyObject
        beq   $t7, $0, emptyListOrAnyObject

    # Node *headObj = head -> obj;
        lw    $t1, 4($t0)
    # Obj *tailObj = headObj -> prev;
        lw    $t2, 12($t1)
    # Obj *currentObj = head -> obj;
        move  $t3, $t1

    # leer el ID del objeto
      #cosas que imprimir
        la    $a0, enterObjectID
        li    $v0, 4
        syscall

        la    $a0, 0($t0)
        li    $v0, 4
        syscall

        la    $a0, colon
        li    $v0, 4
        syscall

      #lectura de ID
        li    $v0, 5
        syscall

        move  $t4, $v0

doWhileLookingID:
        lw    $t7, 4($t3)
      # if ((currentObj -> ID) == ID)
        bne   $t7, $t4, continueLooking
        
        la    $a0, foundID
        li    $v0, 4
        syscall

        la    $a0, 0($t3)
        li    $v0, 4
        syscall

        la    $a0, tab
        li    $v0, 4
        syscall

        la    $a0, id
        li    $v0, 4
        syscall

        lw    $a0, 4($t3)
        li    $v0, 1
        syscall

        la    $a0, newLine
        li    $v0, 4
        syscall

        la    $a0, newLine
        li    $v0, 4
        syscall

      #  if (currentObj == head -> obj)
        bne    $t3, $t1, normalDeleteObj
deleteHeadObject:
    #elimino el nodo y pero tambien tengo que apuntarlo desde la categoria
        move   $a0, $t3
        jal    makeLinksDeleteObject
        sw     $v0, 4($t0)

        move   $a0, $t1
        move   $a1, $t3
        jal    updateID
        
        move  $a0, $t3
        jal   sfree

        j endDeleteObj

normalDeleteObj:
        move   $a0, $t3
        jal    makeLinksDeleteObject


        move   $a0, $t1
        move   $a1, $t3
        jal    updateID

        move   $a0, $t3
        jal    sfree

        j endDeleteObj

continueLooking:
        lw    $t3, 8($t3)
    
    #condicion de salida para do while
        lw    $t7, 4($t3)
        lw    $t6, 4($t2)
        bne   $t7, $t6, doWhileLookingID
    #fin do while

emptyListOrAnyObject:
        la    $a0, emptyObjectOrlist
        li    $v0, 4
        syscall

        j     endDeleteObj

endDeleteObj:
    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr    $ra



makeLinksDeleteObject:
        lw    $t7, 12($a0)
        lw    $t6, 8($a0)
        sw    $t6, 8($t7)

        lw    $t7, 8($a0)
        lw    $t6, 12($a0)
        sw    $t6, 12($t7)

        move  $v0, $t7
        jr    $ra



updateID:
        lw    $t7, 4($a1)
        addi  $t7, -1
        sw    $t7, 4($a1)

        lw    $a1, 8($a1)

        bne   $a1, $a0, updateID

        jr    $ra




#codigo profe
smalloc: 
        lw      $t7, slist
        beqz    $t7, sbrk
        move    $v0, $t7
        lw      $t7, 8($t7)
        sw      $t7, slist
        jr      $ra
sbrk:
        li      $a0, 16
        li      $v0, 9
        syscall
        j $ra
sfree: 
        la      $t7, slist
        sw      $t7, 8($a0)
        sw      $a0, slist
        jr      $ra


exit:
      li $v0, 10
      syscall
