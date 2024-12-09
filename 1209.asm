問題一: 隨機數第一位和第四位重複 creatNUM函數
問題二: 比較答案不正確 CompareNumbers函數

INCLUDE Irvine32.inc

.data
randNums DWORD 4 DUP(0)      ; 隨機生成的四個數字
input DWORD ?                ; 玩家輸入
seperateInput DWORD 4 DUP(0) ; 玩家輸入的分解數字
A DWORD 0                    ; 正確數字和位置
B DWORD 0                    ; 正確數字但位置錯誤
tryCase DWORD 8              ; 最大嘗試次數
newline BYTE 13, 10, 0
startGame DWORD 0                    ; 是否為第一局遊戲
gameState DWORD 0
userInputResult DWORD ?


msgInput BYTE "Please input your guess of the four digits:", 0
msgAttempt BYTE "Attempt: ", 0
msgInvalid BYTE "Invalid input! Please try again.", 0
msgWin BYTE "Congratulations, game successful!", 0
msgFail BYTE "Game failed!", 0
msgA BYTE "A", 0
msgB BYTE "B", 0
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
        call Randomize
        call creatNUM
        mov randNums, eax
        


        lea esi, randNums
        mov ecx, 4

        showAnswer:
            mov eax, [esi]
            call WriteDec
            add esi, 4
            loop showAnswer
            call Crlf




        call userInput
        mov userInputResult, eax 
        
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
;---------------------------
    
    LOCAL i : DWORD            ; 循環計數器
    LOCAL isDuplicate : DWORD  ; 是否有重複數字
    
    mov i, 0                   ; 初始化計數器
    lea esi, OFFSET randNums

    create:
        call Randomize
        call Random32
        mov edx, 0           ; 餘數在edx
        mov ebx, 10
        div ebx              ; ebx=10 用於rand%10
        mov eax, edx         ; 首位存入EAX[0]

        ; 檢查是否重複
        mov isDuplicate, 0
        mov ecx, i
        mov ebx, 0

    checkDuplicate:
        cmp ebx, ecx
        jge storeNUM
        mov edx, [esi + ebx * 4]
        cmp eax, edx
        jne nextCheck
        mov isDuplicate, 1
        jmp create
    
    nextCheck:
        inc ebx
        jmp checkDuplicate

    storeNUM:
        cmp isDuplicate, 1
        je create
        mov edx, i
        shl edx, 2
        mov [esi + edx], eax
        inc i
        cmp i, 4
        jl create
        
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
    LOCAL i : DWORD

    mov A, 0
    mov B, 0

    mov esi, OFFSET randNums
    mov edi, OFFSET seperateInput
    mov ecx, 4

compareOuter:
    cmp ecx, 0
    je quit
    sub ecx, 1
    mov eax, [esi + ecx * 4]        ; 第四位開始比對
    mov i, 4      ; b[i]位置

    compareInner:
        cmp i, 0
        je skipMatch

        mov ebx, i
        dec ebx
        shl ebx, 2
        mov ebx, [edi + ebx]      ; b[4]~b[1]比對
        cmp eax, ebx                    ;a[4]先與b[4]比
        
        jne skipMatch                   ; 不同
        cmp ecx, i                      ; 
        je incrementA
        inc B
        jmp skipMatch

incrementA:
    inc A

    skipMatch:
        dec i
        cmp i, 0
        jne compareInner        ; b還沒比完
        loop compareOuter       ; b比完了
    quit:

    ret
CompareNumbers ENDP

;---------------------------
userInput PROC
; 處理玩家輸入
; EAX = 0 -> WIN
; EAX = 1 -> CONTINUE
; EAX = 2 -> FAIL
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
    mov eax, 1
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
        mov eax, 0
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

        mov eax, 2

    quit:

    ret
userInput ENDP

END main
