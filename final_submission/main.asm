%macro istream 2
	mov rax, 0
	mov rdi, 0
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro ostream 2
	mov rax, 1 
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro oper 2
	mov rbx, %1
	mov rcx, %2

	cmp rbx, ADD_OPER
	je addition

	cmp rbx, SUB_OPER
	je subtraction

	cmp rbx, MUL_OPER
	je multiplication

	cmp rbx, DIV_OPER
	je multiplication
%endmacro

section .bss
	buffer   resq 100
	equation resq 100
	ascii    resq 100
	result   resq 0 

section .data
	ADD_OPER equ '+'
	SUB_OPER equ '-' 
	MUL_OPER equ '*' 
	DIV_OPER equ '/'

	EXIT_SUCCESS equ 0 
	SYS_EXIT     equ 60

	msg    db  "Enter Equation: "
	msglen equ $-msg

section .text
	global _start

_start: 
	mov r10, 1

addition: 
	add rax, rcx
	mov qword[result], rax
	jmp continue

subtraction: 
	sub rax, rcx
	mov qword[result], rax
	jmp continue

multiplication: 
	mul rcx
	mov qword[result], rax
	jmp continue

division: 
	div rcx
	mov qword[result], rax
	jmp continue


startprogram:
	ostream msg    , msglen
	istream buffer , 100

	movzx rax, byte[buffer] 
	sub   rax, "0"

	jmp runloop

runloop:
	mov rdx, qword[buffer+r10] 
	inc r10 
	oper rdx, qword[buffer+r10]

continue: 
	inc r10 
	cmp rdx, 10 
	jne runloop 

	mov ah, 0 
	mov al, byte[result]
	mov bl, 10
	div bl 

	add byte[ascii+0], al 
	add byte[ascii+1], ah 
	mov word[ascii+2], 10

	ostream ascii, 100

exit: 
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall
