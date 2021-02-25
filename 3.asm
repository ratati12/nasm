section .bss
fd resb 4
buffer resb 1
section .text:
global _start
_start:

pop ebx
pop ebx
pop ebx
mov eax, 5 ; sys_open
mov ecx, 0
mov edx, 0
int 0x80

mov [fd], eax
write:
mov eax, 3 ; sys_read
mov ebx, [fd]
mov ecx, buffer
mov edx, 1
int 0x80

cmp eax, 1
jl exit

mov eax, 4
mov ebx, 1
mov ecx, buffer
mov edx, 1
int 0x80
jmp write

exit:
mov eax, 1
mov ebx, 0
int 0x80
