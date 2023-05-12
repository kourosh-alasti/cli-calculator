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
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

%macro check 1
	mov ax, %1 

	cmp ax, ADD_OPER
	je addition

	cmp ax, SUB_OPER
	je subtraction

	cmp ax, MUL_OPER
	je multiplication

	cmp ax, DIV_OPER
	je division

	;
	;	ERROR HANDLING
	;
%endmacro

section .bss
	buffer  resb 10
	num_one resb 1
	num_two resb 1
	symbol  resb 1
	result  resb 10

section .data
	SYS_EXIT     equ 60
	EXIT_SUCCESS equ 0
	ADD_OPER	   equ '+'
	SUB_OPER     equ '-'
	MUL_OPER     equ '*'
	DIV_OPER     equ '/'

	intro_msg db  "Enter an equation: "
	intro_len equ $-intro_msg

	ascii     db  "0000000", 10

section .text
	global _start

_start: 
	mov r10, 1

program: 
	ostream intro_msg, intro_len
	istream buffer   , r10

	mov al            , [buffer+r10*0]
	and al		        , 0fh 
	mov byte[num_one] , al 

	mov al            , [buffer+r10]
	mov byte[symbol]  , al

	mov al            , [buffer+r10*2]
	and al            , 0fh
	mov byte[num_two] , al 
 
	mov al            , byte[num_one] 
	mov byte[result]  , al

loop_one: 
	mov al, byte[result] 
	mov bl, byte[num_two]

	check symbol

display: 
	mov al, byte[result]
	add byte[ascii], al 
	ostream ascii, 2

exit: 
	mov rax, SYS_EXIT
	mov rdi, EXIT_SUCCESS
	syscall


addition: 	
	add al, bl 
	mov byte[result], al
	jmp display 

subtraction: 	
	sub al, bl
	mov byte[result], al 
	jmp display

multiplication: 
	mul bl 
	mov byte[result], al 
	jmp display

division: 
	mov ah, 0 
	div bl 
	mov byte[result], al 
	jmp display