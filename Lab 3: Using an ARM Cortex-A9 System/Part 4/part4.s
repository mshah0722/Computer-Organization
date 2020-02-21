/* Program that converts a binary number to decimal */
           .text               // executable code follows
           .global _start
_start:
            MOV    R4, #N       // R4 points to N storage location
            MOV    R5, #Digits  // R5 points to the decimal digits storage location
			MOV    R1, #10		// Using R1 as a divisor of 10
            LDR    R4, [R4]     // R4 holds N
            MOV    R0, R4       // parameter for DIVIDE goes in R0
            BL     DIVIDE		// Branch Link to DIVIDE Subroutine
			STRB   R0, [R5]		// Ones digit in R0 is stored at R5 last byte
			MOV    R0, R3		// Moves quotient back to dividend
			BL     DIVIDE		// Branch Link to DIVIDE Subroutine
            STRB   R0, [R5, #1] // Tens digit in R0 is stored at R5 second last byte
			MOV    R0, R3       // Moves quotient back to dividend
			BL     DIVIDE		// Branch Link to DIVIDE Subroutine
			STRB   R0, [R5, #2] // Hundreds digit in R0 is stored at R5 third last byte
			MOV    R0, R3       //Moves quotient back to dividend
			BL     DIVIDE		// Branch Link to DIVIDE Subroutine
            STRB   R0, [R5, #3] // Thousands digit in R0 is stored in fourth last byte
END:        B      END			// Task completed

/* Subroutine to perform the integer division R0 / 10.
 * Returns: quotient in R3, and remainder in R0
*/
DIVIDE:     MOV    R2, #0	// Immediate value 0 is stored in R2
CONT:       CMP    R0, R1	// R1 is compared with R0
            BLT    DIV_END  // If R0 < R1, branch link to DIV_END
            SUB    R0, R1	// R0 = R0 - R1
            ADD    R2, #1	// R2 = R2 + 1
            B      CONT		// Loop CONT
DIV_END:    MOV    R3, R2   // quotient in R3 (remainder in R0)
            MOV    PC, LR	// PC gets Link Register

N:          .word  97         // the decimal number to be converted
Digits:     .space 4          // storage space for the decimal digits

            .end
