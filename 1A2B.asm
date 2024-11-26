
INCLUDE Irvine32.inc

.DATA
menuText BYTE "猜數字遊戲", 0
optionText BYTE "1. 開始遊戲", 0
helpText BYTE "遊戲規則：輸入四位數字，X 表示數字位置正確，Y 表示數字正確但位置錯誤。", 0
exitText BYTE "3. 退出", 0
invalidInput BYTE "輸入不合法，請重新輸入！", 0
successText BYTE "恭喜，遊戲成功！", 0
failureText BYTE "遊戲失敗！", 0
correctAnswer BYTE "正確答案是：", 0

.CODE
main PROC
    call Menu          ; 顯示選單
    call GetInput      ; 取得玩家選擇
    cmp eax, 1         ; 判斷玩家選擇
    je StartGame
    cmp eax, 2
    je Help
    cmp eax, 3
    je ExitProgram
    jmp InvalidInput

Menu PROC
    ; 顯示主選單
    mov edx, OFFSET menuText
    call WriteString
    call Crlf
    mov edx, OFFSET optionText
    call WriteString
    call Crlf
    mov edx, OFFSET exitText
    call WriteString
    call Crlf
    ret
Menu ENDP

Help PROC
    ; 顯示遊戲規則
    mov edx, OFFSET helpText
    call WriteString
    call Crlf
    call Crlf
    ret
Help ENDP

StartGame PROC
    ; 遊戲主邏輯
    ; 略：需要隨機數生成、輸入比較等
    ret
StartGame ENDP

GetInput PROC
    ; 獲取用戶輸入
    call ReadInt
    ret
GetInput ENDP

InvalidInput PROC
    ; 無效輸入提示
    mov edx, OFFSET invalidInput
    call WriteString
    call Crlf
    ret
InvalidInput ENDP

ExitProgram PROC
    ; 程式退出
    exit
ExitProgram ENDP

END main 