INCLUDE Irvine32.inc

.data
randNums DWORD 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
NUM DWORD 4 DUP (?)
input DWORD ?                ; 玩家輸入
seperateInput DWORD 4 DUP(0) ; 玩家輸入的分解數字
A DWORD 0                    ; 正確數字和位置
B DWORD 0                    ; 正確數字但位置錯誤
tryCase DWORD 8              ; 最大嘗試次數
newline BYTE 13, 10, 0
startGame DWORD 0                    ; 是否為第一局遊戲
gameState DWORD 0
userInputResult DWORD ?


msgInput BYTE "Please input your guess of the four digits:", 0dh, 0ah, 0
msgAttempt BYTE "Attempt: ", 0
msgInvalid BYTE "Invalid input! Please try again.", 0
msgWin BYTE "Congratulations, game successful!", 0
msgFail BYTE "Game failed!", 0
msgA BYTE "A", 0dh, 0ah, 0
msgB BYTE "B", 0dh, 0ah, 0
msgAnswer BYTE "The correct answer is: ", 0dh, 0ah, 0
msgEndGame BYTE "Thanks for playing!", 0dh, 0ah, 0
msgContinue BYTE "Enter 1 to continue the game.", 0dh, 0ah, 0

.code
main PROC
; 主程式

    NewGame:
        mov edx, OFFSET msgInput    ; 請玩家輸入訊息
        call WriteString
	    call Crlf
        mov tryCase, 8         ; 初始化最大嘗試次數
        
        call creatNUM

        call userInput
        
        
        jmp continueGame          ; 僅在適當情況下跳轉
        

    continueGame:
		lea edx, OFFSET msgContinue   ; 詢問是否下一局
		call WriteString
        call Readchar
        cmp al, '1'
		je NewGame
        cmp al, '0'            ; 如果輸入 '0'，結束遊戲
        je EndGame
        

    EndGame:
		mov edx, OFFSET msgEndGame  ; output end message
		call WriteString

    invoke ExitProcess, 0

main ENDP

;---------------------------
creatNUM PROC
; Creat random number(0 ~ 9) to game, saving in EAX.
; 兩個兩個打亂
;---------------------------

    LOCAL var1 : DWORD
    LOCAL var2 : DWORD

    


    mov ecx, 100  ; 執行 100 次交換

create:
    ; 產生亂數 var1 和 var2
    call Randomize
    call Random32
    mov edx, 0
    mov ebx, 10
    div ebx
    mov var1, edx

    call RandomRange
    mov edx, 0
    mov ebx, 10
    div ebx
    mov var2, edx

    ; 設定 esi 和 edi 為索引值
    mov esi, var1
    mov edi, var2

    ; 避免 esi 和 edi 指向相同位置
    cmp esi, edi
    je create

    ; 確保範圍合法
    cmp esi, 10
    jge create
    cmp edi, 10
    jge create

swap:
    ; 交換 randNums[esi*4] 和 randNums[edi*4]
    push eax
    push ebx
    mov eax, DWORD PTR randNums[esi*4]
    mov ebx, DWORD PTR randNums[edi*4]
    mov DWORD PTR randNums[esi*4], ebx
    mov DWORD PTR randNums[edi*4], eax
    pop ebx
    pop eax

    ; 繼續迴圈
    loop create


    mov ecx, 4
    mov esi, 0
    get:
        mov eax, DWORD PTR randNums[esi]
        mov NUM[esi], eax
        add esi, 4
        loop get
    
    mov ecx, 4
    mov esi, 0
    showAnswer:
            mov eax, DWORD PTR NUM[esi]
            call WriteDec
            add esi, 4
            loop showAnswer
            call Crlf
    ret
 creatNUM ENDP       


;---------------------------
SplitInput PROC
    ; 將輸入的整數拆解為陣列
;---------------------------

    mov eax, input
    mov esi, OFFSET seperateInput
    mov ecx, 4

    L1:
        cmp ecx, 0
        je quit
        mov edx, 0
        mov ebx, 10
        div ebx
        sub ecx, 1
        mov [esi + ecx * 4], edx
        cmp ecx, 0
        jne L1

    quit:

    ret
SplitInput ENDP

;---------------------------
CompareNumbers PROC
; 比較玩家輸入與生成的數字
;---------------------------

    mov A, 0
    mov B, 0

    mov esi, 0
    mov edi, 0
    mov ecx, 4

compareOuter:
    
    mov eax, DWORD PTR NUM[esi]
    push ecx

    compareInner:
        mov ecx, 4
        cmp eax, seperateInput[edi]
        je incrementA
        jmp quit

    incrementB:
        inc B
        pop ecx
        jmp quit

    incrementA:
        cmp esi, edi
        jne incrementB
        inc A
        pop ecx
        jmp quit

    quit:
        add esi, 4
        loop compareOuter 

    ret
CompareNumbers ENDP

;---------------------------
userInput PROC
; 處理玩家輸入
;---------------------------



input00:
    cmp tryCase, 0
    je gameFail

    lea edx, msgAttempt
    call WriteString
    call ReadInt
    mov input, eax

    ; 驗證輸入
    cmp input, 0
    jl wrong
    cmp input, 9999
    jg wrong

    ; 拆解輸入並比較
    call SplitInput
    call CompareNumbers

    ; 顯示結果
    mov eax, A
    call WriteDec
    lea edx, msgA
    call WriteString

    mov eax, B
    call WriteDec
    lea edx, msgB
    call WriteString
    call Crlf

    ; 判定遊戲結果
    cmp A, 4
    je gameWin
    dec tryCase
    cmp tryCase, 0
    je gameFail
    jmp input00

    wrong:
        lea edx, msgInvalid
        call WriteString
        call Crlf
        jmp input00

    gameWin:
        lea edx, msgWin
        call WriteString
        call Crlf
        jmp quit

    gameFail:
        lea edx, msgFail
        call WriteString

        ; 顯示正確答案
        lea edi, msgAnswer
        call WriteString

        lea esi, randNums
        mov ecx, 4

        showAnswer:
            mov eax, [esi]
            call WriteDec
            add esi, 4
            loop showAnswer
            call Crlf


    quit:

    ret
userInput ENDP

END main
