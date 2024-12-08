INCLUDE Irvine32.inc

.data
randNums db 4 dup(0)      ; 用於存放四個隨機數 (8 位單元)
buffer db 20 dup(0)       ; 緩衝區
message db "Generated numbers: ", 0
newline db 13, 10, 0

.code
GenerateUniqueRandom PROC
    ; 初始化隨機數
    call Randomize

    ; 生成不重複的四個數字
    xor ecx, ecx            ; ECX 作為索引，指向 randNums
generateLoop:
    ; 生成一個隨機數
    mov eax, 10             ; 隨機數範圍 0-9
    call RandomRange        ; 返回隨機數在 EAX
    mov bl, al              ; 保存生成的隨機數到 BL

    ; 檢查是否重複
    lea esi, randNums       ; ESI 指向 randNums 陣列
    mov edx, ecx            ; 將當前索引作為計數器
checkDuplicate:
    cmp edx, 0              ; 若已檢查完所有已有數字
    je storeNumber          ; 若無重複，跳至存數字
    mov al, byte ptr [esi]  ; 取陣列中的數字到 AL
    cmp al, bl              ; 比較生成的數字與現有數字
    je generateLoop         ; 如果重複，重新生成
    inc esi                 ; 檢查下一個數字
    dec edx                 ; 減少計數器
    jmp checkDuplicate      ; 繼續檢查

storeNumber:
    mov byte ptr [randNums + ecx], bl ; 存入數字到陣列
    inc ecx                 ; 增加索引
    cmp ecx, 4              ; 是否已生成 4 個數字
    jne generateLoop        ; 如果未生成 4 個數，繼續

    ret
GenerateUniqueRandom ENDP

main PROC
    ; 調用隨機生成函數
    call GenerateUniqueRandom

    ; 打印生成的數字
    mov edx, OFFSET message
    call WriteString

    lea esi, randNums       ; ESI 指向 randNums
    mov ecx, 4              ; 打印 4 個數字
printNumbers:
    mov al, byte ptr [esi]  ; 讀取陣列中的數字到 AL
    inc esi                 ; 移動到下一個數字
    call WriteDec           ; 打印該數字
    loop printNumbers

    ; 換行
    mov edx, OFFSET newline
    call WriteString

    ret
main ENDP

END main
