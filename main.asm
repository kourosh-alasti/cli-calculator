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

;; ---------------------------------- ;;
;;  																	;;
;;       UNINITIALIZED VARIABLES      ;;
;; 																		;;
;; ---------------------------------- ;;

section .bss
	equation resb 100 
	ascii    resb 100
	buffer   resb 100

;; ---------------------------------- ;;
;;  																	;;
;;         DATA SECTIONS              ;;
;; 																		;;
;; ---------------------------------- ;;

section .data
	; Intro Message
	intromsg db 0dh, 0ah, 0dh, 0ah, " ************************* Welcome to CLI Calculator ************************* ", 0dh, 0ah, 0dh, 0ah
	introlen equ $-intromsg
	; Prompt Message
	promptmsg db 0dh, 0ah, " Please enter the Equation that you want evaluated (Don't user any spaces!): "
	promptlen equ $-promptmsg
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
	mov rax, 60
	mov rdi, 0
	syscall 

