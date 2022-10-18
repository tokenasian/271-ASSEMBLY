TITLE PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures! 6		(Proj6_armstrm2.asm)

; Author: Matthew Armstrong
; Last Modified: 8/12/2022
; OSU email address: armstrm2@oregonstate.edu
; Course number/section:  CS271    Section: 400
; Project Number:   6              Due Date: 8/12/2022
; Description: This program prompts a user to input 10 signed decimal integers. 
;			   The program converts these and stores them into an array of numeric values. 
;			   The program then displays a list of the integers, the sum, and average of these numeric values as strings.

INCLUDE Irvine32.inc

; ---------------------------------------------------------------------------------------
;	Name: mGetString MACRO
;	Description: This MACRO will display a promt for the user to enter a signed int, 
;				then get the user input stored into a memory location.
;	Precondition: ReadVal Proc is called, and the correct parameters must be passed by reference.
;	Postcondition: EAX, ECX, and EDX are modified but saved and restored, so, none...
;	Receives: 
;			mUserPrompt  = address for the user prompt message 
;			mInputBuffer = address for the user input to be stored in
;			mInputString = the length of the input string 
;	Returns: 
;			mInputBuffer = buffer address for the user input to be stored in
;			mInputString = the length of the input string 
; ---------------------------------------------------------------------------------------
mGetString	MACRO	mUserPrompt, mInputBuffer, mInputString
	; save the EDX, ECX, and EAX register
	PUSHAD 
	MOV		EDX, mUserPrompt
	; call WritString to display the prompt output
	CALL	WriteString
	MOV		ECX, 101										; ECX will hold the buffer size
	MOV		EDX, mInputBuffer								; EDX will hold the buffer address
	; call ReadString to get the input from the user
	CALL	ReadString
	MOV		mInputString, EAX								; EAX will hold the number of characters entered 
	; restore the registers
	POPAD
	
ENDM

; ----------------------------------------------------------------------------------------
;	Name: mDisplayString MACRO
;	Description: This MACRO will display display the string.
;	Precondition: None.
;	Postcondition: EDX is modified, but restored. 
;	Receives: stringOutput = where the string printed to the console is stored.
;	Returns: None.
; ----------------------------------------------------------------------------------------
mDisplayString MACRO stringOutput
	; save the EDX register
	PUSH	EDX
	MOV		EDX, stringOutput
	; call WriteString to disply the output
	CALL	WriteString
	; restore the EDX register
	POP		EDX
				
ENDM

; CONSTANTS
ARRAYSIZE = 10		    ; maximum number of unsigned integers the user can input
MAXSIZE = -2147483648			; maximum characters allowed for the length of the input string

.data
; ----------------------------------------
; intro strings to print to the console
; ----------------------------------------
header				BYTE		"PROGRAMMING ASSIGNMENT 6: Designing low-level I/O procedures!", 13,10,0
author				BYTE		"Written by: Matthew Armstrong", 13,10,0
ecred				BYTE		"**EC: Number each line of user input and display a running subtotal of the user�s valid numbers.**", 13,10,0
instruction			BYTE		"Please provide 10 signed decimal integers.", 0Ah
					BYTE		"Each number needs to be small enough to fit inside a 32 bit register." , 0Ah
					BYTE		"After you have finished inputting the raw numbers,", 0Ah
					BYTE		"I will display a list of the integers, their sum, and their average value..." , 13,10,0
; ----------------------------------------
; display strings to print to the console
; ----------------------------------------
error_msg			BYTE		"ERROR: You did not enter a signed number or your number was too big.", 13,10,0
prompt_msg			BYTE		") Please enter a signed number: ", 0
array_msg			BYTE		"You entered the following numbers: ", 0
spacing				BYTE		", ", 0

sum_msg				BYTE		"The sum of these numbers is: ", 0
avg_msg				BYTE		"The truncated average is: ", 0

goodbye				BYTE		"Thanks for playing!", 13,10,0
; ----------------------------------------
; data variables for the program
; ----------------------------------------
inputArray			SDWORD		ARRAYSIZE DUP (?)	; an array of 10 valid integers
arrayString			BYTE		MAXSIZE DUP (?)		
userInputString		BYTE		MAXSIZE DUP (?)		; the string of the entered user inputs

isNegative			DWORD		0
numCount			DWORD		0
inputLen			DWORD		?					; the length of the input string or the number of characters in the user input
validInput			SDWORD		?					; the converted value

sumCalc				SDWORD		?
avgCalc				SDWORD		?

lineCount			DWORD		1					; Ectra Credit Line Counter

.code

main PROC
	PUSH	OFFSET ecred
	PUSH	OFFSET instruction
	PUSH	OFFSET author
	PUSH	OFFSET header
	CALL	introduction
	CALL	CrLf

	MOV		ECX, ARRAYSIZE
	MOV		EDI, OFFSET inputArray 

_validateInput:
	PUSH	ARRAYSIZE
	PUSH	inputLen
	PUSH	OFFSET userInputString
	PUSH	OFFSET prompt_msg
	PUSH	OFFSET error_msg
	PUSH	OFFSET validInput
	PUSH	numCount
	PUSH	lineCount
	PUSH	isNegative
	PUSH	OFFSET arrayString
	CALL	ReadVal
	
	MOV		EAX, DWORD PTR validInput			; EAX will hold the values in validInput
	MOV		[EDI], EAX							; validInput values are moved to the inputArray
	INC		lineCount							; Extra Credit #1
	ADD		EBX, EAX

	ADD		EDI, 4								; increment the inputArray, then point toward the next element 
	LOOP	_validateInput

	; set up the array size and the array address
	MOV		ECX, ARRAYSIZE	
	MOV		ESI, OFFSET inputArray
	
;--------------------------------------------------------
; print the array message to the console using WriteVal
;--------------------------------------------------------
	CALL	CrLf
	mDisplayString OFFSET array_msg

_displayLoop:
	PUSH	ARRAYSIZE
	PUSH	[ESI]
	PUSH	OFFSET arrayString			    ; display the array
	CALL	WriteVal

	; here we have reached the end of our string, so don't add a comma here.
	CMP		ECX, 1							
	JE		_calculateSum

	; print ", " for proper formatting
	mDisplayString	OFFSET spacing		

	ADD		ESI, 4							; point toward the next element of array
	LOOP	_displayLoop

;--------------------------------------------------------
; calculate the sum and average
;--------------------------------------------------------
	_calculateSum:
		MOV		EAX, 0						; initialize the sum
		MOV		ECX, ARRAYSIZE
		MOV		ESI, OFFSET inputArray

	_sumLoop:
		ADD		EAX, [ESI]					; add current element 
		ADD		ESI, 4						; move array pointer to the next element to go through array
		LOOP	_sumLoop					; auto decrement 
		MOV		sumCalc, EAX				; MOV the sum value to EAX

		MOV		EAX, sumCalc				; EAX set to sumCalc to hold the sum
		CDQ
		MOV		EBX, ARRAYSIZE				; EBX set to 10 because we must divide by the number of the max inputs
		IDIV	EBX						
		MOV		avgCalc, EAX				; EAX will hold the average

;--------------------------------------------------------
; print the sum to the console using WriteVal
;--------------------------------------------------------
		CALL	CrLf			
		mDisplayString OFFSET sum_msg

		PUSH	ARRAYSIZE
		PUSH	sumCalc
		PUSH	OFFSET arrayString
		CALL	WriteVal

;--------------------------------------------------------
; print the average to the console using WriteVal
;--------------------------------------------------------
		CALL	CrLf			
		mDisplayString OFFSET avg_msg

		PUSH	ARRAYSIZE
		PUSH	avgCalc
		PUSH	OFFSET arrayString
		CALL	WriteVal				; print the average

;--------------------------------------------------------
; print the goodbye message to the console using WriteVal
;--------------------------------------------------------
		CALL	CrLf
		PUSH	OFFSET goodbye
		CALL	farewell

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; ---------------------------------------------------------------------------------------
; Name: introduction PROC
; Description: This PROC introduces the program to the user using the mDisplayString MACRO.
; Preconditions: None.
; Postconditions: None.
; Receives:
;			[EBP+20] = extra credit
;			[EBP+16] = instructions
;			[EBP+12] = author
;			[EBP+8]  = header
; Returns: validInput
; ---------------------------------------------------------------------------------------
introduction PROC
	PUSH	EBP
	MOV		EBP, ESP
	
	mDisplayString  [EBP+8]
	mDisplayString	[EBP+12]
	CALL	CrLf
	mDisplayString	[EBP+16]
	CALL	CrLf
	mDisplayString	[EBP+20]
	CALL	CrLf

	POP		EBP
	RET		20

introduction ENDP

; ---------------------------------------------------------------------------------------
; Name: ReadVal
; Description: This PROC converts the user's entered ASCII digit characters to its signed numeric value. 
; Preconditions: Prompt, string, and string length are pushed to the stack...
; Postconditions: None.
; Receives:
;			[EBP+44] = ARRAYSIZE
;			[EBP+40] = inputLen
;			[EBP+36] = userInputString
;			[EBP+32] = prompt_msg
;			[EBP+28] = error_msg
;			[EBP+24] = validInput
;			[EBP+20] = numCount
;			[EBP+16] = lineCount
;			[EBP+12] = isNegative
;			[EBP+8]  = arrayString
; Returns: validInput
; ---------------------------------------------------------------------------------------
ReadVal PROC
	PUSH	EBP
	MOV		EBP, ESP
	; save the register
	PUSHAD

_prompt:
;--------------------------------------------------------
;	Extra Credit #1 
;--------------------------------------------------------
	PUSH	[EBP+44]			; ARRAYSIZE
	PUSH	[EBP+16]			; LINE COUNTER
	PUSH	[EBP+8]				; arrayString
	CALL	WriteVal			; must use writeval...

;--------------------------------------------------------
; Invoke mGetString macro! prompt, string, length...
;--------------------------------------------------------
	mGetString	[EBP+32], [EBP+36], [EBP+40]

	MOV		ECX, [EBP+40]		; length of the input string 
	MOV		ESI, [EBP+36]		; buffer for the user input to be stored in...

	MOV		EDI, [EBP+24] 
				
	CLD											

_signLoop:
	LODSB						; load to al

	MOV		EBX, [EBP+40]		; inputLen
	CMP		EBX, ECX			; check to see if "+ / -"

	JNE		_convertToInteger
	CMP		AL, 45				; is it negative?
	JE		_isNegative

	CMP		AL, 43				; is it positive? (edge case: +23)
	JE		_nextCheck
	JMP		_convertToInteger

	_isNegative:
		MOV		AL, 1
		MOV		[EBP+12], AL	
		JMP		_nextCheck

	_convertToInteger:
		CMP		AL, 48			; is the input character an ASCII digit? (edge case: 1+1, !@#, etc..)
		JL		_repromptUser 

		CMP		AL, 57			; is the input character less 9 in ASCII? (edge case: 51d6fd) 
		JG		_repromptUser

		SUB		AL, 48			; subtract 48 - AL to convert it to an integer...
		MOVSX	EAX, AL
		PUSH	EAX				; save the EAX register

		MOV		EAX, [EBP+20]	; numCount is held by EAX
		MOV		EBX, 10			; "10" is held by EBX
		MUL		EBX				; multiply the current value by 10
		POP		EBX				; POP the subtracted value
		JO		_repromptUser	; OVERFLOW check (edge case: 115616148561615630)

		ADD		EAX, EBX		; add to numeric total value
		MOV		[EBP+20], EAX	; store value...

	_nextCheck:
		LOOP	_signLoop 
		
		MOV		EBX, [EBP+12]
		CMP		EBX, 1
		JNZ		_validCheck
		NEG		EAX				; (positive > negative)

	_validCheck:
		MOV		[EDI], EAX		; store the validated numeric total value (edge case: enter 10 inputs that display in the array)
		JMP		_finishReadVal

	_repromptUser:
	;------------------------------------------------------------
	; display an error message, and then prompt the user again!
	;------------------------------------------------------------
		mDisplayString	[EBP+28]
		MOV		EBX, 0

		MOV		[EBP+12], EBX			; set isNegative to 0
		MOV		[EBP+20], EBX			; clear conversion holder
		JMP		_prompt					; start over

_finishReadVal:
	POPAD
	POP		EBP
	RET		40

ReadVal	ENDP

; ---------------------------------------------------------------------------------------
; Name: WriteVal PROC
; Description: This PROC converts a signed numeric value into a string.
;				It is passed by reference to the displayString macro, in order to display the string representation of the passsed numerical value 
;				to the console...
; Preconditions: None.
; Postconditions: The string representation of the passed numerical value is displayed to the console.
; Receives:
;			[EBP+16] = the ARRAYSIZE for the max number of inputs to be entered.
;			[EBP+12] = the value to be converted to ASCII 
;			[EBP+8]	 = the arrayString address
; Returns: It displays the array as a string.
; ---------------------------------------------------------------------------------------
WriteVal PROC
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD						

	MOV		EDI, [EBP+8]			; memory address for the arraystring 
	MOV		ESI, [EBP+12]			; memory address of "value"
	MOV		EAX, ESI				; EAX will hold the numerical value
		
	MOV		ECX, 0					; ECX is initialized to the counter

	CMP		EAX, 0				
	JGE		_convertString

	NEG		EAX						; append the value

	PUSH	EAX						; save the value in the EAX register
	MOV		AL, 45					; add the - sign to the stored string
	STOSB
	POP		EAX

	_convertString:
		MOV		EBX, 10
		MOV		EDX, 0
		CDQ
		IDIV	EBX						; 10 is our divisor.
		INC		ECX						; ECX is holding the counter we must increment. 

		ADD		EDX, 48					; here we convert the remainder to ASCII,
		PUSH	EDX						; then we store the converted remainder to the string!

		CMP		EAX, 0					; are we finished converting? if the value is not 0, then we are not finished!

		JZ		_reverseString			; jump if zero
		JNZ		_convertString			; jump if not zero

	_reverseString:
		POP		EAX						; hold the remainder...

		STOSB

		LOOP	_reverseString 

		MOV		EAX, 0					; reset the string...
		STOSB

	_finishWriteVal:
		mDisplayString [EBP+8]

		POPAD
		POP		EBP
		RET		12
WriteVal ENDP

; ---------------------------------------------------------------------------------------
; Name: farewell PROC
; Description: This PROC ends the program by displaying the goodbye message.
; Preconditions: None.
; Postconditions: None.
; Receives:
;			[EBP+8]  = goodbye message
; Returns: None.
; ---------------------------------------------------------------------------------------
farewell PROC
	PUSH	EBP
	MOV		EBP, ESP

	mDisplayString [EBP+8]

	POP		EBP
	RET		4
		
farewell ENDP

END main
