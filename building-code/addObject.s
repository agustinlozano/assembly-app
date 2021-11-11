objectWillBeAdded:      .asciiz "\n\tSe agregara el nuevo objeto dentro de la categoria: "
addObjectKeyword:       .asciiz "\n\tIngresar la keyword del objeto: "
addFirstObjMessage:     .asciiz "\n\tAgrega el primer objeto de la lista"
addOtherObjMessage:     .asciiz "\n\tAgrega un objeto mas a la lista"
successAddObjMessage:   .asciiz "\n\tExito: objeto agregado\n\n"

##############################################################################
##                               add object                                 ##
##############################################################################
#   headCat -> $t0; newObj -> $t3; headObj -> $t1; tailObj -> $t2; aux -> $t7
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
        li    $a0, 16
        li    $v0, 9
        syscall
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

        jal makeLinksAddObject

    # newObject -> ID = prevID + 1;
        addi    $t4, $t4, 1
        sw      $t4, 4($t3)

endAddObject:
        la    $a0, successAddObjMessage
        li    $v0, 4
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
        sw    $t7, 4($t3)
        li    $t7, 1

        la    $t0, ($t3)
        la    $t1, ($t3)
    
    #actualizar los punteros tail y head
        sw    $t1, 4($t0)
        sw    $t2, 4($t0)

    #realizar los enlaces correspondientes
        jal   makeLinksAddObject

    # headCat -> obj = headObj;
        sw    $t1, 4($t0)

        j endAddObject

makeLinksAddObject:
    # tailObj -> next = newObject;
        sw     $t3, 8($t2)
    # newObject -> prev = tailObj;
        sw     $t2, 12($t3)
    # tailObj = newObj
        sw     $t3, 12($t1)
    # newObject -> next = headObj;
        sw     $t1, 8($t3)
    # headObj -> prev = newObject;
        sw     $t3, 12($t1)
        
        j $ra