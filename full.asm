INCLUDE Irvine32.inc
.DATA
    menuMsg BYTE "Guess Number Game", 0
    menuOptions BYTE "1. Start Game", 0, 13, 10
    BYTE "2. Help", 0, 13, 10
    BYTE "3. Exit", 0, 13, 10
    BYTE "Please enter (1-3):", 0
    invalidInput BYTE "Invalid input, please re-enter!", 0
    helpMsg BYTE "Welcome to the program", 13, 10
    BYTE "Game Instructions:", 13, 10
    BYTE "Enter a four-digit number...", 0
    successMsg BYTE "Congratulations, game successful!", 0
    failedMsg BYTE "Game failed!", 0
    correctAnswerMsg BYTE "The correct answer is: ", 0
    timeMsg BYTE "You took %.2f seconds to complete the game.", 0
    inputPrompt BYTE "Please input your guess of the four digits", 0
    invalidGuess BYTE "Invalid input! Please try again.", 0
    replayMsg BYTE "Enter 1 to continue the game,", 0
    BYTE "Enter 2 to return to the menu,", 0
    BYTE "Enter 0 to exit the game:", 0
    randomNums DWORD 0, 0, 0, 0
    userGuess DWORD 0, 0, 0, 0
    startTime DWORD 0
    endTime DWORD 0
    attempts DWORD 0
    ACount DWORD 0
    BCount DWORD 0
.CODE
main PROC
    ; 初始化訊息
    call menu

    ; 主選單循環
menuLoop:
    call GetInput
    cmp eax, 1
    je startGame
    cmp eax, 2
    je showHelp
    cmp eax, 3
    je exitProgram
    ; 錯誤輸入處理
    mov edx, OFFSET invalidInput
    call WriteString
    jmp menuLoop

startGame:
    ; 初始化遊戲
    call GenerateRandomNumbers
    call GameLoop
    jmp menuLoop

showHelp:
    ; 顯示說明
    mov edx, OFFSET helpMsg
    call WriteString
    call Crlf
    jmp menuLoop

exitProgram:
    ; 程式結束
    call Exit

GameLoop PROC
    mov attempts, 0
guessLoop:
    ; 提示玩家輸入
    mov edx, OFFSET inputPrompt
    call WriteString
    call GetInput ; 玩家輸入的四位數
    ; 驗證輸入
    cmp eax, 1000
    jl invalidGuess
    cmp eax, 9999
    jg invalidGuess
    ; 分析猜測
    call CompareNumbers
    cmp ACount, 4
    je gameSuccess
    inc attempts
    cmp attempts, 8
    jle guessLoop
    ; 遊戲失敗
    mov edx, OFFSET failedMsg
    call WriteString
    jmp replayMenu

invalidGuess:
    ; 錯誤猜測輸入
    mov edx, OFFSET invalidGuess
    call WriteString
    jmp guessLoop

gameSuccess:
    ; 遊戲成功
    mov edx, OFFSET successMsg
    call WriteString

replayMenu:
    mov edx, OFFSET replayMsg
    call WriteString
    call GetInput
    cmp eax, 1
    je startGame
    cmp eax, 2
    jmp menuLoop
    cmp eax, 0
    call Exit

GenerateRandomNumbers PROC
    ; 初始化隨機數字生成
    mov ecx, 4
generateLoop:
    call RandomRange
    add eax, '0'
    mov randomNums[ecx * 4 - 4], eax
    loop generateLoop
    ret
GenerateRandomNumbers ENDP

CompareNumbers PROC
    ; 比較玩家猜測和隨機數
    ; TODO: 添加具體比較邏輯
    ret
CompareNumbers ENDP

GetInput PROC
    ; 獲取玩家輸入
    call ReadInt
    ret
GetInput ENDP
