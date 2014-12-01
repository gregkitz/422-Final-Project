*-----------------------------------------------------------
* Title      : 422 Project Code
* Written by : Dallas Van Ess
* Date       : Starting from 11/17/2014
* Description: My Code for the Project
*-----------------------------------------------------------

* Equates Section

CR          EQU         $0D             * Hex value for Carriage Return
LF          EQU         $0A             * Hex value for New Line Read
START       EQU         $400            * Address for ORG
start_addr  EQU         $00007000       * Starting address where the program is stored
end_addr    EQU         $00008000       * Ending address where the program is stored
EXIT        EQU         $2700           * Simulator Stop code

* Code Section
                ORG         START
            
            MOVEA.L     #start_addr,A0   * Store starting address in A0
            MOVEA.L     #end_addr,A1     * Store ending address in A1
            
MAIN:       CMPA.L      A1,A0            * Check if out of range
            BGT         FINISH           * If out of range, Branch
            MOVE.L      (A0)+,D0         * Store the data in D0 and increment
            
            MOVEM.L     A0-A1,-(SP)      * Store registers before jumping
            JSR         OPCODE           * Jump to the opcode section to start decoding
            MOVEM.L     (SP)+,A0-A1      * Restore registers after returning
            
            MOVE.B      #14,D0           * Trap code for output
            TRAP        #15              * Output decoded line in A1
            
            BRA         MAIN             * Else restart loop   
            
            
            
FINISH:     LEA         end_message,A1   * Load ending message into A1
            MOVE.B      #14,D0           * Trap code for output   
            TRAP        #15             
                      
            
OPCODE:     *Dallas insert here    
            

            SIMHALT                              
        
* Data Section
end_message DC.B        'Finshed',CR,0

            END         START
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
