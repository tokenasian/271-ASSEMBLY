TITLE Project 4 Nested Loops and Procedures     (Proj4_armstrm2.asm)

; Author: Matthew Armstrong
; Last Modified: 07/22/2022
; OSU email address: armstrm2@oregonstate.edu
; Course number/section: [271]  CS271 Section [400]
; Project Number: #4                Due Date: 07/24/2022
; Description: The purpose of this assignment is to reinforce concepts around procedures, nested loops, and data validation...
; This program is designed to introduce the user with the author name, program instructions, and program title... 
; We prompt the user to input n number of primes to be displayed. 
; The range of valid numbers the user is allowed to enter is between 1 to 4000!
; The program then calculates and displays the all of the prime numbers up to and including the nth prime. 

INCLUDE Irvine32.inc
; limits definied as constants per requirement 
   maxRange = 4000
   minRange = 1
.data
	excrd1				BYTE		"EC1: Align the output columns (the first digit of each number on a row should match with the row above). (1pt)", 0
	excrd2				BYTE		"EC2: Extend the range of primes to display up to 4000 primes, shown 20 rows of primes per page. (2pt)" , 0
	intro				BYTE		"Prime Numbers Programmed by Matthew Armstrong", 0
	instruction_1		BYTE		"Enter the number of prime numbers you would like to see!", 0
	instruction_2		BYTE		"I'll accept orders for up to 4000 primes!", 0
	input_prompt		BYTE		"Enter the number of primes to display [1....4000]: ", 0
	user_input			SDWORD		?	
	error_prompt		BYTE		"No primes for you! Number out of range. Try again.", 0
	printnext20			BYTE		"Press any key to continue: ", 0
	goodbye				BYTE		"Results certified by Matthew. Goodbye.", 0

	curr_num			DWORD		?	; check if the number we are evaluating is a prime or not a prime
	line_pos			DWORD		?	; lines printed
	row_pos				DWORD		0	; rows printed

.code
main PROC

	CALL	introduction	; introduce the program
	CALL	getUserData		; obtain the user input
	CALL	showPrimes		; display n primes
	CALL	farewell		; end the program 

main ENDP

;    --------------------------
;	 Name: Introduction PROC
;	 Description:	Introduce the user to the program by printing intro, instructions, and extra credit details to the console...
;	 Precondition:	None.
;	 Postcondition:	EDX is modified. 
;	 Receives:	None.
;	 Returns:	None.
;    --------------------------

introduction PROC
	MOV		EDX, OFFSET intro
	CALL	WriteString 
	CALL	CrLf 
	CALL	CrLf 

	MOV		EDX, OFFSET excrd1
	CALL	WriteString
	CALL	CrLf

	MOV		EDX, OFFSET excrd2
	CALL	WriteString
	CALL	CrLf

	CALL	CrLf
	MOV		EDX, OFFSET instruction_1
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf 

	MOV		EDX, OFFSET instruction_2
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf 

	RET
introduction ENDP

;    --------------------------
;	 Name: getUserData PROC 
;	 Description:	Prompt the user to enter an integer, to get the number of primes to be displayed.
;	 Precondition:	None.
;	 Postcondition:	EAX, EDX, are modified.
;	 Receives:	None.
;	 Returns:	user_input = number of primes to be displayed.

;    --------------------------
getUserData PROC
	MOV		EDX, OFFSET input_prompt
	CALL	Writestring
	; receives user_input
	CALL	ReadInt
	MOV		user_input, EAX
	; call subprocedure to ensure integer is in range
	CALL	validate

	RET
getUserData ENDP

;    --------------------------
;	 Name: validate Subprocedure
;	 Description: Checks that the user input is within the advertised limits.
;	 Precondition: user_input is in the specified range of 1 to 4000.
;	 Postcondition: EDX is modified. 
;	 Receives: EAX = user_input, minRange, maxRange...
;	 Returns: None.
;    -------------------------

validate PROC
	; compare user_input to minRange.
	CMP		EAX, minRange
	; jump to _printError if the input is less than 1.
	JL		_printError
	; compare user_input to maxRange.
	CMP		EAX, maxRange
	; jump to _printError if the input is greater than 4000.
	JG		_printError
	; jump to _validInput when the input is in range.
	JMP		_validInput

	_printError:
		; display error message if not in the correct range.
		MOV		EDX, OFFSET error_prompt
		CALL	WriteString
		CALL	CrLf
		; re-prompt the user to input another integer.
		CALL	getUserData

	_validInput:
		RET 
validate ENDP

;    --------------------------
;	 Name: showPrimes PROC
;	 Description: Procedure that prints n prime numbers entered by the user to the console...
;	 Precondition: user_input is in the specified range of 1 to 4000.
;	 Postcondition: EAX, ECX, EDX are modified.
;	 Receives: user_input, curr_num, line_pos, row_pos 
;	 Returns: none
;    -------------------------

showPrimes PROC

	; here we move the user_input value into the EXC to initialize the LOOP counting
	MOV		ECX, user_input				
	; here the divisor is set to 2, and we can examine if the current number is or is not a prime
	MOV		curr_num, 2				

	_countingLoop:
	    MOV		user_input, ECX

		; call isPrime procedure to generate prime numbers 
		CALL	isPrime					

		CMP		EAX, 1
		; if not equal to 1, continue on to the next number...
		JNE		_addOne		

		_printPrimes:
		MOV		EAX, curr_num
		CALL	WriteDec
		; aligns the output columns according to the EC#1 rules
		MOV		al, 9
		CALL	WriteChar
		; increment 
		INC		line_pos	
		; are 10 primes printed on the current line? if so, go to _addNewLine to start printing the next line. 
		MOV		EDX, line_pos			
		CMP		EDX, 10
		JE		_addNewLine				

		JMP		_continueLoop

		_addOne:
			INC		ECX
			JMP		_continueLoop

		; move to _addNewLine once 10 primes are displayed on the output
		_addNewLine:
			CALL	CrLf 
			; increment 
			INC		row_pos
			; reset line_pos
			MOV		line_pos, 0
			; are there now 20 rows? if so, jump to_next20, so that we can start a new page...
			CMP		row_pos, 20
			JE		_next20
			; move on to continue the loop
			JMP		_continueLoop 

		; move to _next20 once current page is filled with 20 rows 
		_next20:
			; prompt to continue loading the next 20 rows
			MOV		EDX, OFFSET printnext20
			CALL	WriteString
			CALL	ReadInt
			; reset row_pos
			MOV		row_pos, 0
			; move on to continue the loop
			JMP		_continueLoop

		_continueLoop:
			INC		curr_num
			LOOP	_countingLoop
			JMP		_endloop

		_endloop:
			CALL CrLf

			RET
showPrimes ENDP

;    --------------------------
;	 Name: isPrime Subprocedure
;	 Description: Subprocedure evalatues whether or not the current input is prime (1) or not prime (0)
;	 Precondition: we have the integer stored that we are evaluating. 
;	 Postcondition: EAX, EBX
;	 Receives: curr_num which is the number we are evaluating to see if it is a prime 
;	 Returns: EAX register which tells us if curr_num is a prime (1) or not a prime (0)
;    -------------------------
isPrime PROC

	MOV		EBX, 2
	MOV		EAX, curr_num

	_PrimeChecker:
		CMP		EBX, curr_num
		JE		_PrimeIsFound 
		MOV		EDX, 0
		DIV		EBX
		CMP		EDX, 0			 ; the current number is not a prime if the remainder is 0. 
		
		JE		_PrimeIsNotFound
		INC		EBX
		MOV		EAX, curr_num
		JMP		_PrimeChecker

	_PrimeIsFound:
		MOV		EAX, 1
		RET

	_PrimeIsNotFound:
		MOV		EAX, 0
		RET

isPrime	ENDP

;    ------------------------------
;	 Name: farewell PROC
;	 Description: Say goodbye to the user by printing the farewell message to the console...
;	 Precondition: None.
;	 Postcondition: EDX modified
;	 Receives: goodbye.
;	 Returns: None.
;    ------------------------------

farewell PROC

	CALL CrLf 
	MOV EDX, OFFSET goodbye
	CALL WriteString
	CALL CrLf
	CALL CrLf

farewell ENDP

	Invoke exitProcess, 0	;exit to operating system

END main
