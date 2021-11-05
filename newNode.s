                .data
title:          .asciiz "Agregar una nueva catogoria"                
getCategory: 		.asciiz "\n\tIngrese el nombre de la categoria: "
successMessage: .asciiz "\n\tExito! categoria ingresada"
endMessage:     .asciiz "\n\nFin del programa\n"
buffer:         .space 16


        .text
main: 
        li $s1, 0				          #head <= null

    #mostrar titulo del programa
        la    $a0, title
        li    $v0, 4
        syscall

    #hacer la invocacion de la funcion addNode
        jal   newNode

        j endApp

newNode: 
    #reservo memoria dinamica
        li    $v0, 9              #sbrk
        li    $a0, 16             #16bytes
        syscall
        move  $s3, $v0            #almacena la dir. newNode
    
    #pedir la categoria del nuevo nodo en $s3
        la   $a0, getCategory     #preguntamos el nombre de la cat
        li   $v0, 4               #syscall code for printing string
        syscall

    #leemos el string ingresado
    #lee hasta encotrar el '\0' o llenar el buffer
        li   $v0, 8
        la   $a0, buffer          #a0 ahora contiene la dir. del buffer
        li   $a1, 16              #a1 ahora contiene el length
        syscall

    #le mostramos al user lo que ingreso
    #    la    $a0, buffer         #reload byte space to primary address
    #    li    $v0, 4              #print string
    #    syscall
        sw    $v0, 0($s3)         #almacena la categoria en el primer campo

    #salvar retorno en la pila: apilar $ra
        addi  $sp, $sp, -4
        sw    $ra, 0($sp)
    
    #if head es null agregamos el primer nodo
        bne   $s1, $0, addNewNode
addFirstNode: 
        move  $s1, $s3            #head ahora contiene la direccion de newnode
        move  $s2, $s3            #tail ahora contiene la direccion de newnode

        move  $a0, $s1            #paso el head como parametro
        move  $a1, $s2            #paso el tail como parametro
        move  $a2, $s3            #paso el newNode como parametro
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