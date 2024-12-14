INCLUDE Irvine32.inc

.data
    
    randNum DWORD 4 DUP(0)
    getNum DWORD 4 DUP(0)
    A DWORD 0
    B DWORD 0
    tryCase DWORD 8

    ; bar
        
    	total DWORD 8
    	msgLine BYTE "=====", 0
    	msgBlank BYTE "     ", 0
    	msgBarBegin BYTE "[", 0
    	msgBarEnd BYTE "] ", 0
    	msgArrow BYTE ">", 0
    	msgRemain BYTE " chances left", 0dh, 0ah, 0

    ; message
    welcome BYTE "Guess Number Game", 0dh, 0ah
            BYTE "1. Start Game", 0dh, 0ah
            BYTE "2. Help", 0dh, 0ah
            BYTE "3. Exit", 0dh, 0ah
            BYTE "Please enter (1-3): ", 0
        
    msgHelp BYTE "Welcome to the program", 0dh, 0ah
            BYTE "Game Instructions: Enter a four-digit number, after entering, a hint of XAYB will appear.", 0dh, 0ah
            BYTE "X indicates how many digits are correct and in the correct position.", 0dh, 0ah
            BYTE "Y indicates how many digits are correct but in the wrong position.", 0dh, 0ah
            BYTE "Press 1 to continue the game: ", 0

    msgStartInvalid BYTE "Invalid input! Please enter (1-3): ", 0
    msgHelpInvalid BYTE "Invalid input! Please enter 1 to continue the game: ", 0
    msgA BYTE "A", 0
    msgB BYTE "B", 0
    msgWin BYTE "Congratulations, game successful!", 0dh, 0ah, 0
    msgFail BYTE "Game failed!", 0dh, 0ah, 0
    msgEndGame BYTE "Thanks for playing!", 0dh, 0ah, 0
    msgContinue BYTE "Enter 1 to continue the game, enter 0 to exit the game: ", 0dh, 0ah, 0
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
game PROC
;---------------------------
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
    call progress_bar

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
        
        mov ecx, 4
        mov esi, 0
        L1:
        mov eax, [randNum + esi * 4]
        call WriteDec
        inc esi
        loop L1
        
        call Crlf
        call Crlf
        jmp continue

    continue:
        lea edx, msgContinue
        call WriteString
    inputAgain:
        call ReadInt
        cmp eax, 1
        je new
        cmp eax, 0
        je endGame
        jmp invalid

    invalid:
        call Crlf
        lea edx, msgInvalid
        call WriteString
        jmp inputAgain

    endGame:
        lea edx, msgEndGame
        call WriteString
        
quit:
    ret
Game ENDP
;---------------------------
creatNUM PROC
;---------------------------
    call Randomize	
    mov esi, 0
    mov ecx, 4		; 生成4個數字

createN:
    mov eax, 10		; 範圍介於0~9之間
    call RandomRange	; 生成隨機數
    mov [randNum + esi * 4], eax

    cmp esi, 0		
    jne L1		; 若不是生成第0項，跳至L1
    inc esi
    loop createN

    L1:
        push ecx	    ; createN的ecx
        mov ecx, esi        ; 迴圈次數，第1項時為1，依此類推
        mov edi, esi        ; 指向前面的數字
        L3:
            dec edi		; 比較生成數與前面的數字是否重複
            mov ebx, [randNum + edi * 4]	; 前面數字的值
            cmp eax, ebx			; 生成數存放在EAX
            je same				; 如果重複跳至same
            loop L3

            pop ecx		; 沒有重複則彈出createN的ecx
            cmp ecx, 1		
            je quit		; 若ecx = 1，代表4位數生成完畢，結束生成
            dec ecx		; 否則ecx - 1
            inc esi		; esi + 1
            jmp createN		; 繼續生成下一個數字
        
        same:
            pop ecx		; 彈出createN的ecx
            jmp createN		; 重新生成隨機數

quit:
    ret
 creatNUM ENDP
;---------------------------
compareN1 PROC
; n0和g0比
;---------------------------
    
    mov esi, 0
    mov eax, [randNum + esi * 4]

    cmp eax, [getNum + esi * 4]     ; n0, g0
    je incA
    inc esi                         ; esi = 1
    cmp eax, [getNum + esi * 4]     ; n0, g1
    je incB
    inc esi                         ; esi = 2
    cmp eax, [getNum + esi * 4]
    je incB
    inc esi                         ; esi = 3
    cmp eax, [getNum + esi * 4]
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
; n1, g1
;---------------------------
    
    mov esi, 1                              ; esi = 1
    mov eax, [randNum + esi * 4]            ; n1

    cmp eax, [getNum + esi * 4]             ; n1, g1
    je incA
    dec esi                                 ; esi = 0
    cmp eax, [getNum + esi * 4]             ; n1, g0
    je incB
    mov esi, 2                              ; esi = 2
    cmp eax, [getNum + esi * 4]             ; n1, g2
    je incB
    inc esi                                 ; esi = 3
    cmp eax, [getNum + esi * 4]
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
; n2, g2
;---------------------------
    mov esi, 2                                 ; esi = 2
    mov eax, [randNum + esi * 4]               ; n2

    cmp eax, [getNum + esi * 4]                ; n2, g2
    je incA
    mov esi, 0                                 ; esi = 0
    cmp eax, [getNum + esi * 4]
    je incB
    inc esi
    cmp eax, [getNum + esi * 4]
    je incB
    mov esi, 3
    cmp eax, [getNum + esi * 4]
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
; n3, g3
;---------------------------
    mov esi, 3                              ; esi = 3
    mov eax, [randNum + esi * 4]

    cmp eax, [getNum + esi * 4]             ; n3, g3
    je incA
    mov esi, 0                              ; esi = 0
    cmp eax, [getNum + esi * 4]
    je incB
    inc esi                                 ; esi = 1
    cmp eax, [getNum + esi * 4]
    je incB
    inc esi                                 ; esi = 2
    cmp eax, [getNum + esi * 4]
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
    

quit: 
    ret
compareN4 ENDP


;---------------------------
userInput PROC
;---------------------------
  L1:
    call ReadInt
    cmp eax, 9999
    ja invalid
    cmp eax, 0000
    jb invalid

    mov esi, 3
    mov ecx, 4

seperate:
    mov edx, 0
    mov ebx, 10 ; %10
    div ebx     ; 商:EAX 餘:EDX
    mov [getNum + esi * 4], edx
    dec esi
    loop seperate
    jmp quit

  invalid:
        lea edx, msgInvalid
        call WriteString
        call Crlf
        jmp L1
    quit:
        ret
userInput ENDP
;---------------------------
progress_bar PROC
;---------------------------
	mov eax, tryCase
    mov ebx, total
	sub ebx, eax

	lea edx, msgBarBegin
	call WriteString

	mov ecx, ebx
	L1:
		lea edx, msgLine
		call WriteString
		loop L1
	
	lea edx, msgArrow
	call WriteString

    cmp eax, 0
    je L3
	mov ecx, eax        ;tryCase->blank    
	L2:
		lea edx, msgBlank
		call WriteString
		loop L2
	
    L3:
	lea edx, msgBarEnd
	call WriteString

	mov eax, tryCase
	call WriteDec

	lea edx, msgRemain
	call WriteString
    call Crlf

	ret
progress_bar ENDP

END main
;---------------------------
