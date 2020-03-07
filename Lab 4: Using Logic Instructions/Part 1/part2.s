/* Program that counts consecutive 1’s */

				.text					// Executable code follows
				.global _start
_start:		
				MOV		R3, #TEST_NUM	// R3 points to the test numbers
				MOV		R5, #0			// R5 will hold the the longest string of 1’s in any of the words
LOOP:
				MOV 	R0, #0			// R0 will hold the result
				LDR 	R1, [R3], #4	// Read R3 and then advance
				CMP		R1, #0			// Loop until the data contains no more words
				BEQ		DONE
				BL		ONES
				CMP 	R5, R0			// Compare R5 and R0
				MOVLT	R5, R0			// Move R0 -> R5 if R5 < R0
				B		LOOP
ONES:
		begin:
				CMP 	R1, #0			// Loop until the data contains no 1's
				BEQ		END
				LSR		R2, R1, #1		// Perform SHIFT
				AND		R1, R1, R2		// Perform AND
				ADD		R0, #1			// Count the string length
				B		begin			// LOOP
			
		END:	
				MOV		PC, LR			// Return
DONE:
				B		DONE

TEST_NUM: 		.word	0x103fe00f		// Answer = 9
				.word   0xfffffffe		// Answer = 31
				.word   0x5c284216		// Answer = 3
				.word   0x84b56bd6		// Answer = 4
				.word   0x78b2fb36		// Answer = 5
				.word   0xbf4662f7		// Answer = 6
				.word   0x88a6b807		// Answer = 3
				.word   0xdc0c51b6		// Answer = 3
				.word   0xd4a8aa68		// Answer = 2
				.word   0xdfd09de8		// Answer = 7
				.word   0x0
				.end