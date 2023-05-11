%macro check 2
	;mov symbol_temp, %1
	mov ebx, %1
	;mov number_temp, %2
	mov ecx, %2

	cmp ebx, ADD_OPER
	je addition

	cmp ebx, SUB_OPER
	je subtraction

	cmp ebx, MUL_OPER
	je multiplication

	cmp ebx, DIV_OPER
	je division
%endmacro

%macro print 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro scan 2
	mov rax, 0 
	mov rdi, 0 
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

; OPERATION FUNCTIONS

addition:
	add eax, ecx
	jmp continue_prog

subtraction: 
	sub eax, ecx
	jmp continue_prog

multiplication: 
	mul ecx
	jmp continue_prog 

division: 
	div ecx
	jmp continue_prog


section .bss
	; Input Stream
	buffer      resq 100
	; Result Var ;; FOR OUTPUT
	result      resq 100

	; TEMP VARS
	symbol_temp db   0
	number_temp db   0

section .data
	; CONSTANTS
	SYS_EXIT     equ 60
	EXIT_SUCCESS equ 0

	ADD_OPER     equ '+'
	SUB_OPER     equ '-'
	MUL_OPER     equ '*'
	DIV_OPER     equ '/'

	ZERO         equ 48

	ascii  db "00000000", 10
		

	msg    db  "Enter an equation: "
	msglen equ $-msg

	results    db  "Result: "
	resultslen equ $-results

section .text
	global _start

_start: 
	mov r8d, 1




beginning: 
	print msg    , msglen
	scan  buffer , 100

check_input:
	movzx eax, byte[buffer]
	;sub rax, "0" 

	inc r8d 
	mov r9d, [buffer+r8d]
	inc r8d 
	mov r10d, [buffer+r8d]
	
	check r9d, r10d

continue_prog:
	;add rax, "0"

	mov [result], eax

	print results, resultslen
	print buffer, 100

	add rdi, ZERO
	mov qword[buffer], rdi
	print buffer, 100
	
	;print result, 100
	;print rax , 100

exit: 
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall

