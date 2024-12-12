INCLUDE Irvine32.inc
;INCLUDELIB Irvine32.lib
;INCLUDELIB kernel32.lib

.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD


.data
select DWORD 0                 ; 儲存用戶選擇的選項
input_format DB "%d", 0        
invalid_msg DB "Invalid input, please try again.", 0Ah, 0
exit_msg DB "Exiting the program. Goodbye!", 0Ah, 0

msg1 DB "Guess Number Game", 0
msg2 DB "1. Start Game",  0
msg3 DB "2. Help",  0
msg4 DB "3. Exit",  0
msg5 DB "Please enter (1-3): ", 0
msg6 DB "         Welcome to the program", 0  ; 9 個空格
msg7 DB "Game Instructions: Enter a four-digit number...", 0
msg8 DB "X indicates how many digits are correct and in the correct position.", 0
msg9 DB "Y indicates how many digits are correct but in the wrong position.", 0
msg10 DB "Press any key to continue............", 0
msg11 DB "You took XX seconds to complete the game.",  0

.code
main PROC
main_loop:
   ; push OFFSET msg1
    ;call WriteString
    ;call Crlf
    ;call menu  ; 呼叫 menu 副程式
    lea eax, select
    push eax
    
    call ReadInt
    mov [select], eax           ; 將讀取的整數存入 select 變數
    cmp eax, 1
    jl invalid_input ; 如果輸入小於1，跳轉到錯誤訊息
    cmp eax, 3
    jg invalid_input ; 如果輸入大於3，跳轉到錯誤訊息

    ; 比較選擇的選項
    mov eax, [select]
    cmp eax, 2                 ; 若選擇 2，進入幫助功能
    je help

    cmp eax, 3                 ; 若選擇 3，退出程式
    je exit_label

    push OFFSET invalid_msg
    call WriteString
    call Crlf             ; 換行
    call WaitMsg          ; 等待用戶按鍵
    add esp, 4
    jmp main_loop

invalid_input:
push OFFSET invalid_msg
    call WriteString
    call Crlf
exit_label:
    push OFFSET exit_msg
    call WriteString
    
    call Crlf             ; 換行
    call WaitMsg          ; 等待用戶按鍵
    add esp, 4
    INVOKE ExitProcess, 0
main ENDP

menu PROC
    push OFFSET msg1
    call WriteString
    call Crlf             ; 換行

    ;call WaitMsg          ; 等待用戶按鍵
    ;add esp, 4

    push OFFSET msg2
    call WriteString
    call Crlf             ; 換行
    ;call WaitMsg          ; 等待用戶按鍵
    ;add esp, 4

    push OFFSET msg3
    call WriteString
    call Crlf             ; 換行
    ;call WaitMsg          ; 等待用戶按鍵
    ;add esp, 4

    push OFFSET msg4
    call WriteString
    call Crlf             ; 換行
    ;call WaitMsg          ; 等待用戶按鍵
    ;add esp, 4

    push OFFSET msg5
    call WriteString
    call Crlf             ; 換行
    ;call WaitMsg          ; 等待用戶按鍵
    ;add esp, 4

    ret
menu ENDP

help PROC
    push OFFSET msg6
    call WriteString
    
    call Crlf             ; 換行
    call WaitMsg          ; 等待用戶按鍵
    add esp, 4
    ret
help ENDP


 
 same PROC
    push ebp
    mov ebp, esp
    sub esp, 4              ; 分配局部變量 u
    mov DWORD PTR [ebp-4], 0 ; u = 0

    mov ecx, 0              ; i = 0
outer_loop:
    cmp ecx, 3              ; if (i >= 3)
    jge end_outer_loop      ; 跳到外層循環結束

    mov edx, ecx            ; j = i
    inc edx                 ; j = i + 1
inner_loop:
    cmp edx, 4              ; if (j >= 4)
    jge end_inner_loop      ; 跳到內層循環結束

    ; 比較 num[i] 和 num[j]
    mov eax, DWORD PTR [ebp+8+ecx*4] ; num[i]
    cmp eax, DWORD PTR [ebp+8+edx*4] ; num[j]
    jne no_match

    mov DWORD PTR [ebp-4], 1 ; u = 1
    jmp end_inner_loop

no_match:
    inc edx
    jmp inner_loop

end_inner_loop:
    inc ecx
    jmp outer_loop



end_outer_loop:
    mov eax, DWORD PTR [ebp-4] ; 返回 u
    mov esp, ebp
    pop ebp
    ret
same ENDP



record_time PROC
    push ebp
    mov ebp, esp

    ; 計算時間差
    push DWORD PTR [ebp+12] ; end_time
    push DWORD PTR [ebp+8]  ; start_time
    call difftime
    add esp, 8             ; 恢復堆疊平衡

    ; 保存結果到堆疊
    sub esp, 8
    fstp QWORD PTR [esp]

    ; 打印時間
    push OFFSET msg11
    push esp               ; time_taken
    call WriteString
    
    call Crlf             ; 換行
    call WaitMsg          ; 等待用戶按鍵
    add esp, 12

    mov esp, ebp
    pop ebp
    ret
record_time ENDP

; 自製 difftime 功能：計算時間差
; 參數：
;   [ebp+8]  - start_time (DWORD)
;   [ebp+12] - end_time (DWORD)
; 返回：
;   eax      - 時間差 (DWORD)

difftime PROC
    push ebp
    mov ebp, esp           ; 建立堆疊框架

    mov eax, DWORD PTR [ebp+12] ; end_time
    sub eax, DWORD PTR [ebp+8]  ; 計算時間差 (end_time - start_time)

    mov esp, ebp           ; 恢復堆疊
    pop ebp
    ret
difftime ENDP



end main


