%macro ostream 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro istream 2
	mov rax, 0
	mov rdi, 0
	mov rsi %1
	mov rdx %2
	syscall
%endmacro

section .bss
	equation resb 10 
	ascii    resb 10
	buffer   resb 10

section .data
	; Intro Message
	intromsg db 0dh, 0ah, 0dh, 0ah, " ************************* Welcome to CLI Calculator ************************* ", 0dh, 0ah, 0dh, 0ah
	introlen equ $-intromsg
	; Prompt Message
	promptmsg db 0dh, 0ah, " Please enter the Equation that you want evaluated: "
	promptlen equ $-promptmsg
	; Result Message
	resultmsg db 0dh, 0ah, " Your Result is: "
	resultlen equ $-resultmsg


section .text
	global _start

_start: 
	mov r10, 0 

next1: 
	ostream intromsg, introlen
	ostream promptmsg, promptlen
	; istream buffer, 

exit: 
	mov rax, 60
	mov rdi, 0
	syscall 

