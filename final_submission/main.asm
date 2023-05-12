;; ---------------------------------- ;;
;;  								                  ;;
;;         MACROS FOR PROGRAM         ;;
;; 	   								                ;;
;; ---------------------------------- ;;

;; ------------ ;;
;; OUTPUTSTREAM ;;
;; ------------ ;;
%macro ostream 2
	mov rax, 1
	mov rdi, 1
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

;; ------------ ;;
;; INPUTSTREAM  ;;
;; ------------ ;;
%macro istream 2
	mov rax, 0 
	mov rdi, 0 
	mov rsi, %1
	mov rdx, %2
	syscall
%endmacro

;; --------------- ;;
;; OPERATION LOGIC ;;
;; --------------- ;; 
%macro check 1
	mov ax, [%1] 

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

;; ---------------------------------- ;;
;;  								                  ;;
;;       UNINITIALIZED VARIABLES      ;;
;; 									                  ;;
;; ---------------------------------- ;;
section .bss
	buffer   resb 9
	temp_num resb 1
	symbol   resb 1
	result   resb 10

;; ---------------------------------- ;;
;;  							                    ;;
;;         DATA SECTION               ;;
;; 									                  ;;
;; ---------------------------------- ;;

section .data
	; --------- ; 
	; CONSTANTS ; 
	; --------- ; 
	SYS_EXIT     equ 60
	EXIT_SUCCESS equ 0
	ADD_OPER	   equ '+'
	SUB_OPER     equ '-'
	MUL_OPER     equ '*'
	DIV_OPER     equ '/'

	; ------------- ; 
	; ASCII OUPUT   ;
	; ------------- ;
	ascii db  "0000000", 10


	; ------------- ; 
	; INTRO MESSAGE ;
	; ------------- ;
	intromsg db 0dh, 0ah, 0dh, 0ah, " ************************* Welcome to CLI Calculator ************************* ", 0dh, 0ah, 0dh, 0ah 
	introlen equ $-intromsg

	; -------------- ; 
	; PROMPT MESSAGE ;
	; -------------- ; 
	promptmsg db 0dh, 0ah, " Please enter the Equation that you want evaluated (Don't use any spaces!): "
	promptlen equ $-promptmsg

	; -------------- ;
	; RESULT MESSAGE ;
	; -------------- ;
	resultmsg db " has a result of: "
	resultlen equ $-resultmsg

	; ---------------- ; 
	; CONTINUE MESSAGE ; 
	; ---------------- ; 
	continuemsg db 0dh, 0ah, " Do you want to continue (Y/N)? "
	continuelen equ $-continuemsg

	; ----------- ; 
	; END MESSAGE ; 
	; ----------- ; 
	endmsg db 0dh, 0ah, 0dh, 0ah, " ************************* Thank You for Using Me ************************* ", 0dh, 0ah, 0dh, 0ah 
	endlen equ $-endmsg

	

section .text
	global _start

_start: 
	mov r10, 2

program: 
	ostream promptmsg, promptlen
	istream buffer   , r10

	mov al             , [buffer]
	and al		         , 0fh 
	mov byte[result]   , al 

	mov al            , [buffer+1]
	mov byte[symbol]  , al

	mov al            , [buffer+r10]
	and al            , 0fh
	mov byte[temp_num] , al 

	mov al, byte[result] 
	mov bl, byte[buffer+r10]

	check symbol

loop_one: 
	mov al, byte[buffer+r10+1]
	mov byte[symbol], al
	mov al, byte[result]
	mov bl, byte[buffer+r10*2]

	check symbol

display: 
	inc r10
	mov bl, byte[buffer+r10*2]
	cmp bl, 10
	jne loop_one

	mov al, byte[result]
	add byte[ascii], al 
	ostream ascii, 2

exit: 
	mov rax, SYS_EXIT      ; Call code for exit
	mov rdi, EXIT_SUCCESS  ; Exit program with success
	syscall


;; ---------------------------------- ;;
;;  					     		                ;;
;;       OPERATION FUNCTIONS          ;;
;; 									                  ;;
;; ---------------------------------- ;;

; ------------- ; 
; ADDITION FUNC ; 
; ------------- ;
addition: 	
	add al, bl 
	mov byte[result], al
	jmp display 

; ---------------- ; 
; SUBTRACTION FUNC ;
; ---------------- ;
subtraction: 	
	sub al, bl
	mov byte[result], al 
	jmp display

; ------------------- ;
; MULTIPLICATION FUNC ; 
; ------------------- ;
multiplication: 
	mul bl 
	mov byte[result], al 
	jmp display

; ------------- ;
; DIVISION FUNC ; 
; ------------- ;
division: 
	mov ah, 0 
	div bl 
	mov byte[result], al 
	jmp display