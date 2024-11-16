INCLUDE Irvine32.inc

.data
GRID_SIZE DWORD 3                 ; 地圖大小 3x3
MAX_ROUNDS DWORD 5                ; 最大回合數
grid DWORD 9 DUP(0)               ; 地圖初始化
score DWORD 0                     ; 玩家得分
rounds DWORD 0                    ; 回合數
playAgain DWORD 1                 ; 是否繼續遊戲
msgWelcome BYTE "歡迎來到打地鼠遊戲！", 0
msgMapSize BYTE "地圖大小為 ", 0
msgX BYTE "x", 0
msgEachRound BYTE "，每回合隨機出現一隻地鼠。", 0
msgRound BYTE "第 ", 0
msgRoundEnd BYTE " 回合：", 0
msgEnd BYTE "遊戲結束！您的總得分是：", 0
msgSlash BYTE "/", 0
msgTime BYTE "回合結束！", 0
msgPlayAgain BYTE "是否要再來一局？(1: 是, 0: 否)：", 0
msgHit BYTE "打中了！", 0
msgMiss BYTE "沒打中。", 0
msgInvalid BYTE "輸入無效，請輸入正確的行與列。", 0
msgThanks BYTE "感謝遊玩！再見！", 0
msgMap BYTE "地圖：", 0
moleSymbol BYTE "[*] ", 0
emptySymbol BYTE "[ ] ", 0
inputPrompt BYTE "請輸入您要打的行與列（以空格分隔，從 1 開始計算）：", 0

.code
main PROC
    ; 初始化遊戲
    call Randomize
    mov edx, OFFSET msgWelcome
    call WriteString
    call Crlf

    mov edx, OFFSET msgMapSize
    call WriteString
    mov eax, GRID_SIZE
    call WriteDec
    mov edx, OFFSET msgX
    call WriteString
    mov eax, GRID_SIZE
    call WriteDec
    mov edx, OFFSET msgEachRound
    call WriteString
    call Crlf

gameLoop:
    ; 初始化
    call InitGrid
    mov score, 0
    mov rounds, 0

mainLoop:
    ; 遊戲主迴圈
    cmp rounds, MAX_ROUNDS
    jge gameOver

    ; 顯示回合數
    inc rounds
    mov edx, OFFSET msgRound
    call WriteString
    mov eax, rounds
    call WriteDec
    mov edx, OFFSET msgRoundEnd
    call WriteString
    call Crlf

    ; 產生地鼠
    call GenerateMole

    ; 顯示地圖
    call PrintGrid

    ; 玩家行動
    call PlayerTurn
    add score, eax
    jmp mainLoop

gameOver:
    ; 遊戲結束處理
    mov edx, OFFSET msgEnd
    call WriteString
    mov eax, score
    call WriteDec
    mov edx, OFFSET msgSlash
    call WriteString
    mov eax, MAX_ROUNDS
    call WriteDec
    call Crlf

    ; 是否再來一局
    mov edx, OFFSET msgPlayAgain
    call WriteString
    call ReadInt
    mov playAgain, eax
    cmp playAgain, 1
    je gameLoop

    ; 結束遊戲
    mov edx, OFFSET msgThanks
    call WriteString
    exit

main ENDP

; 初始化地圖
InitGrid PROC
    lea esi, grid
    mov ecx, 9                  ; 清空地圖 (3x3)
InitLoop:
    mov DWORD PTR [esi], 0
    add esi, 4
    loop InitLoop
    ret
InitGrid ENDP

; 隨機生成地鼠位置
GenerateMole PROC
    ; 清空地圖
    call InitGrid

    ; 隨機選擇地鼠位置
    mov eax, 9                  ; GRID_SIZE * GRID_SIZE
    call RandomRange
    lea esi, grid
    mov DWORD PTR [esi + eax * 4], 1
    ret
GenerateMole ENDP

; 顯示地圖
PrintGrid PROC
    mov edx, OFFSET msgMap
    call WriteString
    call Crlf

    lea esi, grid
    mov ecx, GRID_SIZE
PrintRow:
    push ecx
    mov ecx, GRID_SIZE
PrintCol:
    mov eax, DWORD PTR [esi]
    cmp eax, 1
    je PrintMole
    mov edx, OFFSET emptySymbol
    jmp WriteSymbol
PrintMole:
    mov edx, OFFSET moleSymbol
WriteSymbol:
    call WriteString
    add esi, 4
    loop PrintCol
    call Crlf
    pop ecx
    loop PrintRow
    ret
PrintGrid ENDP

; 玩家行動
PlayerTurn PROC
    mov edx, OFFSET inputPrompt
    call WriteString
    call ReadInt
    mov ebx, eax                ; row
    call ReadInt
    mov ecx, eax                ; col

    dec ebx
    dec ecx
    cmp ebx, 0
    jl InvalidInput
    cmp ebx, 2
    jg InvalidInput
    cmp ecx, 0
    jl InvalidInput
    cmp ecx, 2
    jg InvalidInput

    ; 檢查地鼠
    lea esi, grid
    imul ebx, 3
    add ebx, ecx
    mov eax, DWORD PTR [esi + ebx * 4]
    cmp eax, 1
    jne Missed
    mov edx, OFFSET msgHit
    call WriteString
    mov eax, 1
    ret

Missed:
    mov edx, OFFSET msgMiss
    call WriteString
    xor eax, eax
    ret

InvalidInput:
    mov edx, OFFSET msgInvalid
    call WriteString
    xor eax, eax
    ret
PlayerTurn ENDP

END main
