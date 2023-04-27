;; ---------------------------------- ;;
;;  																	;;
;;         MACROS FOR PROGRAM         ;;
;; 																		;;
;; ---------------------------------- ;;

%macro ostream 2
	mov rax, 1    ; SYS_Write
	mov rdi, 1    ; Write to STD_OUT
	mov rsi, %1   ; Address of %1 
	mov rdx, %2   ; Length of %1
	syscall       ; Calling system services
%endmacro

%macro istream 2
	mov rax, 0    ; SYS_Read
	mov rdi, 0    ; Read from STD_IN
	mov rsi, %1   ; Address of %1
	mov rdx, %2   ; Length of %1
	syscall       ; Calling system services
%endmacro

%macro operate 2
	mov rbx, %1 
	mov rcx, %2 
	
%endmacro

;; ---------------------------------- ;;
;;  																	;;
;;       UNINITIALIZED VARIABLES      ;;
;; 																		;;
;; ---------------------------------- ;;

section .bss
	equation resq 100 
	ascii    resq 100
	buffer   resq 100

;; ---------------------------------- ;;
;;  																	;;
;;         DATA SECTIONS              ;;
;; 																		;;
;; ---------------------------------- ;;

section .data
	; -----
	; CONSTANTS
	EXIT_SUCCESS equ 0
	SYS_EXIT     equ 60

	; -----
	; Intro Message
	intromsg db 0dh, 0ah, 0dh, 0ah, " ************************* Welcome to CLI Calculator ************************* ", 0dh, 0ah, 0dh, 0ah
	introlen equ $-intromsg

	; -----
	; Prompt Message
	promptmsg db 0dh, 0ah, " Please enter the Equation that you want evaluated (Don't user any spaces!): "
	promptlen equ $-promptmsg

	; -----
	; Result Message
	resultmsg db 0dh, 0ah, " has a result of: "
	resultlen equ $-resultmsg


section .text
	global _start

_start: 
	mov r10, 0 

;; ---------------------------------- ;;
;;  																	;;
;;         PROGRAM START LOOP         ;;
;; 																		;;
;; ---------------------------------- ;;

START: 
	ostream intromsg  , introlen 
	ostream promptmsg , promptlen
	istream buffer    , 100

	; EQUATION = BUFFER
	mov al             , byte[buffer]
	mov al             , 0fh
	mov byte[equation] , al

	; RESULT OUPUT 
	ostream buffer, 100


exit: 
	mov rax, SYS_EXIT      ; Call code for exit
	mov rdi, EXIT_SUCCESS  ; Exit program with success
	syscall 

