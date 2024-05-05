.file "test.asm"
.intel_syntax noprefix
.globl _start

foo:
    mov rax, 0x3c
    ret

_start:
    call foo
    syscall
