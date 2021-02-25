section .bss
key resb 4
fd resb 4
buffer resb 4
size resb 4
section .text
global _start
_start: 
pop ebx
pop ebx
pop ebx

mov eax, 5 ; sys_open
mov ecx, 2
mov edx, 0
int 0x80

mov [fd], eax

mov eax, 3 ;insert key
mov ebx, 0
mov ecx, key
mov edx, 4
int 0x80

crypt:
mov eax, 3; sys_read
mov ebx, [fd]
mov ecx, buffer
mov edx, 4
int 0x80

cmp eax, 4
jl exit

mov eax, [key]
mov edx, [buffer]
xor edx, eax
mov [buffer], edx

mov eax, 19 ;sys_lseek
mov ebx, [fd]
mov ecx, -4
mov edx, 1
int 0x80

mov ebx, 0
mov eax, 4 ;sys_write
mov ebx, [fd]
mov ecx, buffer
mov edx, 4
int 0x80
jmp crypt
exit:
mov eax, 1
mov ebx, 0
int 0x80
