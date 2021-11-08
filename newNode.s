                .data
head:           .word   0         
getCategory: 		.asciiz "\n\tIngrese el nombre de la categoria: "
successMessage: .asciiz "\n\tExito! categoria ingresada"
endMessage:     .asciiz "\n\nFin del programa\n"
buffer:         .space 16

firstNodeMessage:      .asciiz "Agrega la primer categoria\n"
newNodeMessage:        .asciiz "Agrega una nueva categoria\n"

        .text
main: 
        lw    $s1, head  		        #head <= null

    #hacer la invocacion de la funcion addNode
        la    $a0, ($s1)
        jal   newNode

        j endApp

newNode:
    #recupero head desde $a0
        la    $t0, ($a0)

    #reservo memoria dinamica
        li    $v0, 9              #sbrk
        li    $a0, 16             #16bytes
        syscall
        move  $t3, $v0            #almacena la dir. newNode
    
    #pedir la categoria del nuevo nodo en $t3
        la   $a0, getCategory     #preguntamos el nombre de la cat
        li   $v0, 4               #syscall code for printing string
        syscall

    #leemos el string ingresado
    #lee hasta encotrar el '\0' o llenar el buffer
        li   $v0, 8
        la   $a0, buffer          #a0 ahora contiene la dir. del buffer
        li   $a1, 16              #a1 ahora contiene el length
        syscall

    #almacena la categoria en el primer campo
        la    $s0, buffer
        sw    $s0, 0($t3)      #Feedback lucas

    #salvar retorno en la pila: apilar $ra
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)

    #if head es null agregamos el primer nodo
        bne   $t0, $0, addNewNode

        la    $a0, firstNodeMessage
        li    $v0, 4
        syscall

addFirstNode: 
        la  $t0, ($t3)            #head ahora contiene la direccion de newnode
        la  $t2, ($t3)            #tail ahora contiene la direccion de newnode

        la  $a0, ($t0)            #paso el head como parametro
        la  $a1, ($t2)            #paso el tail como parametro
        la  $a2, ($t3)            #paso el newNode como parametroro
        sw  $a2, head             #Feedback lucas
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

        move  $a0, $t0            #paso el head como parametro
        move  $a1, $t2            #paso el tail como parametro
        move  $a2, $t3            #paso el newNode como parametro
        jal   makelinksAddCategory


    #realiza los enlaces para aniadir un nodo a una CDLL
    #como esta funcion es leaf, no hace falta apilar $ra
makelinksAddCategory:
        sw    $a2, 8($a1)
        sw    $a1, 12($a2)
        move  $a1, $a2
        sw    $a0, 8($a2)
        sw    $a2, 12($a0)

        jr    $ra


endApp: 
        la    $a0, endMessage      #preguntamos el nombre de la cat
        li    $v0, 4               #syscall code for printing string
        syscall
        li    $v0, 10              #fin programa
        syscall