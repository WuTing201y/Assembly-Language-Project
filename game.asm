INCLUDE Irvine32.inc

.data
    n1 DWORD 0
    n2 DWORD 0
    n3 DWORD 0
    n4 DWORD 0
    input DWORD ?
    get1 DWORD 0
    get2 DWORD 0
    get3 DWORD 0
    get4 DWORD 0
    A DWORD 0
    B DWORD 0
    tryCase DWORD 8

    ; message
    msgA BYTE "A", 0
    msgB BYTE "B", 0
    msgWin BYTE "Congratulations, game successful!", 0dh, 0ah, 0
    msgFail BYTE "Game failed!", 0dh, 0ah, 0
    msgEndGame BYTE "Thanks for playing!", 0dh, 0ah, 0
    msgContinue BYTE "Enter 1 to continue the game, enter 0 to exit the game:", 0dh, 0ah, 0
    msgInput BYTE "Please input your guess of the four digits: ", 0dh, 0ah, 0
    msgInvalid BYTE "Invalid input! Please try again.", 0dh, 0ah, 0
    msgAnswer BYTE "The correct answer is: ", 0

.code
main PROC

new:
    lea edx, msgInput           ;歡迎訊息
    call WriteString
    mov tryCase, 8
    mov A, 0
    mov B, 0
    call creatNUM
try:
    dec tryCase
    mov A, 0
    mov B, 0
    call userInput
    call compareN1
    call compareN2
    call compareN3
    call compareN4

    cmp A, 4
    je win
    cmp tryCase, 0
    je fail
    jmp try

    win:
        lea edx , msgWin
        call WriteString
        jmp continue
    fail:
        lea edx, msgFail
        call WriteString
        lea edx, msgAnswer
        call WriteString
        mov eax, n1
        call WriteDec
        mov eax, n2
        call WriteDec
        mov eax, n3
        call WriteDec
        mov eax, n4
        call WriteDec
        call Crlf
        call Crlf
        jmp continue

    continue:
        lea edx, msgContinue
        call WriteString
        call ReadInt
        cmp eax, 1
        je new
        jmp endGame

    endGame:
        lea edx, msgEndGame
        call WriteString


 main ENDP

;---------------------------
compareN1 PROC
; n1和get1比
; 不對，n1和n2比
;---------------------------
    

    mov eax, n1
    cmp eax, get1
    je incA
    cmp eax, get2
    je incB
    cmp eax, get3
    je incB
    cmp eax, get4
    je incB
    jmp quit

incA:
    inc A
    jmp quit
incB:
    inc B
    jmp quit

quit: 
    ret
compareN1 ENDP

;---------------------------
compareN2 PROC
; n1和get1比
; 不對，n1和n2比
;---------------------------
    

    mov eax, n2
    cmp eax, get2
    je incA
    cmp eax, get1
    je incB
    cmp eax, get3
    je incB
    cmp eax, get4
    je incB
    jmp quit

incA:
    inc A
    jmp quit
incB:
    inc B
    jmp quit

quit: 
    ret
compareN2 ENDP

;---------------------------
compareN3 PROC
; n1和get1比
; 不對，n1和n2比
;---------------------------
    

    mov eax, n3
    cmp eax, get3
    je incA
    cmp eax, get1
    je incB
    cmp eax, get2
    je incB
    cmp eax, get4
    je incB
    jmp quit

incA:
    inc A
    jmp quit
incB:
    inc B
    jmp quit

quit: 
    ret
compareN3 ENDP

;---------------------------
compareN4 PROC
; n1和get1比
; 不對，n1和n2比
;---------------------------
    

    mov eax, n4
    cmp eax, get4
    je incA
    cmp eax, get1
    je incB
    cmp eax, get2
    je incB
    cmp eax, get3
    je incB
    jmp print

incA:
    inc A
    cmp A, 4
    je quit
    jmp print

incB:
    inc B

print:
    mov eax, A
    call WriteDec
    lea edx, msgA
    call WriteString

    mov eax, B
    call WriteDec
    lea edx, msgB
    call WriteString
    call Crlf
    call Crlf

    

quit: 
    ret
compareN4 ENDP
;---------------------------
creatNUM PROC
;---------------------------
 call Randomize

createN1:
    mov eax, 10
    call RandomRange
    mov n1, eax

createN2:
    mov eax, 10
    call RandomRange
    mov n2, eax

    cmp n1, eax   ; EAX = n2
    je createN2
    
    createN3:
        mov eax, 10
        call RandomRange
        mov n3, eax

        cmp n1, eax
        je createN3
        cmp n2, eax
        je createN3

        createN4:
            mov eax, 10
            call RandomRange
            mov n4, eax

            cmp n1, eax
            je createN4
            cmp n2, eax
            je createN4
            cmp n3, eax
            je createN4

    ret
 creatNUM ENDP

;---------------------------
userInput PROC
;---------------------------
L1:
    call ReadInt
    cmp eax, 9999
    ja invalid
    cmp eax, 0000
    jb invalid

    mov edx, 0
    mov ebx, 10 ; %10
    div ebx     ; 商:EAX 餘:EDX
    mov get4, edx

    mov edx, 0
    mov ebx, 10 ; %10
    div ebx     ; 商:EAX 餘:EDX
    mov get3, edx

    mov edx, 0
    mov ebx, 10 ; %10
    div ebx     ; 商:EAX 餘:EDX
    mov get2, edx

    mov edx, 0
    mov ebx, 10 ; %10
    div ebx     ; 商:EAX 餘:EDX
    mov get1, edx
    jmp quit

  invalid:
        lea edx, msgInvalid
        call WriteString
        call Crlf
        jmp L1
    quit:
        ret
userInput ENDP
 END main
;---------------------------
