#deleteNode
theOneNode:             .asciiz "\n\tSe elemininara el unico elemento existente\n"
successDeleteMessage:   .asciiz "\n\tSe ha eliminado el nodo seleccionado\n"
emptyObjectListMessage: .asciiz "\n\tLa categoria no tiene objetos ligados que borrar"
itWillBeDeleteMessage:  .asciiz "\n\tSe borrara solo la categoria indicada"



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

    # if (current == (*head) && current == (*tail)  
        bne   $t2, $t0, normalDelete
        bne   $t2, $t1, normalDelete

        la    $a0, theOneNode
        li    $v0, 4
        syscall

    #salvar primer retorno en la pila
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

        move  $a0, $t0
        jal deleteAllObjects

        sw    $0, head
        sw    $0, tail

    #liberar nodo de categoria
        move  $a0, $t2
        jal   sfree

endDeleteObj:
        la    $a0, successDeleteMessage
        li    $v0, 4
        syscall

    #desapilar antes de retornar
        lw    $ra, 0($sp)
        addi  $sp, $sp, 4

        jr $ra

          

          #funcion para borrar todos los objetos ligados a una categoria
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



          # Caso de lista vacia
emptyObjectList:
    #imprimo los mensajes correspondiente
        la    $a0, emptyObjectListMessage
        li    $v0, 4
        syscall

        la    $a0, itWillBeDeleteMessage
        li    $v0, 4
        syscall

        jr $ra 


        #caso donde la lista tiene mas de un objeto
normalDelete:
        #deleteAllObjects(*head)
        #makeLinksDeleteCategory(head, tail)

        j endDeleteObj



        #funcion para hacer los enlaces de borrado para una categoria
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
    #llamo a la funcion liberar - QUIZAS HAYA ERROR ACA
        move  $a0, $t0
        jal   sfree
    # (*head) = aux;
        sw    $t4, head

    jr  $ra