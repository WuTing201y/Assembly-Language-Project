.data
randomNum DWORD 4 DUP(?)   ; 存放隨機生成的數字
input DWORD 4 DUP(?)       ; 存放玩家輸入的數字
pick DWORD ?               ; 玩家輸入的數字
tryCase DWORD 8            ; 最大嘗試次數
A_count DWORD ?            ; A 的數量
B_count DWORD ?            ; B 的數量
msgInput BYTE "Please input your guess of the four digits:", 0
msgAttempt BYTE "Attempt %d: ", 0
msgInvalid BYTE "Invalid input!", 0
msgWin BYTE "Congratulations, game successful!", 0
msgFail BYTE "Game failed!", 0
msgAnswer BYTE "The correct answer is: ", 0
msgExit BYTE "Enter 1 to continue the game, enter 2 to return to the menu, enter 0 to exit the game:", 0


.code

Game PROC
    call Randomize  ; same as srand(time(NULL))

GenerateRandomNum:
    mov ecx, 4
    lea esi, randomNum

GenerateLoop:
    call RandomRange  ; generate Random Number
    mov ebx, 10     ; range from 0 to 9
    xor edx, edx
    div ebx
    mov [esi], dl  ; highest posi is arr[3], remainder store in edx and 0~9 only in dl register
    add esi, 4
    loop GenerateLoop


; 玩家輸入input
    lea edx, msgInput
    call WriteString
    call Crlf

GameLoop:
    lea esx, msgAttempt
    mov ecx, 1
    call WriteString
    call RealInt
    mov pick, eax

    ; is valid?
    cmp pick, 1000
    jl InvalidInput
    cmp pick, 9999
    jg InvalidInput

    ; seperate input to single number
    mov eax, pick
    lea esi, input
    mov ecx, 4   ; set loop time

SeperateInput:
    xor edx, edx  ; same as mov edx, 0 but xor is faster
    mov ebx, 10
    div ebx       ; quotient store in eax, reminder store in edx
    mov [esi + ecx*4 - 4], edx  ;倒序存入
    loop SeperateInput

    ; check Input if it's right
    xor randomNum, randomNum
    xor input, input
    mov ecx, 4
    lea esi, A_count
    lea edi, B_count
CompareLoop:
    mov eax, [esi]
    mov ebx, [edi]
    cmp eax, ebx
    je CorrectPosi

    cmp eax, [ebx + 4]
    je WrongPosi
    cmp eax, [ebx + 8]
    je WrongPosi
    cmp eax, [ebx + 12]
    je WrongPosi

    jmp NextCompare

CorrectPosi:
    inc A_count
    jmp NextCompare

WrongPosi:
    inc B_count
    jmp NextCompare

NextCompare:
    add esi, 4
    loop CompareLoop

    ; output result
    mov eax, A_count
    mov ebx, B_count
    call WriteDec
    call Crlf

    ; win or lose?
    cmp A_count, 4
    je GameWin
    cmp ecx, tryCase
    je GameFail
    jmp GameLoop

InvalidInput:
    lea, edx, msgInvalid
    call WriteString
    call Crlf
    jmp GameLoop

GameWin:
    lea edx, msgWin
    call WriteString
    call Crlf
    jmp EndGame

GameFail:
    lea edx, msgFail
    call WriteString
    call Crlf

    ;output answer
    lea edx, msgAnswer
    call WriteString
    lea esi, randomNum
    mov ecx, 4

EndGame:
    lea edxm msgExit
    call WriteString
    call ReadInt
    
    cmp eax, 1   ; again
    je GenerateRandomNum

    cmp eax, 2  ; back to home
    je main

    cmp eax, 0
    je Exit     ;end

Exit:
    call ExitProcess

Game ENDP
