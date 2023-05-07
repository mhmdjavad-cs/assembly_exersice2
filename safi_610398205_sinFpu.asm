extern scanf
extern printf

section .data
   number  dq 0
   i       dq 0
   sum     dq 0.0
   theta   dq 22.07
   trash   dq 0.0
   current  dq 0
   k        dq 0.0

   ; for using scanf
   fmts    db  "%lf",0


   ; for using printf
   fmtp    db  "%lf",NL,0

   ; constants:
   sys_exit     equ     60
   sys_read     equ     0
   sys_write    equ     1
   stdout       equ     1
   stdin        equ     0
   NL           equ   0xA


section .bss
    ;theta resq 1

section .text
   global main

main:

    call    readNum
    mov     [number],rax
    
    



    push    rbp
    mov     rdi,fmts
    mov     rsi,theta
    mov     rax,0
    call    scanf      ; reads: %lf
    pop     rbp
    



    ;for loop
    mov     rax,1
    mov     [i],rax
    for1:
        ;loop compare:
        mov     rax,[i]
        mov     rbx,[number]
        inc     rbx
        cmp     rax,rbx
        je      endfor1
        ;=========================for loop body

        fild     qword [i]
        fst      qword [k]

        ;fst     qword [current]
        ;push    rbp
        ;mov     rdi,fmtp
        ;movq    xmm0, qword [current]
        ;mov     rax,1   ; tedad register haye xmm
        ;call    printf
        ;pop     rbp



        fmul    qword [theta]


        ;fst     qword [current]
        ;push    rbp
        ;mov     rdi,fmtp
        ;movq    xmm0, qword [current]
        ;mov     rax,1   ; tedad register haye xmm
        ;call    printf
        ;pop     rbp


        fsin


        ;fst     qword [current]
        ;push    rbp
        ;mov     rdi,fmtp
        ;movq    xmm0, qword [current]
        ;mov     rax,1   ; tedad register haye xmm
        ;call    printf
        ;pop     rbp

        ;fld     qword [i]
        ;fxch    st1
        fdiv    qword [k]



        ;fst     qword [current]
        ;push    rbp
        ;mov     rdi,fmtp
        ;movq    xmm0, qword [current]
        ;mov     rax,1   ; tedad register haye xmm
        ;call    printf
        ;pop     rbp


        fld     qword [sum]
        fadd    st0,st1

        fstp    qword [sum]
        fstp    qword [trash]
        ;fstp    qword [trash]


        ;=====================end for loop body
        mov     rax,[i]
        inc     rax
        mov     [i],rax
        jmp     for1
    endfor1:


   push    rbp
   mov     rdi,fmtp
   ;mov     rsi,0
   ;mov     si,word [i]
   ;mov     rdx,s
   ;mov     rcx,[c]
   movq    xmm0, qword [sum]
   ;movq    xmm1, qword [best2]
   mov     rax,1   ; tedad register haye xmm
   call    printf
   pop     rbp



exit:
    mov     rax,sys_exit
    xor     rdi,rdi
    syscall












































; functions that we use in this code:

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

;---------------------------------------------------------
getc:
   push   rcx
   push   rdx
   push   rsi
   push   rdi 
   push   r11 

 
   sub    rsp, 1
   mov    rsi, rsp
   mov    rdx, 1
   mov    rax, sys_read
   mov    rdi, stdin
   syscall
   mov    al, [rsi]
   add    rsp, 1

   pop    r11
   pop    rdi
   pop    rsi
   pop    rdx
   pop    rcx

   ret
;---------------------------------------------------------

readNum:
   push   rcx
   push   rbx
   push   rdx

   mov    bl,0
   mov    rdx, 0
rAgain:
   xor    rax, rax
   call   getc
   cmp    al, '-'
   jne    sAgain
   mov    bl,1  
   jmp    rAgain
sAgain:
   cmp    al, NL
   je     rEnd
   cmp    al, ' ' ;Space
   je     rEnd
   sub    rax, 0x30
   imul   rdx, 10
   add    rdx,  rax
   xor    rax, rax
   call   getc
   jmp    sAgain
rEnd:
   mov    rax, rdx 
   cmp    bl, 0
   je     sEnd
   neg    rax 
sEnd:  
   pop    rdx
   pop    rbx
   pop    rcx
   ret

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
;-------------------------------------------













