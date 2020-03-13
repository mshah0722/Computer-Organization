//Part1 : Write an ARM assembly language program that displays a decimal digit on the seven-segment display HEX0.
//The other seven-segment displays HEX5 − 1 should be blank.
//If KEY0 is pressed on the board, you should set the number displayed on HEX0 to 0
//If KEY1 is pressed then increment the displayed number, 
//If KEY2 is pressed then decrement the number
//Pressing KEY3 should blank the display, and pressing any other KEY after that should return the display to 0.
//When you are not pressing any KEY the Data register provides 0
//When you press KEYi the Data register provides the value 1 in bit position i.
//Once a button-press is detected, be sure that your program waits until the button is released. 

.global 		_start

.equ HEX, 		0xFF200020
.equ KEYS, 		0xFF200050

_start:
				LDR R0, =HEX
				LDR R1, =KEYS
				LDR R2, =KEY_CODE
				LDR R3, =BIT_CODES
			
				//Register 6 is the global Key Number
				MOV R6, #0
			
CHECKFORINPUT:		
				LDR R4, [R1]
			
				//Check KEY0
				LDR R5, [R2]
				CMP R5, R4
				
				//If the value is 0 display zero
				BEQ DISPLAY0
				
				//Check KEY1
				LDR R5, [R2, #4]
				CMP R5, R4
				
				//If the value is 0 increase the number by 1
				BEQ INCREASE1
				
				//Check KEY2
				LDR R5, [R2, #8]
				CMP R5, R4
				
				//If the value is 0 decrease the number by 1
				BEQ DECREASE1
				
				//Check KEY3
				LDR R5, [R2, #12]
				CMP R5, R4
				
				//If the value is 0 decrease the number by 1
				BEQ CLEAR
				
				//If no signals are recieved, check again
				B CHECKFORINPUT
				
DISPLAY0:
				//Wait until the person lets go of the KEY
				BL WAIT
				
				//Display a 0 on HEX0
				MOV R6, #0
				LDRB R7, [R3, R6]
				STR R7, [R0]
				
				//Check for new input
				B CHECKFORINPUT
				
DISPLAY9:
				//Wait until the person lets go of the KEY
				BL WAIT
				
				//Display a 0 on HEX0
				MOV R6, #9
				LDRB R7, [R3, R6]
				STR R7, [R0]
				
				//Check for new input
				B CHECKFORINPUT

INCREASE1:
				//Wait until the person lets go of the KEY
				BL WAIT
				
				//Check if R6 is not >=9
				CMP R6, #9
				
				//If the number is greater than 0, display 0
				BGE DISPLAY0
				
				//Else, add and show new num
				ADD R6, #1
				LDRB R7, [R3, R6]
				STR R7, [R0]
				
				//Check for new input
				B CHECKFORINPUT

DECREASE1:
				//Wait until the person lets go of the KEY
				BL WAIT
				
				//Check that R6 is not ==0
				CMP R6, #0
				BEQ DISPLAY9
				
				
				SUB R6, #1
				LDRB R7, [R3, R6]
				STR R7, [R0]
				
				B CHECKFORINPUT
				
CLEAR:
				//Wait until the person lets go of the KEY
				BL WAIT
				
				LDRB R7, [R3, #10]
				STR R7, [R0]
				B   POSTCLEAR
				
WAIT:
				LDR R4, [R1]
				CMP R4, #0
				BNE WAIT
				MOV PC,LR 
POSTCLEAR: 
				LDR R4, [R1]
				
				LDR R5, [R2]
				CMP R5, R4
				BEQ DISPLAY0
				
				LDR R5, [R2, #4]
				CMP R5, R4
				BEQ DISPLAY0
				
				LDR R5, [R2, #8]
				CMP R5, R4
				BEQ DISPLAY0
				
				B POSTCLEAR

END:
				B END
				
KEY_CODE: 		.word 0b1, 0b10, 0b100, 0b1000 

BIT_CODES:  	.byte 0b00111111, 0b00000110, 0b01011011, 0b01001111,  0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111, 0b0000000
				.skip 1

.end