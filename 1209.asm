INCLUDE Irvine32.inc

.data
randNums DWORD 4 DUP(0)      ; 隨機生成的四個數字
input DWORD ?                ; 玩家輸入
seperateInput DWORD 4 DUP(0) ; 玩家輸入的分解數字
A DWORD 0                    ; 正確數字和位置
B DWORD 0                    ; 正確數字但位置錯誤
tryCase DWORD 8              ; 最大嘗試次數
newline BYTE 13, 10, 0

msgInput BYTE "Please input your guess of the four digits:", 0
msgAttempt BYTE "Attempt: ", 0
msgInvalid BYTE "Invalid input! Please try again.", 0
msgWin BYTE "Congratulations, game successful!", 0
msgFail BYTE "Game failed!", 0
msgA BYTE "A", 0
msgB BYTE "B", 0
msgAnswer BYTE "The correct answer is: ", 0

.code

;---------------------------
GenerateUniqueRandom PROC
    ; 生成不重複的四位數字
    call Randomize
    xor ecx, ecx            ; 索引清零

generateLoop:
    mov eax, 10             ; 隨機數範圍 0-9
    call RandomRange
    mov ebx, eax            ; 保存隨機數到 EBX

    lea esi, randNums
    mov edx, ecx            ; 設定檢查計數
checkDuplicate:
    cmp edx, 0
    je storeNumber
    mov eax, [esi + edx * 4 - 4]
    cmp eax, ebx
    je generateLoop         ; 若重複重新生成
    dec edx
    jmp checkDuplicate

storeNumber:
    mov [randNums + ecx * 4], ebx
    inc ecx
    cmp ecx, 4
    jne generateLoop
    ret
GenerateUniqueRandom ENDP

;---------------------------
SplitInput PROC
    ; 將輸入的整數拆解為陣列
    mov eax, input
    lea esi, seperateInput
    mov ecx, 4

splitLoop:
    xor edx, edx
    mov ebx, 10
    div ebx
    mov [esi + ecx * 4 - 4], edx
    loop splitLoop
    ret
SplitInput ENDP

;---------------------------
CompareNumbers PROC
    ; 比較玩家輸入與生成的數字
    mov A, 0
    mov B, 0

    lea esi, randNums
    lea edi, seperateInput
    mov ecx, 4

compareOuter:
    mov eax, [esi + ecx * 4 - 4]
    mov ebx, ecx

compareInner:
    mov edx, [edi + ebx * 4 - 4]
    cmp eax, edx
    jne skipMatch
    cmp ecx, ebx
    je incrementA
    inc B
    jmp skipMatch

incrementA:
    inc A

skipMatch:
    dec ebx
    cmp ebx, 0
    jne compareInner
    loop compareOuter
    ret
CompareNumbers ENDP

;---------------------------
userInput PROC
    ; 處理玩家輸入與結果判定
    lea edx, msgInput
    call WriteString
    call Crlf

inputLoop:
    cmp tryCase, 0
    je gameFail

    lea edx, msgAttempt
    call WriteString
    call ReadInt
    mov input, eax

    ; 驗證輸入
    cmp input, 1000
    jl invalidInput
    cmp input, 9999
    jg invalidInput

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
    jmp inputLoop

invalidInput:
    lea edx, msgInvalid
    call WriteString
    call Crlf
    jmp inputLoop

gameWin:
    lea edx, msgWin
    call WriteString
    call Crlf
    ret

gameFail:
    lea edx, msgFail
    call WriteString

    ; 顯示正確答案
    lea esi, randNums
    mov ecx, 4
showAnswer:
    mov eax, [esi + ecx * 4 - 4]
    call WriteDec
    loop showAnswer

    call Crlf
    ret
userInput ENDP

;---------------------------
main PROC
    ; 主程式
    call GenerateUniqueRandom

                ; 打印生成的數字
                            mov edx, OFFSET msgAnswer
                            call WriteString

                            lea esi, randNums       ; ESI 指向 randNums
                            mov ecx, 4              ; 打印 4 個數字
                        printNumbers:
                            mov eax, [esi]  ; 讀取陣列中的數字到eax
                            add esi, 4                 ; 移動到下一個數字
                            call WriteDec           ; 打印該數字
                            loop printNumbers

                            ; 換行
                            mov edx, OFFSET newline
                            call WriteString

    call userInput
    ret
main ENDP

END main
