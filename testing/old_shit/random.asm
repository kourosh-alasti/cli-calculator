;; ---------------------------------- ;;
;;  								                  ;;
;;         MACROS FOR PROGRAM         ;;
;; 	   								                ;;
;; ---------------------------------- ;;

;; ------------ ;;
;; OUTPUTSTREAM ;;
;; ------------ ;;

%macro ostream 2
	mov rax, 1    ; SYS_Write
	mov rdi, 1    ; Write to STD_OUT
	mov rsi, %1   ; Address of %1 
	mov rdx, %2   ; Length of %1
	syscall       ; Calling system services
%endmacro

;; ------------ ;;
;; INPUTSTREAM  ;;
;; ------------ ;;
%macro istream 2
	mov rax, 0    ; SYS_Read
	mov rdi, 0    ; Read from STD_IN
	mov rsi, %1   ; Address of %1
	mov rdx, %2   ; Length of %1
	syscall       ; Calling system services
%endmacro

;; --------------- ;;
;; OPERATION LOGIC ;;
;; --------------- ;; 

%macro operate 2
	mov ebx, %1 
	mov ecx, %2 

	cmp ebx, ADD_OPERATOR
	je addition
	
	cmp ebx, SUB_OPERATOR
	je subtraction 

	cmp ebx, MUL_OPERATOR
	je multiplication

	cmp ebx, DIV_OPERATOR
	je divide
%endmacro

;; ---------------------------------- ;;
;;  								                  ;;
;;       UNINITIALIZED VARIABLES      ;;
;; 									                  ;;
;; ---------------------------------- ;;

section .bss
	result   resq 100
	equation resq 100 
	ascii    resq 100
	buffer   resq 100

;; ---------------------------------- ;;
;;  							                    ;;
;;         DATA SECTION               ;;
;; 									                  ;;
;; ---------------------------------- ;;

section .data
	; --------- ; 
	; CONSTANTS ; 
	; --------- ; 
	ADD_OPERATOR equ '+' 
	SUB_OPERATOR equ '-' 
	MUL_OPERATOR equ '*' 
	DIV_OPERATOR equ '/'
	EXIT_SUCCESS equ 0
	SYS_EXIT     equ 60

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
	mov r10, 1

;; ---------------------------------- ;;
;;  					     		                ;;
;;       OPERATION FUNCTIONS          ;;
;; 									                  ;;
;; ---------------------------------- ;;

; ------------- ; 
; ADDITION FUNC ; 
; ------------- ;
addition: 
	add eax, ecx 
	jmp CONTINUE

; ---------------- ; 
; SUBTRACTION FUNC ;
; ---------------- ; 
subtraction: 
	sub eax, ecx 
	jmp CONTINUE

; ------------------- ;
; MULTIPLICATION FUNC ; 
; ------------------- ; 
multiplication: 
	mul ecx 
	jmp CONTINUE

; ------------- ;
; DIVISION FUNC ; 
; ------------- ;
divide: 
	div ecx
	jmp CONTINUE

;; ---------------------------------- ;;
;;  					     		  ;;
;;       PROGRAM START LOOP           ;;
;; 									  ;;
;; ---------------------------------- ;;

START: 
	; OUTPUT STARTER 
	ostream intromsg  , introlen 
	ostream promptmsg , promptlen
	istream buffer    , 100

	; EQUATION = BUFFER
	mov al             , byte[buffer]
	mov al             , 0fh
	mov byte[equation] , al

	; --------------------------- ; 
	; QUICK CONVERT CHAR TO ASCII ;
	; e.x. "1" -> 48 - 47 <- "0"  ;
	; --------------------------- ; 
	movzx eax , byte[buffer]
	sub   eax , "0"
	
	jmp   LOOPER

;; ---------------------------------- ;;
;;  					     		                ;;
;;           RESULT OUTPUT            ;;
;; 									                  ;;
;; ---------------------------------- ;;

RESULT: 
	; mov     result    , eax
	; ostream buffer    , 100
	ostream resultmsg , resultlen 

PROMPT: 
	ostream continuemsg , continuelen
	istream buffer      , 100 
	movzx   eax         , byte[buffer]
	cmp     eax         , "Y"
	je      RESET
	jmp     exit

;; ---------------------------------- ;;
;;  					     		                ;;
;;           RESET PROGRAM TO         ;;
;; 		   LOOP THROUGH AGAIN           ;;
;; 									                  ;;
;; ---------------------------------- ;;

RESET:
	ostream endmsg, endlen
	;mov     buffer, 0 
	mov     eax   , 0 
	mov     edx   , 0 
	mov     al    , 0 
	mov     r10   , 1 
	jmp     START
	
;; ---------------------------------- ;;
;;  					     		                ;;
;;           OPERATION LOOP           ;;
;; 									                  ;;
;; ---------------------------------- ;;

LOOPER: 
	mov al, byte[buffer+r10] 
	inc r10
	operate al, byte[buffer+r10]

CONTINUE:
	inc r10 
	cmp al, 10 
	jne LOOPER
	mov result, eax
	ostream result, 100
	jmp RESULT

	


exit: 
	mov rax, SYS_EXIT      ; Call code for exit
	mov rdi, EXIT_SUCCESS  ; Exit program with success
	syscall 

