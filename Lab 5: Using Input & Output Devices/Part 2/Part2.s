//Program displays a two-digit decimal counter on the seven-segment displays HEX1−0
//The counter should be incremented approximately every 0.25 seconds
//When the counter reaches the value 99, it should start again at 0

.global 			_start

.equ HEX, 			0xFF200020
.equ KEYS, 			0xFF200050
.equ EDGE, 			0xFF20005C

_start:
					LDR R0, =HEX
					LDR R1, =EDGE
					LDR R2, =BIT_CODES
					
					MOV R3, #-1
					MOV R8, #0
				
CHECKFORINTERRUPT:	
					LDR R4, [R1]
					CMP R4, #1
					
					//Check for end of interrupt signal to reset it
					BGE RESETINTERRUPT
					
					//If the number has not been checked, check number
					CMP R8, #0
					BEQ CHECKNUM
					
					//Else show nothing on HEX display
					B SHOWNOTHING
					
RESETINTERRUPT:
					//Used to reset the interrupt
					LDR R4, =RESETNUM
					LDR R4, [R4]
					STR R4, [R1]
					
					//R8 will hold the complement of R8 with move negative command
					MVN R8, R8
					
					//If the number has not been checked, check number
					CMP R8, #0
					BEQ CHECKNUM
					
					//Else show nothing on HEX display
					B SHOWNOTHING
					
CHECKNUM:
					MOV R4, #99
					CMP R3, R4
					
					//Reset if number is greater than or equal to 99
					BGE RESET 
					
					//If not, add 1
					ADD R3, #1
					
					//Divide the number by 10
					B DIVIDE
					
RESET:
					//Reset the number to 0
					MOV R4, #0
					MOV R3, R4
					
					//Divide the number by 10
					B DIVIDE
					
SHOW: 
					LDRB R6, [R2, R4]
					LDRB R7, [R2, R5]
					
					//NEED TO PUT THESE IN THE SAME REGISTER
					LSL R6, #8
					ADD R6, R7
					STR R6, [R0]
					B DO_DELAY					
					
SHOWNOTHING: 
					MOV R6, #0
					STR R6, [R0]
					
					//Check for interrupt signal
					B CHECKFORINTERRUPT
					
DIVIDE: 
					MOV R5, R3
					MOV R4, #0
					
CONTINUE:       
					CMP R5, #10
					
					//Go back to show if R5 < 10
					BLT SHOW 
					
					//Else subtract 10
					SUB R5, #10
					ADD R4, #1
					B CONTINUE
					
DO_DELAY: 
					//Delay counter
					LDR R7, =TIMER 
					LDR R7, [R7]

SUB_LOOP: 
					//R7 = R7-1
					SUBS R7, R7, #1
					
					//If R7 != 0
					BNE SUB_LOOP
					
					//Else check for interrupt signal
					B CHECKFORINTERRUPT
					
BIT_CODES:  		.byte 0b00111111, 0b00000110, 0b01011011, 0b01001111,  0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111, 0b0000000
					.skip 1

RESETNUM: 			.word 0b111111111

TIMER: 				.word 210000000, 2000000 
    
.end