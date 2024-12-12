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

welcome BYTE "Guess Number Game", 0dh, 0ah
        BYTE "1. Start Game", 0dh, 0ah
        BYTE "2. Help", 0dh, 0ah
        BYTE "3. Exit", 0dh, 0ah
        BYTE "Please enter (1-3): ", 0
        
msgHelp BYTE "Welcome to the program", 0dh, 0ah
        BYTE "Game Instructions: Enter a four-digit number...", 0dh, 0ah
        BYTE "X indicates how many digits are correct and in the correct position.", 0dh, 0ah
        BYTE "Y indicates how many digits are correct but in the wrong position.", 0dh, 0ah
        BYTE "Press 1 to continue the game: ", 0

msgStartInvalid BYTE "Invalid input! Please enter (1-3): ", 0
msgHelpInvalid BYTE "Invalid input! Please enter 1 to continue the game: ", 0

msg11 DB "You took XX seconds to complete the game.",  0

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

    call menu
start:
    call ReadInt
    cmp eax, 1
    je game
    cmp eax, 2
    je help
    cmp eax, 3
    je quit
    jmp start_invalid

    start_invalid:
        lea edx, msgStartInvalid
        call WriteString
        jmp start

    quit:
        ret
    INVOKE ExitProcess, 0
main ENDP
;---------------------------
difftime PROC
; 自製 difftime 功能：計算時間差
; 參數：
;   [ebp+8]  - start_time (DWORD)
;   [ebp+12] - end_time (DWORD)
; 返回：
;   eax      - 時間差 (DWORD)
;---------------------------
    push ebp
    mov ebp, esp           ; 建立堆疊框架

    mov eax, DWORD PTR [ebp+12] ; end_time
    sub eax, DWORD PTR [ebp+8]  ; 計算時間差 (end_time - start_time)

    mov esp, ebp           ; 恢復堆疊
    pop ebp
    ret
difftime ENDP
;---------------------------
menu PROC
;---------------------------
    lea edx, welcome
    call WriteString
    ret
menu ENDP

;---------------------------
help PROC
;---------------------------
    call Crlf
    lea edx, msgHelp
    call WriteString
L1:
    call ReadInt
    cmp eax, 1
    je quit
    jmp invalid

    invalid:
        call Crlf
        lea edx, msgHelpInvalid
        call WriteString
        jmp L1
quit:
    call game
    ret
help ENDP


;---------------------------
record_time PROC
;---------------------------
    push ebp
    mov ebp, esp

  
    push DWORD PTR [ebp+12] ; end_time
    push DWORD PTR [ebp+8]  ; start_time
    call difftime
    add esp, 8 


    sub esp, 8
    fstp QWORD PTR [esp]

    push OFFSET msg11
    push esp               ; time_taken
    call WriteString
    
    call Crlf       
    call WaitMsg  
    add esp, 12

    mov esp, ebp
    pop ebp
    ret
record_time ENDP


;---------------------------
game PROC
;---------------------------

new:
    call Crlf
    lea edx, msgInput           ;歡迎訊息
    call WriteString
    mov tryCase, 3
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
    ret
Game ENDP
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

