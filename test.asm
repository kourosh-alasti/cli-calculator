section .data
  prompt1 db "Enter equation: ", 0
  prompt2 db "Result: ", 0

section .bss
  equation resb 8

section .text
  global _start

_start: 

  mov rax, 0    ; SYS_Read
	mov rdi, 0    ; Read from STD_IN
	mov rsi, equation   ; Address of %1
	mov rdx, 8
  int 0x80
  
  mov eax, [equation+1]
  mov ebx, [equation+2]
  mov ecx, [equation+4]
  mov edx, [equation+6]

  cmp byte[equation+1], '+'
  je PLUS 

  cmp byte[equation+1], '-'
  je MINUS

  cmp byte[equation+1], '*'
  je TIME

  cmp byte[equation+1], '/'
  je DIVIDE

PLUS:
  add eax, ebx
  jmp display

MINUS: 
  sub eax, ebx 
  jmp display

TIME:
  mul ebx 
  jmp display

DIVIDE: 
  div ebx 
  jmp display

display:
  mov eax, 4
  mov ebx, 1
  mov ecx, prompt1
  mov edx, 16
  int 0x80

  mov eax, 4
  mov ebx, 1
  mov ecx, equation
  mov edx, 8
  int 0x80

  mov eax, 4
  mov ebx, 1
  mov ecx, prompt2
  mov edx, 8
  int 0x80

  mov eax, 4
  mov ebx, 1
  mov ecx, eax
  mov edx, 4
  int 0x80

  mov eax, 1
  mov ebx, 0
  int 0x80