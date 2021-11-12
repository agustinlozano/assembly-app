# Circular doubly linked list
A circular doubly linked list, also known as a circular two-way linked list, is a more advanced form of a linked list that includes a pointer to both the next and previous node in the sequence. The distinction between a doubly linked and a circular doubly linked list is the same as the distinction between a single linked and a circular linked list. The previous field of the first node and the next field of the last node in the circular doubly linked list do not contain NULL. Rather, the address of the first node in the list, i.e., START, is stored in the next field of the final node. Similarly, the address of the last node is stored in the previous field of the first field. A circular doubly linked list contains both the successor and predecessor pointers arranged in a circular pattern. The major benefit of utilizing a circular doubly linked list is that it doubles the efficiency of search operations. The disadvantage of this linked list is that it requires additional memory to hold previous and next node references.

# La aplicación
El proyecto se trata sobre desarrollar un programa que trabaje con estructuras de datos abstractas, la aplicación debe ser capaz de gestionar y relacionar información ligada a listas circulares doblemente enlazadas, para crear una estructura de dato única y de mayor complejidad. Para ello, el software tiene que estar dotado por una biblioteca que le permita realizar múltiples operaciones y enlaces entre los distintos nodos existentes en cada momento de su ejecución, así como utilizar la memoria dinámica del sistema. 

![](https://github.com/agustinlozano/circular-doubly-linked-list/blob/master/src/img/Captura%20de%20pantalla%20de%202021-11-02%2014-50-40.png)

Dada la complejidad del proyecto y la dificultad de codificación de bajo nivel que por naturaleza tiene el assembly, el programa fue previamente escrito y optimizado en lenguaje C.

Asignatura: Arquitectura de las Computadoras
