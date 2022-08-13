TITLE Integer Accumulator Project 3 (Proj3_armstrm2.asm)

; Author: Matthew Armstrong
; Last Modified: 7/16/2022
; OSU email address: armstrm2@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:   3              Due Date: 7/17/2022
; Description: a simple data validation, looping, and constants project that repeatedly asks a user to input a range of numbers. 
; the program displays a count of the number of valid entries, the min and max value, sum, and a rounded average.
; the program displays an error message when an entry is invalid or if there is no number entered.

INCLUDE Irvine32.inc
MIN_BOUND_1		=		-200
MAX_BOUND_1		=		-100
MIN_BOUND_2		=		-50
MAX_BOUND_2		=		-1

.data
; PROGRAM OUTPUT
header							BYTE			"Welcome to the Integer Accumulator by Matthew Armstrong!", 0
description_1					BYTE			"We will be accumulating user-input negative integers between specified bounds, then displaying required statistics. ", 0
ask_name						BYTE			"What is your name? ", 0
display_name					BYTE			"Hello there, ", 0
instruction_1					BYTE			"Please enter numbers in [-200, -100] or [-50, -1].", 0
instruction_2					BYTE			"Enter a non-negative number when you are finished to see results.", 0
enter_number					BYTE			") Enter number: ", 0
error_message					BYTE			"Number Invalid!", 0
special_error_message			BYTE			"ERROR: You did not enter any valid numbers.", 0
goodbye							BYTE			"We have to stop meeting like this. Farewell, ", 0
extra_credit1					BYTE			"EC: Number the lines during user input. Increment the line number only for valid number entries.", 0

; RESULT OUTPUT
msg1							BYTE			"You entered ", 0
msg2							BYTE			" valid numbers.", 0
msg3							BYTE			"The maximum valid number is: ", 0
msg4							BYTE			"The minimum valid number is: ", 0
msg5							BYTE			"The sum of your valid numbers is: ", 0
msg6							BYTE			"The rounded average is: ", 0

;  USER INPUT
user_name						BYTE			80 DUP(0)
user_characters					DWORD			?

user_input						SDWORD			?				
count							SDWORD			0				
max_entry						SDWORD			-201			
min_entry						SDWORD			0				
sum								SDWORD			0				
avg								SDWORD			0				
rem								SDWORD			?				

.code
main PROC
;    --------------------------
;	Introduction Section:
;   Introduce the program by printing the program header (title and name), and the program instructions (including extra credit) to the console.
;    --------------------------

		; print the program title to the console 
	MOV					EDX, OFFSET header
	CALL	WriteString
	CALL	CrLf

			; print the extra credit instruction to the console 
	MOV					EDX, OFFSET extra_credit1
	CALL	WriteString
	CALL	CrLf

	CALL	CrLf
	MOV					EDX, OFFSET description_1
	CALL	WriteString
	CALL	CrLf
	CALL	CrLf

		; get the user name, save the input in a null-terminated BYTE array
	CALL	CrLf
	MOV					EDX, OFFSET ask_name
	CALL	WriteString
	MOV					EDX, OFFSET user_name
	MOV					ECX, 80
	CALL	ReadString						 ; receive input with ReadString
	MOV					user_characters, EAX
	CALL	CrLf

		; read the user name to the console and say hello!
	MOV					EDX, OFFSET display_name
	CALL	WriteString
	MOV					EDX, OFFSET user_name
	CALL	WriteString
	CALL	CrLf

		; print the display instructions to the console 
	CALL	CrLf
	MOV					EDX, OFFSET instruction_1
	CALL	WriteString
	CALL	CrLf
	MOV					EDX, OFFSET instruction_2
	CALL	WriteString
	CALL	CrLf

_UserInput:
;    --------------------------
;	UserInput Section:
;   Repeatedly prompt the user to enter a number, specificying bounds of acceptable inputs.
;    --------------------------
	MOV					EAX, count
	ADD					EAX, 1
	CALL	WriteDec
	MOV					EDX, OFFSET enter_number	; prompt the user to enter data 
	CALL	WriteString
	CALL	ReadInt									; utilize ReadInt to obtain the User Input
	MOV					user_input, EAX
	JMP					_CheckInteger				; JMP to check if the user input is a non-negative

_CheckInteger:
;    --------------------------
;	Check if the usr input is a non-negative! Compare the user input to 0, then check if the input is GREATER than (or equal to) 0.
;	If the input is GREATER than (or equal to) 0, then JUMP to calculate the average,
;	where entring a non-negative integer will either lead to the printed results or a special error message.

;	Otherwise, JUMP to validate the input if it is not a non-negative integer. 
;    --------------------------

	CMP					user_input, 0
	JGE					_CalculateAvg
	JS					_ValidateUserData

_InvalidData:
;    --------------------------
;	Check if the user input data is invalid!
;	Print the error message to the console when the entered data is invalid ("Number Invalid!").
;   We must then loop the user back to the user input section, so that they may try again.
;    --------------------------

	MOV					EDX, OFFSET error_message 
	CALL	WriteString
	CALL	CrLf
	JMP					_UserInput

_ValidateUserData:
;    --------------------------
;	Validate the user input to be in range 
;	[-200, -100] or [-50, -1] (inclusive).
;    --------------------------

_first_check:
;    --------------------------
;	is the first input GREATER than (or equal to) -200? Compare the user input to -200.
;	JUMP to compare the user input to -100, if GREATER than or equal to -200 (ex -110 is greater than -200).
;	JUMP to invalidate the integer, if it is NOT greater than or equal to -200 (ex -550 is less than -200).
;    --------------------------

	MOV					EAX, user_input
	CMP					user_input, MIN_BOUND_1
	JGE					_second_check			
	JLE					_InvalidData			

_second_check:
;    --------------------------
;	is the user input LESS than (or equal to) -100? Compare the user input to -100.
;	JUMP to validate the user input if the integer is LESS than or equal to -100 
;	EX -110 is less than -100, but it not less than -200, so it is in range of [-200, -100].
;    --------------------------

	CMP					EAX, MAX_BOUND_1
	JLE					_ValidInteger			
	
_third_check:
;    --------------------------
;	is the user input GREATER than (or equal to) -50? Compare the user input to -50.
;	JUMP to compare the user input to -1, if it is GREATER than or equal to -50 (ex -36 is greater than -50).
;    --------------------------

	CMP					EAX, MIN_BOUND_2
	JGE					_fourth_check

_fourth_check:
;    --------------------------
;	is the user input LESS than (or equal to) -1? Compare the user input to -1.
;	JUMP to validate the user input if the integer is LESS than or equal to -1.
;	in range of [-50, -1]
;    --------------------------

	CMP					EAX, MAX_BOUND_2
	JLE					_ValidInteger

; When a valid number is entered, store number or valid
;		numbers entered, min, max_entry, sum, rounded average,	
;		and decimal rounded average

_ValidInteger:
;    --------------------------
;	Stores valid inputs
;   The Min, Max, count, Sum, and Average must all be stored in named variables as they are calculated...
;    --------------------------

		; increment the count
	INC					count					

		; calculate the sum
	MOV					EAX, sum
	ADD					EAX, user_input			
	MOV					sum, EAX
	
	MOV					EAX, user_input
	CMP					EAX, max_entry
	JLE					_AddMin
	MOV					max_entry, EAX

_CalculateMin:
	MOV					EAX, user_input
	CMP					EBX, min_entry
	JGE					_AddMin
	JMP					_UserInput

_AddMin:
	MOV					min_entry, EAX
	JMP					_UserInput

_CalculateAvg:
;    --------------------------
;	Calculate the (rounded integer) average of the valid numbers...
;    --------------------------

	MOV					EAX, count
	CMP					EAX, 0						; compare the user input to 0
	JE					_SpecialMessageException    ; display a special error message if no number was entered

	MOV					EAX, sum					
	MOV					EBX, count				
	CDQ
	IDIV				EBX							; divide

	MOV					avg, EAX
	MOV					rem, EDX

	MOV					EAX, count
	MOV					EBX, -2
	CDQ
	IDIV				EBX							; divide
	MOV					EBX, rem
	CMP					rem, EAX					; compare the remainder 

	JL					_Rounded

_Rounded:
	MOV					EAX, avg
	SUB					EAX, 1
	MOV					avg, eax


_ConsoleOutput:
;    --------------------------
;	Print the display results to the console
;    --------------------------

	MOV					EDX, OFFSET msg1
	CALL	WriteString
	MOV					EAX, count
	CALL	WriteDec
	MOV					EDX, OFFSET msg2
	CALL	WriteString
	CALL	CrLf

		; print the maximum
	MOV					EDX, OFFSET msg3
	CALL	WriteString
	MOV					EAX, max_entry
	Call	WriteInt
	CALL	CrLf

		; print the minimum
	MOV					EDX, OFFSET msg4
	CALL	WriteString
	MOV					EAX, min_entry
	Call	WriteInt
	CALL	CrLf

		; print the sum
	MOV					EDX, OFFSET msg5
	CALL	WriteString
	MOV					EAX, sum
	Call	WriteInt
	CALL	CrLf

		; print the rounded average
	MOV					EDX, OFFSET msg6
	CALL	WriteString
	MOV					EAX, avg
	Call	WriteInt
	CALL	CrLf

		; stop the program
	JMP				   _TerminateProgram

_SpecialMessageException:
;    --------------------------
;	Print a special message error to the console
;	The user input loop should terminate depending on the value of the SIGN flag, so,
;   Terminate the program if the user input is above or equal to 0
;    --------------------------

	MOV					EDX, OFFSET special_error_message
	CALL	WriteString
	CALL	CrLf
	JS				   _TerminateProgram

_TerminateProgram:
;    --------------------------
;	Terminate the program
;	Print the closing message to the console with the user name attatched 
;    --------------------------


	CALL	CrLf
	MOV					EDX, OFFSET goodbye
	CALL	WriteString
	MOV					EDX, OFFSET user_name
	CALL	WriteString

	Invoke ExitProcess, 0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
