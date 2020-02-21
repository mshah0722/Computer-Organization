/* Program that finds the largest number in a list of integers	*/

            .text                   // executable code follows
            .global _start                  
_start:                             
			MOV     R4, #RESULT     // R4 points to result location
			LDR     R0, [R4, #4]    // R0 holds the number of elements in the list
			MOV     R1, #NUMBERS    // R1 points to the start of the list
			LDR 	R6, [R1]		// R6 holds the largest number so far
			BL      LARGE 
				
LARGE_FINISHED:		STR     R6, [R4]        // R6 holds the subroutine return value
							// store largest number into result location
			
END:        B       END

/* Subroutine to find the largest integer in a list
 * Parameters: R0 has the number of elements in the lisst
 *             R1 has the address of the start of the list
 * Returns: R6 returns the largest item in the list
 */
LARGE:			SUBS    R0, #1	// Start each loop be decrementing the counter
			BEQ	LARGE_FINISHED	// Check if the result is equal to 0, branch to LARGE_FINISHED
			ADD     R1, #4
			LDR	R5, [R1]	// R5 will get the next number
			CMP     R6, R5		// Checks if a larger number is found
			BGE     LARGE		// If its smaller, it loops back to the begining
			MOV     R6, R5		// Updates the largest number in R6
			B       LARGE		// Repeat Loop
				
RESULT:     .word   0           
N:          .word   7           // number of entries in the list
NUMBERS:    .word   4, 5, 3, 6  // the data
            .word   1, 8, 2                 

            .end                            

