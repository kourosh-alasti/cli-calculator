%macro	print 	2
        mov     rax, 1					;SYS_write
        mov     rdi, 1					;standard output device
        mov     rsi, %1					;output string address
        mov     rdx, %2					;number of character
        syscall						;calling system services
%endmacro

%macro	scan 	2
        mov     rax, 0					;SYS_read
        mov     rdi, 0					;standard input device
        mov     rsi, %1					;input buffer address
        mov     rdx, %2					;number of character
        syscall						;calling system services
%endmacro


section .bss
buffer	resb	4
n1	resb	1
n2	resb	1
s1	resb	1
result	resb	1

section .data
msg1	db	"Input equation: "
ascii	db	"0", 10

section .text
	global _start
_start:
	print	msg1, 16
	scan	buffer, 4
	mov	al, [buffer+0]
	and	al, 0fh
	mov	byte[n1], al
	mov	al, [buffer+2]
	and	al, 0fh
	mov	byte[n2], al
	mov	al, [buffer+1]
	mov	byte[s1], al

	mov	al, byte[n1]
	mov	byte[result], al
loop1:
	mov	al, byte[result]
	mov	bl, byte[n2]
	cmp	byte[s1], '+'
	jne	next1
	call 	addition
	jmp	second
next1:
	cmp	byte[s1], '-'
	jne	next2
	call	subtraction
	jmp	second
next2:	
	cmp	byte[s1], '*'
	jne	next3
	call	multiplication
	jmp	second
next3:
	cmp	byte[s1], '/'
	jne	second
	call	division
second:
output:
	mov	al, byte[result]
	add	byte[ascii], al
	print 	ascii, 2
done:
	mov	rax, 60
	mov	rdi, 0
	syscall
	
	
addition:
	add	al, bl
	mov	byte[result], al
	ret
	
subtraction:
	sub	al, bl
	mov	byte[result], al
	ret
	
multiplication:
	mul	bl
	mov	byte[result], al
	ret

division:
	mov	ah, 0
	div	bl
	mov	byte[result], al
	ret