.data
currentCatMessage: .asciiz "\nLa categoria actual es: "

#codigo repetido
emptyList:      .asciiz "La lista esta vacia\n"
newLine:        .asciiz "\n"
tab:            .asciiz "\t"


.text
main:

nextCategory:
    #recupero head desde $a0
        lw    $t0, ($a0)
        lw    $t1, ($a1)

        beq   $t0, $0, catIsEmpty

    # $t2 = (*head) -> prev;
        lw    $t2, 12($t0)
    # (*tail) = (*tail) -> prev;
        lw    $t3, 12($t1)   
        sw    $t3, tail
    # (*head) = $t2;
        sw    $t2, head
        
    #imprimir mensaje
        la    $a0, emptyList
        li    $v0, 4
        syscall
    
    j $ra
    

