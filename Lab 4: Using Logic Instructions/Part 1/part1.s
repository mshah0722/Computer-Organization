/* Program that counts consecutive 1’s */

			.text					// Executable code follows
			.global _start
_start:		
			MOV		R1, #TEST_NUM	// Load the data word...
			LDR		R1, [R1]		// Into R1
			
			MOV 	R0, #0			// R0 will hold the result
LOOP:		CMP		R1, #0			// Loop until the data contains no more 1's
			BEQ		END
			LSR		R2, R1, #1		// Perform SHIFT
			AND		R1, R1, R2		// Perform AND
			ADD		R0, #1			// Count the string length
			B		LOOP			// LOOP
			
END:		B		END

TEST_NUM: 	.word	0x103fe00f
			.end