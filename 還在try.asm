
INCLUDE Irvine32.inc

.data
menuMsg BYTE "Guess Number Game", 0Dh, 0Ah, 0
        BYTE "1. Start Game", 0Dh, 0Ah, 0
        BYTE "2. Help", 0Dh, 0Ah, 0
        BYTE "3. Exit", 0Dh, 0Ah, 0
        BYTE "Please enter (1-3): ", 0

helpMsg BYTE "Game Instructions:", 0Dh, 0Ah
        BYTE "Enter a four-digit number.", 0Dh, 0Ah
        BYTE "X indicates how many digits are correct and in the correct position.", 0Dh, 0Ah
        BYTE "Y indicates how many digits are correct but in the wrong position.", 0Dh, 0Ah
        BYTE "Press any key to continue...", 0

guessPrompt BYTE "Please input your guess of the four digits: ", 0
invalidInputMsg BYTE "Invalid input, please re-enter!", 0Dh, 0Ah, 0
winMsg BYTE "Congratulations, game successful!", 0Dh, 0Ah, 0
loseMsg BYTE "Game failed!", 0Dh, 0Ah, 0
correctAnswerMsg BYTE "The correct answer is: ", 0
timeMsg BYTE "You took ", 0
timeSecMsg BYTE " seconds to complete the game.", 0
xaybMsg BYTE "%dA%dB", 0

.data?
userInput DWORD ?
randomNum DWORD 4 DUP(?)
userGuess DWORD 4 DUP(?)
attempt DWORD ?
correctCount DWORD ?
positionCount DWORD ?

.code
main PROC
    call Menu
MainLoop:
    call ReadInt            ; Read user's menu choice
    mov eax, userInput
    cmp eax, 3              ; Check if user chose "Exit"
    je ExitProgram
    cmp eax, 1              ; Check if user chose "Start Game"
    je StartGame
    cmp eax, 2              ; Check if user chose "Help"
    je Help
    call InvalidInput       ; Handle invalid input
    jmp MainLoop            ; Return to menu
main ENDP

Menu PROC
    mov edx, OFFSET menuMsg
    call WriteString
    ret
Menu ENDP

Help PROC
    mov edx, OFFSET helpMsg
    call WriteString
    call WaitMsg
    call Menu
    ret
Help ENDP

StartGame PROC
    call Randomize
    call GenerateRandomNumber
    call PlayGame
    ret
StartGame ENDP

GenerateRandomNumber PROC
    mov ecx, 4              ; Generate 4 digits
GenLoop:
    call RandomRange
    mov randomNum[ecx*4-4], eax ; Store each digit
    loop GenLoop
    ret
GenerateRandomNumber ENDP

PlayGame PROC
    mov attempt, 1          ; Reset attempts
GameLoop:
    mov edx, OFFSET guessPrompt
    call WriteString
    call ReadInt            ; Get user input
    mov eax, userInput

    ; Check if the input is valid (4 digits)
    cmp eax, 1000
    jl InvalidInputInGame
    cmp eax, 9999
    jg InvalidInputInGame

    ; Store user input as separate digits
    mov ecx, 3
InputLoop:
    mov ebx, 10
    xor edx, edx
    div ebx                  ; Extract digit
    mov userGuess[ecx*4], edx
    dec ecx
    cmp ecx, -1
    jge InputLoop

    ; Compare numbers
    call CompareNumbers
    cmp correctCount, 4      ; Check if all digits match
    je Win
    inc attempt
    cmp attempt, 9           ; Check if attempts exceeded
    jl GameLoop

Lose:
    mov edx, OFFSET loseMsg
    call WriteString
    mov edx, OFFSET correctAnswerMsg
    call WriteString
    mov ecx, 4
PrintAnswerLoop:
    mov eax, randomNum[ecx*4-4]
    add eax, '0'
    call WriteChar
    loop PrintAnswerLoop
    ret

InvalidInputInGame:
    mov edx, OFFSET invalidInputMsg
    call WriteString
    jmp GameLoop

Win:
    mov edx, OFFSET winMsg
    call WriteString
    ret
PlayGame ENDP

CompareNumbers PROC
    mov correctCount, 0      ; Reset counters
    mov positionCount, 0

    ; Compare digits for exact matches (correct position)
    mov ecx, 4
CompareExactLoop:
    mov eax, randomNum[ecx*4-4]
    cmp eax, userGuess[ecx*4-4]
    jne SkipExactMatch
    inc correctCount
SkipExactMatch:
    loop CompareExactLoop

    ; Compare digits for matches in wrong position
    mov ecx, 4
OuterLoop:
    mov eax, randomNum[ecx*4-4]
    push ecx
    mov edx, 4
InnerLoop:
    mov ebx, userGuess[edx*4-4]
    cmp eax, ebx
    jne SkipPositionMatch
    inc positionCount
    jmp EndInnerLoop
SkipPositionMatch:
    loop InnerLoop
EndInnerLoop:
    pop ecx
    loop OuterLoop

    ; Display results as XAYB
    mov edx, OFFSET xaybMsg
    mov eax, correctCount
    mov ebx, positionCount
    call WriteDec
    ret
CompareNumbers ENDP

InvalidInput PROC
    mov edx, OFFSET invalidInputMsg
    call WriteString
    call Menu
    ret
InvalidInput ENDP

ExitProgram PROC
    exit
ExitProgram ENDP

END main

