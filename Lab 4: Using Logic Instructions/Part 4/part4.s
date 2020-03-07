/* Program that counts consecutive 1’s, 0’s, Alternate’s */

					.text					// Executable code follows
					.global _start
_start:		
					MOV		R3, #TEST_NUM	// R3 points to the test numbers
					MOV		R1, #ALT		// R1 point to the alternating numbers 10101010...
					LDR		R8, [R1]		// R8 contains alternating numbers 10101010...
					
					MOV		R5, #0			// R5 will hold the the longest string of 1’s in any of the words
					MOV		R6, #0			// R6 will hold the the longest string of 0's in any of the words
					MOV		R7, #0			// R7 will hold the the longest string of ...
											// alternating 1's and 0's in any of the words						
LOOP:				
					LDR		R1, [R3], #4	// Read from R3 then advance to the next number
					CMP 	R1, #0			// Loop until no more words are left
					BEQ		DISPLAY			// If all the test numbers are done, display it on the board
					MOV		R4, R1
					
					MOV		R0, #0			// R0 will keep count
					BL		ONES
					CMP		R5, R0			// Compare R5 and R0
					MOVLT	R5, R0			// Move R0 -> R5 if R5 < R0
					
					MOV		R0, #0			// R0 will keep count
					MOV		R1, R4			// Restore value of R1
					BL		ZEROS
					CMP		R6, R0			// Compare R6 and R0
					MOVLT	R6, R0			// Move R0 -> R6 if R6 < R0
					
					MOV		R0, #0			// R0 will keep count
					MOV		R1, R4			// Restore value of R1
					BL		ALTERNATE
					CMP		R7, R0			// Compare R7 and R0
					MOVLT	R7, R0			// Move R0 -> R7 if R7 < R0
					
					B		LOOP
ONES:
		LOOP_1s:	CMP		R1, #0			// Loop until the data contains no more 1's
					BEQ		END_1s
					LSR		R2, R1, #1		// Perform SHIFT
					AND		R1, R1, R2		// Perform AND
					ADD		R0, #1			// Count the string length
					B		LOOP_1s			// Repeat LOOP_1s
			
		END_1s:		BX		LR				// Link back to the main LOOP
ZEROS:
		LOOP_0s:	CMP		R1, #0xffffffff	// Loop until the data contains no more 0’s
					BEQ		END_0s
					LSR		R2, R1, #1		// Perform SHIFT
					ORR		R2, #0x80000000 // Perform bitwise OR to change first bit to 1
					ORR		R1, R2			// Perform bitwise OR with the shifted and non-shifted values
					ADD		R0, #1			// Count the string length
					B		LOOP_0s			// Repeat LOOP_0s
			
		END_0s:		BX		LR				// Link back to the main LOOP
ALTERNATE:
		LOOP_ALT:	CMP		R1, #0			// Loop until the data contains no more 0's
					BEQ		END_ALT
					EOR		R1, R8			// Perform bitwise XOR
					B		LOOP_1s			// Repeat LOOP_1s
			
		END_ALT:	BX		LR				// Link back to the main LOOP
END:				
					B		END

/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
 *    Parameters: R0 = the decimal value of the digit to be displayed
 *    Returns: R0 = bit patterm to be written to the HEX display
 */

SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR              

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment

DIVIDE:		MOV		R2, #0
CONT:		CMP		R0, #10
			BLT		DIV_END
			SUB     R0, #10
			ADD     R2, #1
			B       CONT
DIV_END:    MOV     R1, R2
            MOV     PC, LR

/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0
            MOV     R0, R5          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0
            MOV     R0, R6          // display R6 on HEX3-2
            BL      DIVIDE          // ones digit will be in R0; tens digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            LSL     R0, #16         // save bit code
			ORR     R4, R0
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE  
			LSL     R0, #24
            ORR     R4, R0
            STR     R4, [R8]        // display the numbers from R6 and R5
            LDR     R8, =0xFF200030 // base address of HEX5-HEX4
            MOV     R0, R7          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE       
            LSL     R0, #8
            ORR     R4, R0
            STR     R4, [R8]        // display the number from R7
			B		END					
									
TEST_NUM: 			.word	0x103fe00f		// ANSWERS: 9 9 2
					.word   0xfffffffe		// ANSWERS: 31 1 2
					.word   0x5c284216		// ANSWERS: 3 4 5
					.word   0x84b56bd6		// ANSWERS: 4 4 5
					.word   0x78b2fb36		// ANSWERS: 5 3 4
					.word   0xbf4662f7		// ANSWERS: 6 3 4
					.word   0x88a6b807		// ANSWERS: 3 8 5
					.word   0xdc0c51b6		// ANSWERS: 3 6 3
					.word   0xd4a8aa68		// ANSWERS: 2 3 9
					.word   0xdfd09de8		// ANSWERS: 7 4 4
					.word   0x0
ALT:				.word   0x55555555 		// 101010...
					.end