*-----------------------------------------------------------
* Title      : 422 Project Code
* Written by : Luke Selbeck
* Date       : Starting from 11/17/2014
* Description: My Code for the Project
*-----------------------------------------------------------

* Equates Section

CR          EQU         $0D             * Hex value for Carriage Return
LF          EQU         $0A             * Hex value for New Line Read
START       EQU         $1000            * Address for ORG
start_addr  EQU         $00007000       * Starting address where the program is stored
end_addr    EQU         $00008000       * Ending address where the program is stored
EXIT        EQU         $2700           * Simulator Stop code

* Code Section
                ORG         START
            
            
            LEA         prompt1,A1       * Load starting address prompt into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15  
            
            MOVE.B      #2,D0            * Load input task
            TRAP        #15              * Store user input in A0
            
            * Convert to hex
            MOVE.L      A1,A3            * Use A3 for computations
            
SADDR_LOOP  MOVE.B      (A3)+,D3         * Get a byte from the string in A3
            CMP.B       #0,D3            * Check if you're at the end
            BEQ         END_ADDR_PT      * If you're at the end, get out of the loop
            CMP.B       #$40,D3          * Check if the cur char is a num or letter
            BGT         SLTTR_UP         * Use differet conversion for num vs letter
            CMP.B       #$60,D3          * Use different conversion for upper vs lowercase
            BGT         SLTTR_LW         * Branch to lowercase conversion
            ADDI.B      #-$30,D3         * Convert string to number
            BRA         SCOMPILE         * Use differet conversion for num vs letter
SLTTR_UP    ADDI.B      #-$37,D3         * Convert string to number
            BRA         SCOMPILE         
SLTTR_LW    ADDI.B      #-$3D,D3         * Convert string to number 
SCOMPILE    ASL.L       #4,D4            * Shift left one hex digit to make room
            ADD.L       D3,D4            * Add converted number to result
            BRA SADDR_LOOP
            
END_ADDR_PT MOVE.L      D4,A6            * move the start addr result into proper place
            CLR.L       D4               * Reset registers for second address
            CLR.L       D3               * Reset registers for second address
            
            LEA         prompt2,A1       * Load starting address prompt into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15
            
            MOVE.B      #2,D0            * Load input task
            TRAP        #15              * Store user input in A0
            
            MOVE.L      A1,A3            * Use A3 for computations

            
EADDR_LOOP  MOVE.B      (A3)+,D3         * Get a byte from the string in A3
            CMP.B       #0,D3            * Check if you're at the end
            BEQ         MAIN             * If you're at the end, get out of the loop
            CMP.B       #$40,D3          * Check if the cur char is a num or letter
            BGT         ELTTR_UP         * Use differet conversion for num vs letter
            CMP.B       #$60,D3          * Use different conversion for upper vs lowercase
            BGT         ELTTR_LW         * Branch to lowercase conversion
            ADDI.B      #-$30,D3         * Convert string to number
            BRA         ECOMPILE         * Use differet conversion for num vs letter
ELTTR_UP    ADDI.B      #-$37,D3         * Convert string to number
            BRA         ECOMPILE         
ELTTR_LW    ADDI.B      #-$3D,D3         * Convert string to number
ECOMPILE    ASL.L       #4,D4            * Shift left one hex digit to make room
            ADD.L       D3,D4            * Add converted number to result
            BRA EADDR_LOOP
            
MAIN:
            MOVE.L      D4,A5
            MOVE.B      #0,D1            * This is the line counter to display one page
            CMPA.L      A5,A6            * Check if out of range
            BGT         FINISH           * If out of range, Branch
            MOVE.L      (A6)+,D0         * Store the data in D0 and increment
            
            MOVEM.L     D1/A5-A6,-(SP)      * Store registers before jumping
            * JSR         OPCODE           * Jump to the opcode section to start decoding
            MOVEM.L     (SP)+,D1/A5-A6      * Restore registers after returning
            
            * MOVE.B      #13,D0           * Trap code for output
            * TRAP        #15              * Output decoded line in A1
            
            ADDI        #1,D1            * Increment line counter
            CMP.L       #29,D1           * Check if we've printed a page
            BGT         PAGE_REQ         * If we've printed a page, ask to print more
            
            BRA         MAIN             * Else restart loop   
            
            
PAGE_REQ    CLR.L       D1               * Reset line counter
            MOVE.L      #$00000000,A1    * Clear previous messages

            LEA         page_mss,A1      * Load page request into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15
            
            MOVE.B      #4,D0            * Load input task
            TRAP        #15              * Wait until user presses enter
            BRA MAIN                     * Print more
            
            
            
FINISH:     LEA         end_message,A1   * Load ending message into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15     
        
                      
            
OPCODE:     *Dallas insert here    
            

            SIMHALT                              
        
* Data Section
end_message DC.B        'Finshed',CR,0
prompt1     DC.B        'Please input the starting address in hex:',0
prompt2     DC.B        'Please input the ending address in hex:',0
page_mss    DC.B        'Would you like to continue?',0

            END         START




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
