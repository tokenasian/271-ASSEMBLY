TITLE Generating, Sorting, and Counting Random integers 5		(Proj5_armstrm2.asm)

; Author: Matthew Armstrong
; Last Modified: 8/8/2022
; OSU email address: armstrm2@oregonstate.edu
; Course number/section:  CS271    Section: 400
; Project Number:   5              Due Date: 8/7/2022
; Description: This program generates 200 random integers in the range of 15 and 50. It displays the original unsorted list, the median value of the array,
;			   the sorted list, and a count of instances for each generated number, starting with the lowest value... 

INCLUDE Irvine32.inc
LO = 15
HI = 50
ARRAYSIZE = 200

.data	
countArray			DWORD	    HI-LO+1		DUP (?)
COUNTSIZE			DWORD		LENGTHOF	countArray
countElement		DWORD		0

randArray			DWORD		ARRAYSIZE	DUP(?) 
arrayCount			DWORD		LENGTHOF	randArray 

intro1				BYTE		"Generating, Sorting, and Counting Random integers!					Programmed by Matthew Armstrong",  13,10,0
instruct1			BYTE		"This program generates 200 random integers between 15 and 50, inclusive.", 13,10,0
instruct2			BYTE		"It then displays the original list, sorts the list, displays the median value of the list,", 13,10,0
instruct3			BYTE		"displays the list sorted in ascending order, and finally displays the number of instances",  13,10,0
instruct4			BYTE		"of each generated value, starting with the number of lowest.", 13,10,0

unsortedlist		BYTE		"Your unsorted random numbers: ", 13,10, 0
medianval			BYTE		"The median value of the array: ", 0
sortedlist			BYTE		"Your sorted random numbers: ", 13,10, 0
instanceslist		BYTE		"Your list of instances of each generated number, starting with the smallest value: ", 13,10, 0

goodbye				BYTE		"Goodbye, and thanks for using my program! ", 13,10, 0

space				BYTE		" ", 0

.code
main PROC
	CALL	Randomize 

	; Calls the introduction
	PUSH	OFFSET	intro1			; 24
	PUSH	OFFSET	instruct1		; 20
	PUSH	OFFSET	instruct2		; 16
	PUSH	OFFSET	instruct3		; 12
	PUSH	OFFSET	instruct4		; 8
	CALL	introduction

	; Calls fillArray
	PUSH	OFFSET	randArray		; 20  
	PUSH	HI						; 16
	PUSH	LO						; 12
	PUSH	ARRAYSIZE				; 8
	CALL	fillArray 

	; Calls displaylist for unsorted integers
	PUSH	OFFSET space			; 20
	pUSH	OFFSET unsortedlist		; 16	
	PUSH	OFFSET randArray		; 12
	PUSH	ARRAYSIZE				; 8
	CALL	displayList

	; Calls sortList
	PUSH	OFFSET randArray		; 12
	PUSH	ARRAYSIZE				; 8
	CALL	sortList

	; Calls displayMedian for the median integer
	PUSH	OFFSET medianval		; 16
	PUSH	OFFSET randArray		; 12
	PUSH	ARRAYSIZE				; 8
	CALL	displayMedian 

	; Calls displaylist for sorted integers
	PUSH	OFFSET space			; 20
	PUSH	OFFSET sortedlist		; 16
	PUSH	OFFSET randArray		; 12
	PUSH	ARRAYSIZE				; 8
	CALL	displayList

	; Calls countList
	PUSH	HI						; 28
	PUSH	LO						; 24
	PUSH	ARRAYSIZE				; 20
	PUSH	OFFSET randArray		; 16
	PUSH	OFFSET countArray		; 12
	PUSH	OFFSET countElement		; 8
	CALL	countList			

	; Calls displaylist for number of instances
	PUSH	OFFSET space			; 20
	PUSH	OFFSET instanceslist	; 16
	PUSH	OFFSET countArray		; 12
	PUSH	COUNTSIZE				; 8
	CALL	displayList

	; Calls farewell
	PUSH	OFFSET goodbye			; 8
	CALL	farewell

	exit	; exit to operating system
main ENDP

introduction PROC
; ---------------------------------------------------------------------------------
; Name: introduction PROC
; Description: The purpose of this procedure is to introduce the program to the user detailing the title and author,
;			  as well as the instructions of the program, so that the user knows what to expect from the program.
;
; Preconditions: none.
;
; Postconditions: EDX is modified.
;
; Receives: intro1, instruct1, instruct2, instruct3, instruct4
;
; Returns: This procedure prints the introduction and instructions to the console.
; ---------------------------------------------------------------------------------
	; set up the stack frame
	PUSH	EBP
	MOV		EBP, ESP
	; print the introduction to the console
	MOV		EDX, [EBP+24]
	CALL	WriteString
	CALL	CrLf
	; print the instructions to the console
	MOV		EDX, [EBP+20]
	CALL	WriteString
	MOV		EDX, [EBP+16]
	CALL	WriteString
	MOV		EDX, [EBP+12]
	CALL	WriteString
	MOV		EDX, [EBP+8] 
	CALL	WriteString

	POP		EBP
	RET		20

introduction ENDP

fillArray PROC
; ---------------------------------------------------------------------------------
; Name: fillArray
;
; Description: This procedure will fill the array loop with a max of 200 random integers between the range of 15 (low integer) and 50 (high integer).
;
; Preconditions: ARRAYSIZE, LO, HI are global variables.
;
; Postconditions: EBP, ECX, ESI, and EAX are modified.
;
; Receives: 
; [EBP+20] = randArray address
; [EBP+16] = hi
; [EBP+12] = LO
; [EBP+8] = ARRAYSIZE
; 
; Returns: randArray filled with the specificed random integers...

; ---------------------------------------------------------------------------------
	; set up the stack frame
	PUSH	EBP					; + 4
	MOV		EBP, ESP			; base pointer

	; set up the fill array loop
	MOV		ECX, [EBP+8]		; array size in ecx
	MOV		ESI, [EBP+20]		; address of array in esi

	_fillArrayLoop:
		; generate the random integer
		MOV		EAX, [EBP+16]	; initialize range to HI, MOV to EAX
		SUB		EAX, [EBP+12]	; HI - LO, so subtract 15 from 50...
		INC		EAX				; increment by 1, which will give us 15 - 50.
		CALL	RandomRange		; call RandomRange to generate each random number.
		ADD		EAX, [EBP+12]	; add LO back, so that it is part of the answer of HI - LO + 1.
		MOV		[ESI], EAX		; store the random integer into the array...
		ADD		ESI, 4			; and here we incrememnt to the next element!
		LOOP	_fillArrayLoop

		POP		EBP
		RET		16

fillArray		ENDP

sortList PROC
; ---------------------------------------------------------------------------------
; Name: sortsList PROC
;
; Description: This procedure is responsible for sorting the randArray in ascending order. 
;
; Preconditions: randArray is updated with 200 random integers between a specific lo - hi range. 
;
; Postconditions: EBP, ECX, ESI, EAX, EDX, EBX.
;
; Receives: 
; [ESP+12] = randArray address
; [EBP+8] = ARRAYSIZE
;
; Returns: randArray is updated to be sorted in an ascending order...
;
; Assembly Language for x86 Processors by Kip Irvine was utilizied for the sortList proc.
; ---------------------------------------------------------------------------------
	; set up the stack frame
	PUSH	EBP					
	MOV		EBP, ESP					

	MOV		ECX, [EBP+8]		; array size to set up the counter loop
	SUB		ECX, 1				; decrement ARRAYSIZE - 1
	MOV		ESI, [EBP+12]		; address of randAray

	; outer loop
	_L1:
		PUSH	ECX				; save the outer loop count
		MOV		EDX, [EBP+8]	
		MOV		ESI, [EBP+12]   

		; inner loop
		_L2:
			MOV		EAX, [ESI]		; get the array value
			MOV		EBX, [ESI+4]	
			CMP		EBX, EAX		; compare pair of values
			JG		_noExchanging	; if [ESI] <= [ESI+4], then there is no exchange
					
			PUSH	ESI		
			ADD		ESI, 4
			PUSH	ESI	
			SUB		ESI, 4			; decrement the esi

			CALL	exchangeElements

			_noExchanging: 
				ADD		ESI, 4		
				LOOP	_L2			; back to inner loop

				POP		ECX			; get the outer loop count
				LOOP	_L1			; repeat the outer loop

				POP		EBP
				RET		8
sortList ENDP

exchangeElements PROC
; ---------------------------------------------------------------------------------
; Name: exchangeElements
; 
; Description: This subprocedure will swap elements in the randarray.
;
; Preconditions: none
;
; Postconditions: none
;
; Receives: 
; [EBP+12] = randArray address
; [EBP+8] = ARRAYSIZE
; 
; Returns: randArray updated with two exchanges values...
; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP

	PUSHAD 
	MOV		ESI, [EBP+8]		
	MOV		EDI, [EBP+12]		

	MOV		EAX, [EDI]		
	MOV		EBX, [ESI]		

	MOV		[ESI], EAX		
	MOV		[EDI], EBX			

	POPAD 
	POP		EBP
	RET		8
exchangeElements ENDP

displayMedian PROC
; ---------------------------------------------------------------------------------
; Name: displayMedian PROC
;
; Description: This procedure will get the median value of the array to display on the console.
;
; Preconditions: randArray is filled with 200 random integers between a specified LO and HI range, and sorted in ascending order. 
;
; Postconditions: EBP, ESI, EAX, EDX, and EBX are modified. 
;
; Receives: 
; [EBP+16] = medianval
; [EBP+12] = randArray address
; [EBP+8] = ARRAYSIZE
; 
; Returns: median value is printed to the console
; ---------------------------------------------------------------------------------
	; set up the stack frame
	PUSH	EBP
	MOV		EBP, ESP
	; print the median value to the console
	CALL	CrLf
	MOV		EDX, [EBP+16]			; "the median value of the array is..."
	CALL	WriteString

	; obtain the median value of the array by dividing it in half
	MOV		ESI, [EBP+12]			; randArray address
	MOV		EAX, [EBP+8]			; arrray size

	MOV		EBX, 2
	MOV		EDX, 0
	DIV		EBX

	MOV		EBX, 4
	MUL		EBX
	ADD		ESI, EAX
	MOV		EAX, [ESI]

	MOV		EBX, [ESI+4]
	ADD		EAX, EBX
	MOV		EBX, 2
	MOV		EDX, 0
	DIV		EBX

	CMP		EDX, 1
	JE		_roundUp
	JMP		_noRounding

	_noRounding:
		JMP		_printMedianVal
		_roundUp:
			INC		EAX
		_printMedianVal:
			CALL	WriteDec
			CALL	CrLf

			POP		EBP
			RET		12

displayMedian ENDP

displayList PROC
; ---------------------------------------------------------------------------------
; Name: displayList PROC
;
; Description: This procedure is responsible for printing the updated array (unsorted, sorted, median value), to the console. 
;			   This procedure will also print the string titles to the console.
;
; Preconditions: 
; randArray is filled with 200 random integers between a specified LO and HI range...
; randArray is sorted.
;
; Postconditions: none.
;
; Receives: 
; [EBP+20] = a space for formatting, " "
; [EBP+16] = unsorted, sorted, instance list
; [EBP+12] = randArray, countArray
; [EBP+8] = ARRAYSIZE, COUNTSIZE
;
; Returns: none.
; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD 

	CALL	CrLf
	MOV		EDX, [EBP+16]				; print the string titles (unsorted, sorted, instances...) to the console from main...
	CALL	WriteString

	MOV		ECX, [EBP+8]				; array size to ECX
	MOV		ESI, [EBP+12]				; randArray address to ESI
	MOV		EBX, 0

	_printArray:
		CMP		EBX, 20				; compare EBX -- are there 20 numbers per line? then a new line is needed...
		JE		_addNextLine		; JUMP to create a new line
		_continuePrinting:
			MOV		EAX, [ESI]
			CALL	WriteDec
			INC		EBX
			MOV		EDX, [EBP+20]		
			CALL	WriteString
			ADD		ESI, 4
			LOOP	_printArray	
			CALL	CrLf
			JMP		_finishPrinting
		_addNextLine:
			CALL	CrLf
			MOV		EBX, 0				; set EBX back to 0
			JMP		_continuePrinting 
		_finishPrinting:
			POPAD
			POP		EBP
			RET		16

displayList	ENDP

countList PROC	
; ---------------------------------------------------------------------------------
; Name: countlist PROC
;
; Description: This procedure is responsible for generating the number of instances, starting with the smallest value...
;
; Preconditions: 
; randArray is filled with 200 random integers between a specified LO and HI range...
; randArray is sorted.
;
; Postconditions: none.
;
; Receives: 
; [EBP+28] = HI
; [EBP+24] = lo
; [EBP+20] = ARRAYSIZE
; [EBP+16] = randArray
; [EBP+12] = countArray
; [EBP+8] = countElement
;
; Returns: countArray is updated, a count of the number of instances for each integer is stored in the array
; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP
	PUSHAD

	MOV		ESI, [EBP+16] ; randArray address
	MOV		EDI, [EBP+12] ; countArray address

	MOV		ECX, [EBP+20] ; ARRAYSIZE
	MOV		EBX, [EBP+24] ; LO
	MOV		EAX, [EBP+8]  ; countElement tracker

	MOV		EAX, 0

	_arrayCountLoop:
		CMP		EBX, [ESI]				; compare EBX to [ESI]
		JE		_incrementCount			; is ESI pointing to the same element as EBX? if so, increment the counter
		JNE		_nextCount				
		_incrementCount:
			INC		EAX					; add to the count
			ADD		ESI, 4				; increment ESI to point towards the next position
			LOOP	_arrayCountLoop
		_nextCount:
			MOV		[EDI], EAX			; store the current count to the EDI address
			ADD		EDI, 4				; increment EDI to point towards the next position
			INC		EBX					; increment the number
			CMP		EBX, [EBP+28]		; compare EBX to see if it is in the specified range
			JA		_endCountLoop		; end the loop if it is in range
			MOV		EAX, 0				; reset the counter...
			JMP		_arrayCountLoop
		_endCountLoop:
			POPAD
			POP		EBP
			RET		24

countList ENDP

farewell PROC
; ---------------------------------------------------------------------------------
; Name: farewell PROC
;
; Description: This procedure will print the farewell message to the console.
;
; Preconditions: n/a
;
; Postconditions: ebp, edx are modified.
;
; Receives: 
;
; [EBP+8] = goodbye message
;
; Returns: n/a
; ---------------------------------------------------------------------------------
	PUSH	EBP
	MOV		EBP, ESP

	CALL	CrLf
	CALL	CrLf
	MOV		EDX, [EBP+8]
	CALL	WriteString
	CALL	CrLf

	POP		EBP
	RET		4

farewell		ENDP

END main

