
extern printf

section .data
    str1    db  "string test",0
    lenstr  equ  $ - str1
    char1   db  "J"
    int1:    dq  16514
    int2    dq  15164848989651
    
    format  db "char is: %c , string is: %s , len is: %d, number one: %d , number two: %ld" , NL,0

    ; constants:
    sys_exit     equ     60
    NL           equ   0xA

section .bss

section .text
    global main


main:

    push    rbp
    mov     rdi,format
    mov     rsi,[char1]
    mov     rdx,str1
    mov     rcx,lenstr
    mov     r8,[int1]
    mov     r9,[int2]
    mov     rax,0
    call    printf
    pop     rbp

; better exit:
    mov     rax,sys_exit
    xor     rdi,rdi
    syscall






