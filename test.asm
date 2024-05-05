.file "test.asm"
.intel_syntax noprefix
.globl _start

main:
    # write syscall
    mov rax, 0x1
    # write syscall arguments
    mov rdi, 0x1
    mov rsi, rsp
    sub rsi, 0x10
    mov rdx, 0x0c
    # write string to stack
    mov QWORD PTR [rsi], 0x6c6c6548
    mov QWORD PTR [rsi+4], 0x6f77206f
    mov QWORD PTR [rsi+8], 0x21646c72
    syscall
    # Not sure if zeroing everything is required, but probably good to prevent side effects
    mov QWORD PTR [rsi], 0x00000000
    mov QWORD PTR [rsi+4], 0x00000000
    mov QWORD PTR [rsi+8], 0x00000000
    mov rdi, 0x0
    mov rsi, 0x0
    mov rdx, 0x0
    ret

_start:
    call main
    mov rax, 0x3c
    syscall
