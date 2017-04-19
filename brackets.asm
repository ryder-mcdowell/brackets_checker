section .bss

input resb 100
inputlen equ $-input

section .data

numbytes dd 0

errorm	db	"Error: unbalanced brackets", 0xa
len	equ	$-errorm

section .text

global _start

_start:

	mov eax,3	; sys_read
	mov ebx,0	; stdin
	mov ecx,input
	mov edx,inputlen
	int 0x80

	mov [numbytes],eax
	mov edx,[numbytes]

	mov ebp,esp

	mov esi,input

loop:
	cmp [esi],byte '('
	je pushh
	cmp [esi],byte '['
	je pushh
	cmp [esi],byte '{'
	je pushh
	cmp [esi],byte ')'
	je popp1
	cmp [esi],byte ']'
	je popp2
	cmp [esi],byte '}'
	je popp3

	inc esi

	dec edx
	cmp edx,0
	je end
	jne loop

error:
	mov eax,4	; sys_write
	mov ebx,1	; stdout
	mov ecx,errorm
	mov edx,len
	int 0x80

	mov eax,1	; sys_exit
	int 0x80

popp1:
	inc esi
	pop eax
	cmp al,byte '('
	je loop
	jne error

popp2:
	inc esi
	pop eax
	cmp al,byte '['
	je loop
	jne error

popp3:
	inc esi
	pop eax
	cmp al,byte '{'
	je loop
	jne error

pushh:
	push dword [esi]	; ax
	inc esi
	jmp loop

end:
	cmp ebp,esp
	jne error

	mov eax,4	; sys_write
	mov ebx,1	; stdout
	mov ecx,input
	mov edx,inputlen
	int 0x80

	mov eax,1	; sys_exit
	int 0x80
