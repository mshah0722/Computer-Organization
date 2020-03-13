//In this part you are to modify your code so that a hardware timer is used to measure an exact delay of 0.25 seconds. 
//You should use polled I/O to cause the ARM processor to wait for the timer.

.global 		_start

.equ HEX, 		0xFF200020
.equ TIMER, 	0xFFFEC600

_start:
				LDR R0, =HEX
				LDR R1, =TIMER
				LDR R2, =BIT_CODES
				MOV R3, #-1
			
CHECKNUMBER: 	
				MOV R4, #99
				CMP R3, R4
				
				//Reset if number >= 99
				BGE RESET
				
				//If it is not, add 1
				ADD R3, #1
				
				//Subtract number by 10 after 10 numbers
				B DIVIDE
				
RESET:
				//Reset the interrupt
				LDR R4, =RESETNUMBER
				LDR R4, [R4]
				STR R4, [R1]
				
				//Reset the number
				MOV R4, #0
				MOV R3, R4
				
				//Subtract number by 10 after 10 numbers
				B DIVIDE
				
DIVIDE:
				MOV R5, R3
				MOV R4, #0
				
CONTINUE:		
				CMP R5, #10
				
				//If the number is less than 10, show the number
				BLT SHOW
				
				//Subtract by 10 if the number is equal to 10
				SUB R5, #10
				
				//Increase 10s digit by 1
				ADD R4, #1
				
				B CONTINUE

SHOW:
				LDRB R6, [R2, R4]
				LDRB R7, [R2, R5]
				
				//Place both numbers in the same register
				LSL R6, #8
				ADD R6, R7
				STR R6, [R0]
				
				B SETUP
				
SETUP:
				//Load the value
				LDR R4, =delay
				LDR R4, [R4]
				
				STR R4, [R1]
				
				//Load the enable
				MOV R4, #0b1
				STR R4, [R1, #0x8]
				
				B DELAY
				
DELAY:
				//Delay the process
				LDR R5, [R1, #0xc]
				CMP R5, #1
				BNE DELAY
				
				MOV R5, #0b1
				STR R5, [R1, #0xc]
				
				B CHECKNUMBER
				
BIT_CODES: 		.byte 0b00111111, 0b00000110, 0b01011011, 0b01001111,  0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111, 0b0000000
				.skip 1
				
RESETNUMBER: 	.word 0b111111111

delay: 			.word 50000000

.end