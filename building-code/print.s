              .data
noObjects:    .asciiz "no tiene objetos ligados"
emptyList:    .asciiz "La lista esta vacia"
asterisk:     .asciiz "\n\t*"
colon:        .asciiz ": "
comma:        .asciiz ", "
id:           .asciiz "ID: "
newLine:      .asciiz "\n"
tab:          .asciiz "\t"


#blucle que imoprime esta roto

              .text
main:
    #head <= null
        li    $s1, 0

    #invocar funcion
        move  $a0, $s1
        jal   printList

    #terminar programa
        li    $v0, 10
        syscall

printList:
    #recupero head desde $a0
        lw    $t0, head             #feedback lucas

    #inicializo el registro que recorre la lista: $t1
        lw    $t1, ($t0)            #feedback lucas

    #if head es null la lista esta vacia
        beq    $t0, $0, catIsEmpty

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
    
    #bloque de codigo para imprimir objetos ligados a la cat
          lw     $t2, 4($t1)      #headObj = current->obj;
          move   $t3, $t2         #currentObject = headObj;
    
      #if currentObj es null entonces no tiene objetos ligados
          beq    $t0, $0, objIsEmpty
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

nextCategory:
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

        j doWhileCat

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
    
        j nextCategory