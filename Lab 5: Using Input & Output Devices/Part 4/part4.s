//In this part you are to write an assembly language program that implements a real-time clock.
//Display the time on the seven-segment displays HEX3 − 0 
//in the format SS:DD, where SS are seconds and DD are hundredths of a second.
//Measure time intervals of 0.01 seconds in your program by using polled I/O with the ARM A9 Private Timer.
//You should be able to stop/run the clock by pressing any pushbutton KEY.
//When the clock reaches 59:99, it should wrap around to 00:00.

.global				_start

.equ				HEX, 0xFF200020
.equ				TIMER, 0xFFFEC600
.equ				EDGE, 0xFF20005C

_start:			
					LDR R0, =HEX
					LDR R1, =TIMER
					LDR R2, =BIT_CODES
					LDR R3, =EDGE
					
					//Count Milliseconds
					MOV R4, #-1
					
					//Count Seconds
					MOV R5, #0
					
					//Boolean Value
					MOV R6, #0
				
CHECKFORINTERRUPT:	
					LDR R7, [R3]
					CMP R7, #1
					
					//If the bits are on, reset them
					BGE RESETINTERRUPT
					
					CMP R6, #0
					
					//If boolean is off, continue checking number
					BEQ CHECKNUMBER
					
					//If boolean is on, show the same number
					B SHOW
					
RESETINTERRUPT:
					LDR R7, =RESETNUM
					LDR R7, [R7]
					STR R7, [R3]
					
					//Complement the number to negative with move negative function
					MVN R6, R6
					
					CMP R6, #0
					
					//If the number is equal to 0, then continue checking number
					BEQ CHECKNUMBER
					
					//Else show the same number
					B SHOW
					
CHECKNUMBER:
					MOV R7, #99
					CMP R4, R7
					
					//If number is greater than or equal to 99, reset the number
					BGE RESET
					
					//Else add 1
					ADD R4, #1
					
					//Show the number
					B SHOW
					
RESET:
					MOV R4, #0
					
					MOV R7, #59
					CMP R5, R7
					
					//If seconds is greater than 59, reset to 0
					MOVGE R5, #0
					
					//Else Add 1
					ADD R5, #1
					
					//Show the number
					B SHOW
					
SHOW:
					//Do s
					PUSH {R1, R3}
					
					//Using R3 and R1 in the subroutine
					MOV R3, R5
					BL DIVIDE
					
					//Come back to R1 which holds the 10 digit, R3 holds the 0 digit
					LDRB R7, [R2, R1]
					LDRB R8, [R2, R3]
					
					LSL R7, #8
					ADD R7, R8
					
					//Display the number on HEX
					STR R7, [R0]
					
					//Repeating the same steps for milliseconds
					MOV R3, R4
					BL DIVIDE
					
					LDRB R8, [R2, R1]
					
					LSL R7, #8
					ADD R7, R8
	
					//Display the number on HEX
					STR R7, [R0]
					
					POP {R1, R3}
					
					B SETDELAY
					
DIVIDE:
					//R3 = number to divide, R4 = 10s digit, r5 = 0s digit
					MOV R1, #0 
					
CONTINUE:
					CMP R3, #10
					
					//Return to show number
					MOVLT PC, LR
					
					//Else subtract by 10
					SUB R3, #10
					
					//ADD 1
					ADD R1, #1
					
					B CONTINUE
					
SETDELAY:			
					//Load the value
					LDR R7, =delay
					LDR R7, [R7]
					
					STR R7, [R1]
					
					//Load the enable
					
					MOV R7, #0b1
					STR R7, [R1, #0x8]
					
					B DELAY
					
DELAY:
					//Load the interrupt register
					LDR R8, [R1, #0xc]
					CMP R8, #1
					
					//If the value is not equal to 1 continue delaying
					BNE DELAY
					
					MOV R8, #0b1
					STR R8, [R1, #0xc]
					
					//Check for the interrupt signal
					B CHECKFORINTERRUPT
					
BIT_CODES:  		.byte 0b00111111, 0b00000110, 0b01011011, 0b01001111,  0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111, 0b0000000
					.skip 1
RESETNUM: 			.word 0xf

delay: 				.word 200000, 2000000 
    
.end
					