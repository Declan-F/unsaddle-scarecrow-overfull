.file "calculatorprogram.asm"
.intel_syntax noprefix
.globl _start
# Define constants
.set READSIZE, 0xe

.set ALLOCATED_READSIZE, READSIZE+1

errmessage: .string "There was an error processing your request!\n"

; # Searches string pointed to by RSI with length of rdx, returns the last location of the char in RDI in RCX.
; findChar:
;     # INIT
;     sub rsp, 0x8
;     mov QWORD PTR [rsp], rdx
;     # MAIN
;     mov rcx, rdx
;     _findchar_loop:
;     # We do not need length anymore, so we are reusing rdx for the other character we are comparing
;     movzx rdx, BYTE PTR [rsi+rcx] 
;     cmp rdi, rdx
;     je _findchar_end
;     loop _findchar_loop
;     _findchar_end:
;     # EXIT
;     mov rdx, QWORD PTR [rsp]
;     add rsp, 0x8
;     ret

; findParenthesis:
;     mov rdi, ')'
;     call findChar
;     # save location of right parenthesis
;     mov rax, rcx
;     mov rdi, '('
;     call findChar
;     cmp rax, rcx
;     je _no_parenthesis_found
;     # Both parenthesis found
;     mov rdi, 0xFF
;     ret
;     _no_parenthesis_found:
;     mov rdi, 0x00
;     ret


# Validates parenthesis in the string pointed to by RSI with a length of RDX.
validateParenthesis:
    # INIT
    sub rsp, 0x18
    mov QWORD PTR [rsp], rdx
    mov QWORD PTR [rsp+0x8], rcx
    mov QWORD PTR [rsp+0x10], rax
    # MAIN
    mov rcx, rdx
    inc rcx # Adding one due to loop decrementing then checking, rather than checking first
    xor rdx, rdx
    _validateParenthesis_loop:
    movzx rax, byte PTR [rsi+rcx-1]
    cmp rax, ')'
    je _validateParenthesis_inc
    cmp rax, '('
    jne _validateParenthesis_loop_end
    dec rdx
    jmp _validateParenthesis_loop_end
    _validateParenthesis_inc:
    inc rdx
    _validateParenthesis_loop_end:
    cmp rdx, -1
    je errhandle
    loop _validateParenthesis_loop
    cmp rdx, 0
    jne errhandle
    mov rdx, QWORD PTR [rsp]
    mov rcx, QWORD PTR [rsp+0x8]
    mov rax, QWORD PTR [rsp+0x10]
    add rsp, 0x18
    # EXIT
    ret

calculateoperator:
    call validateParenthesis
    ret

main:
    # initial read syscall
    sub rsp, ALLOCATED_READSIZE
    mov rax, 0x0
    mov rdi, 0x0
    mov rdx, READSIZE
    mov rsi, rsp
    syscall
    call calculateoperator
    add rsp, ALLOCATED_READSIZE
    ret

_start:
    call main
    mov rax, 0x3c
    syscall


errhandle:
    # Write error message
    mov rax, 0x1
    mov rdi, 0x1
    lea rsi, [rip + errmessage]
    mov rdx, 0x2C
    syscall
    # Exit
    mov rax, 0x3c
    syscall
