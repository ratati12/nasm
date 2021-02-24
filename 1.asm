section .bss
fd resb 4
fd1 resb 4
buffer resb 1
size resb 10
size2 resb 4
temp resb 1

section .data
tempfile db 'temp.txt'
len equ $ - tempfile
n db ' bytes', 0xA


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
mov edx, 1
mov [size2], edx
mov [fd], eax ; save fd

mov eax, 8 ; sys_create tempfile
mov ebx, tempfile
mov ecx, 420
int 0x80

mov eax, 5
mov ebx, tempfile
mov ecx, 2
mov edx, 0
int 0x80

mov [fd1], eax ; save fd1

count: ; ------------start count
mov eax, 3 ; sys_read
mov ebx, [fd]
mov ecx, buffer
mov edx, 1
int 0x80

add [size], eax

cmp eax, 1
jl exit
jmp count
exit: ; -------------end count:

mov eax, [size]
point:
mov edx, 0
mov ecx, 10
div ecx
add edx, 0x30
mov [temp], edx
push eax

mov eax, 4 ; sys_write
mov ebx, [fd1]
mov ecx, temp
mov edx, 1
int 0x80
mov edx, [size2]
inc edx
mov [size2], edx

pop eax
cmp eax, 10
jl quit
jmp point

quit:
add eax, 0x30
mov [size], eax
mov eax, 4 ; sys_write
mov ebx, [fd1]
mov ecx, size
mov edx, 1
int 0x80

mov eax, 19 ; sys_lseek tempfile
mov ebx, [fd1]
mov ecx, 0
mov edx, 0

mov ecx, [size2]

out:
push ecx
mov eax, 19 ; sys_lseek
mov ebx, [fd1]
mov ecx, -1
mov edx, 1
int 0x80

mov eax, 3 ; sys_read tempfile
mov ebx, [fd1]
mov ecx, buffer
mov edx, 1
int 0x80

mov eax, 4 ; sys_write from tempfile in stdout
mov ebx, 1
mov ecx, buffer
mov edx, 1
int 0x80

mov eax, 19; sys_lseek
mov ebx, [fd1]
mov ecx, -1
mov edx, 1
int 0x80
pop ecx
loop out

mov eax, 4
mov ebx, 1
mov ecx, n
mov edx, 7
int 0x80

exit1:
mov eax, 6
mov ebx, [fd]
int 0x80

mov eax, 10
mov ebx, tempfile
int 0x80

mov eax, 6
mov ebx, [fd1]
int 0x80

mov eax, 1
mov ebx, 0
int 0x80

