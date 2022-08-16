TITLE Elementary Arithmetic Project 1

; Author: Matthew Armstrong
; Last Modified: 7/06/2022
; OSU email address: armstrm2@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:   1              Due Date: 7/10/2022
; Description: A simple program that asks the user to enter 3 numbers, and calculates the sum, difference, quotient, and remainder, then prints the results on to the console.

INCLUDE Irvine32.inc

.data
	; console output
   intro_header				BYTE				"				Elementary Arithmetic by Matthew Armstrong   ", 0
   intro_program			BYTE				"Enter 3 numbers A > B > C, and I'll show you the sum, difference, quotient, and remainder.", 0
   goodbye					BYTE				"Thanks for using Elementary Arithmetic!  Goodbye!", 0
   input_1					BYTE				"Please enter the first number: ", 0
   input_2					BYTE				"Please enter the second number: ", 0
   input_3					BYTE				"Please enter the third number: ", 0
   extracredit_1			BYTE				"**EC: Repeat until the user chooses to quit**", 0
   extracredit_2			BYTE				"**EC: Check if numbers are not in strictly descending order**", 0
   extracredit_3			BYTE				"**EC: Program handles negative results and computes B-A, C-A, C-B, C-B-A**", 0
   extracredit_4			BYTE				"**EC: Calculate and display the quotients A/B, A/C, B/C, printing the quotient and remainder.**", 0
   LoopPrompt				BYTE				"Do you want to repeat the program again? (Enter 1 to repeat the program. Enter any other key to exit.) : ", 0
   ErrorPrompt				BYTE				"ERROR: The numbers are not in descending order! ", 0
	; inputs
   val_A					DWORD		?		; get the user to enter the first value
   val_B					DWORD		?		; get the user to enter the second value
   val_C					DWORD		?		; get the user to enter the third value
	; operation symbols
   addition					BYTE				" + ", 0
   subtraction				BYTE				" - ", 0
   quotient					BYTE				" / ", 0
   remainder				BYTE				" Remainder ", 0	
   equal					BYTE				" = ", 0
	; required calculations
   A_plus_B					DWORD		?
   A_plus_C					DWORD		?
   B_plus_C					DWORD		?
   A_plus_B_plus_C			DWORD		?
   A_minus_B				DWORD		?
   A_minus_C				DWORD		?
   B_minus_C				DWORD		?
   B_minus_A				DWORD		?
   C_minus_A				DWORD		?
   C_minus_B				DWORD		?
   C_minus_B_minus_A		DWORD		?
   A_div_B					DWORD		?																																																											
   A_div_C					DWORD		?	
   B_div_C					DWORD		?
   A_remain_B				DWORD		?	
   A_remain_C				DWORD		?																																																												
   B_remain_C				DWORD		?
	; extra credit
   RepeatAgain				DWORD		?		; ask the user if they would like to run the program again
   YesRepeat				DWORD		1		; run the program again if the correct input is selected 

.code
main PROC
Introduction:
;    --------------------------
;	Introduction section prints the program header (title and name), and the program instructions (including extra credit), to the console. 
;    --------------------------
	call	CrLf
	mov		edx, OFFSET intro_header 
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extracredit_1
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extracredit_2
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extracredit_3
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extracredit_4
	call	WriteString
	call	CrLf

UserInput:
;    --------------------------
;	UserInput section contains the code responsible for getting the data to prompt the user to enter 3 numbers, in a strictly descending order.
;  JNL prompts an error message when the numbers following input 1 are not in a strictly descending order.
;    --------------------------
	call	CrLf
	mov		edx, OFFSET intro_program
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET input_1 
	call	WriteString
	call	ReadInt
	mov		val_A, eax
	call	CrLf

	mov		edx, OFFSET input_2 
	call	WriteString
	call	ReadInt
	mov		val_B, eax 
	cmp		eax, val_A	; compare value B to value A
	jnl		ErrorCredit ; if EAX is not less than, JMP
	call	CrLf

	mov		edx, OFFSET input_3
	call	WriteString
	call	ReadInt
	mov		val_C, eax
	cmp		eax, val_B	; compare value C to value B
	jnl		ErrorCredit	; if EAX is not less than, JMP
	call	CrLf

Calculate:
;    --------------------------
;  Calculate section contains the code that calculates the required addition and subtraction values; A+B, A+C, B+C, A+B+C, A-B, A-C, B-C. 
;  It also handles extra credit calculations.
;    --------------------------
	; A + B
	mov		eax, val_A		; mov val A into the EAX register
	add		eax, val_B		; add val B into the EAX register
	mov		A_plus_B, eax
	; A + C
	mov		eax, val_A 
	add		eax, val_C
	mov		A_plus_C, eax
	; B + C
	mov		eax, val_B 
	add		eax, val_C
	mov		B_plus_C, eax
	; A + B + C
	mov		eax, val_A 
	add		eax, val_B
	add		eax, val_C
	mov		A_plus_B_plus_C, eax
	; A - B
	mov		eax, val_A 
	sub		eax, val_B
	mov		A_minus_B, eax
	; A - C
	mov		eax, val_A
	sub		eax, val_C
	mov		A_minus_C, eax
	; B - C
	mov		eax, val_B
	sub		eax, val_C
	mov		B_minus_C, eax
; EXTRA CREDIT # 3
	; B - A
	mov		eax, val_B
	sub		eax, val_A
	mov		B_minus_A, eax
	; C - A
	mov		eax, val_C
	sub		eax, val_A
	mov		C_minus_A, eax
	; C - B
	mov		eax, val_C
	sub		eax, val_B
	mov		C_minus_B, eax
	; C - B - A
	mov		eax, C_minus_B
	sub		eax, val_A
	mov		C_minus_B_minus_A, eax
; EXTRA CREDIT # 4
	; A / B
	mov		eax, val_A			
	mov		ebx, val_B
	xor		edx, edx			; set edx to zero
	div		ebx					; do the dvision
	mov		A_div_B, eax		; mov quotient
	mov		A_remain_B, edx		; mov remainder
	; A / C
	mov		eax, val_A
	mov		ebx, val_C
	xor		edx, edx			; set edx to zero
	div		ebx					; do the division
	mov		A_div_C, eax		; mov quotient
	mov		A_remain_C, edx		; mov remainder
	; B / C
	mov		eax, val_B
	mov		ebx, val_C
	xor		edx, edx			; set edx to zero
	div		ebx					; do the division
	mov		B_div_C, eax		; mov quotient
	mov		B_remain_C, edx		; mov remainder
	
Display:
;    --------------------------
;  Display section prints the results of the calculations to the console.
;    --------------------------
	; print A+B to the console
	mov		eax, val_A
	call	WriteDec
	mov		edx, OFFSET addition
	call	WriteString
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, A_plus_B
	call	WriteDec
	call	CrLf
	; print A+C to the console
	mov		eax, val_A 
	call	WriteDec
	mov		edx, OFFSET addition
	call	WriteString
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, A_plus_C
	call	WriteDec
	call	CrLf
	; print B+C to the console
	mov		eax, val_B 
	call	WriteDec
	mov		edx, OFFSET addition
	call	WriteString
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, B_plus_C
	call	WriteDec
	call	CrLf
	; print A+B+C to the console
	mov		eax, val_A 
	call	WriteDec
	mov		edx, OFFSET addition
	call	WriteString
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET addition
	call	WriteString
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, A_plus_B_plus_C
	call	WriteDec
	call	CrLf

	; print A-B to the console
	mov		eax, val_A
	call	WriteDec
	mov		edx, OFFSET subtraction
	call	WriteString
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, A_minus_B
	call	WriteDec
	call	CrLf
	; print A-C to the console
	mov		eax, val_A 
	call	WriteDec
	mov		edx, OFFSET subtraction
	call	WriteString
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, A_minus_c
	call	WriteDec
	call	CrLf
	; print B-C to the console
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET subtraction
	call	WriteString
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, B_minus_C
	call	WriteDec
	call	CrLf

; EXTRA CREDIT #3
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET	subtraction
	call	WriteString
	mov		eax, val_A
	call	WriteDec
	mov		edx, OFFSET	equal
	call	WriteString
	mov		eax, B_minus_A
	call	WriteInt					; WriteInt handles negatives
	call	CrLf
	; print C-A to the console
	mov		eax, val_C 
	call	WriteDec
	mov		edx, OFFSET subtraction
	call	WriteString
	mov		eax, val_A
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, C_minus_A
	call	WriteInt					; WriteInt handles negatives
	call	CrLf
	; print C-B to the console
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET subtraction
	call	WriteString
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, C_minus_B
	call	WriteInt					; WriteInt handles negatives
	call	CrLf
	; print C-B-A to the console
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET subtraction
	call	WriteString
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET subtraction
	call	WriteString
	mov		eax, val_A
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, C_minus_B_minus_A
	call	WriteInt
	call	CrLf

; EXTRA CREDIT # 4
	; print A / B to the console
	mov		eax, val_A 
	call	WriteDec
	mov		edx, OFFSET quotient
	call	WriteString
	mov		eax, val_B
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, A_div_B
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	mov		eax, A_remain_B
	call	WriteDec
	call	CrLf
	; print A / C to the console
	mov		eax, val_A 
	call	WriteDec
	mov		edx, OFFSET quotient
	call	WriteString
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, A_div_C
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	mov		eax, A_remain_C
	call	WriteDec
	call	CrLf
	; print B / C to the console
	mov		eax, val_B 
	call	WriteDec
	mov		edx, OFFSET quotient
	call	WriteString
	mov		eax, val_C
	call	WriteDec
	mov		edx, OFFSET equal
	call	WriteString
	mov		eax, B_div_C
	call	WriteDec
	mov		edx, OFFSET remainder
	call	WriteString
	mov		eax, B_remain_C
	call	WriteDec
	call	CrLf

RepeatCredit:
;    --------------------------
;    EXTRA CREDIT #1, repeat until the user chooses to quit
;    --------------------------
	call	CrLf
	mov		edx, OFFSET LoopPrompt
	call	WriteString
	call	ReadDec					; if ReadInt was used than anything other an integer would be registered as invalid
	call	CrLf
	mov		RepeatAgain, eax
	cmp		YesRepeat, eax			; runs the program again if the correct input is entered
	je		Introduction			; runs the program again by looping back to the introduction section
	jmp		TerminateProgram		; terminates the program successfully if the user chooses to quit, instead of repeating the program

ErrorCredit:	
;    --------------------------
;    EXTRA CREDIT #2, check if numbers are not in strictly descending order
;    --------------------------
	call	CrLf
	mov		edx, OFFSET ErrorPrompt	
	call	WriteString								
	call	CrLf					
	jmp		UserInput				; program goes back to the UserInput section, instead of closing the program

TerminateProgram:
;    --------------------------
;	 print the termination message to the console to say goodbye
;    --------------------------
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf
	Invoke	exitProcess, 0			; exit to operating system

main ENDP

END main
