&macro ostream 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
	ret
%endmacro

section .data
	; Intro Message
	intro_msg db 0dh, 0ah, 0dh, 0ah, " ************************* Welcome to CLI Calculator ************************* ", 0dh, 0ah, 0dh, 0ah
	intro_len equ $-intro_msg
	; Prompt Message
	prompt_msg db " Please enter the Equation that you want evaluated: ", 0dh, 0ah
	promt_len equ $-prompt-msg
	; Result Message
	result_msg db " Your Result is: ", 0dh, 0ah
	result_len equ $-result-msg

section .bss
	equation resb 8 

section .text
	global _start

_start: 

exit: 
	mov rax, 60
	mov rdi, 0
	syscall 

