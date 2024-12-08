INCLUDE Irvine32.inc



.data
randNums DWORD 4 dup(0)      ; 用於存放四個隨機數
buffer DWORD 20 dup(0)       ; 緩衝區

input DWORD ?             ; 玩家輸入的數字
seperateInput DWORD 4 DUP(0)

A DWORD 0            ; A 的數量
B DWORD 0            ; B 的數量

tryCase DWORD 8            ; 最大嘗試次數

msgInput BYTE "Please input your guess of the four digits:", 0
msgAttempt BYTE "Attempt: ", 0
msgInvalid BYTE "Invalid input!", 0
msgWin BYTE "Congratulations, game successful!", 0
msgFail BYTE "Game failed!", 0

msgA db "A", 0
msgB db "B", 0

msgAnswer db "The correct answer is: ", 0
newline db 13, 10, 0

.code
;---------------------------
GenerateUniqueRandom PROC
        ; 初始化隨機數
;---------------------------

        call Randomize

        ; 生成不重複的四個數字
        xor ecx, ecx            ; ECX 作為索引，指向 randNums

    generateLoop:
        ; 生成一個隨機數
        mov eax, 10             ; 隨機數範圍 0-9
        call RandomRange        ; 返回隨機數在 EAX
        mov ebx, eax              ; 保存生成的隨機數到 BL

        ; 檢查是否重複
        lea esi, randNums       ; ESI 指向 randNums 陣列
        mov edx, ecx            ; 將當前索引作為計數器

    checkDuplicate:
        cmp edx, 0              ; 若已檢查完所有已有數字
        je storeNumber          ; 若無重複，跳至存數字
        mov eax, [esi]  ; 取陣列中的數字到 AL
        cmp eax, ebx             ; 比較生成的數字與現有數字
        je generateLoop         ; 如果重複，重新生成
        add esi, 4               ; 檢查下一個數字
        dec edx                 ; 減少計數器
        jmp checkDuplicate      ; 繼續檢查

    storeNumber:
        mov [randNums + ecx * 4], ebx ; 存入數字到陣列
        inc ecx                 ; 增加索引
        cmp ecx, 4              ; 是否已生成 4 個數字
        jne generateLoop        ; 如果未生成 4 個數，繼續

    ret
GenerateUniqueRandom ENDP

;---------------------------
userInput PROC
; 玩家輸入
;---------------------------
        ; 每次輸入前重置 A 和 B
        mov A, 0
        mov B, 0

        lea edx, msgInput
        call WriteString
        call Crlf
        
        ContinueInput:
            lea edx, msgAttempt
            mov ecx, 1
            call WriteString

            call ReadInt
            mov input, eax

            dec tryCase

            ; 判斷是否有效
            cmp input, 0
            jl InvalidInput
            cmp input, 9999
            jg InvalidInput


            ; 拆分input到seperateInput
            mov eax, input
            lea esi, seperateInput      ;將指標指向seperateInput起始位址
            mov ecx, 4                  ; 設置迴圈次數

            Seperate:
                    xor edx, edx
                    mov ebx, 10
                    div ebx
                    mov [esi + ecx*4 -4], edx
                    loop Seperate

           
            lea esi, randNums       ; 所求
            lea edi, seperateInput  ; 所猜
            mov ecx, 4              ; 設置迴圈次數
            

; 差在第二次之後的位置
; 比較第一個位元
; 比較第二個位元
            Compare:
                    mov ecx, 4              ; 設置迴圈次數
                    lea esi, randNums       ; 所求
                    lea edi, seperateInput  ; 所猜

                    L1:
                        mov eax, [esi]      ; 所求 放到 eax暫存器裡
                        mov ebx, [edi]      ; 所猜 放到 ebx暫存器裡
                        cmp eax, ebx
                        je Correct1
                        cmp eax, [edi + 4]  ;比較 所求的第一位數與所猜的第二位數
                        je Wrong1
                        cmp eax, [edi + 8]
                        je Wrong1
                        cmp eax, [edi + 12]
                        je Wrong1
                        jmp L2

                            Correct1:
                                inc A
                                jmp L2

                            Wrong1:
                                inc B
                                jmp L2

                        L2:                           
                            mov eax, [esi + 4]
                            cmp eax, [edi + 4]
                            je Correct2
                            cmp eax, [edi]
                            je Wrong2
                            cmp eax, [edi + 8]
                            je Wrong2
                            cmp eax, [edi + 12]
                            je Wrong2
                            jmp L3

                                Correct2:
                                    inc A
                                    jmp L3

                                Wrong2:
                                    inc B
                                    jmp L3

                            L3:                           
                                mov eax, [esi + 8]
                                cmp eax, [edi + 8]
                                je Correct3
                                cmp eax, [edi]
                                je Wrong3
                                cmp eax, [edi + 4]
                                je Wrong3
                                cmp eax, [edi + 12]
                                je Wrong3
                                jmp L4

                                    Correct3:
                                        inc A
                                        jmp L4

                                    Wrong3:
                                        inc B
                                        jmp L4

                                L4:                           
                                    mov eax, [esi + 12]
                                    cmp eax, [edi + 12]
                                    je Correct4
                                    cmp eax, [edi]
                                    je Wrong4
                                    cmp eax, [edi + 4]
                                    je Wrong4
                                    cmp eax, [edi + 8]
                                    je Wrong4
                                    jmp printAB

                                        Correct4:
                                            inc A
                                            jmp printAB

                                        Wrong4:
                                            inc B
                                            jmp printAB

                printAB:
                        ; 輸出幾A幾B
                        mov eax, A                     
                        call WriteDec
                        lea edx, msgA
                        call WriteString
                        
                        mov eax, B
                        call WriteDec
                        lea edx, msgB
                        call WriteString
                        call Crlf

                        ; 判斷輸贏
                        cmp A, 4
                        je Win
                        cmp tryCase, 0
                        je Fail
                        jmp ContinueInput

        InvalidInput:
            lea edx, msgInvalid
            call WriteString
            call Crlf
            jmp userInput           ; 重新輸入
        Win:
            lea edx, msgWin
            call WriteString
            call Crlf
            jmp quit

        Fail:
            lea edx, msgFail
            call WriteString
            call Crlf
    
        quit:

        ret
            
userInput ENDP


        


;---------------------------
main PROC
; 主函數
;---------------------------

        call GenerateUniqueRandom       ; 調用隨機生成函數
        


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

        call userInput                  ; 調用使用者輸入函數

    ret
main ENDP

END main
