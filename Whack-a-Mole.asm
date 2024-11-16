section .data
    grid db 0, 0, 0, 0, 0, 0, 0, 0, 0     ; 地圖 3x3 的陣列 (預設全為空)
    max_rounds db 5                      ; 最大回合數
    score db 0                           ; 玩家得分
    round db 0                           ; 當前回合數
    prompt db "請輸入行與列 (以 1 開始計算): ", 0
    success_msg db "打中了！", 10, 0
    fail_msg db "沒打中。", 10, 0
    result_msg db "遊戲結束！您的總得分是: ", 0
    newline db 10, 0
    time_msg db "完成時間: ", 0

section .bss
    start_time resq 1                   ; 開始時間
    end_time resq 1                     ; 結束時間

section .text
    global _start

_start:
    ; 初始化遊戲環境
    call seed_random                     ; 初始化隨機數
    mov byte [score], 0                  ; 分數歸零
    mov byte [round], 0                  ; 回合數歸零

    ; 紀錄開始時間
    call get_time
    mov [start_time], rax

game_loop:
    ; 檢查是否達到最大回合
    cmp byte [round], [max_rounds]
    jae game_end

    ; 清空地圖並生成隨機地鼠
    call clear_grid
    call generate_mole

    ; 提示玩家輸入
    mov rdi, prompt
    call print_string

    ; 讀取玩家輸入
    call get_player_input

    ; 判斷是否擊中地鼠
    call check_hit

    ; 回合數加一
    inc byte [round]
    jmp game_loop

game_end:
    ; 紀錄結束時間
    call get_time
    mov [end_time], rax

    ; 顯示分數
    mov rdi, result_msg
    call print_string
    movzx rax, byte [score]
    call print_int
    mov rdi, newline
    call print_string

    ; 計算完成時間並顯示
    mov rax, [end_time]
    sub rax, [start_time]
    mov rdi, time_msg
    call print_string
    call print_time
    mov rdi, newline
    call print_string

    ; 程式結束
    mov eax, 60          ; 系統呼叫: exit
    xor edi, edi         ; 狀態碼: 0
    syscall

; ====== 子程式 ======

; 清空地圖
clear_grid:
    mov rcx, 9
    lea rdi, [grid]
clear_loop:
    mov byte [rdi], 0
    inc rdi
    loop clear_loop
    ret

; 隨機生成地鼠
generate_mole:
    mov rax, 9
    call random
    movzx rbx, al
    mov byte [grid + rbx], 1
    ret

; 讀取玩家輸入
get_player_input:
    call read_int     ; 讀取行
    dec rax           ; 轉換為 0 基礎
    mov rbx, rax

    call read_int     ; 讀取列
    dec rax           ; 轉換為 0 基礎

    ; 計算索引 (row * 3 + col)
    lea rcx, [rbx * 3]
    add rcx, rax
    ret

; 判斷是否擊中地鼠
check_hit:
    movzx rax, byte [grid + rcx]
    cmp al, 1
    jne miss

    ; 打中
    mov rdi, success_msg
    call print_string
    inc byte [score]
    ret

miss:
    ; 沒打中
    mov rdi, fail_msg
    call print_string
    ret

; 獲取當前時間
get_time:
    rdtsc                 ; 獲取時間戳計數
    ret

; 隨機數生成
random:
    ; 簡化的隨機數生成 (模擬)
    xor rax, rax
    rdtsc
    xor rdx, rdx
    div byte [max_rounds] ; 限制範圍
    ret

; 初始化隨機數
seed_random:
    ; 假設隨機生成器初始化，這裡可擴展實現
    ret

; ====== 輸入輸出子程式 ======

; 打印字串
print_string:
    mov rax, 1         ; 系統呼叫號碼 (write)
    mov rdi, 1         ; 檔案描述符 (stdout)
    mov rsi, rdi       ; 字串地址
    mov rdx, 64        ; 預設字串長度
    syscall
    ret

; 讀取整數
read_int:
    ; 簡化模擬，假設讀取整數並返回至 rax
    xor rax, rax
    ret

; 打印整數
print_int:
    ; 模擬整數輸出 (實際需實現數字轉字串)
    ret

; 打印時間
print_time:
    ; 模擬輸出經過時間 (秒)
    ret
