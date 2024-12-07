
.386
.model flat, stdcall
.stack 4096
include Irvine32.inc

.data
a DWORD 4 DUP(?)       ; 存放隨機生成的數字
b DWORD 4 DUP(?)       ; 存放玩家輸入的數字
A DWORD ?              ; A 的數量
B DWORD ?              ; B 的數量
N DWORD 8              ; 最大嘗試次數
pick DWORD ?           ; 玩家輸入的數字
msgInput BYTE "Please input your guess of the four digits:", 0
msgAttempt BYTE "Attempt %d: ", 0
msgInvalid BYTE "Invalid input!", 0
msgSuccess BYTE "Congratulations, game successful!", 0
msgFail BYTE "Game failed!", 0
msgAnswer BYTE "The correct answer is: ", 0
msgExit BYTE "Enter 1 to continue the game, enter 2 to return to the menu, enter 0 to exit the game:", 0

.code
main PROC
    ; 初始化隨機種子
    call Randomize
    
    ; 生成隨機數組
GenerateRandom:
    mov ecx, 4           ; 生成 4 個隨機數字
    lea esi, a
GenLoop:
    call RandomRange
    mov ebx, 10          ; 取範圍 0-9
    xor edx, edx
    div ebx
    mov [esi], eax
    add esi, 4
    loop GenLoop

    ; 遊戲提示輸入
    lea edx, msgInput
    call WriteString
    call Crlf

GameLoop:
    ; 輸入玩家數字
    lea edx, msgAttempt
    mov ecx, 1
    call WriteString
    call ReadInt
    mov pick, eax

    ; 驗證輸入有效性
    cmp pick, 1000
    jl InvalidInput
    cmp pick, 9999
    jg InvalidInput

    ; 將玩家輸入拆分為單個數字
    mov eax, pick
    lea esi, b
    mov ecx, 4
ExtractDigits:
    xor edx, edx
    mov ebx, 10
    div ebx
    mov [esi + ecx * 4 - 4], edx
    loop ExtractDigits

    ; 比對數字
    xor A, A
    xor B, B
    mov ecx, 4
    lea esi, a
    lea edi, b
CompareLoop:
    mov eax, [esi]
    mov ebx, [edi]
    cmp eax, ebx
    je CorrectPosition
    cmp eax, [edi+4]
    je WrongPosition
    cmp eax, [edi+8]
    je WrongPosition
    cmp eax, [edi+12]
    je WrongPosition
    jmp NextCompare

CorrectPosition:
    inc A
    jmp NextCompare
WrongPosition:
    inc B
NextCompare:
    add esi, 4
    loop CompareLoop

    ; 顯示結果
    mov eax, A
    mov ebx, B
    call WriteDec
    call Crlf

    ; 判斷勝負
    cmp A, 4
    je GameWin
    cmp ecx, N
    je GameFail
    jmp GameLoop

InvalidInput:
    lea edx, msgInvalid
    call WriteString
    call Crlf
    jmp GameLoop

GameWin:
    lea edx, msgSuccess
    call WriteString
    call Crlf
    jmp EndGame

GameFail:
    lea edx, msgFail
    call WriteString
    call Crlf

    ; 顯示正確答案
    lea edx, msgAnswer
    call WriteString
    lea esi, a
    mov ecx, 4
PrintAnswer:
    mov eax, [esi]
    call WriteDec
    add esi, 4
    loop PrintAnswer
    call Crlf
    jmp EndGame

EndGame:
    lea edx, msgExit
    call WriteString
    call ReadInt
    cmp eax, 1
    je GenerateRandom
    cmp eax, 2
    je main
    cmp eax, 0
    je Exit

Exit:
    call ExitProcess
main ENDP

END main
