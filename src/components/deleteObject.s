enterObjectID:       .asciiz "\nIngrese el ID del objeto ligado a"
foundID:             .asciiz "\nID hallado, el object es: "
emptyObjectOrlist:   .asciiz "\n\tLa lista esta vacia o bien no tiene ningun objeto ligado a ella\n\n"


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


