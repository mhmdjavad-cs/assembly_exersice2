extern scanf
extern printf

section .data
   number  dq 0
   i       dq 0
   j       dq 0
   best1   dq 0
   best2   dq 0
   best_val    dq 100000.5   
   current     dq 0
   trash       dq 0

   ; for using scanf
   fmts    db  "%lf",0
   msg1     db  "swapping",NL,0
   msg2     db  "we are before swapping",NL,0
   msg3     db  "the answer is:",NL,0
   ans_format  db "%lf %lf",NL,0

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
   list    resq 300





section .text
   global main


main:

   call readNum
   mov     [number],rax



   ;for loop
   mov     rax,0
   mov     [i],rax
   for1:
      ;loop compare:
      mov     rax,[i]
      mov     rbx,[number]
      cmp     rax,rbx
      je      endfor1
      ;=========================for loop body
      push    rbp

        
      mov     rbx,list
      mov     rcx,[i]
      mov     rdx,8
      imul    rcx,rdx
      add     rbx,rcx


      mov     rdi,fmts
      mov     rsi,rbx
      xor     rax,rax
      call    scanf


      pop     rbp
      ;=====================end for loop body
      mov     rax,[i]
      inc     rax
      mov     [i],rax
      jmp     for1
   endfor1:







   ;for loop
   mov     rax,0
   mov     [i],rax
   for2:
      ;loop compare:
      mov     rax,[i]
      mov     rbx,[number]
      cmp     rax,rbx
      je      endfor2
      ;=========================for2 loop body
      ;for loop
      mov     rax,[i]
      inc     rax
      mov     [j],rax
      for3:
         ;loop compare:
         mov     rax,[j]
         mov     rbx,[number]
         cmp     rax,rbx
         je      endfor3
         ;=========================for3 loop body

         ; we have i from 0 to n-1 
         ; and j from 0 to n-1 here:

         
         mov   rbx,list
         mov   rcx,[i]
         mov   rdx,8
         imul  rcx,rdx
         add   rbx,rcx

         ; loading the first number in the stack
         fld   qword [rbx]


         mov   rbx,list
         mov   rcx,[j]
         mov   rdx,8
         imul  rcx,rdx
         add   rbx,rcx

         ; loading the second number in the stack
         fld   qword [rbx]

         fsub  st0,st1
         fstp  qword [current]
         fstp  qword [trash]
         ; we calculate current and the stack is empty now


         fld   qword [current]
         ftst
         fstsw ax
         and   ax,0100011100000000B
         cmp   ax,0000000000000000B
         je    isok
         
         fchs

         isok:
         fstp  qword [current]



         ;TO PRINT CURRENT:
         ;push    rbp
         ;mov     rdi,fmtp
         ;movq    xmm0, qword [current]
         ;mov     rax,1   ; tedad register haye xmm
         ;call    printf         
         ;pop     rbp


         ;push    rbp
         ;mov     rdi,msg2
         ;movq    xmm0, qword [best_val]
         ;mov     rax,0   ; tedad register haye xmm
         ;call    printf         
         ;pop     rbp


         fld   qword [best_val]  ; is in the st1
         fld   qword [current]   ; is in the st0
         fcom  st0,st1
         fstsw ax

         and   ax,0100011100000000B
         cmp   ax,0000000100000000B ; if current is lesser jmp to swap
         je    swap
         jmp  continue

         swap:
            fstp  qword [trash]
            fstp  qword [trash]
            ; stack is empty now
            mov   rbx,list
            mov   rcx,[i]
            mov   rdx,8
            imul  rcx,rdx
            add   rbx,rcx

            ; loading the first number in the stack
            fld   qword [rbx]
            fstp  qword [best1]

            mov   rbx,list
            mov   rcx,[j]
            mov   rdx,8
            imul  rcx,rdx
            add   rbx,rcx

            ; loading the first number in the stack
            fld   qword [rbx]
            fstp  qword [best2]

            fld   qword [current]
            fstp  qword [best_val]
            

            ;push    rbp
            ;mov     rdi,msg1
            ;movq    xmm0, qword [best_val]
            ;mov     rax,0   ; tedad register haye xmm
            ;call    printf         
            ;pop     rbp

            ; TO PRINT bestval:
            ;push    rbp
            ;mov     rdi,fmtp
            ;movq    xmm0, qword [best_val]
            ;mov     rax,1   ; tedad register haye xmm
            ;call    printf         
            ;pop     rbp



            jmp   continue2

         continue:
            fstp  qword [trash]
            fstp  qword [trash]
            ; stack is empty now

         continue2:


         ; TO PRINT CURRENT:
         ;push    rbp
         ;mov     rdi,fmtp
         ;movq    xmm0, qword [current]
         ;mov     rax,1   ; tedad register haye xmm
         ;call    printf         
         ;pop     rbp



      
         ;=====================end for3 loop body
         mov     rax,[j]
         inc     rax
         mov     [j],rax
         jmp     for3
      endfor3:
      ;=====================end for loop body
      mov     rax,[i]
      inc     rax
      mov     [i],rax
      jmp     for2
   endfor2:



   ;push    rbp
   ;mov     rdi,msg3
   ;movq    xmm0, qword [best_val]
   ;mov     rax,0   ; tedad register haye xmm
   ;call    printf         
   ;pop     rbp

   push    rbp
   mov     rdi,ans_format
   ;mov     rsi,0
   ;mov     si,word [i]
   ;mov     rdx,s
   ;mov     rcx,[c]
   movq    xmm0, qword [best1]
   movq    xmm1, qword [best2]
   mov     rax,2   ; tedad register haye xmm
   call    printf
   pop     rbp


   ;push    rbp
   ;mov     rdi,fmtp
   ;movq    xmm0, qword [best1]
   ;mov     rax,1   ; tedad register haye xmm
   ;call    printf         
   ;pop     rbp

   ;push    rbp
   ;mov     rdi,fmtp
   ;movq    xmm0, qword [best2]
   ;mov     rax,1   ; tedad register haye xmm
   ;call    printf         
   ;pop     rbp

   ;push    rbp
   ;mov     rdi,fmtp
   ;movq    xmm0, qword [best_val]
   ;mov     rax,1   ; tedad register haye xmm
   ;call    printf         
   ;pop     rbp





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













