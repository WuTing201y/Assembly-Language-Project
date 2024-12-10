INCLUDE Irvine32.inc
.386
.model flat, stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD


.data
select DWORD ?                 ; �x�s�Τ��ܪ��ﶵ
input_format DB "%d", 0        ; �Ω� scanf ���榡�r��
invalid_msg DB "Invalid input, please try again.", 0Ah, 0
exit_msg DB "Exiting the program. Goodbye!", 0Ah, 0

msg1 DB "Guess Number Game", 0Ah, 0Ah, 0
msg2 DB "1. Start Game", 0Ah, 0
msg3 DB "2. Help", 0Ah, 0
msg4 DB "3. Exit", 0Ah, 0
msg5 DB "Please enter (1-3): ", 0
msg6 DB 9 DUP(' '), "Welcome to the program", 0Ah, 0Ah, 0Ah, 0
msg7 DB "Game Instructions: Enter a four-digit number...", 0
msg8 DB "X indicates how many digits are correct and in the correct position.", 0
msg9 DB "Y indicates how many digits are correct but in the wrong position.", 0
msg10 DB "Press any key to continue............", 0
msg11 DB "You took %.2f seconds to complete the game.", 0Ah, 0Ah, 0

.code
main PROC
main_loop:
    call menu                  ; �I�s menu �Ƶ{��
    lea eax, select
    push eax
    push OFFSET input_format
    call scanf
    add esp, 8

    mov eax, select
    cmp eax, 2                 ; �Y��� 2�A�i�J���U�\��
    je help

    cmp eax, 3                 ; �Y��� 3�A�h�X�{��
    je exit

    push OFFSET invalid_msg
    call WriteString
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4
    jmp main_loop

exit:
    push OFFSET exit_msg
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4
    INVOKE ExitProcess, 0
main ENDP

menu PROC
    push OFFSET msg1
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4

    push OFFSET msg2
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4

    push OFFSET msg3
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4

    push OFFSET msg4
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4

    push OFFSET msg5
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4

    ret
menu ENDP

help PROC
    push OFFSET msg6
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 4
    ret
help ENDP


 
 same PROC
    push ebp
    mov ebp, esp
    sub esp, 4              ; ���t�����ܶq u
    mov DWORD PTR [ebp-4], 0 ; u = 0

    mov ecx, 0              ; i = 0
outer_loop:
    cmp ecx, 3              ; if (i >= 3)
    jge end_outer_loop      ; ����~�h�`������

    mov edx, ecx            ; j = i
    inc edx                 ; j = i + 1
inner_loop:
    cmp edx, 4              ; if (j >= 4)
    jge end_inner_loop      ; ���줺�h�`������

    ; ��� num[i] �M num[j]
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
    mov eax, DWORD PTR [ebp-4] ; ��^ u
    mov esp, ebp
    pop ebp
    ret
same ENDP

record_time PROC
    push ebp
    mov ebp, esp

    ; �p��ɶ��t
    push DWORD PTR [ebp+12] ; end_time
    push DWORD PTR [ebp+8]  ; start_time
    call difftime
    add esp, 8             ; ��_���|����

    ; �O�s���G����|
    sub esp, 8
    fstp QWORD PTR [esp]

    ; ���L�ɶ�
    push OFFSET msg11
    push esp               ; time_taken
    call WriteString
    
    call Crlf             ; ����
    call WaitMsg          ; ���ݥΤ����
    add esp, 12

    mov esp, ebp
    pop ebp
    ret
record_time ENDP



end main
