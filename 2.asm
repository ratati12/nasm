section .bss
fd resb 4
buffer resb 10
size resb 10

section .data
msg db 0x0

section .text
global _start
_start:
pop ebx 
pop ebx
pop ebx
push ebx
mov eax, 5 ; sys_open
mov ecx, 2
mov edx, 0
int 0x80
mov [fd], eax ; save fd

count:
mov eax, 3 ; sys_read
mov ebx, [fd]
mov ecx, buffer
mov edx, 1
int 0x80

add [size], eax

cmp eax, 1
jl exit
jmp count

exit:

mov eax, 19 ;sys_lseek
mov ebx, [fd]
mov ecx, 0
mov edx, 0
int 0x80

mov ecx, [size]
null:
push ecx
mov eax, 4
mov ebx, [fd]
mov ecx, msg
mov edx, 1
int 0x80
pop ecx
loop null

mov eax,6; sys_close
mov ebx, [fd]
int 0x80

pop ebx
mov eax, 10
int 0x80

mov eax, 1
mov ebx, 0
int 0x80
