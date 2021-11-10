#deleteNode
theOneNode:             .asciiz "\n\tSe elemininara el unico elemento existente\n\n"
successDeleteMessage:   .asciiz "\nSe ha eliminado el nodo seleccionado\n"
emptyObjectListMessage: .asciiz "\nLa categoria no tiene objetos ligados que borrar"
itWillBeDeleteMessage:  .asciiz "\nSe borrara solo la categoria indicada\n\n"


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
        beq   $t2, $0, emptyList

    # if (current == (*head) && current == (*tail)  
        bne   $t2, $t0, normalDelete
        bne   $t2, $t1, normalDelete

        la    $a0, theOneNode
        li    $v0, 4
        syscall

    #salvar retorno en la pila: apilar $ra
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

        jal deleteAllObjects

        sw    $0, head
        sw    $0, tail

        #free($t2) -> como son llamado a fucines
        #             voy a tener que gestionar $ra

endDeleteObj:
        la    $a0, successDeleteMessage
        li    $v0, 4
        syscall

    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr $ra





normalDelete:
        #deleteAllObjects(*head)
        #makeLinksDeleteCategory(head, tail)

        j endDeleteObj





deleteAllObjects:
    # Obj *current  = NULL
        move  $t3, $0

        beq   $t0, $0, emptyObjectList
    
    # current = head -> obj;
        lw    $t4, 4($t0)
        move  $t3, $t4
doWhileDeletingObj:
        lw    $t3, 8($t3)
        #free($t2) -> como son llamado a fucines
        #             voy a tener que gestionar $ra
        bne   $t3, $t4, doWhileDeleteObj

        move  $t4, $0
        sw    $t4, 4($t0)

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
