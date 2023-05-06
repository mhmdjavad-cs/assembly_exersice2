extern printf
extern scanf

section .data
    x   dq  0.0,0.0

    n   dq  0
    c   db  "Q"
    i   dw  3245


    msgUse  db  "Enter 4 variables with format %lf %s %lf %c: ",0
    msgRead db  "the number of read variable is: ",0
    fmts    db  "%lf %s %lf %c",0
    ; the above is the format that will be used in scanf
    fmtp    db  "int=%d, str=%s, char=%c, float1=%lf, float2=%g",NL,0

    ; constants:
    sys_exit     equ     60
    sys_write    equ     1
    stdout       equ     1
    NL           equ   0xA


section .bss
    s   resb    100


section .text
    global main

main:
    push    rbp

    mov     rsi,msgUse
    call    printString

    mov     rdi,fmts
    mov     rsi,x
    mov     rdx,s
    mov     rcx,x+8
    mov     r8,c
    xor     rax,rax
    call    scanf      ; reads: %lf %s %lf %c
    
    mov     qword [n],rax
    mov     rsi, msgRead
    call    printString
    call    writeNum
    call    newLine

    mov     rdi,fmtp
    mov     rsi,0
    mov     si,word [i]
    mov     rdx,s
    mov     rcx,[c]
    movq    xmm0, qword [x]
    movq    xmm1, qword [x+8]
    mov     rax,2   ; tedad register haye xmm
    call    printf

    pop     rbp



exit:
    mov     rax,sys_exit
    xor     rdi,rdi
    syscall

























; functions that we used:
;-------------------------------------------
printString:
   push    rax
   push    rcx
   push    rsi
   push    rdx
   push    rdi

   mov     rdi, rsi
   call    GetStrlen
   mov     rax, sys_write  
   mov     rdi, stdout
   syscall 
   
   pop     rdi
   pop     rdx
   pop     rsi
   pop     rcx
   pop     rax
   ret
;-------------------------------------------
; rdi : zero terminated string start 
GetStrlen:
   push    rbx
   push    rcx
   push    rax  

   xor     rcx, rcx
   not     rcx
   xor     rax, rax
   cld
         repne   scasb
   not     rcx
   lea     rdx, [rcx -1]  ; length in rdx

   pop     rax
   pop     rcx
   pop     rbx
   ret

;----------------------------------------------------
newLine:
   push   rax
   mov    rax, NL
   call   putc
   pop    rax
   ret
;---------------------------------------------------------
putc:	

   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

   push   ax
   mov    rsi, rsp    ; points to our char
   mov    rdx, 1      ; how many characters to print
   mov    rax, sys_write
   mov    rdi, stdout 
   syscall
   pop    ax

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx
   ret
;---------------------------------------------------------
writeNum:
   push   rax
   push   rbx
   push   rcx
   push   rdx

   sub    rdx, rdx
   mov    rbx, 10 
   sub    rcx, rcx
   cmp    rax, 0
   jge    wAgain
   push   rax 
   mov    al, '-'
   call   putc
   pop    rax
   neg    rax  

wAgain:
   cmp    rax, 9	
   jle    cEnd
   div    rbx
   push   rdx
   inc    rcx
   sub    rdx, rdx
   jmp    wAgain

cEnd:
   add    al, 0x30
   call   putc
   dec    rcx
   jl     wEnd
   pop    rax
   jmp    cEnd
wEnd:
   pop    rdx
   pop    rcx
   pop    rbx
   pop    rax
   ret