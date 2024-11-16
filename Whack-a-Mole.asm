INCLUDE Irvine32.inc

.data
GRID_SIZE     DWORD 3                   ; 地圖大小
GRID_SIZE_SQ  DWORD 9                   ; GRID_SIZE * GRID_SIZE (3x3)
MAX_ROUNDS    DWORD 5                   ; 最大回合數
playAgain     DWORD 1                   ; 是否繼續遊戲
score         DWORD 0                   ; 玩家得分
rounds        DWORD 0                   ; 已進行回合數
startTime     DWORD ?                   ; 開始時間
endTime       DWORD ?                   ; 結束時間
elapsedTime   REAL8 ?                   ; 花費時間
grid          DWORD 9 DUP(0)            ; 地圖資料 (3x3), 9 個 DWORD 初始化為 0

prompt1       BYTE "歡迎來到打地鼠遊戲！", 0
prompt2       BYTE "地圖大小為 3x3，每回合隨機出現一隻地鼠。", 0
prompt3       BYTE "是否要再來一局？(1: 是, 0: 否)：", 0
prompt4       BYTE "請輸入您要打的行與列（以空格分隔，從 1 開始計算）：", 0
prompt5       BYTE "打中了！", 0
prompt6       BYTE "沒打中。", 0
prompt7       BYTE "輸入無效，請輸入正確的行與列。", 0
prompt8       BYTE "遊戲結束！您的總得分是：", 0
prompt9       BYTE "您完成此局花費的時間為 %.2f 秒。", 0

.code
main:
    ; 初始化隨機數生成器
    call Randomize

    ; 顯示歡迎訊息
    mov edx, offset prompt1
    call WriteString
    mov edx, offset prompt2
    call WriteString

game_loop:
    ; 初始化遊戲變數
    mov dword ptr [score], 0
    mov dword ptr [rounds], 0
    call GetSystemTime ; 取得系統時間，記錄遊戲開始時間

    ; 遊戲回合循環
    mov eax, [rounds]
    cmp eax, MAX_ROUNDS
    jge game_end

round_loop:
    ; 顯示回合數
    mov eax, [rounds]
    push eax
    mov edx, offset prompt4
    call WriteString

    ; 產生地鼠
    call generateMole

    ; 顯示地圖
    call printGrid

    ; 玩家行動
    call playerTurn

    ; 增加回合數
    inc dword ptr [rounds]

    ; 繼續回合循環
    jmp round_loop

game_end:
    ; 計算遊戲結束時間
    call GetSystemTime
    call calculateElapsedTime ; 計算花費時間

    ; 顯示遊戲結束訊息
    mov edx, offset prompt8
    call WriteString
    mov eax, [score]
    call WriteInt
    mov edx, offset prompt9
    call WriteString
    ; 輸出時間
    call WriteReal8

    ; 問玩家是否再來一局
    mov edx, offset prompt3
    call WriteString
    call ReadInt
    mov [playAgain], eax
    cmp eax, 1
    jne exit_game
    jmp game_loop

exit_game:
    ; 顯示結束訊息
    mov edx, offset prompt1
    call WriteString
    exit

; 顯示地圖函數
printGrid PROC
    ; 顯示每行
    mov ecx, 0         ; 行數 i
print_row:
    cmp ecx, GRID_SIZE
    jge print_done     ; 結束顯示
    ; 顯示每列
    mov ebx, 0         ; 列數 j
print_col:
    cmp ebx, GRID_SIZE
    jge next_row       ; 下一行

    ; 計算偏移量
    mov eax, ecx
    mov edx, ebx
    mov esi, GRID_SIZE
    imul eax, esi     ; eax = i * GRID_SIZE
    imul edx, 4       ; j * 4
    add eax, edx      ; eax = (i * GRID_SIZE + j) * 4
    lea edi, [grid + eax] ; 計算實際偏移量

    ; 讀取 grid[i][j] 的值
    mov eax, [edi]
    cmp eax, 0
    je print_empty
    mov edx, offset prompt5 ; 顯示打中
    call WriteString
    jmp next_col

print_empty:
    mov edx, offset prompt6  ; 顯示沒打中
    call WriteString
next_col:
    inc ebx
    jmp print_col

next_row:
    inc ecx
    jmp print_row

print_done:
    ret
printGrid ENDP

; 隨機產生地鼠位置函數
generateMole PROC
    ; 隨機選擇地鼠位置
    call RandomRange  ; 範圍是 0 到 2
    mov eax, edx      ; 保存隨機數，行索引
    call RandomRange  ; 範圍是 0 到 2
    mov ebx, edx      ; 保存隨機數，列索引
    ; 清空地圖
    mov ecx, 0
    mov edx, GRID_SIZE_SQ
clear_grid:
    lea edi, [grid + ecx*4]
    mov [edi], 0
    inc ecx
    cmp ecx, edx
    jl clear_grid
    ; 設定隨機位置為地鼠
    lea edi, [grid + eax*GRID_SIZE*4 + ebx*4]
    mov dword ptr [edi], 1
    ret
generateMole ENDP

; 玩家行動函數
playerTurn PROC
    ; 請玩家輸入位置並檢查是否正確
    mov edx, offset prompt4
    call WriteString
    call ReadInt   ; 讀取行
    mov eax, eax   ; 保存行
    call ReadInt   ; 讀取列
    mov ebx, eax   ; 保存列
    ; 輸入轉換為 0 基數索引
    dec eax        ; 行索引 - 1
    dec ebx        ; 列索引 - 1

    ; 檢查行列有效性
    cmp eax, 0
    jl invalid_input
    cmp eax, GRID_SIZE
    jge invalid_input
    cmp ebx, 0
    jl invalid_input
    cmp ebx, GRID_SIZE
    jge invalid_input

    ; 計算偏移量並檢查是否打中地鼠
    mov esi, GRID_SIZE
    imul eax, esi     ; eax = row * GRID_SIZE
    imul ebx, 4       ; col * 4
    add eax, ebx      ; eax = (row * GRID_SIZE + col) * 4
    lea edi, [grid + eax] ; 計算偏移量

    mov edx, [edi]
    cmp edx, 1
    je hit_mole
    mov edx, offset prompt6
    call WriteString
    ret

hit_mole:
    mov edx, offset prompt5
    call WriteString
    inc dword ptr [score]  ; 增加分數
    ret

invalid_input:
    mov edx, offset prompt7
    call WriteString
    ret
playerTurn ENDP

; 計算遊戲花費時間函數
calculateElapsedTime PROC
    ; 計算時間差
    fld QWORD PTR [endTime]
    fsub QWORD PTR [startTime]
    fstp QWORD PTR [elapsedTime] ; 輸出花費時間
    ret
calculateElapsedTime ENDP
END main
